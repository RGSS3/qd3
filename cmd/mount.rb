class QD3
	desc "mount NAME DIR", "MOUNT DIR (default: this folder) as /mnt/NAME"
	def mount(name, dir = Dir.getwd)
		ssh_mount name, dir
	end
end