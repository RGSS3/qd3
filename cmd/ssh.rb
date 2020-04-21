class QD3
	desc "sh [LINE]", "Enter the shell"
	option :ssh
	option :connector
	def sh(*args)
		if options[:ssh]
			@sshkey = options[:ssh] 
		end
		
		if args[0] == nil
			@ssh_connector = options[:connector] || "putty.exe"
			Kernel.system ssh_cmdline(qd3config)
		else
			@ssh_connector = options[:connector] || "plink.exe"
			Kernel.system ssh_cmdline(qd3config, support: "-batch") + " " + args[0]
		end
	end
end