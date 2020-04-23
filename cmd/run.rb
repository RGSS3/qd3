class QD3
	desc "start", "Run for the first time"
	option :qemu, desc: "(advanced) extra options passed to qemu"
	def start
		config = qd3config
		cmdline = qemu_cmdline(config)
		puts "#{ENV['QD3_EXE_QEMU']} #{cmdline} #{options[:qemu]}"
		run = "#{ENV['QD3_EXE_QEMU']} #{cmdline} #{options[:qemu]} 2>nul >nul"
		pid = Process.spawn run
		config["pid"] = pid
		info "Waiting for machine to boot"
		saveconfig(config)
		ssh_ping config, pid
		info "Working for provisions 1/2"
		(config["init"] || []).each{|x|
			ssh_run config, " \"" + x + "\""	
		}
		
=begin
		info "Working for folder mountings"
		(config["mount"] || {}).each{|k, v|
			ssh_mount k, v
		}
		ssh_mount "here"
=end
		docker_make_mirror(config)
		info "Working for provisions 2/2"
		(config["after-init"] || []).each{|x|
			ssh_run config, " \"" + x + "\""	
		}
		
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