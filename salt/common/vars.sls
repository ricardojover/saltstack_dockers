{% set my_var = 'whatever' %}

{% set docker_hub = salt['pillar.get']('docker_hub', {}) %}
{% set docker_hub_username = docker_hub.get('user_name', {}) %}
{% set docker_hub_password = docker_hub.get('password', {}) %}
{% set my_dockers = ['logstash_sa', 'filebeat_sa', 'metricbeat_sa'] %}

{% set docker = {} %}
{%- do docker.update({ 'user'       : docker_hub_username,
                       'password'   : docker_hub_password,
                       'my_dockers' : my_dockers,
                    })
%}

