DATA_DIR = config["raw_data_dir"]

rule prefetch:
    output:
        sra = DATA_DIR + "/{sample}/{sample}.sra"
    params:
        outdir = DATA_DIR
    conda: "../envs/sra_tools.yaml"
    shell:
        """
        prefetch {wildcards.sample} --output-directory {params.outdir}
        """

rule fasterq_dump:
    input:
        sra = DATA_DIR + "/{sample}/{sample}.sra"
    output:
        r1 = DATA_DIR + "/{sample}_raw_1.fastq.gz",
        r2 = DATA_DIR + "/{sample}_raw_2.fastq.gz"
    params:
        outdir = DATA_DIR
    conda: "../envs/sra_tools.yaml"
    threads: 6
    shell:
        """
        fasterq-dump {input.sra} \
            --split-files \
            --threads {threads} \
            --outdir {params.outdir}
        mv {params.outdir}/{wildcards.sample}_1.fastq {params.outdir}/{wildcards.sample}_raw_1.fastq
        mv {params.outdir}/{wildcards.sample}_2.fastq {params.outdir}/{wildcards.sample}_raw_2.fastq
        pigz -p {threads} {params.outdir}/{wildcards.sample}_raw_1.fastq
        pigz -p {threads} {params.outdir}/{wildcards.sample}_raw_2.fastq
        """
