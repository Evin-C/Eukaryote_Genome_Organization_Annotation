#!/usr/bin/env bash

#SBATCH --job-name=BUSCO              # Job name
#SBATCH --output=BUSCO_%j.out         # Standard output log
#SBATCH --error=BUSCO_%j.err          # Standard error log
#SBATCH --cpus-per-task=32
#SBATCH --mem=80G                     # 80G memory allocation
#SBATCH --time=24:00:00
#SBATCH --partition=pibu_el8

# Load BUSCO module
module load BUSCO/5.4.2-foss-2021a

# Define variables
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation"
FINALDIR="${WORKDIR}/final"
OUTPROT="${FINALDIR}/busco_proteins"
OUTTX="${FINALDIR}/busco_transcripts"

cd "${FINALDIR}"
mkdir -p "${OUTPROT}"
mkdir -p "${OUTTX}"

# Run BUSCO on proteins
busco -i "${FINALDIR}/maker_proteins.longest.fasta" \
      -l brassicales_odb10 \
      -o busco_proteins \
      -m proteins \
      --cpu ${SLURM_CPUS_PER_TASK} \
      --out_path ${OUTPROT}

# Run BUSCO on transcripts
busco -i "${FINALDIR}/maker_transcripts.longest.fasta" \
      -l brassicales_odb10 \
      -o busco_transcripts \
      -m transcriptome \
      --cpu ${SLURM_CPUS_PER_TASK} \
      --out_path ${OUTTX}