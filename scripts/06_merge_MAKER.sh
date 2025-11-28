#!/usr/bin/env bash

#SBATCH --job-name=merge_gff          # Job name
#SBATCH --output=merge_gff_%j.out     # Standard output log
#SBATCH --error=merge_gff_%j.err      # Standard error log
#SBATCH --cpus-per-task=4             
#SBATCH --mem=10G                     # 10G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="${COURSEDIR}/softwares/Maker_v3.01.03/src/bin"
DS_LOG="${WORKDIR}/MAKER_results/gene_annotation_directory/hifi_assembly.maker.output/hifi_assembly_master_datastore_index.log"
OUTDIR="${WORKDIR}/MAKER_results/gene_annotation_directory/merged"

# Create Output directory
mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

# Merge GFFs
"${MAKERBIN}/gff3_merge" -s -d "${DS_LOG}" > hifi_assembly.all.maker.gff
"${MAKERBIN}/gff3_merge" -n -s -d "${DS_LOG}" > hifi_assembly.all.maker.noseq.gff

# Merge FASTAs
"${MAKERBIN}/fasta_merge" -d "${DS_LOG}" -o hifi_assembly
    # (writes to current dir with -o prefix)