#!/usr/bin/env bash
#SBATCH --job-name=TEsorter_copia      # Job name
#SBATCH --output=TEsorter_copia_%j.out # Standard output log
#SBATCH --error=TEsorter_copia_%j.err  # Standard error log
#SBATCH --cpus-per-task=16             
#SBATCH --mem=80G                      # 80G memory allocation
#SBATCH --time=24:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
CONTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif"

# Input File from SeqKit (Copia Sequences)
INPUT_FILE="${WORKDIR}/SeqKit_results/Copia_TElib/Copia_sequences.fa"

OUTDIR="${WORKDIR}/TEsorter_results/Copia"
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

# Run TEsorter
apptainer exec --bind "${WORKDIR}" "${CONTAINER}" TEsorter \
"${INPUT_FILE}" -db rexdb-plant -p "${SLURM_CPUS_PER_TASK}"