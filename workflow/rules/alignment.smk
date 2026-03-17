BASE_DIR = "/opt/students/martha.pierson/rna_seq_delta8THC"
DATA_DIR = config["raw_data_dir"]

# Constrain sample wildcard to only match SRR IDs
wildcard_constraints:
    sample = "SRR[0-9]+"

rule hisat2:
    input:
        r1 = DATA_DIR + "/{sample}_filtered_1.fastq.gz",
        r2 = DATA_DIR + "/{sample}_filtered_2.fastq.gz"
    output:
        # Unsorted BAM marked temp() - automatically deleted after sorting to save disk space
        bam = temp(BASE_DIR + "/results/hisat2/{sample}.bam"),
        # Alignment summary kept for MultiQC report
        summary = BASE_DIR + "/results/hisat2/{sample}_summary.txt"
    params:
        # Path to HISAT2 genome index prefix (without .ht2 extension)
        index = config["genome_index"]
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 8
    shell:
        """
        hisat2 -p {threads} \
            -x {params.index} \
            -1 {input.r1} -2 {input.r2} \
            --new-summary \
            --summary-file {output.summary} \
            | samtools view -bS - > {output.bam}
            # pipe HISAT2 output directly into samtools to convert
            # SAM to BAM on the fly without writing SAM to disk (~20GB saved per sample)
        """

rule sort_bam:
    input:
        # Unsorted BAM from hisat2 rule
        bam = BASE_DIR + "/results/hisat2/{sample}.bam"
    output:
        # Sorted BAM - required by featureCounts and genome browsers
        sorted_bam = BASE_DIR + "/results/hisat2/{sample}.sorted.bam"
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 4
    shell:
        """
        samtools sort -@ {threads} \
            -o {output.sorted_bam} \
            {input.bam}
        """

rule index_bam:
    input:
        # Sorted BAM from sort_bam rule
        sorted_bam = BASE_DIR + "/results/hisat2/{sample}.sorted.bam"
    output:
        # Index file - acts like a table of contents for the BAM
        # allowing tools to quickly access specific genomic regions
        bai = BASE_DIR + "/results/hisat2/{sample}.sorted.bam.bai"
    conda: "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        samtools index {input.sorted_bam}
        """
