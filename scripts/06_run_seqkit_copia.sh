#!/usr/bin/env bash

#SBATCH --job-name=seqkit_copia        # Job name
#SBATCH --output=seqkit_copia_%j.out   # Standard output log
#SBATCH --error=seqkit_copia_%j.err    # Standard error log
#SBATCH --cpus-per-task=1             
#SBATCH --mem=2G                       # 2G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Load SeqKit module
module load SeqKit/2.6.1

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
OUTDIR="${WORKDIR}/SeqKit_results/Copia_TElib"

# EDTA TE library FASTA
TELIB="${WORKDIR}/EDTA_results/hifi_assembly.fa.mod.EDTA.TElib.fa"

# Create the output directory if it doesn't already exist:
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

# Extract Copia sequences
seqkit grep -r -p "Copia" "${TELIB}" > "${OUTDIR}/Copia_sequences.fa"