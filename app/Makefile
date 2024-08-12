.PHONY: db.init
db.init: ## DBMSのユーザーやDB作成
	@echo '---[ MySQL ]'
	@echo user: $${MYSQL_USER}
	@echo host: $${MYSQL_HOST}
	@echo 'pass: *****'
	@echo '---'
	mysql -u$${MYSQL_USER} -h$${MYSQL_HOST} < ./sql/00-init.sql
	@mysql -u$${MYSQL_USER} -h$${MYSQL_HOST} -e "show databases like 'app_%';"
	@mysql -u$${MYSQL_USER} -h$${MYSQL_HOST} -e "select user from mysql.user where user = 'app';"

.PHONY: down
down: ## docker compose down
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
