CONCURRENCY ?= 100
REPS ?= 100

.PHONY: bench_all bench_official-fpm bench_official-apache bench_custom-fpm

bench_all: bench_official-fpm bench_official-apache bench_custom-fpm

start:
	@echo ""
	@echo "Starting docker-compose.yml"
	@echo ""
	@docker-compose down
	@docker-compose up -d

build:
	@echo ""
	@echo "Starting docker-compose.yml"
	@echo ""
	@docker-compose down
	@docker-compose build
	@docker-compose up -d

bench_custom-fpm:
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm down
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm build
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm up -d
	@echo ""
	@echo "Custom php-fpm + nginx"
	@echo ""
	sleep 3;
	siege -b -c${CONCURRENCY} -r${REPS} http://127.0.0.1:8010/lucky/number
	@docker-compose -f docker-compose.custom-fpm.yaml -p php_bench_custom_fpm down

install_symphony:
	@docker run --rm \
	--volume ${PWD}/symfony_skeleton:/app \
	composer:1 install --ansi

install:
	@docker run --rm \
	--volume ${PWD}:/app \
	composer install --ansi
