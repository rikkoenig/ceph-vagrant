nodes = [ 
  { :hostname => 'mon1', :ip => '192.168.0.41', :box => 'bionic64' }, 
  { :hostname => 'mon2', :ip => '192.168.0.42', :box => 'bionic64' }, 
  { :hostname => 'mon3', :ip => '192.168.0.43', :box => 'bionic64' }, 
  { :hostname => 'osd1',  :ip => '192.168.0.51', :box => 'bionic64', :ram => 1024, :osd => 'yes' }, 
  { :hostname => 'osd2',  :ip => '192.168.0.52', :box => 'bionic64', :ram => 1024, :osd => 'yes' }, 
  { :hostname => 'osd3',  :ip => '192.168.0.53', :box => 'bionic64', :ram => 1024, :osd => 'yes' },
  { :hostname => 'ansible', :ip => '192.168.0.40', :box => 'bionic64' } 
] 
 
Vagrant.configure("2") do |config| 
  nodes.each do |node| 
    config.vm.define node[:hostname] do |nodeconfig| 
      nodeconfig.vm.box = "ubuntu/bionic64" 
      nodeconfig.vm.hostname = node[:hostname] 
      nodeconfig.vm.network :private_network, ip: node[:ip] 
      nodeconfig.vm.provision :shell, path: "bootstrap.sh", privileged: false
      nodeconfig.vm.synced_folder "./data", "/vagrant_data"
      if node[:hostname] == "ansible"
        nodeconfig.vm.provision :shell, path: "ansible-bootstrap.sh", privileged: false
      end
      if node[:osd] == "yes"
        nodeconfig.vm.provision :shell, path: "data/parter.sh"
      end
      memory = node[:ram] ? node[:ram] : 512; 
      nodeconfig.vm.provider :virtualbox do |vb| 
        vb.customize [ 
          "modifyvm", :id, 
          "--memory", memory.to_s, 
        ]
        vb.linked_clone = true 
        if node[:osd] == "yes"
          vb.customize [ "storagectl", :id, "--name", "SAS Controller", "--add", "sas", "--portcount", 4]
          vb.customize [ "createhd", "--filename", "disk_osddb-#{node[:hostname]}", "--size", "15360" ]
          vb.customize [ "createhd", "--filename", "disk_osddata1-#{node[:hostname]}", "--size", "10240" ] 
          vb.customize [ "createhd", "--filename", "disk_osddata2-#{node[:hostname]}", "--size", "10240" ] 
          vb.customize [ "storageattach", :id, "--storagectl", "SAS Controller", "--port", 1, "--device", 0, "--type", "hdd", "--nonrotational", "on", "--medium", "disk_osddb-#{node[:hostname]}.vdi" ] 
          vb.customize [ "storageattach", :id, "--storagectl", "SAS Controller", "--port", 2, "--device", 0, "--type", "hdd", "--medium", "disk_osddata1-#{node[:hostname]}.vdi" ] 
          vb.customize [ "storageattach", :id, "--storagectl", "SAS Controller", "--port", 3, "--device", 0, "--type", "hdd", "--medium", "disk_osddata2-#{node[:hostname]}.vdi" ] 
        end 
      end 
    end 
    config.hostmanager.enabled = true 
    config.hostmanager.manage_guest = true 
  end 
end 
