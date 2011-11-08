ifdef ONE_LOCATION
PREFIX = $(ONE_LOCATION)
else
PREFIX = /usr
endif

install : 
	mkdir -p $(PREFIX)/lib/ruby/onevc/
	cp bin/onevc $(PREFIX)/bin/onevc
	cp lib/ruby/cli/one_helper/onevc_helper.rb $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb
	cp lib/ruby/onevc/VirtualCluster.rb $(PREFIX)/lib/ruby/onevc/VirtualCluster.rb
	chmod +x $(PREFIX)/bin/onevc

uninstall :
	rm -f $(PREFIX)/bin/onevc
	rm -f $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb
	rm -f $(PREFIX)/lib/ruby/onevc/VirtualCluster.rb
	rm -rf $(PREFIX)/lib/ruby/onevc/
