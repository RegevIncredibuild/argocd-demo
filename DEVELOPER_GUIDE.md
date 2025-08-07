# Developer Guide: GitOps with ArgoCD

This guide will help you understand how to deploy your applications using our GitOps workflow with ArgoCD.

## Quick Start

1. **Fork/clone this repository**
   ```bash
   git clone https://github.com/RegevIncredibuild/argocd-demo.git
   cd argocd-demo
   ```

2. **Create your application directory**
   ```bash
   mkdir -p my-app/templates
   ```

3. **Create application files**
   - Create `Chart.yaml`, `values.yaml`, and templates
   - Use the existing `nginx-demo` as a reference

4. **Create ArgoCD application manifest**
   ```bash
   cp apps/nginx-demo-app.yaml apps/my-app.yaml
   # Edit my-app.yaml to point to your new application
   ```

5. **Commit and push your changes**
   ```bash
   git add .
   git commit -m "Add my-app application"
   git push
   ```

6. **Verify in ArgoCD UI**
   - Your application will be automatically deployed
   - Check the sync status in the ArgoCD dashboard

## Anatomy of an Application

Each application in this GitOps repository consists of:

1. **Helm Chart Directory** (e.g., `nginx-demo/`)
   - `Chart.yaml` - Chart metadata
   - `values.yaml` - Default configuration values
   - `templates/` - Kubernetes manifest templates
   - `templates/NOTES.txt` - (Optional) Usage notes displayed after deployment

2. **ArgoCD Application Definition** (e.g., `apps/nginx-demo-app.yaml`)
   - Defines how ArgoCD should deploy your application
   - Points to the Helm chart directory
   - Specifies target namespace and sync policies

## Testing Your Application

Before pushing changes:

1. **Validate your Helm chart**
   ```bash
   helm lint my-app
   helm template my-app
   ```

2. **Review rendered manifests**
   ```bash
   helm template my-app > rendered-manifests.yaml
   # Review the output for correctness
   ```

## Troubleshooting

If your application fails to sync:

1. Check the ArgoCD UI for error messages
2. Enable debug options in your `values.yaml`:
   ```yaml
   debug:
     enabled: true
     logLevel: debug
   ```
3. Use the provided validation tools (see `validation/` directory)

## GitOps Best Practices

1. **Small, incremental changes** - Easier to review and troubleshoot
2. **Test locally before pushing** - Use provided validation tools
3. **Use meaningful commit messages** - Helps with auditing and rollbacks
4. **Keep secrets separate** - Use Sealed Secrets or external secret management
5. **Review the rendered manifests** - Ensure templates generate what you expect

Need more help? Contact the platform team.
