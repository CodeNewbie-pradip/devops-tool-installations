#!/bin/bash

# Exit on any error
set -e

echo "🔍 Checking prerequisites..."
apt update
apt install -y unzip wget openjdk-17-jdk

echo "☕ Verifying Java version..."
java -version

echo "📦 Downloading SonarQube..."
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.7.0.110598.zip

echo "📂 Extracting SonarQube..."
unzip sonarqube-25.7.0.110598.zip
mv sonarqube-25.7.0.110598 sonarqube

echo "👤 Creating sonar user..."
useradd -r -s /bin/false sonar
chown -R sonar:sonar /opt/sonarqube

echo "⚙️ Creating SonarQube service..."
cat <<EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Reloading systemd and starting SonarQube..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl start sonarqube
systemctl enable sonarqube

echo "✅ SonarQube setup complete!"
echo "🌐 Visit SonarQube on: http://<your-server-ip>:9000"
echo "🔑 Default credentials: admin / admin"
