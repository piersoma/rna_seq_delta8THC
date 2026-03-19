BASE_DIR = "/opt/students/martha.pierson/rna_seq_delta8THC"

rule deg:
    input:
        # Count matrices from featureCounts
        counts = expand(BASE_DIR + "/results/counts/{sample}.featureCounts.txt", sample=config["samples"]),
        # Sample metadata file
        samplesheet = config["samplesheet"]
    output:
        # Final DEG report
        BASE_DIR + "/results/DEG/DEG_report.html"
    log:
        # Capture full R output for debugging
        BASE_DIR + "/results/DEG/deg.log"
    conda: "../envs/deg.yaml"
    script:
        # R markdown script for DEG analysis
        "../src/deg.Rmd"
