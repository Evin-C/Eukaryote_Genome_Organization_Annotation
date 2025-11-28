#!/usr/bin/env bash

#SBATCH --job-name=genespace_input      # Job name
#SBATCH --output=genespace_input_%j.out # Standard output log
#SBATCH --error=genespace_input_%j.err  # Standard error log
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G                        # 4G memory allocation
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
FINALDIR="${WORKDIR}/final"
OUTDIRBED="${WORKDIR}/genespace/bed"
OUTDIRPEPTIDE="${WORKDIR}/genespace/peptide"

# Longest Protein File Path
LONGPROT="${FINALDIR}/maker_proteins.longest.fasta"

mkdir -p "${OUTDIRBED}"
mkdir -p "${OUTDIRPEPTIDE}"

# Accession Names
ANZ="Anz_0"
ALTAI="Altai_5"
ETNA="Etna_2"
TAZ="Taz_0"

# Accession GFFs Directories
GENEGFFS="/data/courses/assembly-annotation-course/CDS_annotation/data/Lian_et_al/gene_gff/selected"
# Accession Fasta Directories
PROTFASTA="/data/courses/assembly-annotation-course/CDS_annotation/data/Lian_et_al/protein/selected"

# Prepare BED Files
cd "${OUTDIRBED}"
###-ANZ--------------------------------------------------------------------------------------------------ANZ-###
# Extract gene features from Accession Anz-0 GFF3
grep -P "\tgene\t" "${FINALDIR}/filtered.genes.renamed.gff3" > temp_genes.gff3

# Format into a BED file
awk 'BEGIN{OFS="\t"}{
  split($9,a,";"); split(a[1],b,"=");
  print $1, $4-1, $5, b[2]
}' temp_genes.gff3 > "${ANZ}.bed"
###-ALTAI----------------------------------------------------------------------------------------------ALTAI-###
# Extract gene features from Accession Altai-5 GFF3
grep -P "\tgene\t" "${GENEGFFS}/Altai-5.EVM.v3.5.ann.protein_coding_genes.gff" > temp_genes.gff3

# Format into a BED file
awk 'BEGIN{OFS="\t"}{
  split($9,a,";"); split(a[1],b,"=");
  print $1, $4-1, $5, b[2]
}' temp_genes.gff3 > "${ALTAI}.bed"
###-ETNA------------------------------------------------------------------------------------------------ETNA-###
# Extract gene features from Accession Etna-2 GFF3
grep -P "\tgene\t" "${GENEGFFS}/Etna-2.EVM.v3.5.ann.protein_coding_genes.gff" > temp_genes.gff3

# Format into a BED file
awk 'BEGIN{OFS="\t"}{
  split($9,a,";"); split(a[1],b,"=");
  print $1, $4-1, $5, b[2]
}' temp_genes.gff3 > "${ETNA}.bed"
###-TAZ--------------------------------------------------------------------------------------------------TAZ-###
# Extract gene features from Accession Taz-0 GFF3
grep -P "\tgene\t" "${GENEGFFS}/Taz-0.EVM.v3.5.ann.protein_coding_genes.gff" > temp_genes.gff3

# Format into a BED file
awk 'BEGIN{OFS="\t"}{
  split($9,a,";"); split(a[1],b,"=");
  print $1, $4-1, $5, b[2]
}' temp_genes.gff3 > "${TAZ}.bed"

###-------------------------------------------------------------------------------------------------------------
# Prepare Peptide Files
cd "${OUTDIRPEPTIDE}"
###-ANZ--------------------------------------------------------------------------------------------------ANZ-###
# rewrite headers from isoform -> gene (strip -R*)
# Input: ${FINALDIR}/maker_proteins.longest.fasta
# Output: Anz_0.fa (headers are pure gene IDs matching the BED)
awk 'BEGIN{FS="[ \t]"; OFS=""}
  /^>/{
    id=$1; sub(/^>/,"",id);           # first token of header
    gene=id; sub(/-R.*/,"",gene);     # drop isoform suffix (e.g., -RA/-RB/…)
    print ">", gene; next
  }
  { print }
' "${FINALDIR}/maker_proteins.longest.fasta" > Anz_0.fa
###-ALTAI----------------------------------------------------------------------------------------------ALTAI-###
cp "${PROTFASTA}/Altai-5.protein.faa" "${ALTAI}.fa"
###-ETNA------------------------------------------------------------------------------------------------ETNA-###
cp "${PROTFASTA}/Etna-2.protein.faa" "${ETNA}.fa"
###-TAZ--------------------------------------------------------------------------------------------------TAZ-###
cp "${PROTFASTA}/Taz-0.protein.faa" "${TAZ}.fa"

###-------------------------------------------------------------------------------------------------------------
# TAIR10 files
TAIRFILES="/data/courses/assembly-annotation-course/CDS_annotation/data"

# Copy TAIR10 files
cp "${TAIRFILES}/TAIR10.bed" "${OUTDIRBED}"
cp "${TAIRFILES}/TAIR10.fa" "${OUTDIRPEPTIDE}"