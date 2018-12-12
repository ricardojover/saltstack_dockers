include:
  {% if ((grains['os'] == 'Ubuntu' and grains['osrelease'] in ('12.04','14.04')) or (grains['os'] == 'CentOS')) %}
  - pkgrepos.docker
  - pkgrepos.puppet
  {% endif %}
  - pkgrepos.apt-get-update

