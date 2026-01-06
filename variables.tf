variable "runtime" {
  type        = string
  description = <<EOF
The runtime to use when configuring the cloud function.
GCP currently supports nodejsxy, pythonxy, goxy, javaxy, rubyxy, phpxy, and dotnetx (x is major version, y is minor version).
Examples: `nodejs20`, `python39`, `dotnet3`, `go116`, `java11`, `ruby30`, `php74`
See https://docs.cloud.google.com/functions/docs/runtime-support for full support schedule.
EOF
}

variable "entrypoint" {
  type        = string
  description = <<EOF
The entrypoint to use when configuring the cloud function.
This generally refers to the main function in your code; however, it depends on your runtime.
See https://docs.cloud.google.com/run/docs/write-functions#function_entry_point
EOF
}

variable "cpu" {
  type        = number
  default     = 1
  description = <<EOF
The amount of CPU to allocate to the cloud function.
EOF
}

variable "memory" {
  type        = string
  default     = "256Mi"
  description = <<EOF
The amount of memory to allocate to the cloud function.
EOF
}

variable "timeout" {
  type        = number
  default     = 20
  description = <<EOF
The maximum number of seconds to allow the cloud function to run.
If an execution exceeds the timeout, GCP will kill the process and fail the operation.
EOF
}

variable "max_instances" {
  type        = number
  default     = 3
  description = <<EOF
The maximum number of instances to run for the cloud function.
EOF
}

variable "max_request_concurrency" {
  type        = number
  default     = 10
  description = <<EOF
The maximum number of requests is determined by (max_instances * max_request_concurrency).
This determines the number of concurrent requests to a single instance.
EOF
}
