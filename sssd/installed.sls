{% from "sssd/map.jinja" import sssd with context %}

{% set package = {
  'upgrade': salt['pillar.get']('sssd:package:upgrade', False),
} %}

{% set service = {
  'manage': salt['pillar.get']('sssd:service:manage', True),
  'running': salt['pillar.get']('sssd:service:running', True),
  'enable': salt['pillar.get']('sssd:service:enable', True),
} %}

{% set config = {
  'manage': salt['pillar.get']('sssd:config:manage', False),
  'source': salt['pillar.get']('sssd:config:source', 'salt://sssd/conf/sssd.conf'),
  'nsswitch': salt['pillar.get']('sssd:config:nsswitch', 'salt://sssd/conf/nsswitch.conf'),
  'pam_passwd': salt['pillar.get']('sssd:config:pam_passwd', 'salt://sssd/conf/password-auth-ac'),
  'pam_fprint': salt['pillar.get']('sssd:config:pam_fprint', 'salt://sssd/conf/fingerprint-auth-ac'),
  'pam_smcard': salt['pillar.get']('sssd:config:pam_smcard', 'salt://sssd/conf/smartcard-auth-ac'),
} %}

sssd.installed:
  pkg.{{ 'latest' if package.upgrade else 'installed' }}:
    - name: {{ sssd.package }}
  {% if service.manage -%}
  service.{{ 'running' if service.enable else 'dead' }}:
    - name: {{ sssd.service }}
    - require:
      - pkg: sssd.installed
      - file: sssd.installed
    - watch:
      - pkg: sssd.installed
      - file: sssd.installed
  {% endif -%}
  {% if config.manage %}
  file.managed:
    - name: {{ sssd.config }}
    - source: {{ config.source }}
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: sssd.installed

nsswitch.config:
  file.managed:
    - name: {{ sssd.nsswitch }}
    - source: {{ config.nsswitch }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: sssd.installed

pam_passwd.config:
  file.managed:
    - name: {{ sssd.pam_passwd }}
    - source: {{ config.pam_passwd }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: sssd.installed

pam_fprint.config:
  file.managed:
    - name: {{ sssd.pam_fprint }}
    - source: {{ config.pam_fprint }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: sssd.installed

pam_smcard.config:
  file.managed:
    - name: {{ sssd.pam_smcard }}
    - source: {{ config.pam_smcard }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: sssd.installed

  {% endif %}
