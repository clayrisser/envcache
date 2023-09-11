# File: /main.mk
# Project: envcache
# File Created: 11-01-2022 02:41:58
# Author: Clay Risser
# -----
# Last Modified: 11-09-2023 06:41:28
# Modified By: Clay Risser
# -----
# Risser Labs LLC (c) Copyright 2021 - 2022
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

_ENVS := $(MKPM_TMP)/envcache/envs

export MKCACHE_RESET_ENVS := $(RM) -rf $(_ENVS) $(NOFAIL)

ifneq ($(_ENVS),/envcache/envs)
-include $(_ENVS)
$(_ENVS):
	@$(ECHO) 🗲  make will be faster next time
	@$(MKDIR) -p $(@D)
	@$(RM) -rf $@ $(NOFAIL)
	@$(TOUCH) $@
	@for e in $$CACHE_ENVS; do \
		if [ "$$($(ECHO) $$(eval "echo \$$$$e") | $(AWK) '{$$1=$$1};1')" != "" ]; then \
			$(ECHO) "export $$e := $$(eval "echo \$$$$e")" >> $(_ENVS); \
		fi \
	done
endif

export CACHE_ENVS += \
