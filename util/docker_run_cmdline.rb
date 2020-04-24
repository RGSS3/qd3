require 'json'
module QD3Util
	def docker_make_mirror(config)
		mirrors = ((config["docker"] || {})["mirrors"])
		if mirrors
			File.write "qd3_docker.tmp", JSON.dump({"registry-mirrors": mirrors})
			ssh_push "qd3_docker.tmp", "/root/daemon.json"
			ssh_run config, "sudo cp /root/daemon.json /etc/docker/daemon.json"
			ssh_run config, "sudo /etc/init.d/docker restart"
		end
	end
	def docker_run_cmdline(config, line)
		docker_make_mirror config
		cmdline = "docker run -it --rm --privileged"
		cmdline << " -v/:/host"
		if @container_name
			cmdline << " --name #{@container_name}"
		end
		
		((config["docker"] || {})["network"] || {}).each{|k, v|
			cmdline << " -p #{k}:#{v}"
		}
		cmdline << " " << line
		File.write "qd3_docker.tmp", cmdline
		ssh_cmdline(config, connector: "putty") + " -m qd3_docker.tmp -t" 
	end
	
	def docker_exec_cmdline(config, line)
		cmdline = "docker exec -it #{@container_name || "default"} #{line}"
		File.write "qd3_docker.tmp", cmdline
		connector = options[:connector] || "plink.exe"
		ssh_cmdline(config, connector: connector) + " -ssh -t \"#{cmdline}\"" 
	end
	
	def docker_cmdline(config, line)
		cmdline = "docker #{line}"
		puts cmdline
		File.write "qd3_docker.tmp", cmdline
		connector = options[:connector] || "plink.exe"
		ssh_cmdline(config, connector: connector) + " -batch -ssh -t \"#{cmdline}\"" 
	end
end