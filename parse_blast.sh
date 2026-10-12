#!/bin/bash

BLAST_FILE="blastoutput2.out"

echo " BLAST Output Parsing Script "

echo -e "1. List the subject accession for all HSPs"
awk '{print $2}' $BLAST_FILE

echo -e "2. List the alignment length and percent ID for all HSPs "
awk '{print "Length: " $4 ", Percent ID: " $3}' $BLAST_FILE

echo -e "3. Show the HSPs with more than 20 mismatches"
awk '$5 > 20' $BLAST_FILE

echo -e "4. Show the HSPs shorter than 100 amino acids and with more than 20 mismatches"
awk '$4 < 100 && $5 > 20' $BLAST_FILE

echo -e "5. List the first 20 HSPs that have fewer than 20 mismatches"
awk '$5 < 20' $BLAST_FILE | head -n 20

echo -e "6. How many HSPs are shorter than 100 amino acids? "
awk '$4 < 100' $BLAST_FILE | wc -l

echo -e "7. List the top ten highest (best) HSPs "
sort -k12,12nr $BLAST_FILE | head -n 10

echo -e "8. List the start positions of all matches where the HSP Subject accession includes 'AEI'"
awk '$2 ~ /AEI/ {print $9}' $BLAST_FILE

echo -e "9. How many subject sequences have more than one HSP?"
awk '{print $2}' $BLAST_FILE | sort | uniq -c | awk '$1 > 1' | wc -l

echo -e "10. What percentage of each HSP is made up of mismatches? "
awk '{print ($5 / $4) * 100 "%"}' $BLAST_FILE

echo -e "11. Allocate HSPs into different groups based on their scores"
awk '{
    if ($12 < 50) group="Low Score (<50)";
    else if ($12 >= 50 && $12 < 100) group="Mid-Low (50-100)";
    else if ($12 >= 100 && $12 < 200) group="Mid-High (100-200)";
    else group="High Score (>200)";
    print group ": " $0
}' $BLAST_FILE

echo -e "Script execution complete!"
