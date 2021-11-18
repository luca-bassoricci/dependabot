resource "helm_release" "dependabot-development" {
  count = local.development ? 1 : 0

  provider = helm.development

  name       = local.release.name
  repository = local.release.repository
  chart      = local.release.chart
  version    = local.release.version

  lint              = local.release.lint
  atomic            = local.release.atomic
  wait              = local.release.wait
  dependency_update = local.release.dependency_update
  create_namespace  = true

  namespace = local.release.namespace

  values = [
    templatefile("values/common.tpl", {
      gitlab_access_token = var.gitlab_access_token
    }),
    yamlencode({
      service = { type = "LoadBalancer" }
      mongodb = { strategyType = "Recreate" }
      image   = { pullPolicy = "Always" }
    })
  ]

  set {
    name  = "image.tag"
    value = var.image_tag
  }
}
