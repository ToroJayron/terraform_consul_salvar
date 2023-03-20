# terraform_consul_salvar
documentation on creating consul cluster using terraform
**main.tf**
In the main.tf 3 instances will be created provided with the user data that will download and install consul
inside the three instances

**network.tf**
In the network.tf file I have included VPC, Route Table, Security Group, Subnet, and Route Table Association.
In the security group I have allowed the incoming traffic from port 8300, 8500, and port 22. These ports will
allow our instance to connect on consul

**providers.tf**
I have included here the providers that is needed which is consul and aws

**variables.tf**
In this file I have included the instance type, the instance ami, the number of instances that will be created
and lastly the region where my cluster will be deployed

**What to do**
-After applying the instances and they are created try to establish ssh connection in one of the instances.

-When the SSH connection is established use the "sudo systemctl start consul"  command to start consul.

-When the consul is running edit the "/etc/consl.d/consul.hcl file and change the bind_addr to the ip address 
of the instance. 

-When done editing the file use "consul agent -dev -client=<ip address> it will make the instance to be the leader.
  
-Then go to the other instances and join the cluster by using "consul join <server ip address>. Lastly to check the consul UI go to your browser and type the commande "<IPv4publicaddress>:8500
