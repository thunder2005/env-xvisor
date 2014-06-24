# Remove the double quotes from COMPONENTS value, which are interpreted as is
# by the Makefile
COMPONENTS:=$(shell echo $(COMPONENTS))

#
# Prepare rule for each component, i.e. the step to get the component sources
# $1: The component name (TOOLCHAIN, LINUX, ...)
#
define PREPARE_RULE
  # This rule only exists for archived components (i.e. the kernel)
  ifeq ($($1_REPO),)
    # The component server and file must be set
  endif # !$1_REPO

  # Check if the component git repository is defined
  ifneq ($($1_REPO),)
$(BUILDDIR)/$($1_PATH):
	@echo "(Clone) $$@"
	$(Q)git clone -q $$($1_REPO) -b $$($1_BRANCH) $$@

  # The component is not fetch with a git repository
  else # $($1_REPO) empty or unset

    # Check if the component can be downloaded
    ifneq ($($1_SERVER),)
      ifneq ($($1_FILE),)
$(ARCDIR)/$($1_FILE): | $(TMPDIR)
	@echo "(Download) $$(@F)"
	$(Q)wget --no-verbose $($1_SERVER)/$$(@F) -O $(TMPDIR)/$$(@F)
	$(Q)mkdir -p $$(@D)
	$(Q)mv $(TMPDIR)/$$(@F) $$@

$(BUILDDIR)/$($1_PATH): $(ARCDIR)/$($1_FILE) | ${TMPDIR}
	@echo "(Decompress) $$(<F)"
        # Extraction depend on the suffix, and extract in a temporary directory
        # first, in case of interruption
        ifeq ($(suffix $($1_FILE)),.zip)
        # Extract it quietly, without keeping timestamps
	$(Q)unzip -qDx $$< -d $(TMPDIR)
        else # $1_FILE suffix is not .zip
	$(Q)tar mxf $$< -C $(TMPDIR)
        endif # $1_FILE suffix
	$(Q)mv $(TMPDIR)/$$(@F) $$@

      else
      # $1_FILE has been set, we cannot fetch the component
$(BUILDDIR)/$($1_PATH):
	@echo "$1 file has not been set, exiting..."
	$(Q)exit 1
      endif # $1_FILE

    # Nor $1_SERVER nor $1_REPO has been set, we cannot fetch the component
    else # $1_SERVER empty or unset
$(BUILDDIR)/$($1_PATH):
	@echo "$1 server or repository has not been set, exiting..."
	$(Q)exit 1
    endif # $1_SERVER
  endif # $1_REPO
endef

$(foreach component,$(COMPONENTS),\
  $(eval $(component)-prepare: $($(component)_DIR)))

# Generate the preparation rules for each component, depending on the fetching
# method (git repository cloning or archive download)
$(foreach component,$(COMPONENTS),$(eval $(call PREPARE_RULE,$(component))))
