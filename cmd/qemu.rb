class QD3
	desc "qemu ARGS", "send commands to the qemu for internal usage"
	def qemu(*args)
		Kernel.system "#{ENV['QD3_EXE_QEMU']} #{args.join(' ')}"
	end
end
	