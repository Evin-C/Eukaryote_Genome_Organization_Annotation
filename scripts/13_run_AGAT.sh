#!/usr/bin/env bash

#SBATCH --job-name=agat_stats         # Job name
#SBATCH --output=agat_stats_%j.out    # Standard output log
#SBATCH --error=agat_stats_%j.err     # Standard error log
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G                     # 10G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
FINALDIR="${WORKDIR}/final"
CONTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/agat_1.5.1--pl5321hdfd78af_0.sif"

# Run AGAT
apptainer exec --bind "${WORKDIR}" "${CONTAINER}" agat_sp_statistics.pl\
    -i "${FINALDIR}/filtered.genes.renamed.gff3" -o "${FINALDIR}/annotation.stat"