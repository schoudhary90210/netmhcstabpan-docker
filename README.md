# NetMHCstabpan Docker Container

This Docker image provides NetMHCstabpan-1.0 (integrated with NetMHCpan-2.8) for MHC peptide stability predictions. It's built on Ubuntu 16.04 for compatibility with the tool's binaries.

## Features
- Predicts peptide stability (Thalf(h), %Rank_Stab, BindLevel) for HLA alleles.
- Supports single/multi-peptide inputs, protein FASTA (digests into 9-mers), multi-alleles, sorting, and thresholds.
- Outputs to XLS for easy viewing in Excel.
- Known Limitation: Affinity predictions (-ia) are not functional due to path resolution issues with NetMHCpan (outputs only stability).

## Installation
1. Install Docker: Download from https://www.docker.com/products/docker-desktop/.
2. Pull the image: docker pull yourusername/netmhcstabpan:final

- On Apple Silicon Macs, it runs via emulation (may be slower; see Troubleshooting).

## Usage
Run commands from your terminal in a directory with your input files. Use `-v "$PWD":/data` to mount your current directory as /data in the container.

### Basic Command Format
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a  -f /data/<input_file> -inptype  -p -xls -xlsfile /data/output.xls [options]
- `-a`: HLA allele (e.g., HLA-A02:01, or "HLA-A02:01,HLA-A03:01" for multi).
- `-f`: Input file path in /data.
- `-inptype 1`: For plain peptide list (one per line).
- `-p`: For peptide input (no digestion; use without for proteins).
- `-xls -xlsfile`: Output to XLS.
- Options: -ia (affinity, currently broken), -s 0 (sort by stability), -t 0.5 (threshold), -l 9 (length).

### Examples
1. **Single Peptide**:
echo "SYFPEITHI" > single_peptide.txt
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/single_peptide.txt -inptype 1 -p -xls -xlsfile /data/output_single.xls


2. **Multi-Peptide**:
echo -e "SYFPEITHI\nGILGFVFTL\nYLVALGINA\n" > peptides.txt
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/peptides.txt -inptype 1 -p -xls -xlsfile /data/output_ia.xls

3. **Protein FASTA**:
echo -e ">protein1\nMAAVKTLNPYAKDGDYYYSWKFSGSTF" > protein.fasta
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/protein.fasta -xls -xlsfile /data/output_protein.xls

4. **Multi-Allele**:
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a "HLA-A02:01,HLA-A03:01,HLA-B07:02" -f /data/peptides.txt -inptype 1 -p -xls -xlsfile /data/output_multi_allele.xls

5. **Sorting and Threshold**:
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/peptides.txt -inptype 1 -p -s 0 -t 0.5 -xls -xlsfile /data/output_sorted.xls

6. **Interactive Debug**:
docker run --platform linux/amd64 --rm -it --entrypoint /bin/bash netmhcstabpan:final


### Limitations
- Affinity predictions (-ia) do not work (outputs only stability due to path errors in NetMHCpan).
- Emulation on Apple Silicon Macs may cause slow performance or failures; use an AMD64 machine for best results.
- Peptide lengths are limited to 8-11 (default 9).

### Troubleshooting
- **Emulation Warning**: On Apple Silicon, add `--platform linux/amd64` to commands; if slow, allocate more CPU/RAM in Docker Desktop settings.
- **Errors**: If "file not found", check input paths or run interactive to inspect.
- **No Affinity**: Known issue; tool falls back to stability.
- **Build Issues**: Ensure NetMHCstabpan-1.0 and NetMHCpan-2.8 folders are in your directory.



