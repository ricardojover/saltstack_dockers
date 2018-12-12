{% from 'common/vars.sls' import docker with context %}

/tmp/parse_template.py:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://base/files/parse_template.py

/tmp/variables.cfg:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://private/variables.cfg

{% for file in [ 'docker-login', 'docker-cleanup', 'docker-mynet', 'logstash', 'filebeat', 'metricbeat' ] %}
{% if ((grains['os'] == 'Ubuntu' and grains['osrelease'] in ('12.04','14.04')) or (grains['os'] == 'CentOS')) %}
/etc/init/{{ file }}.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://base/files/upstart/{{ file }}.conf
  cmd.run:
    - name: /usr/bin/python /tmp/parse_template.py -c /tmp/variables.cfg -f /etc/init/{{ file }}.conf
    - cwd: /
{% else %}
/etc/systemd/system/{{ file }}.service:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://base/files/systemd/{{ file }}.service
  cmd.run:
    - name: /usr/bin/python /tmp/parse_template.py -c /tmp/variables.cfg -f /etc/systemd/system/{{ file }}.service && /bin/systemctl enable {{ file }}.service
    - cwd: /
{% endif %}
{% endfor %}

# As you can see in this line bellow, we can get the variables in different ways
# We can import an object and use it or we can use the pillar directly.
# The advantage of using an object is that it can be as simple as you with
# The advantage of using the pillar is that you don't need to import the object
# in every single file
{{ docker.user }}_login:
  cmd.run:
    - name: /usr/bin/docker login -u {{ docker.user }} -p {{ salt['pillar.get']('docker_hub:password') }}

pull_cleanup:
  cmd.run:
    - name: /usr/bin/docker pull meltwater/docker-cleanup:1.8.0

{% for my_docker in docker.my_dockers %}
pull_{{ my_docker }}:
  cmd.run:
    - name: /usr/bin/docker pull {{ docker.user }}/{{ my_docker }}:latest
{% endfor %}

{% for beat in [ 'filebeat', 'metricbeat' ] %}
/usr/share/{{ beat }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
{% endfor %}

{% for beat in [ 'filebeat', 'metricbeat' ] %}
/usr/share/{{ beat }}/{{ beat }}.yml:
  file.managed:
    - user: root
    - mode: 644
    - source: salt://base/files/templates/{{ beat }}.yml
    - require:
      - file: /usr/share/{{ beat }}
{% endfor %}

/usr/local/etc/templates/logstash.env.tmpl:
  file.managed:
    - user: root
    - mode: 644
    - source: salt://base/files/templates/logstash.env.tmpl

