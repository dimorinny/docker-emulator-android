SHELL := /usr/bin/env bash
VERSIONS = android-16 android-17 android-18 android-19 android-21 android-22 android-23 android-24 android-25 android-26

generate:
	for version in $(VERSIONS); do \
		mkdir -p ./build/$$version ; \
		sed "s/{{ platform }}/$$version/g" templates/Dockerfile > build/$$version/Dockerfile ; \
		sed "s/{{ platform }}/$$version/g" templates/config.ini > build/$$version/config.ini ; \
		sed "s/{{ platform }}/$$version/g" templates/Makefile > build/$$version/Makefile ; \
		sed "s/{{ platform }}/$$version/g" templates/setup_adb_redirection.sh > build/$$version/setup_adb_redirection.sh ; \
		sed "s/{{ platform }}/$$version/g" templates/setup_android_config_from_environment.sh > build/$$version/setup_android_config_from_environment.sh ; \
		sed "s/{{ platform }}/$$version/g" templates/start_emulator.sh > build/$$version/start_emulator.sh ; \
		sed "s/{{ platform }}/$$version/g" templates/entrypoint.sh > build/$$version/entrypoint.sh ; \
		cp base/* ./build/$$version ; \
	done

clean:
	rm -rf ./build

build: generate
	for version in $(VERSIONS); do \
		$(MAKE) -C build/$$version build; \
	done

lint: generate
	for version in $(VERSIONS); do \
		$(MAKE) -C build/$$version lint; \
	done

tag: generate
	for version in $(VERSIONS); do \
		$(MAKE) -C build/$$version tag; \
	done

login:
	@docker login -u "$(DOCKER_USER)" -p "$(DOCKER_PASS)" "$(PROXY)"

push: login
	for version in $(VERSIONS); do \
		$(MAKE) -C build/$$version push; \
	done
