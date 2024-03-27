#fastqc
rule fastqc:
    input:
        r1 = '/Users/robertkans/Pipeline/sample1_R1.fastq',
        r2 = '/Users/robertkans/Pipeline/sample1_R2.fastq'
    output:
        r1_html = '/Users/robertkans/Pipeline/sample1_R1_fastqc.html',
        r2_html = '/Users/robertkans/Pipeline/sample1_R2_fastqc.html'
    shell:
        """
        fastqc {input.r1} {input.r2} -o /Users/robertkans/Pipeline/
        """

#standardizes chromosome naming format
rule fix_chrom_ref:
    input:
        ref = '/Users/robertkans/Pipeline/GCF_000001405.26_GRCh38_genomic.fna'
    output:
        fix_chrom_ref = '/Users/robertkans/Pipeline/fixed_chrom_GCF_000001405.26_GRCh38_genomic.fna'
    shell:
        """
        awk -F'[_. ]' '/^>/ {sub(/^0+/, "", $2); print ">chr" $2, substr($0, index($0, $4))} !/^>/' {input.ref} > {output.fix_chrom_ref}
        """

#aligns reads
rule hisat2:
    input: 
        fastq_1 = '/Users/robertkans/Pipeline/sample1_R1.fastq',
        fastq_2 = '/Users/robertkans/Pipeline/sample1_R2.fastq',
        ref = '/Users/robertkans/Pipeline/fixed_chrom_GCF_000001405.26_GRCh38_genomic.fna'
    output:
        ref_index = '/Users/robertkans/Pipeline/GRCh38_index',
        sam = '/Users/robertkans/Pipeline/aligned_reads.sam'
    shell:
        """
        hisat2-build {input.ref} {output.ref_index}
        hisat2 -x {output.GRCh38_index} -1 {input.fastq_1} -2 {input.fastq_2} -S {output.sam}
        """

#converts sam to sorted bam
rule samtobam: 
    input:
        sam = '/Users/robertkans/Pipeline/aligned_reads.sam'
    output:
        sorted_bam = '/Users/robertkans/Pipeline/sorted.bam'
    shell:
        """
        samtools sort {input.sam} -o {output.sorted_bam}
        """

#counts expression levels 
rule featureCounts:
    input:
        bam = '/Users/robertkans/Pipeline/sorted.bam',
        annotations = '/Users/robertkans/Pipeline/gencode.v38.annotation.gtf'
    output:
        counts = '/Users/robertkans/Pipeline/counts.txt'
    shell:
    """
    featureCounts -a {input.annotations} -o {output.counts} {input.bam}
    """

#converts bam to bed
rule bamtobed:
    input:
        sorted_bam = '/Users/robertkans/Pipeline/sorted.bam'
    output:
        bed = '/Users/robertkans/Pipeline/sorted_alignment.bed'
    shell:
        """
        bedtools bamtobed -i {input.sorted_bam} > {output.bed}
        """

#cleans unnecessary bed columns --> bed3
rule clean_bed:
    input:
        bed = '/Users/robertkans/Pipeline/sorted_alignment.bed'
    output:
        clean_bed = '/Users/robertkans/Pipeline/clean_sorted_alignment.bed'
    shell:
        """
        awk '{print $1 "\t" $2 "\t" $3}' {input.bed} > {output.clean_bed}
        """

#optional step to convert chromosome names in bed file
# rule fix_chrom:
#     input:
#         clean_bed = '/Users/robertkans/Pipeline/clean_sorted_alignment.bed'
#     output:
#         fix_chrom = '/Users/robertkans/Pipeline/fix_chrom_clean_sorted_alignment.bed'
#     shell:
#         """
#         awk '{gsub(/^NC_0*/, "", $1); sub(/\..*/, "", $1); print "chr" $1, $2, $3}' {input.clean_bed} > {output.fix_chrom}
#         """

#generates bed file with overlapping annotations from gtf 
rule intersect:
    input:
        fix_chrom = '/Users/robertkans/Pipeline/fix_chrom_clean_sorted_alignment.bed',
        annotations = '/Users/robertkans/Pipeline/gencode.v38.annotation.gtf'
    output:
        annotated_bed = '/Users/robertkans/Pipeline/annotated_genes.bed'
    shell:
        """
        bedtools intersect -a {input.fix_chrom} -b {input.annotations} -wa -wb > {output.annotated_bed}
        """





