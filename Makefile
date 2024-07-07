.PHONY: ping
ping: ## 接続確認
	docker compose run --rm ansible ansible -i inventories/all-in-one/hosts.yaml web_servers -m ansible.builtin.ping

.PHONY: ansible.all-in-one
setup.all-in-one: ## all-in-one環境をsetup
	docker compose run --rm ansible ansible-playbook -i inventories/all-in-one/hosts.yaml all-in-one.yaml

.PHONY: ssh.all-in-one
ssh.all-in-one: ## all-in-one環境にssh
	ssh "${ANSIBLE_SSH_USER}@${ALL_IN_ONE_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}"


################################################################################
# CI
################################################################################
.PHONY: lint
lint: ## rubocop
	bundle exec rubocop

.PHONY: check
check: ## 静的型検査
	bundle exec steep check

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
