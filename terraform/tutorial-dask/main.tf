provider "aws" {
  region = var.aws_region
}

# Define an EC2 instance for the Dask scheduler.
resource "aws_instance" "dask_scheduler" {
  ami           = "ami-0261755bbcb8c4a84" # Ubuntu 20.04
  instance_type = var.scheduler_instance_type

  subnet_id              = aws_default_subnet.default.id
  vpc_security_group_ids = [aws_security_group.dask.id]

  user_data = <<-EOT
              #!/bin/bash

              export HOME=/home/ubuntu
              cd $HOME

              wget "https://repo.anaconda.com/miniconda/${var.miniconda_exe}"
              bash ${var.miniconda_exe} -b -p ./miniconda3
              PATH=$HOME/miniconda3/bin:$PATH

              eval "$(conda shell.bash hook)"
              conda init bash
              conda create -n ${var.prefix} python=${var.python_version} -y
              conda activate ${var.prefix}
              python -m pip install "covalent==${var.covalent_package_version}"

              touch ./dask_scheduler_setup_complete

              dask-scheduler > ./dask_scheduler.log 2>&1
              EOT

  tags = {
    Name = "dask-scheduler"
  }
}

# Define a list of EC2 worker instances for the Dask cluster.
resource "aws_instance" "dask_worker" {
  count = var.n_workers

  root_block_device {
    volume_size = var.enable_gpu ? 128 : 64
  }
  ami           = var.enable_gpu ? "ami-0c47a507d2c485dff" : "ami-0261755bbcb8c4a84" # Ubuntu 20.04
  instance_type = var.enable_gpu ? var.worker_instance_type_gpu : var.worker_instance_type

  subnet_id              = aws_default_subnet.default.id
  vpc_security_group_ids = [aws_security_group.dask.id]

  user_data = <<-EOT
              #!/bin/bash

              export DASK_SCHEDULER_ADDRESS="${aws_instance.dask_scheduler.private_ip}:${var.scheduler_port}"
              export HOME=/home/ubuntu
              cd $HOME

              wget "https://repo.anaconda.com/miniconda/${var.miniconda_exe}"
              bash ${var.miniconda_exe} -b -p ./miniconda3
              export PATH=$HOME/miniconda3/bin:$PATH

              eval "$(conda shell.bash hook)"
              conda init bash
              conda create -n ${var.prefix} python=${var.python_version} -y
              conda activate ${var.prefix}
              python -m pip install "covalent==${var.covalent_package_version}"
              chown -R ubuntu:ubuntu $HOME

              touch ./dask_worker_${count.index + 1}_setup_complete

              dask-worker $DASK_SCHEDULER_ADDRESS > ./dask_worker.log 2>&1
              EOT

  tags = {
    Name = "dask-worker-${count.index + 1}"
  }
}
