#!/usr/bin/env bash

#SBATCH --job-name=MAKER              # Job name
#SBATCH --output=MAKER_%j.out         # Standard output log
#SBATCH --error=MAKER_%j.err          # Standard error log
#SBATCH --cpus-per-task=4             
#SBATCH --mem=12G                     # 12G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
CONTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif"
OUTDIR="${WORKDIR}/MAKER_results/gene_annotation_directory"

# Create Output directory if needed
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

# Run MAKER to create the Control File
apptainer exec --bind "${WORKDIR}" "${CONTAINER}" maker -CTL 