{\rtf1\ansi\ansicpg1252\cocoartf2820
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # NetMHCstabpan Docker Container\
\
This Docker image provides NetMHCstabpan-1.0 (integrated with NetMHCpan-2.8) for MHC peptide stability predictions. It's built on Ubuntu 16.04 for compatibility with the tool's binaries.\
\
## Features\
- Predicts peptide stability (Thalf(h), %Rank_Stab, BindLevel) for HLA alleles.\
- Supports single/multi-peptide inputs, protein FASTA (digests into 9-mers), multi-alleles, sorting, and thresholds.\
- Outputs to XLS for easy viewing in Excel.\
- Known Limitation: Affinity predictions (-ia) are not functional due to path resolution issues with NetMHCpan (outputs only stability).\
\
## Installation\
1. Install Docker: Download from https://www.docker.com/products/docker-desktop/.\
2. Pull the image: 
\f1 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 docker pull yourusername/netmhcstabpan:final\
\
- On Apple Silicon Macs, it runs via emulation (may be slower; see Troubleshooting).\
\
## Usage\
Run commands from your terminal in a directory with your input files. Use `-v "$PWD":/data` to mount your current directory as /data in the container.\
\
### Basic Command Format\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 \strokec2 docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a  -f /data/<input_file> -inptype  -p -xls -xlsfile /data/output.xls [options]\
- `-a`: HLA allele (e.g., HLA-A02:01, or "HLA-A02:01,HLA-A03:01" for multi).\
- `-f`: Input file path in /data.\
- `-inptype 1`: For plain peptide list (one per line).\
- `-p`: For peptide input (no digestion; use without for proteins).\
- `-xls -xlsfile`: Output to XLS.\
- Options: -ia (affinity, currently broken), -s 0 (sort by stability), -t 0.5 (threshold), -l 9 (length).\
\
### Examples\
1. **Single Peptide**:\
echo "SYFPEITHI" > single_peptide.txt\
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/single_peptide.txt -inptype 1 -p -xls -xlsfile /data/output_single.xls\
\pard\pardeftab720\partightenfactor0
\cf0 \strokec2 \
\
2. **Multi-Peptide**:\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 \strokec2 echo -e "SYFPEITHI\\nGILGFVFTL\\nYLVALGINA\\n" > peptides.txt\
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/peptides.txt -inptype 1 -p -xls -xlsfile /data/output_ia.xls\
\
3. **Protein FASTA**:\
echo -e ">protein1\\nMAAVKTLNPYAKDGDYYYSWKFSGSTF" > protein.fasta\
docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/protein.fasta -xls -xlsfile /data/output_protein.xls\
\
4. **Multi-Allele**:\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a "HLA-A02:01,HLA-A03:01,HLA-B07:02" -f /data/peptides.txt -inptype 1 -p -xls -xlsfile /data/output_multi_allele.xls\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 \
5. **Sorting and Threshold**:\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 docker run --platform linux/amd64 --rm -v "$PWD":/data netmhcstabpan:final -a HLA-A02:01 -f /data/peptides.txt -inptype 1 -p -s 0 -t 0.5 -xls -xlsfile /data/output_sorted.xls\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 \
6. **Interactive Debug**:\
\pard\pardeftab720\sa240\partightenfactor0
\cf0 docker run --platform linux/amd64 --rm -it --entrypoint /bin/bash netmhcstabpan:final\
\pard\pardeftab720\partightenfactor0
\cf0 \strokec2 \
\pard\pardeftab720\sa240\partightenfactor0
\cf0 \strokec2 \
### Limitations\
- Affinity predictions (-ia) do not work (outputs only stability due to path errors in NetMHCpan).\
- Emulation on Apple Silicon Macs may cause slow performance or failures; use an AMD64 machine for best results.\
- Peptide lengths are limited to 8-11 (default 9).\
\
### Troubleshooting\
- **Emulation Warning**: On Apple Silicon, add `--platform linux/amd64` to commands; if slow, allocate more CPU/RAM in Docker Desktop settings.\
- **Errors**: If "file not found", check input paths or run interactive to inspect.\
- **No Affinity**: Known issue; tool falls back to stability.\
- **Build Issues**: Ensure NetMHCstabpan-1.0 and NetMHCpan-2.8 folders are in your directory.\
\
\pard\pardeftab720\partightenfactor0
\cf0 \strokec2 \
\
}