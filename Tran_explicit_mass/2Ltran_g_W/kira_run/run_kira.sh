# !/bin/bash

# You might need to make this script executable
#
# chmod +x run_kira.sh
# ./run_kira.sh


# colours
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# timing
start=`date +%s`

# cycle over every topology
COUNTER=1
TOTAL=$(ls -l */jobs.yaml | wc -l | sed 's/ //g')
TOTAL=$((TOTAL-1))

CURRENTDIR=$(pwd)

printf "\nRunning ${RED}Kira${NC} in ${RED}${CURRENTDIR}${NC}\n\n"

for topology in */ ; do
	
    case $topology in
    	master_integrals/) continue;;
    esac    

    cd "${CURRENTDIR}/${topology}"

    # Print some info
    printf "%-60b" "${COUNTER}/${TOTAL}) Starting the run for ${BLUE}${topology}${NC} ... ";

    # Run AMFlow
    kira jobs.yaml &> /dev/null 
    kira export.yaml &> /dev/null 


    printf "${GREEN}Done!${NC}\n"

    # Increment counter
    (( COUNTER++ ))

done

# timing
end=`date +%s`
runtime=$((end-start))

printf "\nTotal execution time: $(($runtime / 3600))hrs $((($runtime / 60) % 60))min $(($runtime % 60))sec\n\n"