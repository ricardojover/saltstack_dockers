{% import 'common/vars.sls' as my_variables with context %}
{% from 'common/vars.sls' import docker with context %}

include:
  - common.dirs_and_files
  - base.motd
  - base.ubuntupkgs
  - base.syscfg
  - base.startscripts
  - base.parthandler
  - base.firstShutdown

upgrade-all-the-things:
  cmd.run:
    - name: sh -c "export DEBIAN_FRONTEND=noninteractive; apt-get -y --force-yes dist-upgrade"
    - cwd: /
    - require:
      - pkg: ubuntupkgs-install-many-things

# Do this after the upgrade in case the upgrade pulls in a new kernel
install-linux-image-extra-and-headers:
  file.managed:
    - user: root
    - group: root
    - mode: 700
    - source: salt://base/files/install-linux-image-extra-and-headers.sh
    - name: /root/install-linux-image-extra-and-headers.sh
  cmd.run:
    - name: /root/install-linux-image-extra-and-headers.sh
    - cwd: /
    - require:
      - cmd: upgrade-all-the-things

{% for usr in [ 'list', 'gnats', 'irc' ] %}
{{ usr }}:
  user.absent:
    - purge: True
{% endfor %}

{% if (grains['os'] == 'CentOS') %}
games:
  user.absent:
    - purge: True
{% endif %}


{% for dir in [ '/usr/games', '/var/list', '/var/lib/gnats', '/var/run/ircd' ] %}
{{ dir }}:
  file.absent: []
{% endfor %}

update-clamdb-and-scan:
  cmd.run:
    - name: /etc/init.d/clamav-freshclam no-daemon && clamscan --quiet --log /tmp/clamscan.log --exclude-dir /proc --exclude-dir /sys -i -r / && cat /tmp/clamscan.log && rm /tmp/clamscan.log
    - cwd: /
    - require:
      - pkg: ubuntupkgs-install-many-things

update-indexes:
  cmd.run:
    - name: /etc/cron.weekly/man-db
    - cwd: /

# Note that the base packer script also 
# deletes /etc/salt/minion_id and /srv before taking
# the snapshot
wash-the-dishes:
  file.managed:
    - user: root
    - group: root
    - mode: 700
    - source: salt://base/files/wash-the-dishes.sh
    - name: /root/wash-the-dishes.sh
  cmd.run:
    - name: /root/wash-the-dishes.sh && rm /root/wash-the-dishes.sh
    - cwd: /
    - order: last
