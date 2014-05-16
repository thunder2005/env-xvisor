# OpenOCD configure is buggy, reconfigure it
$(STAMPDIR)/.openocd_reconf: $(OPENOCD_DIR) | $(STAMPDIR)
	$(Q)cd $< && autoreconf --force --install
	$(Q)touch $@

openocd-configure $(OPENOCD_BUILD_DIR)/Makefile: $(OPENOCD_DIR) \
  $(STAMPDIR)/.openocd_reconf $(CONF)
	$(Q)mkdir -p $(OPENOCD_BUILD_DIR)
	$(Q)cd $(OPENOCD_BUILD_DIR) && \
	  $(OPENOCD_DIR)/configure --enable-ftdi --prefix=$(HOSTDIR)

openocd-compile: $(OPENOCD_BUILD_DIR)/Makefile
	$(Q)$(MAKE) -C $(OPENOCD_BUILD_DIR) all

openocd-install: openocd-compile
	$(Q)$(MAKE) -C $(OPENOCD_BUILD_DIR) install

openocd-run: # openocd-install
	$(Q)openocd -f $(CONFDIR)/$(OPENOCD_CONF).cfg; echo "" || RET=$$? && \
	  if [ $${RET} -eq 1 ]; then \
	    echo; \
	    echo "If you have any permission difficulties, copy the file"; \
	    echo "  $(wildcard $(CONFDIR)/*usb-jtag-perm.rules)"; \
	    echo "to your udev rule directory, and restart the udev daemon"; \
	  fi; \
	  exit $${RET}
