rule prefetch:
    output:
        sra = temp("/opt/students/martha.pierson/raw_data_delta8THC/{sample}/{sample}.sra")
    params:
        outdir = "/opt/students/martha.pierson/raw_data_delta8THC"
    conda: "../envs/sra_tools.yaml"
    shell:
        """
        prefetch {wildcards.sample} --output-directory {params.outdir}
        """

rule fastq_dump:
    input:
        sra = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}/{sample}.sra"
    output:
        r1 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_raw_1.fastq",
        r2 = "/opt/students/martha.pierson/raw_data_delta8THC/{sample}_raw_2.fastq"
    params:
        outdir = "/opt/students/martha.pierson/raw_data_delta8THC"
    conda: "../envs/sra_tools.yaml"
    shell:
        """
        fastq-dump --split-files \
            --outdir {params.outdir} \
            {input.sra}
        mv {params.outdir}/{wildcards.sample}_1.fastq {output.r1}
        mv {params.outdir}/{wildcards.sample}_2.fastq {output.r2}
        """
