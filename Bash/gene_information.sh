#!/bin/bash

# first argument must be gene name
# (optional) second argument must be "yes" if you want to blast against all genomes
# third argument is cpu's
# perform this script in a directory that contains the "orthology/pan_genome_sequences" folder
# if you want to perform blast on all genomes, make sure the "~/DEPICT_analyses/DEPICT_genomes/" is present
# an example of the output can be found in "Example_gene_information_isolates_coli_jejuni" and "Example_gene_information_summary"


# check gene name availability
file_numbers=`ls orthology/pan_genome_sequences/ | grep ""$1".fa.aln" | wc -w`;
if [ $file_numbers == 0 ]
then
	echo "This gene file is not present"
	exit 1
fi;

# make a file where all the informatio will be stored
echo "Nucleotide sequence:" > "$1"_summary.txt;
echo >> "$1"_summary.txt;

# selecting the nucleotide sequence of the chosen gene
ending_position=`grep -n ">" orthology/pan_genome_sequences/"$1".fa.aln | sed -n 2p | sed 's/:.*//'`;
cat orthology/pan_genome_sequences/"$1".fa.aln | head -n $(($ending_position -1)) >> "$1"_summary.txt;


# making a temporary file to use transeq
cat orthology/pan_genome_sequences/"$1".fa.aln | head -n $(($ending_position -1)) | sed 's:-::g' > temp.txt;

# running transeq
echo >> "$1"_summary.txt;
echo "Amino acid sequence:" >> "$1"_summary.txt;
echo >> "$1"_summary.txt;

transeq -sequence temp.txt -outseq temp2.txt;
cat temp2.txt >> "$1"_summary.txt;

# running blastp
echo "performing blast against nr database"
blastp -query temp2.txt -db ~/db/nr/nr -out temp3.txt -num_threads 10;

# extracting useful information from blastp
alignment_line=`cat temp3.txt | grep -n "Sequences producing significant alignments" | sed 's/:.*//'`;
cat temp3.txt | head -n $(($alignment_line + 7)) | tail -n 8 >> "$1"_summary.txt;

hit1=`cat temp3.txt | grep -n ">[[:space:]]*[A-Z]" | head -n 1 | sed 's/:.*//'`;
hit2=`cat temp3.txt | grep -n ">[[:space:]]*[A-Z]" | head -n 2 | tail -n1 | sed 's/:.*//'`;

echo >> "$1"_summary.txt;
echo "Best hit" >> "$1"_summary.txt;
echo >> "$1"_summary.txt;
cat temp3.txt | head -n $((hit2-1)) | tail -n $((hit2 - hit1)) >> "$1"_summary.txt;

# adding extra data
echo >> "$1"_summary.txt;
echo "All isolates" >> "$1"_summary.txt;
awk -F '\t' '{print $2}' ../Depict_genome_sources_merged_jejuni.txt | sort | uniq -c >> "$1"_summary.txt;

echo >> "$1"_summary.txt;
echo "Isolates with" $1 "(without blast)">> "$1"_summary.txt;
gene=`cat orthology/clustered_proteins | grep "$1:" | tr "\t" "\n" | sed 's:.fasta_[0-9]*::' | sed 's/"$1": //' | tr "\n" " "`;
for gene in $gene; do grep "$gene" ../Depict_genome_sources_merged_jejuni.txt; done | cut -f 1,2 | sort | uniq | cut -f2 | sort | uniq -c >> "$1"_summary.txt;

# using if else to perform blast against all the genomes

if [[ $2 == "yes" ]]
then
# adding isolates with these genes according to blast
echo "performing nucleotide blast against all depict genomes"
echo >> "$1"_summary.txt;
echo "Isolates with" $1 "(after blast)" >> "$1"_summary.txt;

depict_files=`ls ~/DEPICT_analyses/DEPICT_genomes/ | tr "\n" " "`;
for file in $depict_files; do echo $file >> temp4.txt; blastn -query ~/DEPICT_analyses/DEPICT_genomes/$file -subject temp.txt | grep "Sequences producing" >> temp4.txt; done
gene_files=`cat temp4.txt | grep -B1 "Sequences producing" | grep "fasta" |tr "\n" " " | sed 's:.fasta::g'`;
for file in $gene_files; do grep "$file" ../Depict_genome_sources_merged_jejuni.txt; done | cut -f 2 | sort | uniq -c >> "$1"_summary.txt;
fi

# remove the temporary files
rm temp.txt;
rm temp2.txt;
rm temp3.txt;
rm temp4.txt;



