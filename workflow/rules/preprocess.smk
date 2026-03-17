BASE_DIR = "/opt/students/martha.pierson/rna_seq_delta8THC"
DATA_DIR = config["raw_data_dir"]

rule fastqc_raw:
    input:
        r1 = DATA_DIR + "/{sample}_raw_1.fastq.gz",
        r2 = DATA_DIR + "/{sample}_raw_2.fastq.gz"
    output:
        html_r1 = BASE_DIR + "/results/fastqc/{sample}_raw_1_fastqc.html",
        html_r2 = BASE_DIR + "/results/fastqc/{sample}_raw_2_fastqc.html",
        zip_r1  = BASE_DIR + "/results/fastqc/{sample}_raw_1_fastqc.zip",
        zip_r2  = BASE_DIR + "/results/fastqc/{sample}_raw_2_fastqc.zip"
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 2
    shell:
        """
        fastqc {input.r1} {input.r2} \
            --threads {threads} \
            --outdir {BASE_DIR}/results/fastqc
        """

rule fastp:
    input:
        r1 = DATA_DIR + "/{sample}_raw_1.fastq.gz",
        r2 = DATA_DIR + "/{sample}_raw_2.fastq.gz"
    output:
        r1   = DATA_DIR + "/{sample}_filtered_1.fastq.gz",
        r2   = DATA_DIR + "/{sample}_filtered_2.fastq.gz",
        html = BASE_DIR + "/results/fastp/{sample}_fastp.html",
        json = BASE_DIR + "/results/fastp/{sample}_fastp.json"
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 4
    shell:
        """
        fastp \
            -i {input.r1} -I {input.r2} \
            -o {output.r1} -O {output.r2} \
            -h {output.html} -j {output.json} \
            --thread {threads} \
            --detect_adapter_for_pe \
            --qualified_quality_phred 20 \
            --length_required 50
        """

rule fastqc_filtered:
    input:
        r1 = DATA_DIR + "/{sample}_filtered_1.fastq.gz",
        r2 = DATA_DIR + "/{sample}_filtered_2.fastq.gz"
    output:
        html_r1 = BASE_DIR + "/results/fastqc/{sample}_filtered_1_fastqc.html",
        html_r2 = BASE_DIR + "/results/fastqc/{sample}_filtered_2_fastqc.html",
        zip_r1  = BASE_DIR + "/results/fastqc/{sample}_filtered_1_fastqc.zip",
        zip_r2  = BASE_DIR + "/results/fastqc/{sample}_filtered_2_fastqc.zip"
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 2
    shell:
        """
        fastqc {input.r1} {input.r2} \
            --threads {threads} \
            --outdir {BASE_DIR}/results/fastqc
        """
