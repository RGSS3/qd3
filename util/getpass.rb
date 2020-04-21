module QD3Util
	def getpass
		if @pass == nil
			askpass = ENV['QD3_BIN'] + "\\askpass.exe"
			info "Please enter your password for #{ENV['username']}:(Press Enter twice to finish)"
			@pass = `#{askpass}`.chomp("\n")
			STDOUT.puts ""
		end
		@pass
	end
end