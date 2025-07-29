#!/bin/bash

# Exit on any error
set -e

echo "🔄 Updating package list..."
apt update

echo "☕ Installing Java 21 (OpenJDK) and FontConfig..."
apt install -y fontconfig openjdk-21-jre

echo "✅ Verifying Java version..."
java -version

echo "🔐 Adding Jenkins GPG key..."
mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "📦 Adding Jenkins APT repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

echo "🔄 Updating package list again..."
apt update

echo "🚀 Installing Jenkins..."
apt install -y jenkins

echo "🟢 Starting Jenkins service..."
systemctl start jenkins

echo "📌 Enabling Jenkins to start on boot..."
systemctl enable jenkins

echo "🔍 Checking Jenkins service status..."
systemctl status jenkins --no-pager

echo ""
echo "🎉 Jenkins is installed and running!"
echo "🌐 Visit: http://<your-server-ip>:8080"
echo "🔑 To get the initial admin password, run:"
echo "   sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
