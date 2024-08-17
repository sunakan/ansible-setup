.PHONY: ping
ping: ## 接続確認
	docker compose run --rm ansible ansible -i inventories/all-in-one/hosts.yaml web_servers -m ansible.builtin.ping

.PHONY: ping4
ping4: ## 接続確認
	docker compose run --rm ansible ansible -i inventories/basic4-web-db-jobq-jobw/hosts.yaml all -m ansible.builtin.ping
	docker compose run --rm ansible ansible -i inventories/basic4-web-db-jobq-jobw/hosts.yaml all -m ansible.builtin.command -a "hostname -s"


.PHONY: setup.all-in-one
setup.all-in-one: ## all-in-one環境をsetup
	docker compose run --rm ansible ansible-playbook -i inventories/all-in-one/hosts.yaml all-in-one.yaml
	#docker compose run --rm ansible ansible-playbook -i inventories/all-in-one/hosts.yaml all-in-one.yaml --tags "common,redis"

.PHONY: setup.basic4-web-db-jobq-jobw
setup.basic4-web-db-jobq-jobw: ## basic4-web-db-jobq-jobw環境をsetup
	docker compose run --rm ansible ansible-playbook -i inventories/basic4-web-db-jobq-jobw/hosts.yaml basic4-web-db-jobq-jobw.yaml

.PHONY: ssh.all-in-one
ssh.all-in-one: ## all-in-one環境にssh
	ssh "${ANSIBLE_SSH_USER}@${ALL_IN_ONE_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

.PHONY: ssh.basic4-web-01
ssh.basic4-web-01: ## web-01環境にssh
	ssh "${ANSIBLE_SSH_USER}@${WEB_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

.PHONY: ssh.basic4-db-01
ssh.basic4-db-01: ## db-01環境にssh
	ssh "${ANSIBLE_SSH_USER}@${DB_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

.PHONY: ssh.basic4-jobq-01
ssh.basic4-jobq-01: ## job-queue-01環境にssh
	ssh "${ANSIBLE_SSH_USER}@${JOB_QUEUE_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

.PHONY: ssh.basic4-jobw-01
ssh.basic4-jobw-01: ## job-worker-01環境にssh
	ssh "${ANSIBLE_SSH_USER}@${JOB_WORKER_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

.PHONY: newrelic.basic4-check
newrelic.basic4-check-newrelic: ## basic4各環境でnewrelic-infra.yamlを表示
	ssh "${ANSIBLE_SSH_USER}@${WEB_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "sudo cat /etc/newrelic-infra.yml"
	ssh "${ANSIBLE_SSH_USER}@${DB_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "sudo cat /etc/newrelic-infra.yml"
	ssh "${ANSIBLE_SSH_USER}@${JOB_QUEUE_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "sudo cat /etc/newrelic-infra.yml"
	ssh "${ANSIBLE_SSH_USER}@${JOB_WORKER_01_HOST}" -i "${ANSIBLE_SSH_PRIVATE_KEY_FILE}" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "sudo cat /etc/newrelic-infra.yml"


.PHONY: myip
myip: ## myipを取得
	@curl https://ipinfo.io/ip

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
