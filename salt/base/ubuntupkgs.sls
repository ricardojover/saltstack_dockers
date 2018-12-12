include:
  - pkgrepos.addmany
  - base.dockerpkg

# Remove a large number of packages we simply don't need
ubuntupkgs-nuke-junk:
  pkg.purged:
    - pkgs:
      - apport
      - apport-symptoms
      - apt-xapian-index
      - byobu
      - ca-certificates-java
      - command-not-found
      - command-not-found-data
      - console-setup
      - default-jre-headless
      - ed
      - eject
      - friendly-recovery
      - ftp
      - fuse
      - info
      - install-info
      - java-common
      - kbd
      - landscape-client
      - landscape-common
      - laptop-detect
      - libgc1c2
      - libgudev-1.0-0
      - lshw
      - ltrace
      - mlocate
      - ntfs-3g
      - openjdk-7-jre-headless
      - ppp
      - pppconfig
      - pppoeconf
      - tzdata-java

ubuntupkgs-install-many-things:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - software-properties-common
      - curl
      - autoconf
      - apache2
      - auditd
      - build-essential
      - clamav
      - clamav-daemon
      - cowsay
      - default-jre-headless
      - equivs
      - git
      - htop
      - linux-headers-{{ grains['kernelrelease'] }}
      - lsof
      - make
      - mdadm
      - memcached
      - mtr-tiny
      - mysql-client
      - nscd
      - ntp
      - perl
      - puppet
      - python-dev
      - python-jinja2
      - python-pip
      - python-virtualenv
      - python3
      - salt-minion
      - socat
      - sysstat
      - unzip
      - xfsprogs
      - libc6-dev-i386 
      - awscli
    - require:
      - pkg: ubuntupkgs-nuke-junk
      - cmd: apt-get-update

