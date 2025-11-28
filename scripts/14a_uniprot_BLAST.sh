#!/usr/bin/env bash

#SBATCH --job-name=blast_uniprot      # Job name
#SBATCH --output=blast_uniprot_%j.out # Standard output log
#SBATCH --error=blast_uniprot_%j.err  # Standard error log
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G                     # 32G memory allocation
#SBATCH --time=08:00:00
#SBATCH --partition=pibu_el8

# Load module
module load BLAST+/2.15.0-gompi-2021a

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
FINALDIR="${WORKDIR}/final"

# Inputs
QUERY="${FINALDIR}/hifi_assembly.proteins.renamed.filtered.fasta"   # filtered proteins
DB="/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa"

# Outputs
OUT="${FINALDIR}/uniprot.blastp.tsv"

# Run blast
blastp -query "${QUERY}" -db "${DB}" \
  -num_threads ${SLURM_CPUS_PER_TASK} -outfmt 6 -evalue 1e-5 -max_target_seqs 10 \
  -out "${OUT}"

# Keep best hit per query sequence
sort -t $'\t' -k1,1 -k12,12nr -k11,11g "${OUT}" | sort -t $'\t' -u -k1,1 --merge > "${OUT}.besthits"