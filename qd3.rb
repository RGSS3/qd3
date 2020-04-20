require 'thor'
require 'yaml'
module QD3Util
	QD3Exception = Class.new(Exception)
	def check_yaml(a)
		YAML.load(a)
		true
	rescue
		puts a
		open('qd3.log', 'a') do |f|
			f.puts "----CHECK YAML----"
			f.puts $!.to_s
		end
		false
	end
end
class QD3 < Thor
	include QD3Util
	private
end
a = File.dirname(File.expand_path(__FILE__))
Dir.glob(File.join(a, "cmd/*.rb")) do |f|
	require_relative f[a.size + 1..-1]
end

Dir.glob(File.join(a, "util/*.rb")) do |f|
	require_relative f[a.size + 1..-1]
end

QD3.start(ARGV)
