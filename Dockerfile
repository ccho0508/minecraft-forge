# Minecraft moded server, v1.12.2
FROM ubuntu:16.04
MAINTAINER SteamFab <martin@steamfab.io>

USER root

# install Minecraft dependencies
RUN apt-get update && apt-get install -y \
    default-jre-headless \
    wget \
    rsyslog \
    unzip \
    locales

RUN update-ca-certificates -f

# clean up
RUN apt-get clean
RUN rm -rf /tmp/* /tmp/.[!.]* /tmp/..?*  /var/lib/apt/lists/*

# Setup locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV VERSION 1.12.2-14.23.5.2841
ENV SHELL /bin/bash
ENV NB_USER minecraft
ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create minecraft user with UID=1000 and in the 'users' group
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

USER $NB_USER

# download and unpack Minecraft
WORKDIR $HOME
RUN wget --quiet https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2823/forge-1.12.2-14.23.5.2823-installer.jar

# run Minecraft installer
RUN java -jar forge-$VERSION-installer.jar --installServer
RUN rm forge-$VERSION-installer.jar

# Install some mods
RUN mkdir mods
RUN 

RUN cd mods/ && wget --quiet https://cdn.discordapp.com/attachments/544325414190055426/559134671598911488/buildcraft-all-7.99.23.jar
RUN cd mods/ && wget --quiet https://media.forgecdn.net/files/2650/315/Pam%27s+HarvestCraft+1.12.2zb.jar
RUN cd mods/ && wget --quiet https://cdn.discordapp.com/attachments/544325414190055426/559134670965440532/IC2NuclearControl-2.4.3a.jar
RUN cd mods/ && wget --quiet https://media.forgecdn.net/files/2644/656/FamiliarFauna-1.12.2-1.0.11.jar
RUN cd mods/ && wget --quiet https://media.forgecdn.net/files/2665/717/energyconverters_1.12.2-1.2.1.11.jar
RUN cd mods/ && wget --quiet https://cdn.discordapp.com/attachments/544325414190055426/559134680440373249/industrialcraft-2-2.8.111-ex112.jar
RUN cd mods/ && wget --quiet https://cdn.discordapp.com/attachments/544325414190055426/559134665592668182/AdvancedSolarPanels-4.3.0.jar
RUN cd mods/ && wget --quiet https://cdn.discordapp.com/attachments/544325414190055426/559134675990216729/TreeChopper-1.12.2-1.2.4_2.jar
RUN cd mods/ && wget --quiet https://cdn.discordapp.com/attachments/544325414190055426/559134677852487691/OptiFine_1.12.2_HD_U_E3.jar
# Configure remaining tasks for root user
USER root
WORKDIR /root

# Run Minecraft
EXPOSE 25565

COPY run.sh .

ENTRYPOINT ["/root/run.sh"]
