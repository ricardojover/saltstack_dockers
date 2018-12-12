# SaltStack Dockers
Example SaltStack installing Docker-CE

In this project I'm using SaltStack to install the official version of Dockers CE. I download and configure using upstart or systemd (depending on the OS version) a few custom dockers, I use cloud init to configure a template for logstash, etc.

## Deployment
Replace the values in the files /salt/private/variables.cfg and /pillar/docker_hub/init.sls with your own values.

Installation for a standandalone server:
```
curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh
sudo sh install_salt.sh -P
```

To deploy the project locally:
```
salt-call state.apply --local
```
