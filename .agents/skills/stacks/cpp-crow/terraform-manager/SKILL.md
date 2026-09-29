---
name: "terraform-manager"
description: "Activar cuando se requiera inicializar, planificar, aplicar, validar o administrar la infraestructura como código (IaC) basada en Terraform para los entornos local, staging y prod en CrowKit."
---

# Terraform Manager Skill — CrowKit 🦅

Esta Skill estandariza y automatiza el flujo de trabajo con **Terraform** para el aprovisionamiento dinámico y la gestión de infraestructura como código (IaC) en el ecosistema **CrowKit** (entornos `local`, `staging` y `prod`, con módulos Multi-Cloud para AWS, GCP y Azure).

> [!NOTE]
> Para la gestión integral combinada de contenedores Docker, Helm charts y Terraform, consultar también [skills/infra-manager/SKILL.md](../infra-manager/SKILL.md).

## Estructura de Infraestructura

```text
terraform/
├── environments/
│   ├── local/                 # Entorno local basado en Docker Provider (kreuzwerker/docker)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/               # Entorno Staging en Cloud (GCP / AWS / Azure)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/                  # Entorno Producción de alta disponibilidad
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
└── modules/
    ├── aws/                   # Módulos AWS: ecr, eks, kms, vpc
    ├── azure/                 # Módulos Azure: acr, aks, key_vault, vnet
    ├── gcp/                   # Módulos GCP: artifact_registry, gke, secret_manager, vpc
    └── helm_crow_service/     # Módulo de integración Terraform-Helm
```

## Flujo de Trabajo y Comandos

### 1. Inicialización de Entornos (`init`)
Antes de ejecutar planes o cambios en cualquier entorno:
```bash
terraform -chdir=terraform/environments/local init
```

### 2. Validación de Sintaxis HCL (`validate`)
Verificar que la configuración no contenga errores de sintaxis:
```bash
./scripts/verify-terraform.sh
```
O directamente con Terraform:
```bash
terraform -chdir=terraform/environments/local validate
```

### 3. Planificación de Cambios (`plan`)
Simular los recursos a crear o actualizar:
```bash
# Desarrollo local mediante script auxiliar
./scripts/terraform-local.sh plan

# O directamente en el entorno deseado
terraform -chdir=terraform/environments/staging plan
```

### 4. Aplicación de Infraestructura (`apply`)
Aprovisionar los recursos en el entorno correspondiente:
```bash
# Desarrollo local mediante script auxiliar
./scripts/terraform-local.sh apply

# O directamente en el entorno deseado
terraform -chdir=terraform/environments/staging apply
```

### 5. Destrucción / Rollback (`destroy`)
Desaprovisionar la infraestructura:
```bash
./scripts/terraform-local.sh destroy
```

## Protocolos de Seguridad
1. **Archivos Ignorados:** `*.tfstate`, `*.tfstate.*` y `.terraform/` NUNCA deben commitearse en el repositorio de Git.
2. **Entorno Local Host:** En desarrollo local se utiliza el **Docker Provider** (`kreuzwerker/docker`) sobre el socket local mediante `scripts/terraform-local.sh`.
3. **Validación Automática:** Ejecute las herramientas de validación de Terraform configuradas por el proyecto para revisar sintaxis y formato.
