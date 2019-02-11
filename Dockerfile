############################################################
# Dockerfile to run SAVI
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER docliver

################## INSTALL STUFF ######################
# Install programs

# Usage: WORKDIR /path
WORKDIR /home

# Update the repository sources list
RUN apt-get update

# Install ubuntu packages
RUN apt-get install -y automake autotools-dev fuse g++ git libfuse-dev libssl-dev libxml2-dev make pkg-config
RUN apt-get install -y wget
RUN apt-get install -y gcc
RUN apt-get install -y libgomp1
RUN apt-get install -y perl
RUN apt-get install -y python
RUN apt-get install -y libidn11
RUN apt-get install -y curl
RUN apt-get install -y perl
RUN apt-get install -y python
RUN apt-get install -y libidn11
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y build-essential
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libbz2-dev
RUN apt-get install -y liblzma-dev
RUN apt-get install -y python-pip
RUN apt-get install -y unzip
RUN apt-get install -y rsync
RUN apt-get install -y cmake
RUN apt-get install -y s3fs
RUN apt-get install -y default-jdk

# Install python packages
RUN pip install awscli
RUN pip install numpy scipy matplotlib pandas sympy nose biopython

# Install (and build) bioinformatics packages
RUN wget https://sourceforge.net/projects/samtools/files/samtools/1.2/samtools-1.2.tar.bz2
RUN bunzip2 samtools-1.2.tar.bz2
RUN tar -xvf samtools-1.2.tar
WORKDIR /home/samtools-1.2
# RUN ./configure && make && make install
RUN make && make install
WORKDIR /home

RUN wget https://sourceforge.net/projects/samtools/files/samtools/1.4.1/htslib-1.4.1.tar.bz2
RUN bunzip2 htslib-1.4.1.tar.bz2
RUN tar -xvf htslib-1.4.1.tar
WORKDIR /home/htslib-1.4.1
RUN make && make install
WORKDIR /home

RUN wget https://sourceforge.net/projects/snpeff/files/snpEff_v4_1c_core.zip
RUN unzip snpEff_v4_1c_core.zip
RUN chmod u+x snpEff/snpEff.jar
RUN chmod u+x snpEff/SnpSift.jar

# download dbs
WORKDIR /home/snpEff
RUN java -jar snpEff.jar download hg19
RUN java -jar snpEff.jar download GRCh37.75
WORKDIR /home

RUN git clone --recursive https://github.com/vcflib/vcflib.git
WORKDIR /home/vcflib
RUN make
WORKDIR /home

RUN wget https://rabadan.c2b2.columbia.edu/html/public/deprecated/fordoc.tar.gz
RUN tar -zxvf fordoc.tar.gz
WORKDIR /home/fordoc/SAVI/bin
RUN make
WORKDIR /home

# CLEAN
RUN rm *.gz *.tar *.zip

RUN mkdir -p data results ref resources

# ADD COMMANDS TO PATH
ENV PATH="${PATH}:/home/snpEff"
ENV PATH="${PATH}:/home/vcflib/bin"

##################### INSTALL STUFF #####################

# SET UP DIRECTORIES, COPY FILES
# RUN mkdir -p data ref results /opt/software
# RUN ln -s /home/Pandora /opt/software/Pandora

# COPY DATA
# COPY data/mate1.fq.gz /home/data/
# COPY data/mate2.fq.gz /home/data/

#
WORKDIR /home/results

# CMD java -version
# CMD samtools
# CMD which snpEff.jar
# CMD which vcffilter
