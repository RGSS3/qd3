module QD3Util
  def puts(*args)
  	  @logger&.puts args
  end
  
  def system(a)
  	 if FileTest.exists?("qd3log.tmp")
  	 	 File.delete "qd3log.tmp"
  	 end
  	 r = super "#{a} >qd3log.tmp 2>&1"
  	 if FileTest.exists?("qd3log.tmp")
  	 	 @logger&.puts File.read("qd3log.tmp")
  	 end
  	 r
  end
  
  def info(a)
  	 STDOUT.puts "[INFO] #{a}" 
  end
  
  def use_logger(a)
  	 save = @logger
  	 @logger = a
  	 yield
  ensure
  	  @logger = save
  end
  
end