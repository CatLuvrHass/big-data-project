#!/bin/bash
#part 1
touch clean_bash.csv
while read line
do
	#part 1, part 2, part 3
	echo "$line" | sed 's/#]//'  | sed 's/-/,/g' | sed ':a;s/^\(\([^"]*,\?\|"[^",]*",\?\)*"[^",]*\),/\1 /;ta' | tr -d '"'

done <  bashdm.csv > clean_bash.csv


#create a loop for columns and check when word count == 1 and add them to list
num_cols=$(head -1 clean_bash.csv | sed -e 's/[^,]//g' | wc -c)
list=()

for ((i=1; i <= $num_cols; i++)); do
	if [[ $(cut -d, -f $i clean_bash.csv | sed '1d'| sort | uniq | wc -l) -eq 1 ]]
	then
		list+=($i)
	fi
done 

# create a delimeter between the bad cols to cut and return complement clean columns
badCol=""
deli=''
for item in "${list[@]}"; do
	badCol="$badCol$deli$item"
	deli=","
done
cut -d, -f$badCol --complement clean_bash.csv > output.csv

# this loops through two files and return the desired country name from dictionary.csv
# it creates a dictionary of col2 in the file with value of the country name
# then we return this into col4 if col4 of our output file matches.

awk -F"&|," 'FNR==NR{

if(NR>1) a[$2]=$3
next}

{if(FNR==1) next
	$4 = ($4 in a ? a[$4] : "NOT FOUND") }
1' OFS=, dictionary.csv output.csv > last.csv 
 
sed -i '1s/^/INDEX,Name,Age,Country,Height,Hair_Colour\n/' last.csv
