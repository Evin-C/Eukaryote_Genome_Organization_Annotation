#!/usr/bin/env bash

#SBATCH --job-name=seqkit_gypsy        # Job name
#SBATCH --output=seqkit_gypsy_%j.out   # Standard output log
#SBATCH --error=seqkit_gypsy_%j.err    # Standard error log
#SBATCH --cpus-per-task=1             
#SBATCH --mem=2G                       # 2G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Load SeqKit module
module load SeqKit/2.6.1

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
OUTDIR="${WORKDIR}/SeqKit_results/Gypsy_TElib"

# EDTA TE library FASTA
TELIB="${WORKDIR}/EDTA_results/hifi_assembly.fa.mod.EDTA.TElib.fa"

# Create Output directory
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

# Extract Gypsy sequences
seqkit grep -r -p "Gypsy" "${TELIB}" > "${OUTDIR}/Gypsy_sequences.fa"