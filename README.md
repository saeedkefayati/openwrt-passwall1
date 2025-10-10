
# Passwall1

this is repository for all action in passwall1 service

[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)
![GitHub last commit](https://img.shields.io/github/last-commit/saeedkefayati/openwrt-passwall1)
![GitHub top language](https://img.shields.io/github/languages/top/saeedkefayati/openwrt-passwall1)
![GitHub repo size](https://img.shields.io/github/repo-size/saeedkefayati/openwrt-passwall1)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/saeedkefayati/openwrt-passwall1)


<figure>
  <pre role="img" aria-label="ASCII BANNER" style="text-align:center; font-size:0.75rem;">
.-----------------------------------------------------.
|                                                     |
|                                                     |
|   _____ _____ _____ _____ _ _ _ _____ __    __      |
|  |  _  |  _  |   __|   __| | | |  _  |  |  |  |     |
|  |   __|     |__   |__   | | | |     |  |__|  |__   |
|  |__|  |__|__|_____|_____|_____|__|__|_____|_____|  |
|                                                     |
|                                                     |
'-----------------------------------------------------'
  </pre>
</figure>

<br/>


## Smart Installation (Recommend)

1. Install Dependencies<br/>
```bash
  opkg install git git-http
```

<br/>

2. Usage with this command<br/>
- Github:
```bash
sh <(wget -qO- https://raw.githubusercontent.com/saeedkefayati/openwrt-passwall1/main/install.sh)
```

- Githack:
```bash
sh <(wget -qO- https://raw.githack.com/saeedkefayati/openwrt-passwall1/main/install.sh)
```

- jsdelivr CDN:
```bash
sh <(wget -qO- https://cdn.jsdelivr.net/gh/saeedkefayati/openwrt-passwall1@main/install.sh)
```

- statically CDN
```bash
sh <(wget -qO- https://cdn.statically.io/gh/saeedkefayati/openwrt-passwall1/main/install.sh)
```

<br/>

## Manual Installation

1. Install Dependencies<br/>
```bash
  cd /root
```
```bash
  wget -O passwall1.zip https://github.com/saeedkefayati/openwrt-passwall1/archive/refs/heads/main.zip
```
```bash
  opkg install unzip
```


2. Unzip Dependencies<br/>
```bash
  unzip passwall1.zip && rm -rf passwall1.zip
```
```bash
  mv passwall1-main passwall1
```

3. Executable Dependencies<br/>
```bash
  find ./passwall1 -type f -name "*.sh" -exec chmod +x {} \;
```
```bash
  cd passwall1 && ./main.sh
```

4. Add Shortcut Command (optional) - can use passwall1 command<br/>
```bash
  echo '#!/bin/sh' > /usr/bin/passwall1 && echo 'cd /root/passwall1 && ./main.sh' >> /usr/bin/passwall1 && chmod +x /usr/bin/passwall1
```
