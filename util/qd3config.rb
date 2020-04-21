require 'yaml'
module QD3Util
	def qd3config
		if !FileTest.exists?("QD3FILE.yml")
			abort "This directory is not a qdocker3 directory(You forgot `qd3 init`?)"
		end
		YAML.load(File.read("QD3FILE.yml").force_encoding("UTF-8"))
	end
	
	def saveconfig(a)
		File.write "QD3FILE.yml", YAML.dump(a)
	end
end