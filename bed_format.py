import subprocess
import os

current_dir = os.getcwd()

#function to convert output sam files to sorted bam files
def sam_to_sorted_bam(input_sam, sorted_bam):
    bam_output = sorted_bam.replace('.bam', '_temp.bam')
    sam_to_bam_command = ['samtools', 'view', '-S', '-b', input_sam, '-o', bam_output]
    subprocess.run(sam_to_bam_command, check=True)

    sort_command = ['samtools', 'sort', '-o', sorted_bam, bam_output]
    subprocess.run(sort_command, check=True)

    subprocess.run(['rm', bam_output])

#function to convert bam file to bed format
def bam_to_bed(sorted_bam, output_bed):
    command = ['bedtools', 'bamtobed', '-i', sorted_bam]
    with open(output_bed, 'w') as bed_file:
        subprocess.run(command, stdout=bed_file, check=True)

#additional formatting I found necessary to remove all the extra columns
def format_bed_file(output_bed, formatted_bed):
    with open(output_bed, 'r') as input_file:
        with open(formatted_bed, 'w') as output_file:
            for line in input_file:
                columns = line.strip().split('\t')
                chromosome = columns[0]
                start_position = columns[1]
                end_position = columns[2]
                output_file.write(f'{chromosome}\t{start_position}\t{end_position}\n')

#converting the names of the chromosomes to match the format of the reference annotatins file - necessary for chromosome names to be the same when using bedtools intersect
def convert_chromosome_names(formatted_bed, chr_bed):
    with open(formatted_bed, 'r') as input_file:
        with open(chr_bed, 'w') as output_file:
            for line in input_file:
                chromosome, start_pos, end_pos = line.strip().split('\t')
                converted_chromosome = 'chr' + chromosome.split('.')[0].split('_')[1].lstrip('0')
                output_file.write(f'{converted_chromosome}\t{start_pos}\t{end_pos}\n')

input_sam = os.path.join(current_dir, 'aligned_reads.sam')
sorted_bam = os.path.join(current_dir, 'sorted_output.bam')
output_bed = os.path.join(current_dir, 'output_bed.bed')
formatted_bed = os.path.join(current_dir, 'formatted_bed.bed' )
annotated_bed = os.path.join(current_dir, 'output_annotated_bed.bed')
gene_gtf = os.path.join(current_dir, 'gencode.v38.annotation.gtf')
output_bed_with_converted_chromosomes = 'converted_chromosomes_bed.bed'

sam_to_sorted_bam(input_sam, sorted_bam)

print('SAM to sorted BAM conversion completed successfully.')

bam_to_bed(sorted_bam, output_bed)

format_bed_file(output_bed, formatted_bed)

convert_chromosome_names(formatted_bed, output_bed_with_converted_chromosomes)

print('BAM to BED conversion completed successfully.')






