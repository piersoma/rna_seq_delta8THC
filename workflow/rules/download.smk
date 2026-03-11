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
    conda: "../envs/sra_tools.yaml"
    shell:
        """
        fastq-dump --split-files \
            --outdir /opt/students/martha.pierson/raw_data_delta8THC \
            {input.sra}
        """
