# 1. Cloudflare Workers KV Namespace for persistent task storage
resource "cloudflare_workers_kv_namespace" "tasks_kv" {
  account_id = var.cloudflare_account_id
  title      = "${var.kv_namespace_name}_${var.environment}"
}

# 2. Cloudflare Worker Script with KV Namespace binding
resource "cloudflare_workers_script" "task_manager" {
  account_id         = var.cloudflare_account_id
  name               = "${var.worker_name}-${var.environment}"
  content            = file("${path.module}/../application/worker.js")
  module             = true
  compatibility_date = "2024-01-01"

  kv_namespace_binding {
    name         = "TASKS_KV"
    namespace_id = cloudflare_workers_kv_namespace.tasks_kv.id
  }

  plain_text_binding {
    name = "ENVIRONMENT"
    text = var.environment
  }
}

# Note: workers.dev subdomain is enabled by default on Cloudflare
# No additional configuration needed
