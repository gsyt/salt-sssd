include:
  - sssd.installed
  
sssd:
  require:
    - sls: sssd.installed
