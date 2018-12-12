/etc/update-motd.d/00-header:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - contents: |
        #!/bin/sh
        /usr/games/cowthink -f daemon -W 12 SaltStack ? AWS ? Ubuntu ?

{% set motd_files = ['10-help-text', '51-cloudguest'] %}
{% for file in motd_files %}
/etc/update-motd.d/{{ file }}:
  file.absent: []
{% endfor %}
