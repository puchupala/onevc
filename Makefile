ifdef ONE_LOCATION
PREFIX = $(ONE_LOCATION)
else
PREFIX = /usr
endif

install : 
	mkdir -p $(PREFIX)/lib/ruby/onevc/
	mkdir -p $(PREFIX)/share/onevc/
	cp bin/onevc $(PREFIX)/bin/onevc
	cp lib/ruby/cli/one_helper/onevc_helper.rb $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb
	cp lib/ruby/onevc/VirtualCluster.rb $(PREFIX)/lib/ruby/onevc/VirtualCluster.rb
	cp share/onevc/install_onevc $(PREFIX)/share/onevc/install_onevc
	cp share/onevc/uninstall_onevc $(PREFIX)/share/onevc/uninstall_onevc
	cp share/onevc/onevc_backend.rb $(PREFIX)/share/onevc/onevc_backend.rb
	chmod +x $(PREFIX)/bin/onevc
	chmod +x $(PREFIX)/share/onevc/install_onevc
	chmod +x $(PREFIX)/share/onevc/uninstall_onevc
	$(PREFIX)/share/onevc/install_onevc

uninstall :
	$(PREFIX)/share/onevc/uninstall_onevc
	rm -f $(PREFIX)/bin/onevc
	rm -f $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb
	rm -f $(PREFIX)/lib/ruby/onevc/VirtualCluster.rb
	rm -f $(PREFIX)/share/onevc/install_onevc
	rm -f $(PREFIX)/share/onevc/uninstall_onevc
	rm -f $(PREFIX)/share/onevc/onevc_backend.rb
	rm -rf $(PREFIX)/lib/ruby/onevc/
	rm -rf $(PREFIX)/share/onevc/
