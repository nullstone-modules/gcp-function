locals {
  # Simple Go function using Go 1.25
  bootstrap_files = [
    {
      filename = "go.mod"
      content  = <<-EOT
        module example.com/bootstrap

        go 1.25

        require (
          github.com/GoogleCloudPlatform/functions-framework-go v1.8.0
        )
      EOT
    },
    {
      filename = "main.go"
      content  = <<-EOT
        package function

        import (
          "fmt"
          "net/http"

          "github.com/GoogleCloudPlatform/functions-framework-go/functions"
        )

        func init() {
          functions.HTTP("bootstrap", bootstrap)
        }

        // bootstrap is a simple HTTP handler
        func bootstrap(w http.ResponseWriter, r *http.Request) {
          fmt.Fprintf(w, "Hello, %s!", r.URL.Query().Get("name"))
        }
      EOT
    }
  ]
}

data "archive_file" "bootstrap" {
  type        = "zip"
  output_path = "${path.module}/bootstrap.zip"

  dynamic "source" {
    for_each = local.bootstrap_files
    content {
      filename = source.value.filename
      content  = source.value.content
    }
  }
}
