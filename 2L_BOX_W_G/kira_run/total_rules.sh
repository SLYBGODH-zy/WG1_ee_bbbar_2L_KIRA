# !/bin/bash

# You might need to make this script executable
#
# chmod +x total_rules.sh
# ./total_rules.sh

COUNTER=1
TOTAL=$(ls -l */jobs.yaml | wc -l | sed 's/ //g')

if [ -e kira_myintegrals_1.m ]
then
	printf "\nFile kira_myintegrals_1.m will be overwritten\n" 
	rm kira_myintegrals_1.m
fi

if [ -e kira_myintegrals_2.m ]
then
	printf "\nFile kira_myintegrals_2.m will be overwritten\n" 
	rm -r kira_myintegrals_2.m
fi

printf "\nPutting together the first rules to be applied for reduction to Master Integrals and saving them as kira_myintegrals_1.m.\n\nImporting second rules that need to be applied for reduction to Master Integrals and saving them as kira_myintegrals_2.m \n\n"

for topology in */ ; do
    
    if [ "${topology}" = master_integrals/ ]
    then 
    	resultDir=$(ls master_integrals/results/*/kira_myintegrals.m)
    	cat "${resultDir}" >> kira_myintegrals_2.m
    else 
    	cat "${topology}results/${topology}kira_myintegrals.m" >> listed_rules.m
    fi
    
    # Increment counter
    (( COUNTER++ ))

done

#listed_rules.m are the rules coming from each separated topology, in the form {...->..., ...->..., ...}\n{...->...,...}\n... and we have to create a unique list of rules
#tr is needed because sed works line to line, so doesn't recognise }\n{

tr -d "\n" < listed_rules.m | sed 's/{}//g' | sed 's/}{/,/g' | sed -e 's/ + T/\n + T/g' -e 's/ + 0/\n + 0/g' -e 's/ - 0/\n - 0/g' -e 's/ - T/\n - T/g' -e 's/,T/\n,\nT/g' -e 's/{/{\n/' -e 's/}/\n}/' > kira_myintegrals_1.m

rm listed_rules.m
