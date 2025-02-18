# kubeconfig-generator

Below is an example documentation for the bash script:

----

#### Generate Kubeconfig Bash Script Documentation

**Overview**  
This bash script automatically generates a kubeconfig authentication file for a Kubernetes cluster. It retrieves crucial details—such as the Service Account token, CA certificate, and API server endpoint—from the current cluster context and creates a kubeconfig file for subsequent Kubernetes API interactions.

**Prerequisites**  
- **Logged into the Kubernetes Cluster:**  
  Before running this script, you must be logged in to the Kubernetes cluster using kubectl. The script uses the command `kubectl config current-context` to obtain the active cluster context.  
- **kubectl Installed:**  
  The script assumes that the kubectl command is installed and configured correctly on your system.

**Configuration Parameters**  
The script contains configurable parameters that you may need to adjust:
- **SERVICE_ACCOUNT_NAME:**  
  The name of the Service Account whose credentials will be used. *(Default: "pv-deleter-pipeline")*
- **NAMESPACE:**  
  The namespace where the Service Account is located. *(Default: "infra")*
- **CLUSTER:**  
  Derived automatically from `kubectl config current-context`. Represents the current cluster context.
- **KUBECONFIG_FILE:**  
  The name of the output kubeconfig file. The file naming convention is `"kubeconfig-${SERVICE_ACCOUNT_NAME}-${CLUSTER}.yaml"`.

**Script Workflow**  
1. **Determine the Current Cluster:**  
   The script uses `kubectl config current-context` to fetch the active Kubernetes cluster context.
2. **Obtain the Service Account Secret:**  
   It retrieves the secret name associated with the specified Service Account in the given namespace.
3. **Extract Token and CA Certificate:**  
   The script extracts the Service Account token (decoding it from base64) and the CA certificate from the secret.
4. **Extract API Server Endpoint:**  
   It fetches the API server endpoint using `kubectl config view --minify`.
5. **Generate the Kubeconfig File:**  
   A new kubeconfig file is generated using a `heredoc` that populates the necessary details (cluster, context, and user).  
6. **Output Confirmation:**  
   Finally, the script outputs the name of the generated kubeconfig file.

**Usage**  
1. Ensure you are logged into your Kubernetes cluster:
   ```bash
   kubectl login ...
   # or use your preferred method to authenticate with your cluster
   ```
2. Modify the values of `SERVICE_ACCOUNT_NAME` and `NAMESPACE` in the script if needed.
3. Run the script:
   ```bash
   ./generate_kubeconfig.sh
   ```
4. A kubeconfig file named according to the pattern `"kubeconfig-${SERVICE_ACCOUNT_NAME}-${CLUSTER}.yaml"` will be created in the current directory.

**Notes**  
- This script is designed to use the active cluster context. Make sure your kubectl context is set to the desired cluster before running the script.
- You may extend this script to accept input parameters for further automation.

----

This documentation provides an overview and clear instructions on how to use the bash script to generate a kubeconfig authentication file automatically.
