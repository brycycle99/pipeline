# Pipeline.sh README

## Overview
This Snakemake workflow automates the execution of several command line steps to
process and analyze raw FastQ files, perform alignment to a reference 
genome, and annotate the aligned reads with gene names.

## Requirements
Ensure the following packages and interpreters are installed:

- **FastQC**: FastQC is used for quality control analysis of the raw FastQ files.
- **HISAT2**: HISAT2 is utilized for aligning the FastQ files to the reference genome.
- **featureCounts**: featureCounts is used to quantify expression levels and generate a report.
- **BEDTools**: BEDTools is required for manipulating and analyzing genomic data in BED format.
- **SAMtools**: SAMtools is necessary for manipulating SAM/BAM format files.
- **Python**: Python interpreter is needed to execute the Python scripts. 

## Pipeline Steps
The pipeline consists of the following steps:

1. **fastqc**: This script utilizes FastQC to analyze raw FastQ files 
and generate a quality report in HTML format.

2. **hisat2_alignment**: Using HISAT2, this script aligns the FastQ 
files to a reference genome file ('GCF_000001405.26_GRCh38_genomic.fna') 
and produces index files along with an 'aligned_reads.sam' file containing 
the aligned reads.

3. **bed_format**: After alignment, this script processes the 
'aligned_reads.sam' file using BEDTools and SAMtools to sort and convert 
it into 'sorted_output.bam' format. It then converts this file to 
tab-delimited BED format, modifying the chromosome name format in the 
process. The intermediate output files are 'formatted_bed.bed' and 
'converted_chromosomes_bed.bed'.

4. **final_format**: Finally, this script trims excess information from 
the 4th column of the BED file (name) and utilizes BEDTools intersect to 
identify sections of the alignment overlapping with genes in the reference 
annotations file ('gencode.v38.annotation.gtf'). The resulting file, 
'final_bed.bed', contains the aligned reads with Ensembl gene name 
annotations.

## Usage
To run the pipeline, execute the `Snakefile` script in the terminal. 
Ensure that all necessary inputs are in the same directory as the pipeline 
script. Also, make sure that the required input files (raw FastQ files, 
reference genome, annotation files) are present in the appropriate 
locations as specified within the scripts.

```Snakemake
--cores n

