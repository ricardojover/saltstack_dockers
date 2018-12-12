/usr/share/firstboot:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/usr/share/firstshutdown:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# This will be picked up and run the first time the instance boots
# from our script
{% for file in [ '01-instanceify-hostname', '02-instanceify-minion' ] %}
/usr/share/firstboot/{{ file}}:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://base/files/firstboot/{{ file }}
    - require:
      - file: /usr/share/firstboot
{% endfor %}

# These will be run by our script immedietly before shutting the box down
{% set shutdown_files = [ 'clear-old-templates', 'clear-var-cache', 'clearhome', 'clearlogs', 'clamav-update' ] %}
{% for file in shutdown_files %}
/usr/share/firstshutdown/{{ file }}:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://base/files/firstshutdown/{{ file }}
    - require:
      - file: /usr/share/firstshutdown
{% endfor %}
