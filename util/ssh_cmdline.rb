module QD3Util
	def ssh_run(config, line)
		@logger&.puts("SSH> " + line)
		system ssh_cmdline(config, support: "-batch") + " " + line
	end
	def ssh_push(a, b)
		Kernel.system ssh_cmdline(qd3config, connector: "pscp.exe", before: a, path: ":#{b}")
	end
	def ssh_pull(a, b)
		Kernel.system ssh_cmdline(qd3config, connector: "pscp.exe", path: ":#{a}", after: b)
	end
	def ssh_mount(name, dir = Dir.getwd)
		user = ENV['username']
		pass = getpass
		config = qd3config
		uuid = config["uuid"]
		share = "SHARE-#{uuid}-#{name}"
		system "net share #{share} /delete"
		system "net share #{share}=#{dir}  /grant:everyone,full"
		ssh_run config, "sudo umount -f /mnt/#{name}"
		ssh_run config, "sudo mkdir /mnt/#{name}"
		r = @logger
		@logger = nil
		ssh_run config, %{sudo mount -v -t cifs -o username="#{user}",password="#{pass}",dir_mode=0777,file_mode=0777 //10.0.2.2/#{share} /mnt/#{name}}
		@logger = r
	end
	def ssh_cmdline(config, support: nil, 
			                before: nil,
			                connector: nil,
			                filename: "",
			                after: nil, 
			                path: nil)
		if !config.include?("ssh")
			return ""
		end
		connector = connector || @ssh_connector || "plink.exe"
		ssh = @sshseg ? config["ssh"][@sshseg] : config["ssh"] 
		cmdline = "#{ENV['QD3_BASE_PUTTY']}\\#{connector} "
		if ssh["pass"]
			cmdline << " -pw " << ssh["pass"]
		end
		
		if ssh["port"]
			cmdline << " -P " << ssh["port"].to_s
		end
		
		if support
			cmdline << " " << support << " "
		end
		
		if before
			cmdline << " " << before << " "
		end
		
		if ssh["user"]
			cmdline << " " << ssh["user"] << "@localhost#{path}"
		else
			cmdline << " localhost#{path}"
		end
		
		if after
			cmdline << " " << after << " "
		end
		
		cmdline
	end
end