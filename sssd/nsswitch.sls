nsswitch.config:
  file.managed:
    - name: {{ sssd.nsswitch}}
    - source: {{ config.nsswitch}}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: sssd.installed
  {% endif %}
