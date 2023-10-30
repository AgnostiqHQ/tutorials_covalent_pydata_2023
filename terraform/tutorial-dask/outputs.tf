output "scheduler_address" {
  value       = "${aws_instance.dask_scheduler.public_ip}:${var.scheduler_port}"
  description = "Dask scheduler public IP"
}
