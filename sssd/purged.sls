{% from "sssd/map.jinja" import sssd with context %}

sssd.installed:
  pkg.purged:
    - name: {{ sssd.package }}
