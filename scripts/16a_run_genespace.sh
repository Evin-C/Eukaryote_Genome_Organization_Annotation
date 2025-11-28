#!/usr/bin/env bash

#SBATCH --job-name=genespace          # Job name
#SBATCH --output=genespace_%j.out     # Standard output log
#SBATCH --error=genespace_%j.err      # Standard error log
#SBATCH --cpus-per-task=20
#SBATCH --mem=80G                     # 80G memory allocation
#SBATCH --time=24:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

chmod u+x ${WORKDIR}/scripts/16b_genespace.R

# Run genespace
apptainer exec --bind ${COURSEDIR} --bind ${WORKDIR} --bind ${SCRATCH}:/temp --bind /data \
  ${COURSEDIR}/containers/genespace_latest.sif Rscript ${WORKDIR}/scripts/16b_genespace.R ${WORKDIR}/genespace