ifdef ONE_LOCATION
PREFIX=$(ONE_LOCATION)
else
PREFIX=/usr
endif

install : 
	cp bin/onevc $(PREFIX)/bin/onevc
	cp lib/ruby/cli/one_helper/onevc_helper.rb $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb

uninstall :
	rm $(PREFIX)/bin/onevc
	rm $(PREFIX)/lib/ruby/cli/one_helper/onevc_helper.rb