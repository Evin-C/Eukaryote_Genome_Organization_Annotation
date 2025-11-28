#!/usr/bin/env bash

#SBATCH --job-name=maker_map_funcs      # Job name
#SBATCH --output=maker_map_funcs_%j.out # Standard output log
#SBATCH --error=maker_map_funcs_%j.err  # Standard error log
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G                        # 8G memory allocation
#SBATCH --time=02:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
FINALDIR="${WORKDIR}/final"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="${COURSEDIR}/softwares/Maker_v3.01.03/src/bin"

# Inputs
UNIPROT_FA="/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa"
BLAST_BEST="${FINALDIR}/uniprot.blastp.tsv.besthits"
PROT_IN="${FINALDIR}/hifi_assembly.proteins.renamed.filtered.fasta"
GFF_IN="${FINALDIR}/filtered.genes.renamed.gff3"

# Make copies
cp "${PROT_IN}" "${PROT_IN}.Uniprot"
cp "${GFF_IN}"  "${GFF_IN}.Uniprot"

# Write functional annotations into FASTA and GFF
"${MAKERBIN}/maker_functional_fasta" "${UNIPROT_FA}" "${BLAST_BEST}" "${PROT_IN}" > "${PROT_IN}.Uniprot"
"${MAKERBIN}/maker_functional_gff"   "${UNIPROT_FA}" "${BLAST_BEST}" "${GFF_IN}"  > "${GFF_IN}.Uniprot.gff3"