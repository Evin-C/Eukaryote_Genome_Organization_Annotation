#!/usr/bin/env bash

#SBATCH --job-name=plot_BUSCO         # Job name
#SBATCH --output=plot_BUSCO_%j.out    # Standard output log
#SBATCH --error=plot_BUSCO_%j.err     # Standard error log
#SBATCH --cpus-per-task=2             
#SBATCH --mem=4G                      # 4G memory allocation
#SBATCH --time=00:10:00
#SBATCH --partition=pibu_el8

# Define BUSCO output directory paths
USER="ecapan"
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation/final"
GENOME_DIR="/data/users/${USER}/assembly_annotation_course/Genome_Transcriptome_Assembly/BUSCO_results/hifiasm"
TRANS_DIR="${WORKDIR}/busco_transcripts/busco_transcripts"
PROT_DIR="${WORKDIR}/busco_proteins/busco_proteins"

cd "${WORKDIR}"

# Load BUSCO module
module load BUSCO/5.4.2-foss-2021a

# Generate individual plots (optional but useful)
generate_plot.py -wd "${GENOME_DIR}"
generate_plot.py -wd "${TRANS_DIR}"
generate_plot.py -wd "${PROT_DIR}"

# Create individual plot directory
mkdir -p individual_busco

# Move BUSCO plots into this directory
cp "${GENOME_DIR}/busco_figure.png" "${WORKDIR}/individual_busco/Genome_BUSCO.png"
cp "${TRANS_DIR}/busco_figure.png" "${WORKDIR}/individual_busco/Transcripts_BUSCO.png"
cp "${PROT_DIR}/busco_figure.png" "${WORKDIR}/individual_busco/Proteins_BUSCO.png"

# Create combined plot directory
mkdir -p combined_busco

# Copy + rename short_summary files so labels in the plot are clean
cp "$GENOME_DIR"/short_summary*.txt  combined_busco/short_summary.specific.brassicales_odb10.Genome.txt
cp "$TRANS_DIR"/short_summary*.txt   combined_busco/short_summary.specific.brassicales_odb10.Transcripts.txt
cp "$PROT_DIR"/short_summary*.txt    combined_busco/short_summary.specific.brassicales_odb10.Proteins.txt

# Combined plot (genome + transcripts + proteins)
generate_plot.py -wd ${WORKDIR}/combined_busco/