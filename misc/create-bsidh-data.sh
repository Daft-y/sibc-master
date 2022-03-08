#!/bin/bash

# this generates all the required data for bsidh

echo '# logs generated by create-bsidh-data.sh'

declare -a configuration=(\
    "p253" \
    "p255" \
    "p247" \
    "p237" \
    "p257"
    )

for i in `eval echo {0..${#configuration[@]}}`; do
    echo
    echo "# $(date) # Base configuration: ${configuration[$i]}"
    sibc-precompute-sdacs --prime ${configuration[$i]} --algorithm bsidh
    for multievaluation in "--multievaluation" ""; do
        echo "# Processing: sibc --prime ${configuration[$i]} --formula hvelu --algorithm bsidh $multievaluation -u bsidh-precompute-parameters"
        sibc --prime ${configuration[$i]} --formula hvelu --algorithm bsidh $multievaluation -u bsidh-precompute-parameters
        for tuned in "--tuned" ""; do
            for formula in tvelu svelu hvelu; do
                    if [ "$formula" == "tvelu" ] && ([ "$multievaluation" != "" ] || [ "$tuned" != "" ])
                    then
                        continue
                    fi
                    echo "# Processing: sibc --prime ${configuration[$i]} --formula $formula --algorithm bsidh $multievaluation $tuned -u bsidh-precompute-strategy"
                    sibc --prime ${configuration[$i]} --formula $formula --algorithm bsidh $multievaluation $tuned -u bsidh-precompute-strategy
                done
            done
    done
done
echo
echo "# create-bsidh-data.sh finished at $(date)"
