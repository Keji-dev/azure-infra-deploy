# Creation of the resource Github repository, visibility default is set as "public", but can be changed as needed.

resource "github_repository" "azure-infra-deploy" {
    name = "azure-infra-deploy"
    description = "Azure Infraestructure Repository"

    visibility = "public"
}