# File: /main.mk
# Project: envcache
# File Created: 11-01-2022 02:41:58
# Author: Clay Risser
# -----
# Last Modified: 11-01-2022 03:17:41
# Modified By: Clay Risser
# -----
# BitSpur Inc (c) Copyright 2021 - 2022
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

ifneq ($(_ENVS),/envcache/envs)
-include $(_ENVS)
ifneq ($(patsubst %.exe,%,$(SHELL)),$(SHELL))
$(_ENVS):
	@$(call mkdir_p,$(@D))
	@$(call touch,$@)
else
$(_ENVS): $(call join_path,$(PROJECT_ROOT),mkpm.mk) $(call join_path,$(ROOT),Makefile) $(GLOBAL_MK) $(LOCAL_MK)
	@$(ECHO) 🗲  make will be faster next time
	@$(call mkdir_p,$(@D))
	@$(call rm_rf,$@) $(NOFAIL)
	@$(call touch,$@)
	@$(call for,e,$$CACHE_ENVS) \
		if [ "$$($(ECHO) $$(eval "echo \$$$(call for_i,e)") | $(AWK) '{$$1=$$1};1')" != "" ]; then \
			$(ECHO) "export $(call for_i,e) := $$(eval "echo \$$$(call for_i,e)")" >> $(_ENVS); \
		fi \
	$(call for_end)
endif
endif
export CACHE_ENVS += \
