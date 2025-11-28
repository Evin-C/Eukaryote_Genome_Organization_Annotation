#!/usr/bin/env bash

#SBATCH --job-name=calculate_AED      # Job name
#SBATCH --output=calculate_AED_%j.out # Standard output log
#SBATCH --error=calculate_AED_%j.err  # Standard error log
#SBATCH --cpus-per-task=2             
#SBATCH --mem=2G                      # 2G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="${COURSEDIR}/softwares/Maker_v3.01.03/src/bin"
FINALDIR="${WORKDIR}/final"
gff="${FINALDIR}/hifi_assembly.all.maker.noseq.renamed.iprscan.gff"

cd "${FINALDIR}"

perl "${MAKERBIN}/AED_cdf_generator.pl" -b 0.025 ${gff} > assembly.all.maker.renamed.gff.AED.txt 