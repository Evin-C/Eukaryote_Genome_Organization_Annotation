#!/usr/bin/env bash

#SBATCH --job-name=EDTA               # Job name
#SBATCH --output=EDTA_%j.out          # Standard output log
#SBATCH --error=EDTA_%j.err           # Standard input log
#SBATCH --cpus-per-task=40             
#SBATCH --mem=200G                    # 200G memory allocation
#SBATCH --time=48:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
CONTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/EDTA2.2.sif"
INPUT_HIFIASM_FASTA="${WORKDIR}/assemblies/hifi_assembly.fa"
OUTDIR="${WORKDIR}/EDTA_results/"

# EDTA variables
CDS_FASTA="${WORKDIR}/CDS_File/TAIR10_cds_20110103_representative_gene_model_updated"

# Create Output directory if needed
mkdir -p ${OUTDIR}

# Run EDTA
apptainer exec --bind ${WORKDIR} ${CONTAINER} EDTA.pl --genome ${INPUT_HIFIASM_FASTA} \
--species others \
--step all \
--sensitive 1 \
--cds ${CDS_FASTA} \
--anno 1 \
--threads ${SLURM_CPUS_PER_TASK}