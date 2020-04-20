require 'yaml'
module QD3Util
	def qd3config
		YAML.load(File.read("QD3FILE.yml").force_encoding("UTF-8"))
	end
	
	def saveconfig(a)
		File.write "QD3FILE.yml", YAML.dump(a)
	end
end