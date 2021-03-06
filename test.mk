include Makefile

CMD_PREPARE=\
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get -qq update && \
  apt-get -qq install -y --no-install-recommends pandoc >/dev/null

CMD_NBCONVERT=\
  jupyter nbconvert \
  --execute \
  --no-prompt \
  --no-input \
  --to=asciidoc \
  --ExecutePreprocessor.timeout=600 \
  --output=/tmp/out $(PROJECT_PATH_ENV)/$(NOTEBOOKS_DIR)/demo.ipynb

SUCCESS_MSG="[+] Test succeeded: PROJECT_PATH_ENV=$(PROJECT_PATH_ENV) PRESET=$(PRESET)"

.PHONY: test_jupyter
test_jupyter: JUPYTER_CMD=bash -c '$(CMD_PREPARE) && $(CMD_NBCONVERT)'
test_jupyter: JUPYTER_DETACH=
test_jupyter: jupyter
	@echo $(SUCCESS_MSG)


.PHONY: test_jupyter_baked
test_jupyter_baked: PROJECT_PATH_ENV=/project-local
test_jupyter_baked: JOB_NAME=jupyter-baked-$(PROJECT)
test_jupyter_baked:
	$(NEURO) run $(RUN_EXTRA) \
	  --name $(JOB_NAME) \
		--preset $(PRESET) \
		$(CUSTOM_ENV) \
		bash -c '$(CMD_PREPARE) && $(CMD_NBCONVERT)'
	@echo $(SUCCESS_MSG)
