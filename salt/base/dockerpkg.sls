docker-pkg: # Install the package lxc-docker...
  cmd.run:
    - name: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    - cwd: /
  pkg.installed:
  - name: docker-ce
  - hold: True
  - require:
    - pkgrepo: pkgrepos-docker-addrepo
