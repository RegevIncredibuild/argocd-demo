# ArgoCD App of Apps Installation Guide

This guide explains how to deploy the complete application ecosystem 
using the App of Apps pattern.

## Installation Steps

### 1. Install the Root Application

This is the only manual step required. 
The root application will manage all other applications.

Using the ArgoCD UI:
- Click "+ NEW APP" button
- Select "EDIT AS YAML"
- Paste the contents of the root-app.yaml file
- Click "CREATE"

Or
```bash
# Apply the root application to your ArgoCD instance
kubectl apply -f _root-app.yaml -n argocd
```

### 2. Verify Deployment

After deploying the root application, it will automatically:
- Deploy the `demo-project` custom project
- Deploy the `application-set` for dynamic application discovery
- Deploy all applications defined in the `apps/` directory

### 3. Adding New Applications

To add a new application to the ecosystem:

1. Create a new directory for your application (e.g., `my-new-app/`)
2. Add your application files (Chart.yaml, templates/, values.yaml)
3. Create an application definition in `apps/my-new-app.yaml`
4. Commit and push your changes
5. ArgoCD will automatically detect and deploy the new application

## Validation Without kubectl

To validate deployments without using kubectl:

1. ArgoCD UI will show you the sync status of all applications
2. Use the debug pods (when enabled) to verify internal cluster state
3. The status dashboard provides a web interface to verify deployments
4. Application health checks are visible in the ArgoCD UI

## Troubleshooting

If an application fails to sync:

1. Check the ArgoCD UI for error messages
2. Enable debug features in the values.yaml file:
   ```yaml
   debug:
     enabled: true
     showDetails: true
     logLevel: debug
   ```
3. Re-sync the application to deploy debug resources
4. View the debug pod logs through the ArgoCD UI

## Architecture

The application follows this hierarchy:
- Root Application (`argocd-apps`) manages:
  - Project Definition (`demo-project`)
  - ApplicationSet (`cluster-apps`)
  - Individual Applications (like `nginx-demo`)
