output "s3_bucket_name" {
  value       = aws_s3_bucket.bucket.id
  description = "S3 bucket to store job artifacts"
}

output "batch_queue" {
  value       = aws_batch_job_queue.job_queue.name
  description = "AWS Batch job queue"
}

output "batch_job_role_name" {
  value       = aws_iam_role.job_role.name
  description = "IAM role assigned to tasks"
}

output "batch_job_log_group_name" {
  value       = aws_cloudwatch_log_group.log_group.name
  description = "Task Cloudwatch log group name"
}

output "batch_execution_role_name" {
  value       = aws_iam_role.ecs_tasks_execution_role.name
  description = "ECS task execution role"
}
