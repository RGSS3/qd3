class QD3
	desc "docker-run NAME", "run a docker image"
	option :name
	def docker_run(name)
		@container_name = options[:name] || "default"
		system docker_run_cmdline(qd3config, name)
	end
	
	desc "docker-exec CMD", "run a docker exec cmd"
	option :name, desc: "the name of container to run"
	option :connector
	def docker_exec(line)
		@container_name = options[:name] || "default"
		Kernel.system docker_exec_cmdline(qd3config, line)
	end
	
	desc "docker CMD ...", "run a general docker cmd"
	option :connector
	def docker(*line)
		Kernel.system docker_cmdline(qd3config, line.join(" "))
	end
	
end