syscfg-etc-security-limits-conf:
  file.blockreplace:
    - name: /etc/security/limits.conf
    - append_if_not_found: True
    - backup: False
    - content: |
        * soft nofile 4096

syscfg-etc-sysctl-conf:
  file.blockreplace:
    - name: /etc/sysctl.conf
    - append_if_not_found: True
    - backup: False
    - content: |
        net.ipv4.ip_local_port_range = 10152 65535
        net.core.netdev_max_backlog = 2500
        net.ipv4.tcp_max_syn_backlog = 2500
        net.core.somaxconn = 25000
        net.ipv4.tcp_keepalive_time = 300
        net.ipv4.tcp_tw_recycle = 1

