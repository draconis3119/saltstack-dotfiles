bleutooth-enable-on-boot:
  file.append:
    - name: /etc/bluetooth/main.conf
    - text: |
        [Policy]
        AutoEnable=true
