# install prometheus on ubuntu 18.04

```
# export RELEASE="2.15.2"
# wget https://github.com/prometheus/prometheus/releases/download/v${RELEASE}/prometheus-${RELEASE}.linux-amd64.tar.gz
```
After downloading the archive, extract it using tar.

```
# tar xvf prometheus-${RELEASE}.linux-amd64.tar.gz
prometheus-2.15.2.linux-amd64/
prometheus-2.15.2.linux-amd64/promtool
prometheus-2.15.2.linux-amd64/consoles/
prometheus-2.15.2.linux-amd64/consoles/node-cpu.html
prometheus-2.15.2.linux-amd64/consoles/index.html.example
prometheus-2.15.2.linux-amd64/consoles/node-overview.html
prometheus-2.15.2.linux-amd64/consoles/prometheus-overview.html
prometheus-2.15.2.linux-amd64/consoles/node-disk.html
prometheus-2.15.2.linux-amd64/consoles/node.html
prometheus-2.15.2.linux-amd64/consoles/prometheus.html
prometheus-2.15.2.linux-amd64/NOTICE
prometheus-2.15.2.linux-amd64/LICENSE
prometheus-2.15.2.linux-amd64/prometheus.yml
prometheus-2.15.2.linux-amd64/prometheus
prometheus-2.15.2.linux-amd64/tsdb
prometheus-2.15.2.linux-amd64/console_libraries/
prometheus-2.15.2.linux-amd64/console_libraries/menu.lib
prometheus-2.15.2.linux-amd64/console_libraries/prom.lib
```

Change to the newly created directory from file extractions.
```
# cd prometheus-${RELEASE}.linux-amd64/
```
Create Prometheus system group
Prometheus needs its own user and group to run as.
```
# groupadd --system prometheus
# grep prometheus /etc/group

prometheus:x:999:
```
Create Prometheus system user
Now that we have Prometheus group, let's create a user and assign it the group created.
```
# useradd -s /sbin/nologin -r -g prometheus prometheus
# id prometheus
uid=999(prometheus) gid=999(prometheus) groups=999(prometheus)
```
Create configuration and data directories for Prometheus
Prometheus needs a directory to store its data and configuration files. We will create
/var/lib/prometheus for data and /etc/prometheus for configuration files.
```
# mkdir -p /etc/prometheus/{rules,rules.d,files_sd}  /var/lib/prometheus
```
Copy Prometheus binary files to a directory in your $PATH
Preferred directory to put third party binaries on Linux is  /usr/local/bin/ since it is in $PATH by default and it doesn't interfere with system binaries.
```
# cp prometheus promtool /usr/local/bin/
# ls /usr/local/bin/
```
prometheus promtool
Copy consoles and console_libraries to configuration files directory
Console files and libraries need to be placed under  /etc/prometheus/ directory.
```
# cp -r consoles/ console_libraries/ /etc/prometheus/
```
Create systemd unit file:
Ubuntu 18.04 uses systemd init system by default, we need to create a Service unit file for managing Prometheus service. We will put the file under /etc/systemd/system directory. The name of the file has to end with .service 
```
# cat /etc/systemd/system/prometheus.service

[Unit]
Description=Prometheus systemd service unit
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/prometheus \
--config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=/var/lib/prometheus \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries \
--web.listen-address=0.0.0.0:9090

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
```
Note that:

- We bind the service to 0.0.0.0:9090. This will be accessible from all network interfaces on the server. Limit it by specifying IP address for the interface you want to use, 127.0.0.1 for local access only.
- Configuration file specified is /etc/prometheus/prometheus.yml. We will create a basic configuration file to use next.

### Create Prometheus Configuration file
This will be placed in /etc/prometheus/ directory.
```
ubuntu@monitor-upstart:~$ cat /etc/prometheus/prometheus.yml
# Global Config
global:
  scrape_interval:     60s
  evaluation_interval: 60s
  scrape_timeout: 10s

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:

#  - job_name: 'prometheus'
#    static_configs:
#    - targets: ['localhost:9090']

  - job_name: 'MONITOR-SERVER'
    file_sd_configs:
      - files:
         - node-exporter.yml
#  - job_name: 'MONGODB'
#    file_sd_configs:
#      - files:
#         - mongodb-targets.yml
```
```
ubuntu@monitor-upstart:~$ cat /etc/prometheus/node-exporter.yml 
- targets: ['mongodb-rs01:9100']
  labels:
    name: 'mongodb-rs01 - MONITOR-SERVER'

- targets: ['mongodb-rs02:9100']
  labels:
    name: 'mongodb-rs02 - MONITOR-SERVER'

- targets: ['mongodb-rs03:9100']
  labels:
    name: 'mongodb-rs03 - MONITOR-SERVER'
```
For more configuration options, refer to official Prometheus Configuration guide.

Change directory permissions to Prometheus user and group
The ownership of Prometheus files and data should be its user and group.
```
# chown -R prometheus:prometheus /etc/prometheus/  /var/lib/prometheus/
# chmod -R 775 /etc/prometheus/ /var/lib/prometheus/
```
Start and enable Prometheus service
Start and enable Prometheus service to start on boot.
```
# systemctl start prometheus
# systemctl enable prometheus
Created symlink from /etc/systemd/system/multi-user.target.wants/prometheus.service to /etc/systemd/system/prometheus.service.
```
Check status:
```
# systemctl status prometheus
```

