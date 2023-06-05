FROM jenkins/ssh-agent:jdk11
ENV JENKINS_AGENT_SSH_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCS77vD6rooswsog3kWmm+O0QeGfg/P26A281D6E4B9ynxzq5Zhvg37w6WunMW1bCv8pmNDkuhxv1ZbJooLb2IAQiYHqXhYXityQ/akv6qzjv3NP3Onp6JoQwFPdM+zUmSvYD7SkSaGw7ICXexSJbitvZJFIIgm70/+8fmPNzkEVW0CNz/i5nlaHFT952wGAthSc1etvfVZC5D8qaz4t4geAfEg2PnOV5bUXStxR+5vWiFWIoccKmBJbTnVGlyMLp9e/H44VoQ0T+XalUmUIIWuVme/FxwIdpwN/HIMruR6vr5cNIIOraM/sZJ5egpyZSvyZ0/p7v/qkHSiddwzWux0A93HtmlQcEqSo9Ffq7FwCv28oriADnvLxESE/sGRiOsJyYF9jC9Bz00krk5IE8xAsg05zITidHE8IVhTiMewzRICPMPJUXb48rUDGPJzfWncurx3/JL7kJByKOX9ZJDdfEiLXik3X2AP2PEas4vBT+qFGQVgFbkNb7q3AuOfuSE= jenkins@ip-172-32-13-253"
RUN apt-get update && apt-get upgrade -y
RUN apt-get install ca-certificates curl gnupg software-properties-common unzip wget apt-transport-https gnupg lsb-release -y
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "focal")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/trivy.list
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin nodejs terraform trivy
RUN usermod -aG docker jenkins
RUN dockerd; exit 0
