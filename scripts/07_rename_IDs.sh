#!/usr/bin/env bash

#SBATCH --job-name=rename_map          # Job name
#SBATCH --output=rename_map_%j.out     # Standard output log
#SBATCH --error=rename_map_%j.err      # Standard error log
#SBATCH --cpus-per-task=5             
#SBATCH --mem=10G                      # 10G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
SOURCEDIR="${WORKDIR}/MAKER_results/gene_annotation_directory/merged"   # where the merged files are
FINALDIR="${WORKDIR}/final"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="${COURSEDIR}/softwares/Maker_v3.01.03/src/bin"

# Create Output directory
mkdir -p "${FINALDIR}"
cd "${FINALDIR}"

# Filenames
protein="hifi_assembly.all.maker.proteins.fasta"
transcript="hifi_assembly.all.maker.transcripts.fasta"
gff="hifi_assembly.all.maker.noseq.gff"

# Copy from SOURCEDIR to FINALDIR with ".renamed" suffixes
cp "${SOURCEDIR}/${gff}"        "${FINALDIR}/${gff}.renamed.gff"
cp "${SOURCEDIR}/${protein}"    "${FINALDIR}/${protein}.renamed.fasta"
cp "${SOURCEDIR}/${transcript}" "${FINALDIR}/${transcript}.renamed.fasta"

# Accession as prefix
prefix="Anz_0"

# Build ID map from the GFF
"${MAKERBIN}/maker_map_ids" --prefix "${prefix}" --justify 7 "${gff}.renamed.gff" > id.map 

# Apply the map to GFF and FASTAs
"${MAKERBIN}/map_gff_ids"   id.map "${gff}.renamed.gff"
"${MAKERBIN}/map_fasta_ids" id.map "${protein}.renamed.fasta"
"${MAKERBIN}/map_fasta_ids" id.map "${transcript}.renamed.fasta"