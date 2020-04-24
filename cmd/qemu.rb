class QD3
	desc "qemu ARGS", "send commands to the qemu for internal usage"
	def qemu(*args)
		Kernel.system "#{ENV['QD3_EXE_QEMU']} #{args.join(' ')}"
	end
	
	
	desc "qemu-send ARGS", "(internal) send commands to the qemu for internal usage"
	def qemu_send(*args)
		port = qd3config["qemu"]["port"]
		if port
			require 'net/telnet'
			r = Net::Telnet.new "Host"=>"localhost", 
				                "Port"=>port,
				                "Prompt"=>/\(qemu\)/,
				                "Timeout"=>30
		    print r.cmd(args.join(' '))				                
		end
	end
end
	