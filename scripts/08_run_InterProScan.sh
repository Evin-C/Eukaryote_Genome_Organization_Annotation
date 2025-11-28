#!/usr/bin/env bash

#SBATCH --job-name=interproscan       # Job name
#SBATCH --output=interproscan_%j.out  # Standard output log
#SBATCH --error=interproscan_%j.err   # Standard error log
#SBATCH --cpus-per-task=10             
#SBATCH --mem=20G                     # 20G memory allocation
#SBATCH --time=02:00:00
#SBATCH --partition=pibu_el8

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
FINALDIR="${WORKDIR}/final"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="${COURSEDIR}/softwares/Maker_v3.01.03/src/bin"

# Inputs (produced in the previous step)
protein="${FINALDIR}/hifi_assembly.all.maker.proteins.fasta.renamed.fasta"
gff="${FINALDIR}/hifi_assembly.all.maker.noseq.gff.renamed.gff"

# Run InterProScan (PFAM, TSV)
apptainer exec \
  --bind "${COURSEDIR}/data/interproscan-5.70-102.0/data:/opt/interproscan/data" \
  --bind "${WORKDIR}" \
  --bind "${COURSEDIR}" \
  --bind "${SCRATCH}:/temp" \
  "${COURSEDIR}/containers/interproscan_latest.sif" \
  /opt/interproscan/interproscan.sh \
    -appl pfam --disable-precalc -f TSV \
    --goterms --iprlookup --seqtype p \
    -i "${protein}" -o "${FINALDIR}/output.iprscan"

# Update GFF with InterProScan results
"${MAKERBIN}/ipr_update_gff" "${gff}" "${FINALDIR}/output.iprscan" > "${FINALDIR}/hifi_assembly.all.maker.noseq.renamed.iprscan.gff"
