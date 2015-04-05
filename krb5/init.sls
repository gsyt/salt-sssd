include:
  - krb5.installed
  
krb5:
  require:
    - sls: krb5.installed
