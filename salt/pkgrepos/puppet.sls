include:
  - pkgrepos.apt-get-update

pkgrepos-puppet-addrepo:
  cmd.run:
    - name: curl -o /tmp/puppetlabs-rel.deb https://apt.puppetlabs.com/puppetlabs-release-{{ grains['oscodename'] }}.deb && dpkg -i /tmp/puppetlabs-rel.deb && rm /tmp/puppetlabs-rel.deb
    - require_in:
      - cmd: apt-get-update


