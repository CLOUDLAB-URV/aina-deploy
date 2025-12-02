resource "terraform_data" "packer_image" {
  count = var.should_build ? 1 : 0

  triggers_replace = [
    local.packer_contents_hash,
    local.region_build_params,
    local.image_source_build_params,
    local.image_target_build_params,
    local.instance_build_params,
    local.iam_build_params,
    local.run_build_params,
  ]

  provisioner "local-exec" {
    when        = create
    working_dir = "${path.module}/packer/"
    command     = "packer init . && packer build ${local.region_build_params} ${local.image_source_build_params} ${local.image_target_build_params} ${local.instance_build_params} ${local.iam_build_params} ${local.run_build_params} ."
  }
}

data "local_file" "ami_id" {
  filename   = "${path.module}/.ami_id"
  depends_on = [terraform_data.packer_image]
}
