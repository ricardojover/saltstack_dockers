/var/lib/cloud/handlers/part-handler-000.py:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://base/files/part-handler-000.py

/usr/sbin/part-handler-my-config:
  file.symlink:
    - target: /var/lib/cloud/handlers/part-handler-000.py
