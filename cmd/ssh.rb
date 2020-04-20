class QD3
	desc "sh [LINE]", "Enter the shell"
	def sh(*args)
		if args[0] == nil
			system ssh_cmdline(qd3config, connector: "putty.exe")
		else
			system ssh_cmdline(qd3config, connector: "plink.exe", support: "-batch") + " " + args[0]
		end
	end
end