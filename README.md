# Despliegue Automatizado con Terraform, Ansible y AKS

Este proyecto automatiza el despliegue de una infraestructura escalable en Azure utilizando Terraform y la configuración de servidores Jenkins y Nginx dentro de un clúster de Kubernetes (AKS) mediante Ansible.

## Descripción General

Se ha utilizado Terraform para aprovisionar la infraestructura base en Azure y un repositorio en GitHub para el código. Posteriormente, Ansible se encarga de configurar la máquina virtual con un contenedor Nginx (gestionado como servicio con certificado y autenticación básica) y de desplegar Jenkins en el clúster de Kubernetes, incluyendo almacenamiento persistente y un Load Balancer para acceso externo.

## Arquitectura

La infraestructura desplegada incluye los siguientes componentes:

**Azure (con Terraform):**

* Grupo de recursos
* Azure Container Registry (ACR)
* Máquina Virtual (VM)
* Clúster de Kubernetes (AKS)
* Almacenamiento persistente (para AKS)
* Interfaz de red
* IP pública
* Red Virtual (VNet)
* Subred
* Grupo de seguridad de red (NSG)

**GitHub (con Terraform):**

* Repositorio para el código del proyecto.

**Configuración (con Ansible):**

* **VM:** Despliegue de un contenedor Nginx personalizado (con SSL y autenticación básica) utilizando Podman y gestionado como un servicio de systemd.
* **AKS:** Despliegue de Jenkins, creación de un volumen persistente y exposición mediante un Load Balancer.

## Estructura del Proyecto

azure-infra-deploy/
├── Terraform/
│   ├── _providers.tf
│   ├── _vars.tf
│   ├── aks.tf
│   ├── github_repo.tf
│   ├── main.tf
│   ├── managed_disk.tf
│   ├── network.tf
│   ├── outputs.tf
│   ├── security.tf
│   └── vm.tf
└── Ansible/
    ├── acr_upload.yml
    ├── Aks_setup.yml
    ├── inventory.yml
    ├── role_config.yml
    ├── vars.yml
    ├── vm_setup.yml
    └── nginx-config/
        ├── auth/
        │   └── .htpasswd
        └── ssl/
            ├── nginx.crt
            └── nginx.key
        ├── Dockerfile
        ├── nginx.conf
        ├── acr_credentials.json
        └── Podman-container.service.j2

## Despliegue

### Infraestructura con Terraform

1.  **Validación:**
    ```bash
    terraform validate
    ```
2.  **Planificación:**
    ```bash
    terraform plan
    ```
3.  **Aplicación:**
    ```bash
    terraform apply --auto-approve
    ```
    (Omitir `--auto-approve` para revisión manual antes de la aplicación).

### Configuración con Ansible

#### Despliegue en ACR y Contenedor en VM

1.  Asegúrate de haber iniciado sesión en Azure (`az login`) y en ACR (si es necesario).
2.  Construye la imagen de Nginx personalizada, etiquétala y súbela al ACR.
3.  Ejecuta los playbooks de Ansible para subir imágenes al ACR y configurar la VM:
    ```bash
    ansible-playbook acr_upload.yml && ansible-playbook -i inventory.yml vm_setup.yml
    ```
4.  Verifica que Nginx requiere autenticación accediendo a la IP de la VM en el puerto 8080 con `curl <tu_IP:8080>`.

#### Despliegue en AKS

1.  Instala el SDK de Kubernetes para Python en la máquina donde ejecutas Ansible:
    ```bash
    sudo apt install python3-kubernetes
    ```
2.  Ejecuta el playbook de Ansible para configurar AKS:
    ```bash
    ansible-playbook aks_setup.yml
    ```
3.  Verifica el estado del pod de Jenkins (dentro de la VM de Azure):
    ```bash
    kubectl describe pod -l app=jenkins -n default
    ```
4.  Accede a Jenkins a través del Load Balancer en el puerto 8080.

## Dificultades Encontradas y Soluciones

1.  **Login Correcto desde AKS Creando un Secreto:** Se creó un secreto de Kubernetes utilizando las credenciales de ACR para permitir que AKS extrajera la imagen de Jenkins.
2.  **Creación del Servicio en la VM Automáticamente:** Se configuró un servicio de systemd para el contenedor Podman de Nginx para que se inicie automáticamente después de un reinicio.
3.  **Certificado X.509 y Autenticación Básica htpasswd:** Se generó un certificado autofirmado y se configuró la autenticación básica en Nginx para proteger el acceso.

## Referencias

* Microsoft. (2023). Authenticate with ACR from AKS. Recuperado de [https://learn.microsoft.com/en-us/azure/aks/cluster-container-registry-integration](https://learn.microsoft.com/en-us/azure/aks/cluster-container-registry-integration)
* Freedesktop.org. (2023). Systemd service files. Recuperado de [https://www.freedesktop.org/software/systemd/man/systemd.service.html](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
* NGINX. (2023). Configuring Basic Authentication in Nginx. Recuperado de [https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/)
* Otras menciones: Youtube, Stack Overflow, Reddit

## Licencia

Este proyecto está bajo la [MIT License](LICENSE).
