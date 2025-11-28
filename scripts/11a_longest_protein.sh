#!/usr/bin/env bash

#SBATCH --job-name=longest_proteins
#SBATCH --output=longest_proteins_%j.out
#SBATCH --error=longest_proteins_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=00:30:00
#SBATCH --partition=pibu_el8

# Load modules
module load SAMtools/1.13-GCC-10.3.0
module load UCSC-Utils/448-foss-2021a
module load MariaDB/10.6.4-GCC-10.3.0

FINALDIR="/data/users/ecapan/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation/final"

PROT="${FINALDIR}/hifi_assembly.all.maker.proteins.fasta.renamed.fasta"

cd "${FINALDIR}"

# Index and pick longest isoform per gene (gene = id before "-R")
samtools faidx "${PROT}"
cut -f1,2 "${PROT}.fai" \
| awk 'BEGIN{FS=OFS="\t"}{id=$1; len=$2; split(id,a,"-R"); gene=a[1]; print gene,len,id}' \
| sort -t $'\t' -k1,1 -k2,2nr \
| awk -F'\t' '!seen[$1]++ {print $3}' \
> protein_longest_ids.txt

# Extract those records
faSomeRecords "${PROT}" protein_longest_ids.txt maker_proteins.longest.fasta