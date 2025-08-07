# ArgoCD Applications

This directory contains ArgoCD Application definitions that will be automatically deployed to the cluster.

To add a new application:
1. Create a new application directory at the repository root
2. Add a new Application definition YAML file in this directory

ArgoCD will automatically detect and deploy these applications.

argocd-demo/
├── apps/                       # Bootstrap directory containing Application definitions
│   ├── nginx-demo-app.yaml     # Application definition for the Nginx demo
│   └── README.md               # Documentation
│
└── nginx-demo/             # Actual application code/charts
   ├── Chart.yaml
   ├── values.yaml
   └── templates/
      ├── deployment.yaml
      ├── service.yaml
      └── configmap.yaml