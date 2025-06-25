#!/bin/bash

# CONFIGURAZIONE
LOCATION="italynorth"
RESOURCE_GROUP="monitoring-rg"
VNET_NAME="vnet-monitoring"
SUBNET_NAME="subnet-monitoring"
NSG_NAME="nsg-monitoring"
VM_SIZE="Standard_B1s"
IMAGE="Ubuntu2204"

# Nome delle VM
VM_MAIN="vm-main"
VM_PROMETHEUS="vm-prometheus"
VM_GRAFANA="vm-grafana"

# Funzione per creare una VM
create_vm() {
    VM_NAME=$1
    echo "🚀 Creazione della VM: $VM_NAME"
    az vm create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$VM_NAME" \
        --image "$IMAGE" \
        --size "$VM_SIZE" \
        --admin-username azureuser \
        --generate-ssh-keys \
        --vnet-name "$VNET_NAME" \
        --subnet "$SUBNET_NAME" \
        --nsg "$NSG_NAME" \
        --public-ip-address "$VM_NAME-ip" \
        --output none
}

# CREAZIONE risorse di rete
echo "📦 Creazione Resource Group..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none

echo "🌐 Creazione Virtual Network..."
az network vnet create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VNET_NAME" \
    --subnet-name "$SUBNET_NAME" \
    --output none

echo "🔒 Creazione Network Security Group..."
az network nsg create --resource-group "$RESOURCE_GROUP" --name "$NSG_NAME" --output none

echo "🔓 Apertura porte SSH (22), Prometheus (9090), Grafana (3000)..."
az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_NAME" \
    --name AllowSSH --protocol tcp --priority 1000 --destination-port-ranges 22 --access allow --direction inbound --output none

az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_NAME" \
    --name AllowPrometheus --protocol tcp --priority 1010 --destination-port-ranges 9090 --access allow --direction inbound --output none

az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_NAME" \
    --name AllowGrafana --protocol tcp --priority 1020 --destination-port-ranges 3000 --access allow --direction inbound --output none

# CREAZIONE VMs
create_vm "$VM_MAIN"
create_vm "$VM_PROMETHEUS"
create_vm "$VM_GRAFANA"

echo "✅ Tutte le VMs sono state create con successo!"