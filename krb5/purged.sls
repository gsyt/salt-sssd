{% from "krb5/map.jinja" import krb5 with context %}

krb5.installed:
  pkg.purged:
    - name: {{ krb5.package }}
