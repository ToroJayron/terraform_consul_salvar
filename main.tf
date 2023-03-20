
resource "aws_instance" "salvar_ec2" {
  count= var.ec2cluster
  instance_type = var.instance_type
  ami = var.instance_ami
  subnet_id = aws_subnet.consul-j-subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.j-consul-sg.id]
  key_name = "consul-j-kp"
  associate_public_ip_address = true
  user_data = <<-EOF
          #!/bin/bash
          echo "export AWS_REGION=${var.aws_region}" >> /etc/environment
          echo "export CONSUL_LOCAL_CONFIG='{ \"datacenter\": \"ap-southeast-1\", \"server\": true }'" >> /etc/environment
          curl -fsSL https://releases.hashicorp.com/consul/1.15.1/consul_1.15.1_linux_amd64.zip -o /tmp/consul.zip
          unzip /tmp/consul.zip -d /usr/local/bin/
          mkdir -p /etc/consul.d
          sudo yum install -y yum-utils
          sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
          sudo yum -y install consul
          EOF

  tags = {
    Name = "Consul-J-${count.index}"
  }
  
}
