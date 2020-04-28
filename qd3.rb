require 'thor'
require 'yaml'
$VERBOSE = nil
require 'Win32API'
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
	def enable_vt
		d = "\0" * 8
		h1 = Win32API.new("Kernel32", "GetStdHandle", "L", "L").call(-10)
		h2 = Win32API.new("Kernel32", "GetStdHandle", "L", "L").call(-11)
		h3 = Win32API.new("Kernel32", "GetStdHandle", "L", "L").call(-12)
		Win32API.new("Kernel32", "GetConsoleMode", "Lp", "L").call(h1, d)
		d1 = d.unpack("L").first | 0x204
		Win32API.new("Kernel32", "SetConsoleMode", "LL", "L").call(h1, d1)
		
		Win32API.new("Kernel32", "GetConsoleMode", "Lp", "L").call(h2, d)
		d1 = d.unpack("L").first | 0x204
		Win32API.new("Kernel32", "SetConsoleMode", "LL", "L").call(h2, d1)
		
		Win32API.new("Kernel32", "GetConsoleMode", "Lp", "L").call(h3, d)
		d1 = d.unpack("L").first | 0x204
		Win32API.new("Kernel32", "SetConsoleMode", "LL", "L").call(h3, d1)
		#print "\e[31mEnabled\e[0m"
	end
	public
	def initialize(*)
		super
		#enable_vt
		@logger = MyFileLogger.new("qd3.log") 
	end
end
a = File.dirname(File.expand_path(__FILE__))
Dir.glob(File.join(a, "cmd/*.rb")) do |f|
	require_relative f[a.size + 1..-1]
end

Dir.glob(File.join(a, "util/*.rb")) do |f|
	require_relative f[a.size + 1..-1]
end

QD3.start(ARGV)
