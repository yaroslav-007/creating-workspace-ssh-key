provider "tfe" {
  token = "user-token"
}

###Create workspace in TFE
resource "tfe_workspace" "test" {
  name         = "name-of-workspace"
  organization = "tfe-organization-name"
  ssh_key_id   = "${data.tfe_ssh_key.ssh-key.id}"
  auto_apply   = "true"

  ###Attach simple github repo that consume module from another repo
  vcs_repo {
    identifier = "github-organization/git-hub-repo-name"

    oauth_token_id = "ot-hmAyP66qk2AMVdbJ" #One way to get it is performing https://www.terraform.io/docs/enterprise/api/oauth-tokens.html#sample-request
  }
}

###Create ssh key in the TFE. It key already exist comment it and comment the depend on <data "tfe_ssh_key" "ssh-key"> resource "tfe_ssh_key" "ssh-key" {
resource "tfe_ssh_key" "ssh-key" {
  name         = "name-of-ssh-key"       # the name of the key in TFE
  organization = "tfe-organization-name"

  ###from they private key you should replace every new line with \n
  key = "-----BEGIN RSA PRIVATE KEY-----\nMIIEp..."
}

##Attach ssh key to the created workspace
data "tfe_ssh_key" "ssh-key" {
  name         = "name-of-ssh-key"       # the name of the key in TFE
  organization = "tfe-organization-name"

  ###To wait until ssh key is created
  depends_on = ["tfe_ssh_key.ssh-key"]
}
