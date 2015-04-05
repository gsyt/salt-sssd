include:
  - sssd.installed
  
sssd:
  require:
    - sls: sssd.installed
    - sls: krb5.installed
