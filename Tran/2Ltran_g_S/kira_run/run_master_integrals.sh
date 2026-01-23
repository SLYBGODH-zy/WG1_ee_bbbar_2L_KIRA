# !/bin/bash

# You might need to make this script executable
#
# chmod +x run_master_integrals.sh
# ./run_master_integrals.sh


# colours
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# timing
start=`date +%s`

CURRENTDIR=$(pwd)

printf "\nRunning ${RED}Kira${NC} in ${RED}${CURRENTDIR}${NC}\n\n"


# write myintegrals file
rm master_integrals/myintegrals
touch master_integrals/myintegrals
MAXSECTOR=0
MAXR=0
MAXS=0

for topology in */ ; do
    case $topology in
        master_integrals/) continue;;
    esac 
    cat "${CURRENTDIR}/${topology}results/${topology}masters.final" >> master_integrals/myintegrals

    # compute the sector
    SECTOR=$(tail -1 "${CURRENTDIR}/${topology}results/${topology}masters.final" | cut -f2 -d"#" | xargs)
    sed "s/<SECTOR_${topology//\/}>/[${SECTOR}]/" "${CURRENTDIR}/master_integrals/config/integralfamilies.yaml" > "${CURRENTDIR}/master_integrals/config/tmp"
    mv "${CURRENTDIR}/master_integrals/config/tmp" "${CURRENTDIR}/master_integrals/config/integralfamilies.yaml"

    if [ "$SECTOR" -gt "$MAXSECTOR" ]; then
        MAXSECTOR=${SECTOR}
    fi

    printf "Sector for ${BLUE}${topology//\/}${NC}: ${SECTOR}\n"

    # compute r
    cut -f1 -d"#" "${CURRENTDIR}/${topology}results/${topology}masters.final" | sed 's/]/;/g' | cut -f2 -d "[" > "${CURRENTDIR}/${topology}results/${topology}tmp"
    file_path="${CURRENTDIR}/${topology}results/${topology}tmp"
    max_sum=0

    while IFS= read -r line; do
        sum=$(echo "$line" | awk -F',' '{sum=0; for(i=1; i<=NF; i++) if ($i >= 0) sum+=$i; print sum}')
        if ((sum > max_sum)); then
            max_sum=$sum
        fi
    done < "$file_path"

    if [ "$max_sum" -gt "$MAXR" ]; then
        MAXR=${max_sum}
    fi

    # compute s
    cut -f1 -d"#" "${CURRENTDIR}/${topology}results/${topology}masters.final" | sed 's/]/;/g' | cut -f2 -d "[" > "${CURRENTDIR}/${topology}results/${topology}tmp"
    file_path="${CURRENTDIR}/${topology}results/${topology}tmp"
    max_sum=0

    while IFS= read -r line; do
        sum=$(echo "$line" | awk -F',' '{sum=0; for(i=1; i<=NF; i++) if ($i < 0) sum+=$i; print sum}')
        if ((sum < max_sum)); then
            max_sum=$sum
        fi
    done < "$file_path"
    max_sum=$((max_sum * -1))
    if [ "$max_sum" -gt "$MAXS" ]; then
        MAXS=${max_sum}
    fi

    rm "${file_path}"
done

echo ""
echo "New value for r: $MAXR"
echo "New value for s: $MAXS"
echo ""

sed "s/<RVALUE_MASTER>/${MAXR}/g" "${CURRENTDIR}/master_integrals/jobs.yaml" > "${CURRENTDIR}/master_integrals/tmp.yaml"
mv "${CURRENTDIR}/master_integrals/tmp.yaml" "${CURRENTDIR}/master_integrals/jobs.yaml"

sed "s/<SVALUE_MASTER>/${MAXS}/g" "${CURRENTDIR}/master_integrals/jobs.yaml" > "${CURRENTDIR}/master_integrals/tmp.yaml"
mv "${CURRENTDIR}/master_integrals/tmp.yaml" "${CURRENTDIR}/master_integrals/jobs.yaml"

sed "s/<SECTOR_MASTER>/[${MAXSECTOR}]/g" "${CURRENTDIR}/master_integrals/jobs.yaml" > "${CURRENTDIR}/master_integrals/tmp.yaml"
mv "${CURRENTDIR}/master_integrals/tmp.yaml" "${CURRENTDIR}/master_integrals/jobs.yaml"

cut -f1 -d"#" master_integrals/myintegrals > master_integrals/tmp.txt
mv master_integrals/tmp.txt master_integrals/myintegrals

printf "Running kira...       "
cd "${CURRENTDIR}/master_integrals/"
kira jobs.yaml &> /dev/null 
kira export.yaml &> /dev/null 
printf "${GREEN}Done!${NC}\n" 

# timing
end=`date +%s`
runtime=$((end-start))

printf "\nTotal execution time: $(($runtime / 3600))hrs $((($runtime / 60) % 60))min $(($runtime % 60))sec\n\n"
