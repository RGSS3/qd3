class QD3
	desc "repl", "Run a REPL for QD3"
	def repl
		require 'irb'
		binding.irb
	end
end