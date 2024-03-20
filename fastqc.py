import subprocess
import os

#relative path
current_dir = os.getcwd()

#function to run FastQC read quality analysis. An HTML file containing data and visualizations will be output to current working directory
def run_fastqc(input_files):
    for input_file in input_files:
        command = ['fastqc', input_file]
        subprocess.run(command)

input_fastq_1 = os.path.join(current_dir, 'sample1_R1.fastq')
input_fastq_2 = os.path.join(current_dir, 'sample1_R2.fastq')

#calls function for both paired end reads separately
run_fastqc([input_fastq_1, input_fastq_2])



