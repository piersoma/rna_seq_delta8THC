BASE_DIR = "/opt/students/martha.pierson/rna_seq_delta8THC"

rule multiqc:
    input:
        # FastQC reports on raw reads
        fastqc_raw = expand(BASE_DIR + "/results/fastqc/{sample}_raw_1_fastqc.zip", sample=config["samples"]),
        # FastQC reports on filtered reads
        fastqc_filtered = expand(BASE_DIR + "/results/fastqc/{sample}_filtered_1_fastqc.zip", sample=config["samples"]),
        # fastp trimming reports
        fastp = expand(BASE_DIR + "/results/fastp/{sample}_fastp.json", sample=config["samples"]),
        # HISAT2 alignment summaries
        hisat2 = expand(BASE_DIR + "/results/hisat2/{sample}_summary.txt", sample=config["samples"]),
        # featureCounts summaries
        featurecounts = expand(BASE_DIR + "/results/counts/{sample}.featureCounts.txt.summary", sample=config["samples"])
    output:
        # Single interactive HTML report
        report = BASE_DIR + "/results/multiqc/multiqc_report.html",
        # Output directory
        outdir = directory(BASE_DIR + "/results/multiqc/")
    conda: "../envs/multiqc.yaml"
    params:
        extra = "--verbose"
    shell:
        """
        multiqc \
            {params.extra} \
            --outdir {output.outdir} \
            --filename $(basename {output.report} .html) \
            {input.fastqc_raw} {input.fastqc_filtered} \
            {input.fastp} {input.hisat2} {input.featurecounts}
        """
