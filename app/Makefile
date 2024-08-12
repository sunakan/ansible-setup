.PHONY: db.setup
db.setup: ## DBのセットアップ
	@make db.init
	@make db.migrate
	@make db.reset-and-seed

.PHONY: db.init
db.init: ## DBMSのユーザーやDBの初期化
	@docker compose exec mysql bash -c "mysql -h$${MYSQL_HOST} < /sql/00-init.sql"
	@docker compose exec mysql bash -c "mysql -h$${MYSQL_HOST} -e 'show databases like \"app%\";'"
	@docker compose exec mysql bash -c "mysql -h$${MYSQL_HOST} -e 'select user from mysql.user where user = \"app\";'"
	@docker compose exec mysql bash -c "mysql -h$${MYSQL_HOST} -e 'select table_schema, table_name from information_schema.tables where table_schema like \"app%\"'"

.PHONY: db.migrate
db.migrate: ## DB マイグレーション
	mysqldef -u$${MYSQL_USER} -h$${MYSQL_HOST} --enable-drop-table app_development < ./sql/10-schema.sql
	mysqldef -u$${MYSQL_USER} -h$${MYSQL_HOST} --enable-drop-table app_test < ./sql/10-schema.sql

.PHONY: db.migrate.dry-run
db.migrate.dry-run: ## DB マイグレーション(dry-run)
	mysqldef -u$${MYSQL_USER} -h$${MYSQL_HOST} --enable-drop-table app_development --dry-run < ./sql/10-schema.sql

.PHONY: db.reset-and-seed
db.reset-and-seed: ## DB を1度空にして、seedデータを入れる
	@docker compose exec mysql bash -c "mysql -h$${MYSQL_HOST} app_development < /sql/20-seed.sql"
	@docker compose exec mysql bash -c "mysql -h$${MYSQL_HOST} app_development -e 'select * from products; select * from users;'"

.PHONY: up
up: ## docker compose up
	docker compose up

.PHONY: down
down: ## docker compose down -v
	docker compose down -v

################################################################################
# Utility-Command help
################################################################################
.DEFAULT_GOAL := help

################################################################################
# マクロ
################################################################################
# Makefileの中身を抽出してhelpとして1行で出す
# $(1): Makefile名
define help
  grep -E '^[\.a-zA-Z0-9_-]+:.*?## .*$$' $(1) \
  | grep --invert-match "## non-help" \
  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

################################################################################
# タスク
################################################################################
.PHONY: help
help: ## Make タスク一覧
	@echo '######################################################################'
	@echo '# Makeタスク一覧'
	@echo '# $$ make XXX'
	@echo '# or'
	@echo '# $$ make XXX --dry-run'
	@echo '######################################################################'
	@echo $(MAKEFILE_LIST) \
	| tr ' ' '\n' \
	| xargs -I {included-makefile} $(call help,{included-makefile})
