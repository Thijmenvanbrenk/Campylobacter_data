#!/bin/bash

# first argument must be gene name
# second argument must be database name
# third argument must be the name of the directory with the summary file created by the "gene_information.sh" script
# (optional) fourth options must be "yes" if you want to blast against self chosen operon
# (optional) fifth option must be file name of self chosen operon

# this script depends on the following directories: "~/difference_analyses/", 
#                                                   "~/MLST_analyses/MLST_genomes_databasename"
# an example of the output can be found in "summary_MLST_Example_gene_confirmation_UK_animals_jejuni.txt"

echo "performing" $1 "blast check on" $2 "PubMLST database";

# check to see if arguments are viable
summarypath=`ls ~/difference_analyses/$3/"$1"_summary.txt | wc -w`;
pubmlstpath=`ls ~/MLST_analyses/MLST_genomes_$2`;

if [ "$summarypath" != 1 ] && [ "$pubmlstpath" != 1 ]
then
echo "database or summary path is not correct, please fill in the correct path";
exit 1;
fi

mlst_files=`ls ~/MLST_analyses/MLST_genomes_$2 | tr "\n" " "`
echo "Nucleotide sequence:" > summary_MLST_"$1"_"$2"_"$3".txt
echo >> summary_MLST_"$1"_"$2"_"$3".txt

if [[ $4 == "yes" ]];
then
operonpath=`ls ~/MLST_analyses/$5 | wc -w`;

if [[ $operonpath != 1 ]];
then
echo "operon file does not exist, please fill in the correct file name";
exit 1;
fi

cat ~/MLST_analyses/$5 >> summary_MLST_"$1"_"$2"_"$3".txt

for file in $mlst_files;
do
echo $file >> temp1.txt;
blastn -query ~/MLST_analyses/MLST_genomes_$2/$file -subject ~/MLST_analyses/$5 | grep "Sequences producing" >> temp1.txt;
done

else

end=`cat ~/difference_analyses/$3/"$1"_summary.txt | grep -B2 -n "Amino acid sequence:" | head -n1 | sed 's:-.*::'`
begin="3"

cat ~/difference_analyses/$3/"$1"_summary.txt | head -n $end | tail -n $((end -3)) >> summary_MLST_"$1"_"$2"_"$3".txt
cat ~/difference_analyses/$3/"$1"_summary.txt | head -n $end | tail -n $((end -3)) | sed 's:-::g' > temp2.txt

for file in $mlst_files;
do
echo $file >> temp1.txt;
blastn -query ~/MLST_analyses/MLST_genomes_$2/$file -subject temp2.txt | grep "Sequences producing" >> temp1.txt;
done

fi

positive_hits=`cat temp1.txt | grep -B1 "Sequences producing" | grep ".fas" | sed 's:_.*::g' | tr "\n" " "`

echo >> summary_MLST_"$1"_"$2"_"$3".txt
echo "all" $2 "isolates" >> summary_MLST_"$1"_"$2"_"$3".txt
echo >> summary_MLST_"$1"_"$2"_"$3".txt

cat ~/MLST_analyses/isolate_source_$2 | cut -f2 | sort | uniq -c >> summary_MLST_"$1"_"$2"_"$3".txt

echo >> summary_MLST_"$1"_"$2"_"$3".txt
echo "isolates with" $1 >> summary_MLST_"$1"_"$2"_"$3".txt
echo >> summary_MLST_"$1"_"$2"_"$3".txt

for file in $positive_hits;
do
grep "$file" ~/MLST_analyses/isolate_source_$2;
done | cut -f2 | sort | uniq -c >> summary_MLST_"$1"_"$2"_"$3".txt

rm temp1.txt
rm temp2.txt

