
#function to clean up the annotated bed file. Removes unnecessary files and simply labels each intersected read with the ensembl ID of the gene that it matches
def tsv_to_bed(tsv_file, bed_file):
    with open(tsv_file, 'r') as tsv, open(bed_file, 'w') as bed:
        for line in tsv:
            columns = line.strip().split('\t')
            chromosome = columns[0]
            start = columns[1]
            end = columns[2]
            gene_name = columns[11].split('"')[1]

            bed_line = f'{chromosome}\t{start}\t{end}\t{gene_name}\n'
            bed.write(bed_line)

tsv_to_bed('output_annotated_bed.bed', 'final_bed.bed')
