SHELL := /bin/bash

run_time := "$(shell date '+%Y_%m_%d__%H_%M_%S')"

build_images:
	echo "Building docker images and outputting build logs to ./logs/"; \
	docker compose build 2>&1 | tee logs/build/platform_build_logs_$(run_time).txt

build_images_no_cache:
	echo "Building docker images and outputting build logs to ./logs/"; \
	docker compose build --no-cache 2>&1 | tee logs/build/platform_build_no_cache_logs_$(run_time).txt