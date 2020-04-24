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
			cmdline << " -boot d -cdrom " << cdrom
		end
		if (kernel = config["qemu"]["kernel"])
			cmdline << " -kernel " << kernel
		end
		if (initrd = config["qemu"]["initrd"])
			cmdline << " -initrd " << initrd
		end
		
		["hda", "hdb", "hdc", "hdd"].each{|x|
			if (hd = config["qemu"][x])
				cmdline << " -#{x} " << hdd(hd)
			end
		}
		
		acc = config["qemu"]["accelerator"]
		if acc && ["hax", "whpx"].include?(acc)
			cmdline << " -accel #{acc}"
		end
		cmdline
	end
	
	def hdd(x)
		h, a = x.split(",")
		if !FileTest.file?(h)
			if a
				Kernel.system "#{ENV['QD3_BASE_QEMU']}\\qemu-img.exe create -f qcow2 #{h} #{a}"
			else
				abort "#{h} not found"
			end
		end
		h
	end
end