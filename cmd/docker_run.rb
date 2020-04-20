class QD3
	desc "docker-run NAME", "run a docker"
	def docker_run(name)
		system docker_run_cmdline(qd3config, name)
	end
end