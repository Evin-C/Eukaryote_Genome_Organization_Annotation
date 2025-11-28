#!/usr/bin/env bash

#SBATCH --job-name=samtools_faidx      # Job name
#SBATCH --output=samtools_faidx_%j.out # Standard output log
#SBATCH --error=samtools_faidx_%j.err  # Standard error log
#SBATCH --cpus-per-task=1             
#SBATCH --mem=2G                       # 2G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
CONTAINER="/containers/apptainer/samtools-1.19.sif"
INPUT_HIFIASM_FASTA="${WORKDIR}/assemblies/hifi_assembly.fa"
OUTDIR="${WORKDIR}/samtools_results/"

# Create Output directory
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

# Run samtools faidx on the assembly FASTA (index is created next to the FASTA)
apptainer exec --bind "${WORKDIR}" "${CONTAINER}" samtools \
faidx "${INPUT_HIFIASM_FASTA}"

# Copy index from the FASTA directory to the output directory
cp -f "${INPUT_HIFIASM_FASTA}.fai" "${OUTDIR}"