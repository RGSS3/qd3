class QD3
	desc "start", "Run for the first time"
	def start
		config = qd3config
		cmdline = qemu_cmdline(config)
		run = "#{ENV['QD3_EXE_QEMU']} #{cmdline} 2>nul >nul"
		pid = Process.spawn run
		config["pid"] = pid
		info "Waiting for machine to boot"
		saveconfig(config)
		ssh_ping config
		info "Working for provisions"
		(config["init"] || []).each{|x|
			ssh_run config, " \"" + x + "\""	
		}
		info "Working for folder mountings"
		(config["mount"] || {}).each{|k, v|
			ssh_mount k, v
		}
		ssh_mount "here"
		info "Done"
	end
	
	
	desc "edit", "Edit the config file"
	def edit
		system "#{ENV['QD3_BASE_PN']}\\pn.exe QD3FILE.yml"	
	end
	
	desc "stop", "Stop the running process"
	def stop
		config = qd3config
		if !config["pid"]
			puts "Process is not running"
			return
		end
		if system "taskkill /f /PID #{config["pid"]}"
			config["pid"] = nil
			saveconfig config
			puts "Process terminated"
		else
			STDERR.puts "Can not terminate or find the process"
			exit 1
		end
	end
	
	desc "restart", "Restart the process"
	def restart
		stop
		start
	end
end