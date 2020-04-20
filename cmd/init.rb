require 'erb'
class QD3
	desc "init [template]", "Initialize the directory"
	def init(*args)
		tem = args[0] || "default"
		if FileTest.exists?("QD3FILE.yml")
			STDERR.puts "QD3FILE.yml already exists."
			STDERR.puts "If you really wanted to continue, please remove it."
			exit 1
		else
			template_file = File.join(ENV['QD3_TEMPLATE'], "#{tem}.yml")
			begin
				t = ERB.new(File.read(template_file)).result(binding)
				if check_yaml(t)
					File.write "QD3FILE.yml", t 
					puts "Initialized"
				else
					puts "There is some error in the template"
				end
			rescue Errno::ENOENT
				abort "The template file #{tem}.yml does not exist"
			end
		end
	end
end