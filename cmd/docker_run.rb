class QD3
	desc "docker-run NAME", "run a docker"
	option :name
	def docker_run(name)
		@container_name = options[:name] || "default"
		system docker_run_cmdline(qd3config, name)
	end
	
	desc "docker-exec CMD", "run a docker cmd"
	option :name, desc: "the name of container to run"
	option :connector
	def docker_exec(line)
		Kernel.system docker_exec_cmdline(qd3config, line)
	end
end