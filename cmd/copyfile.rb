class QD3
	desc "push A B", "copy a file A to the machine as file B"
	def push(a, b)
		ssh_push(a, b)
	end
	
	desc "pull A B", "copy a machine file A to the local file b"
	def pull(a, b)
		ssh_pull(a, b)
	end
	
	desc "import IMAGE", "import this image to docker"
	def import(img)
		ssh_push img, "/root/import.tar"
		config = qd3config
		ssh_run config, "\"docker load -i /root/import.tar\""
		ssh_run config, "rm /root/import.tar"
	end
end