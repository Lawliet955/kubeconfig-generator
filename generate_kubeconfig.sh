#!/bin/bash

# To use this bash script, you must before connect to the cluster with kubectl commands. Once logged in,it will automatically
# take the context of the right cluster with 'kubectl config current-context'. This script will generate a kubeconfig file.
# Actually you have to manually modify the var values "SERVICE_ACCOUNT_NAME" and "namespace".
# KUBECONFIG_FILE var is the name that the file generated will have after the script has been executed.

## TO DO: Asssign values to variables giving them in input when executing the script ##


# Parametri configurabili
SERVICE_ACCOUNT_NAME="pv-deleter-pipeline"
NAMESPACE="infra"
CLUSTER=$(kubectl config current-context)
KUBECONFIG_FILE="kubeconfig-${SERVICE_ACCOUNT_NAME}-${CLUSTER}.yaml"



# Recupera il nome del secret associato al Service Account
SECRET_NAME=$(kubectl get sa ${SERVICE_ACCOUNT_NAME} -n ${NAMESPACE} -o jsonpath="{.secrets[0].name}")

# Recupera il token del Service Account
TOKEN=$(kubectl get secret ${SECRET_NAME} -n ${NAMESPACE} -o jsonpath="{.data.token}" | base64 --decode)

# Recupera il certificato della CA
CA_CERT=$(kubectl get secret ${SECRET_NAME} -n ${NAMESPACE} -o jsonpath="{.data['ca\.crt']}")

# Recupera l'endpoint del server API
SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

# Genera il kubeconfig
cat <<EOF > ${KUBECONFIG_FILE}
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${CA_CERT}
    server: ${SERVER}
  name: ${CLUSTER}
contexts:
- context:
    cluster: ${CLUSTER}
    namespace: ${NAMESPACE}
    user: ${SERVICE_ACCOUNT_NAME}
  name: ${CLUSTER}-admin
current-context: ${CLUSTER}-admin
preferences: {}
users:
- name: ${SERVICE_ACCOUNT_NAME}
  user:
    token: ${TOKEN}
EOF

echo "Kubeconfig generato con successo: ${KUBECONFIG_FILE}"
