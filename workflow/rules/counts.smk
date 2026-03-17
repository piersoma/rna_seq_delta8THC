BASE_DIR = "/opt/students/martha.pierson/rna_seq_delta8THC"

rule featurecounts:
    input:
        # Sorted BAM from alignment step
        bam = BASE_DIR + "/results/hisat2/{sample}.sorted.bam"
    output:
        # Count matrix for this sample
        counts = BASE_DIR + "/results/counts/{sample}.featureCounts.txt",
        # Summary file for MultiQC
        summary = BASE_DIR + "/results/counts/{sample}.featureCounts.txt.summary"
    params:
        # GTF annotation file defining gene coordinates
        gtf = config["gtf_file"]
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 4
    shell:
        """
        featureCounts \
            -T {threads} \
            -t exon \
            -g gene_id \
            -p \
            -a {params.gtf} \
            -o {output.counts} \
            {input.bam}
        """
