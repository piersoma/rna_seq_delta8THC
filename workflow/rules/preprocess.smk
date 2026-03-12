rule fastqc_raw:
    input:
        r1 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_raw_1.fastq",
        r2 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_raw_2.fastq"
    output:
        html_r1 = "results/fastqc/{sample}_raw_1_fastqc.html",
        html_r2 = "results/fastqc/{sample}_raw_2_fastqc.html",
        zip_r1  = "results/fastqc/{sample}_raw_1_fastqc.zip",
        zip_r2  = "results/fastqc/{sample}_raw_2_fastqc.zip"
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 2
    shell:
        """
        fastqc {input.r1} {input.r2} \
            --threads {threads} \
            --outdir results/fastqc
        """

rule fastp:
    input:
        r1 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_raw_1.fastq",
        r2 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_raw_2.fastq"
    output:
        r1 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_filtered_1.fastq",
        r2 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_filtered_2.fastq",
        html = "results/fastp/{sample}_fastp.html",
        json = "results/fastp/{sample}_fastp.json"
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
        r1 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_filtered_1.fastq",
        r2 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_filtered_2.fastq"
    output:
        html_r1 = "results/fastqc/{sample}_filtered_1_fastqc.html",
        html_r2 = "results/fastqc/{sample}_filtered_2_fastqc.html",
        zip_r1  = "results/fastqc/{sample}_filtered_1_fastqc.zip",
        zip_r2  = "results/fastqc/{sample}_filtered_2_fastqc.zip"
    conda: "../envs/rnaseq_preprocess.yaml"
    threads: 2
    shell:
        """
        fastqc {input.r1} {input.r2} \
            --threads {threads} \
            --outdir results/fastqc
        """
