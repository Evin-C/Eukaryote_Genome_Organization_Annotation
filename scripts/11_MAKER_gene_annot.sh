#!/usr/bin/env bash

#SBATCH --job-name=MAKER              # Job name
#SBATCH --output=MAKER_%j.out         # Standard output log
#SBATCH --error=MAKER_%j.err          # Standard error log  
#SBATCH --mem=120G                    # 120G memory allocation
#SBATCH --time=7-0
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50

# Define variables
USER="ecapan"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
WORKDIR="/data/users/${USER}/genome_organization_annotation/Eukaryote_Genome_Organization_Annotation/MAKER_results/gene_annotation_directory"
REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker" 

# Load module
module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

cd ${WORKDIR}

# Run
mpiexec --oversubscribe -n 50 apptainer exec \
 --bind $SCRATCH:/TMP --bind $COURSEDIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR --bind ${WORKDIR}\
 ${COURSEDIR}/containers/MAKER_3.01.03.sif \
 maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl