#!/usr/bin/env bash

#SBATCH --job-name=maker_filter       # Job name
#SBATCH --output=maker_filter_%j.out  # Standard output log
#SBATCH --error=maker_filter_%j.err   # Standard error log
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G                     # 20G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
FINALDIR="${WORKDIR}/final"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="${COURSEDIR}/softwares/Maker_v3.01.03/src/bin"

# Inputs
gff="${FINALDIR}/hifi_assembly.all.maker.noseq.renamed.iprscan.gff"
transcript="${FINALDIR}/hifi_assembly.all.maker.transcripts.fasta.renamed.fasta"
protein="${FINALDIR}/hifi_assembly.all.maker.proteins.fasta.renamed.fasta"

cd "${FINALDIR}"

# Filter the GFF by AED and/or Pfam (InterProScan) annotations
#    -s: prints transcripts with AED < 1 and/or Pfam domain (from iprscan)
perl "${MAKERBIN}/quality_filter.pl" -s "${gff}" > hifi_assembly_iprscan_quality_filtered.gff

# Keep only gene-relevant features
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" \
  hifi_assembly_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3

# Check
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# Extract remaining mRNA IDs and filter transcript/protein FASTAs
module load UCSC-Utils/448-foss-2021a
module load MariaDB/10.6.4-GCC-10.3.0

grep -P "\tmRNA\t" filtered.genes.renamed.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' > list.txt 

faSomeRecords "${transcript}" list.txt "${FINALDIR}/hifi_assembly.transcripts.renamed.filtered.fasta"
faSomeRecords "${protein}"    list.txt "${FINALDIR}/hifi_assembly.proteins.renamed.filtered.fasta"