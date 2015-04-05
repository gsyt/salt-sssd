{% from "krb5/map.jinja" import krb5 with context %}

{% set package = {
  'upgrade': salt['pillar.get']('krb5:package:upgrade', False),
} %}

{% set config = {
  'manage': salt['pillar.get']('krb5:config:manage', False),
  'source': salt['pillar.get']('krb5:config:source', 'salt://krb5/conf/krb5.conf'),
} %}

krb5.installed:
  pkg.{{ 'latest' if package.upgrade else 'installed' }}:
    - name: {{ krb5.package }}
  {% if config.manage %}
  file.managed:
    - name: {{ krb5.config }}
    - source: {{ config.source }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: krb5.installed
  {% endif %}
