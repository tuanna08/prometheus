# Install node expoter on ubuntu 18.04 lts

Step 1: Download the latest node exporter package. You should check the Prometheus downloads section for the latest version and update this command to get that package.
```
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
```

Step 2: Unpack the tarball
```
tar -xvf node_exporter-0.18.1.linux-amd64.tar.gz
```

Step 3: Move the node export binary to /usr/local/bin
```
sudo mv node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
```
Create a Custom Node Exporter Service

Step 1: Create a node_exporter user to run the node exporter service.
```
sudo useradd -rs /bin/false node_exporter
```
Step 2: Create a node_exporter service file under systemd.
```
sudo vi /etc/systemd/system/node_exporter.service
```

Step 3: Add the following service file content to the service file and save it.
```
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

Step 4: Reload the system daemon and star the node exporter service.
```
sudo systemctl daemon-reload
sudo systemctl start node_exporter
```

Step 5: check the node exporter status to make sure it is running in the active state.
```
sudo systemctl status node_exporter

```
Step 6: Enable the node exporter service to the system startup.

```
sudo systemctl enable node_exporter

```
Now, node exporter would be exporting metrics on port 9100. 

You can see all the server metrics by visiting your server URL on /metrics as shown below.
```
http://<server-IP>:9100/metrics
```
