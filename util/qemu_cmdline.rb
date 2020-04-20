module QD3Util
	def qemu_cmdline(config)
		if !config.include?("qemu")
			return ""
		end
		
		cdrom  = config["qemu"]["cdrom"]
		memory = config["qemu"]["memory"]
		fwd = []
		(config["qemu"]["network"] || {}).each{|k, v|
			if ["tcp-in", "tcp-out", "udp-in", "udp-out"].include?(k)
				a, b = k.split("-")
				b = {"in" => "hostfwd", "out" => "guestfwd"}[b]
				(v || {}).each{|p1, p2|
					fwd << "%s=%s::%s-:%s" % [b, a, p1, p2]
				}
			end
		}
		cmdline = "-net nic"
		if !fwd.empty?
			cmdline <<  " -net user," << fwd.join(",")
		end
		if memory
			cmdline << " -m " << memory
		end
		if cdrom
			cmdline << " -cdrom " << cdrom
		end
		if config["qemu"]["accelerator"] == "hax"
			cmdline << " -accel hax"
		end
		cmdline
	end
end