FROM --platform=linux/amd64 ubuntu:16.04
RUN apt-get update && apt-get install -y tcsh gawk libgfortran3 libstdc++6 dos2unix
# Copy pre-extracted NetMHCstabpan folder (with data inside)
COPY netMHCstabpan-1.0 /opt/netMHCstabpan-1.0
# Copy pre-extracted NetMHCpan-2.8 and integrate estimate_PCC into the correct bin dir
COPY netMHCpan-2.8 /opt/netMHCpan-2.8
RUN mkdir -p /opt/netMHCstabpan-1.0/Linux_x86_64/bin \
    && cp /opt/netMHCpan-2.8/Linux_x86_64/bin/estimate_PCC /opt/netMHCstabpan-1.0/Linux_x86_64/bin/ \
    && dos2unix /opt/netMHCstabpan-1.0/netMHCstabpan /opt/netMHCpan-2.8/netMHCpan \
    && chmod +x /opt/netMHCstabpan-1.0/Linux_x86_64/bin/* \
    && chmod -R a+rX /opt/netMHCpan-2.8 /opt/netMHCstabpan-1.0
# Duplicate data for the appended path issue, ignoring errors
RUN mkdir -p /opt/netMHCpan-2.8/Linux_x86_64/data/threshold \
    && cp -r /opt/netMHCpan-2.8/data/* /opt/netMHCpan-2.8/Linux_x86_64/data/ || true
# Edit the wrapper script to hardcode NMHOME, TMPDIR, and affpred path
RUN chmod +w /opt/netMHCstabpan-1.0/netMHCstabpan \
    && sed -i 's/setenv[ \t]*NMHOME[ \t]*.*/setenv NMHOME \/opt\/netMHCstabpan-1.0/' /opt/netMHCstabpan-1.0/netMHCstabpan \
    && sed -i 's/set tmpdir = ""/set tmpdir = "\/tmp"/' /opt/netMHCstabpan-1.0/netMHCstabpan \
    && sed -i 's/set NetMHCpan = \/tools\/src\/netMHCpan-2.8\/netMHCpan/set NetMHCpan = \/opt\/netMHCpan-2.8\/netMHCpan/' /opt/netMHCstabpan-1.0/netMHCstabpan \
    && sed -i '/if ($?affpred == 0) then/,/endif/s/^/#/' /opt/netMHCstabpan-1.0/netMHCstabpan \
    && chmod +x /opt/netMHCstabpan-1.0/netMHCstabpan
# Edit the netMHCpan wrapper to hardcode its NMHOME and comment out default conditional
RUN chmod +w /opt/netMHCpan-2.8/netMHCpan \
    && sed -i 's/setenv[ \t]*NMHOME[ \t]*.*/setenv NMHOME \/opt\/netMHCpan-2.8/' /opt/netMHCpan-2.8/netMHCpan \
    && sed -i 's/set tmpdir = ""/set tmpdir = "\/tmp"/' /opt/netMHCpan-2.8/netMHCpan \
    && sed -i '/if ($?NMHOME == 0) then/,/endif/s/^/#/' /opt/netMHCpan-2.8/netMHCpan \
    && sed -i '/set PLATFORM = /s/^/#/' /opt/netMHCpan-2.8/netMHCpan \
    && chmod +x /opt/netMHCpan-2.8/netMHCpan
# Set environment variables and TMPDIR
ENV NMHOME=/opt/netMHCstabpan-1.0
ENV NETMHCpan=/opt/netMHCpan-2.8
ENV TMPDIR=/tmp
RUN mkdir -p /tmp && chmod 1777 /tmp
ENV PATH=/opt/netMHCstabpan-1.0/Linux_x86_64/bin:/opt/netMHCpan-2.8/Linux_x86_64/bin:$PATH
WORKDIR /data
ENTRYPOINT ["/opt/netMHCstabpan-1.0/netMHCstabpan"]
