ifdef ONE_LOCATION
PREFIX = $(ONE_LOCATION)
ETC_PREFIX = $(ONE_LOCATION)/etc
else
PREFIX = /usr
ETC_PREFIX = /etc
endif

install : 
	mkdir -p $(PREFIX)/lib/ruby/onevc/
	mkdir -p $(PREFIX)/share/onevc/
	cp bin/onevc $(PREFIX)/bin/onevc
	cp bin/onevcd $(PREFIX)/bin/onevcd
	cp lib/ruby/cli/one_helper/onevc_helper.rb $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb
	cp lib/ruby/onevc/VirtualCluster.rb $(PREFIX)/lib/ruby/onevc/VirtualCluster.rb
	cp lib/ruby/onevc/VirtualClusterPool.rb $(PREFIX)/lib/ruby/onevc/VirtualClusterPool.rb
	cp lib/ruby/onevc/NodeType.rb $(PREFIX)/lib/ruby/onevc/NodeType.rb
	cp lib/ruby/onevc/onevc_backend.rb $(PREFIX)/lib/ruby/onevc/onevc_backend.rb
	cp lib/ruby/onevc/onevcd_backend.rb $(PREFIX)/lib/ruby/onevc/onevcd_backend.rb
	cp lib/ruby/onevc/onevcd.rb $(PREFIX)/lib/ruby/onevc/onevcd.rb
	cp share/onevc/install_onevc $(PREFIX)/share/onevc/install_onevc
	cp share/onevc/uninstall_onevc $(PREFIX)/share/onevc/uninstall_onevc
	cp etc/cli/onevc.yaml $(ETC_PREFIX)/cli/onevc.yaml
	chmod +x $(PREFIX)/bin/onevc
	chmod +x $(PREFIX)/bin/onevcd
	chmod +x $(PREFIX)/share/onevc/install_onevc
	chmod +x $(PREFIX)/share/onevc/uninstall_onevc
	$(PREFIX)/share/onevc/install_onevc

uninstall :
	$(PREFIX)/share/onevc/uninstall_onevc
	rm -f $(PREFIX)/bin/onevc
	rm -f $(PREFIX)/bin/onevcd
	rm -f $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb
	rm -f $(PREFIX)/lib/ruby/onevc/VirtualCluster.rb
	rm -f $(PREFIX)/lib/ruby/onevc/VirtualClusterPool.rb
	rm -f $(PREFIX)/lib/ruby/onevc/NodeType.rb
	rm -f $(PREFIX)/lib/ruby/onevc/onevc_backend.rb
	rm -f $(PREFIX)/lib/ruby/onevc/onevcd_backend.rb
	rm -f $(PREFIX)/lib/ruby/onevc/onevcd.rb
	rm -f $(PREFIX)/share/onevc/install_onevc
	rm -f $(PREFIX)/share/onevc/uninstall_onevc
	rm -f $(ETC_PREFIX)/cli/onevc.yaml
	rm -rf $(PREFIX)/lib/ruby/onevc/
	rm -rf $(PREFIX)/share/onevc/
