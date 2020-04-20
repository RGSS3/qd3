require 'json'
module QD3Util
	def docker_run_cmdline(config, line)
		mirrors = ((config["docker"] || {})["mirrors"] || [])
		File.write "qd3_docker.tmp", JSON.dump({"registry-mirrors": mirrors})
		ssh_push "qd3_docker.tmp", "/root/daemon.json"
		ssh_run config, "sudo cp /root/daemon.json /etc/docker/daemon.json"
		ssh_run config, "sudo /etc/init.d/docker restart"
		cmdline = "docker run -it --rm --privileged"
		((config["docker"] || {})["mount"] || {}).each{|k, v|
			cmdline << " -v/mnt/#{k}:/mnt/#{k}"
		}
		cmdline << " -v/mnt/here:/mnt/here"
		
		
		((config["docker"] || {})["network"] || {}).each{|k, v|
			cmdline << " -p #{k}:#{v}"
		}
		cmdline << " " << line
		File.write "qd3_docker.tmp", cmdline
		ssh_cmdline(config, connector: "putty") + " -m qd3_docker.tmp -t" 
	end
end