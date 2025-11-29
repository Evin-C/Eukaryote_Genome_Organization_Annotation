# Organisation and Annotation of the *Arabidopsis thaliana* (Anz-0) Genome

**This repository contains scripts and workflow steps for the course "Organisation and Annotation of Eukaryote Genomes (UE-SBL.30004) \[AS-2025\]".**

The goal is to annotate the *Arabidopsis thaliana* accession **Anz-0**, analyse
its transposable element (TE) content, generate and refine gene models, and
compare the genome to other *A. thaliana* accessions and the TAIR10 reference.

The project includes the following workflow steps:

1. **Transposable Element Annotation and Classification**
2. **TE Age Estimation and Genomic Distribution**
3. **Gene Annotation with MAKER**
4. **Annotation Refinement, Functional Annotation, and Quality Assessment**
5. **Comparative Genomics and Pangenome Analysis**

---
## Data

This project uses a PacBio HiFi assembly of *Arabidopsis thaliana* Anz-0 and
external evidence for gene annotation.

- **Genome assembly**: Hifiasm assembly of accession **Anz-0**  
- **Transcript evidence**: Trinity assembly of paired-end RNA-seq reads from accession Sha  
- **Reference genome and proteins**: *A. thaliana* TAIR10  
- **Additional accessions for comparative genomics**: course-provided assemblies

All data are publicly available from the following publications:
- [Lian Q et al. (2024). Nature Genetics, 56:982–991](https://www.nature.com/articles/s41588-024-01715-9). 
- [Jiao WB, Schneeberger K. (2020). Nature Communications, 11:1–10](http://dx.doi.org/10.1038/s41467-020-14779-y). 

---

## Repository structure
```bash
Eukaryote_Genome_Organization_Annotation/
│
├── plots/
│   ├── AED_cumulative_distribution.pdf          # Cumulative AED distribution of gene models
│   ├── LTR_identity_Copia_Gypsy_cladelevel.pdf  # Clade-level LTR identity histograms
│   ├── TAIR10_bp.rip.pdf                        # Riparian plot vs TAIR10 and other accessions
│   ├── TE_density_all.pdf                       # Genome-wide TE and gene density (circlize)
│   ├── busco_figure.pdf                         # BUSCO completeness summary
│   ├── pangenome_frequency_plot.pdf             # Core/accessory/specific gene and OG counts
│   └── repeat_divergence_age_landscape_Mbp.pdf  # TE divergence/age landscape in Mbp
│
├── scripts/
│   ├── 01_run_EDTA.sh                  # Genome-wide TE annotation with EDTA
│   ├── 02a_TEsorter_ltr_full.sh        # Classify full-length LTR-RTs with TEsorter
│   ├── 02b_full_length_LTRs_identity.R # LTR identity distributions by clade
│   ├── 02c_run_samtools.sh             # Samtools-based coverage / index steps for density plots
│   ├── 02d_annotation_circlize.R       # Circos-style TE and gene density plots
│   ├── 03a_run_seqkit_copia.sh         # Extract Copia sequences from TE library
│   ├── 03b_run_seqkit_gypsy.sh         # Extract Gypsy sequences from TE library
│   ├── 03c_TEsorter_copia.sh           # Clade-level classification of Copia elements
│   ├── 03d_TEsorter_gypsy.sh           # Clade-level classification of Gypsy elements
│   ├── 04a_TE_dating.sh                # Wrapper for TE dating (calls 04b_parseRM.pl)
│   ├── 04b_parseRM.pl                  # Parse RepeatMasker output and compute divergence
│   ├── 04c_plot_div.R                  # TE age/divergence landscape plots
│   ├── 05a_MAKER_control_files.sh      # Create MAKER control files
│   ├── 05b_MAKER_gene_annot.sh         # Run MAKER genome annotation
│   ├── 06_merge_MAKER.sh               # Merge per-contig MAKER outputs
│   ├── 07_rename_IDs.sh                # Assign stable Anz-0 gene and transcript IDs
│   ├── 08_run_InterProScan.sh          # Functional domain annotation with InterProScan
│   ├── 09a_calculate_AED.sh            # Update GFF and calculate AED scores
│   ├── 09b_plot_AED.R                  # AED cumulative distribution plot
│   ├── 10_filter_MAKER.sh              # Filter GFF/FASTA to retain high-quality gene models
│   ├── 11a_longest_protein.sh          # Extract longest protein per gene
│   ├── 11b_longest_transcript.sh       # Extract longest transcript per gene
│   ├── 12a_run_BUSCO.sh                # BUSCO on longest proteins/transcripts
│   ├── 12b_plot_BUSCO.sh               # BUSCO summary figure
│   ├── 13_run_AGAT.sh                  # Summary statistics with AGAT
│   ├── 14a_uniprot_BLAST.sh            # BLASTP against UniProt Viridiplantae
│   ├── 14b_MAKER_map_func.sh           # Map BLAST/functional info back to annotations
│   ├── 14c_TAIR_BLAST.sh               # BLASTP against TAIR10 representative proteins
│   ├── 15_genespace_input_prep.sh      # Prepare GENESPACE input files
│   ├── 16a_run_genespace.sh            # Run GENESPACE pipeline
│   ├── 16b_genespace.R                 # GENESPACE visualisation (synteny, riparian plots)
│   └── 17_process_pangenome.R          # Pangenome matrix processing and frequency plots
│
├── .gitignore
├── LICENSE
└── README.md
```

## Analysis Workflow

| Step | Script number(s) | Task  | Tools  |
| ---- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------------ |
| 1    | [01](scripts/01_run_EDTA.sh), [02a](scripts/02a_TEsorter_ltr_full.sh), [03a](scripts/03a_run_seqkit_copia.sh), [03b](scripts/03b_run_seqkit_gypsy.sh), [03c](scripts/03c_TEsorter_copia.sh), [03d](scripts/03d_TEsorter_gypsy.sh)                                                                                            | TE identification, superfamily and clade-level classification                     | EDTA, TEsorter, SeqKit               |
| 2    | [02b](scripts/02b_full_length_LTRs_identity.R), [02c](scripts/02c_run_samtools.sh), [02d](scripts/02d_annotation_circlize.R), [04a](scripts/04a_TE_dating.sh), [04b](scripts/04b_parseRM.pl), [04c](scripts/04c_plot_div.R)                                                                                                  | TE age estimation and genomic distribution                                        | RepeatMasker (via EDTA), samtools, R |
| 3    | [05a](scripts/05a_MAKER_control_files.sh), [05b](scripts/05b_MAKER_gene_annot.sh), [06](scripts/06_merge_MAKER.sh), [07](scripts/07_rename_IDs.sh)                                                                                                                                                                           | Genome-wide gene prediction and ID assignment                                     | MAKER, AUGUSTUS                      |
| 4    | [08](scripts/08_run_InterProScan.sh), [09a](scripts/09a_calculate_AED.sh), [09b](scripts/09b_plot_AED.R), [10](scripts/10_filter_MAKER.sh), [11a](scripts/11a_longest_protein.sh), [11b](scripts/11b_longest_transcript.sh), [12a](scripts/12a_run_BUSCO.sh), [12b](scripts/12b_plot_BUSCO.sh), [13](scripts/13_run_AGAT.sh) | Functional annotation, AED-based filtering and quality assessment                 | InterProScan, BUSCO, AGAT            |
| 5 | [14a](scripts/14a_uniprot_BLAST.sh), [14c](scripts/14c_TAIR_BLAST.sh), [14b](scripts/14b_MAKER_map_func.sh), [15](scripts/15_genespace_input_prep.sh), [16a](scripts/16a_run_genespace.sh), [16b](scripts/16b_genespace.R), [17](scripts/17_process_pangenome.R) | Homology-based functional annotation, orthogroups, synteny and pangenome analysis | BLAST+, GENESPACE, OrthoFinder |

The workflow was applied to the Anz-0 genome and compared to accessions TAIR10, Etna-2, Altai-5, and Taz-0 using orthogroup and synteny analyses.

## Dependencies
### Tools
The following tools and versions were used:
- [EDTA](https://github.com/oushujun/EDTA) (v2.2.2)
- [TEsorter](https://github.com/zhangrengang/TEsorter) (v1.3.0)
- [SeqKit](https://bioinf.shenwei.me/seqkit) (v2.6.1)
- [BioPerl](https://bioperl.org) (v1.7.8)
- [MAKER](https://hpc.nih.gov/apps/maker.html) (v3.01.03)
- [OpenMPI](https://www.open-mpi.org) (v4.1.1)
- [AUGUSTUS](https://github.com/Gaius-Augustus/Augustus) (v3.4.0)
- [InterProScan](https://www.ebi.ac.uk/interpro/about/interproscan) (v5.70-102.0)
- [UCSC utils](https://genome.ucsc.edu) (v448-foss-2021a)
- [MariaDB](https://mariadb.org) (v10.6.4)
- [BUSCO](https://busco.ezlab.org) (v5.4.2)
- [SAMtools](https://www.htslib.org) (v1.13, v1.19)
- [AGAT](https://github.com/NBISweden/AGAT) (v1.5.1)
- [BLAST+](https://blast.ncbi.nlm.nih.gov/Blast.cgi) (v2.15.0)
- [GENESPACE](https://github.com/jtlovell/GENESPACE) (v1.2.3)
- [OrthoFinder](https://github.com/davidemms/OrthoFinder) (v2.55)

### R packages
R (4.4.2) with the following packages and versions:
- tidyverse (v2.0.0)
- data.table (v1.16.4)
- cowplot (v1.1.3)
- circlize (v0.4.16)
- ComplexHeatmap (v2.22.0) ([Bioconductor](https://bioconductor.org/packages/release/bioc/html/ComplexHeatmap.html))
- dplyr (v1.1.4)
- reshape2 (v1.4.4)
- readr (v2.1.5)

## Usage
All scripts are written for an HPC environment using SLURM.
Containers, module loads, paths, and resource requests (CPUs, memory, runtime) must be
adapted to your system.

Scripts are intended to be executed in numerical order.
Sub-steps with letters (e.g. ```02a```, ```02b```) should be run alphabetically.
```04b_parseRM.pl``` and ```16b_genespace.R``` are called by their corresponding shell
wrappers and are not submitted directly.

Example:
```bash
sbatch scripts/01_run_EDTA.sh
sbatch scripts/05b_MAKER_gene_annot.sh
```
Outputs (GFF3, FASTA, tables, plots, etc.) are written to directories specified inside
each script.

## Notes
- The repository documents the workflow and scripts only; reproducing the full
analysis requires access to the course data on the cluster.
- Summary statistics and figures (TE composition, AED distribution, BUSCO,
synteny and pangenome plots) are provided in the plots/ directory.

## License
This project is licensed under the MIT License.