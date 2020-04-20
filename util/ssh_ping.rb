module QD3Util
	def ssh_ping(config, connector: "plink.exe")
		cmdline = ssh_cmdline(config, connector: connector, support: " -batch ") + " " + "echo ABC"
		loop do
			z = `#{cmdline} 2>&1`
			puts z
			return true if z["ABC"]
			if z["POTENTIAL SECURITY BREACH"] || z["is not cached"]
				system "echo y | " + ssh_cmdline(config, connector: connector) + " " + "echo ABC 2>nul 1>nul"
				return true
			end
			puts "waiting"
			STDOUT.flush
			sleep 2
		end
		false
	end
end