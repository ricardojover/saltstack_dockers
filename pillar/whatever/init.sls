whatever:
    name: whatever
    magic_number: 1234567890
    config:
      root_dir: /
      log_level: DEBUG

# e.g. You want to access the log level and if it's not configured
# set INFO by default
# salt['pillar.get']('whatever:config:log_level', INFO)
