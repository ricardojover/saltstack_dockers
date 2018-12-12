include:
  - pkgrepos.apt-get-update

pkgrepos-docker-addrepo:
  pkgrepo.managed:
    - name: deb https://download.docker.com/linux/ubuntu {{ grains['oscodename'] }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - keyserver: hkp://ha.pool.sks-keyservers.net:80
    - keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
    - require_in:
      - cmd: apt-get-update
