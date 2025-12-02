locals {
  packer_contents_hash      = md5(join(",", [for f in fileset("${path.module}/packer", "**") : filemd5("${path.module}/packer/${f}") if f != ".manifest.json"]))
  region_build_params       = "-var aws_region=${var.builder_region} -var availability_zone=${var.builder_availability_zone}"
  image_source_build_params = "-var source_image_filter=${var.source_image_filter}"
  image_target_build_params = "-var ami_name=${var.target_image_name}"
  instance_build_params     = "-var instance_type=${var.instance_type} -var disk_size=${var.disk_size}"
  iam_build_params          = var.iam_instance_profile != null ? "-var iam_instance_profile=${var.iam_instance_profile}" : ""
  run_build_params          = "-var docker_image=${var.docker_image}"
}
