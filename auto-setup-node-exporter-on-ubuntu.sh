#!/bin/sh

#yum update -y
timedatectl set-timezone Asia/Ho_Chi_Minh
#export lanip=`ip -4 addr show eth1| grep -oP "(?<=inet ).*(?=/)"`
export lanip="0.0.0.0"

echo "Lan IP: "$lanip

sudo apt install wget curl git -y

FILE=/tmp/node_exporter-1.5.0.linux-amd64.tar.gz
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else
    echo "$FILE does not exist."
#    wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz  -P /tmp/
    wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz -P /tmp/
fi

tar -xvf /tmp/node_exporter-1.5.0.linux-amd64.tar.gz -C /tmp/

FILE2=/usr/local/bin/node_exporter
if [ -f "$FILE2" ]; then
    echo "$FILE2 exists."
else
    echo "$FILE2 does not exist."
    mv -f /tmp/node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/
fi


useradd -rs /bin/false node_exporter

rm /etc/systemd/system/node_exporter.service -f

cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter  --web.listen-address=$lanip:9100
[Install]
WantedBy=multi-user.target
EOF

timedatectl set-timezone Asia/Ho_Chi_Minh
systemctl daemon-reload
systemctl restart node_exporter

systemctl status node_exporter

curl http://$lanip:9100/
systemctl enable node_exporter
echo "install node exporter done"
