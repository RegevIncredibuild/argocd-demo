# GitOps with ArgoCD - Quick Guide

This guide explains how to use this repository to deploy applications to Kubernetes using GitOps principles with ArgoCD.

## Repository Structure

```
argocd-demo/
├── apps/                       # ArgoCD Application definitions
│   ├── nginx-demo-app.yaml     # Application manifest for the Nginx demo
│   └── README.md               # Documentation
├── nginx-demo/                 # Example Helm chart
│   ├── Chart.yaml              # Chart metadata
│   ├── values.yaml             # Default values
│   └── templates/              # Kubernetes manifest templates
├── _INSTALLATION.md            # ArgoCD installation instructions
└── _root-app.yaml              # Root application for the App of Apps pattern
```

## How to Add Your Application

1. **Create a new Helm chart directory**:
   ```bash
   mkdir -p my-app/templates
   ```

2. **Create basic chart files**:
   - `Chart.yaml` - Chart metadata
   - `values.yaml` - Default configuration values
   - `templates/deployment.yaml` - Deployment definition
   - `templates/service.yaml` - Service definition
   - `templates/NOTES.txt` - Usage instructions

3. **Create ArgoCD application manifest**:
   ```bash
   # Create your application definition in apps/
   cp apps/nginx-demo-app.yaml apps/my-app.yaml
   # Edit my-app.yaml to point to your new application directory
   ```

4. **Push your changes**:
   ```bash
   git add .
   git commit -m "Add my new application"
   git push
   ```

## Debugging

If your application fails to sync:

1. Check the ArgoCD UI for error messages

2. Enable debug mode in your `values.yaml`:
   ```yaml
   debug:
     enabled: true
     logLevel: debug
   ```

3. If you need to modify immutable fields, use the `Replace=true` option:
   ```yaml
   syncOptions:
     - Replace=true
   ```

## Testing Without kubectl

Helm tests can be used to validate your application:

1. Create a test in `templates/tests/test-connection.yaml`
2. Use `helm template` to validate rendering
3. ArgoCD will show test results in the UI

## Best Practices

1. **Store all templates in the `templates/` directory**
2. **Include health checks in your deployments**
3. **Add descriptive NOTES.txt** for user instructions
4. **Follow Kubernetes label standards**
5. **Test locally before pushing**
