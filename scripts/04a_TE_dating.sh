#!/usr/bin/env bash

#SBATCH --job-name=parseRM            # Job name
#SBATCH --output=parseRM_%j.out       # Standard output log
#SBATCH --error=parseRM_%j.err        # Standard error log
#SBATCH --cpus-per-task=4             
#SBATCH --mem=15G                      # 4G memory allocation
#SBATCH --time=00:10:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
PARSE_SCRIPT="${WORKDIR}/scripts/04b_parseRM.pl"

# RepeatMasker Output File
RM_OUT="${WORKDIR}/EDTA_results/hifi_assembly.fa.mod.EDTA.anno/hifi_assembly.fa.mod.out"

# Load BioPerl Module (required for parseRM.pl)
module load BioPerl/1.7.8-GCCcore-10.3.0

# Parse the RepeatMasker Output
perl "${PARSE_SCRIPT}" -i "${RM_OUT}" -l "50,1" -v