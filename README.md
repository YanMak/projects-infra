Центральная инфраструктурная папка для всей группы проектов: хранение скриптов CI/CD, общих Helm-чартов, конфигов доступа, secrets, шаблонов деплоя — всё для консистентной разработки и эксплуатации.


./ci_cd/

ISW (infrastructure script workflow) для всех проектов:
	/ci_cd/projects/<project>/infra: деплойный пайплайн helm, шаблоны окружений local/k8s/dev/prod, sops.yaml и дешифровка values. Для дев локал режима например выгрузка creds, cfg, env файлов из секретов. 

	/ci_cd/projects/<project>/code: локальный запуск микросервисов монорепозитория для dev режима, билд образов dev/prod режима. Для дев режима выгрузка образа сразу в dev minikube минуя remote repo  

	/ci_cd/projects/<project> единая точка деплоя для разных environment: local/k8s/dev/prod  
---

./charts/

Глобальный каталог Helm-чартов и их шаблонов для всех проектов:
	./charts/infra
 	Kafka, Consul, Vault, Redis, и др. (бэковые сервисы и шаблоны под каждый проект). Кастомизации под конкретный проект ./charts/infra/.projects/<project>
 
	./charts/code
	чарты микросервисов, их ingress, публичные values. !!!Непубличные зашифрованные values размещаются в ./secrets/<project> 

---
./helm-pkg/ 

Реестр собранных .tgz Helm-чартов, подготовленных для хоста собственного Helm-репозитория (если нужно).

---
./nginx/

Конфиги внешних ingress/proxy для доступа к разным кластерам.

---
./projects/

Кодовые базы проектов (фронт+бэк), например:
	/projects/ecommerce/v1/
	/projects/<another-product>/v2/

---
./secrets/

Зашифрованные значения и secrets для деплоя: /secrets/<project>/<env>/ — secrets/values/dev, prod, stage, ci, внешние секреты (ESO/Vault)
	Например:
	./secrets/ecommerce/v1/dev
	непубличные вельюс: общий values и диффы для dev k8s/local режима
	
	/code/kube/secrets/ecommerce/v1/dev/external-secrets
	чарты для eso секретов

	./secrets/ecommerce/v1/dev/output
	выгрузка .env/creds/configs для локального режима запуска

	./secrets/ecommerce/v1/prod и ./secrets/ecommerce/v1/stage
	./secrets/ecommerce/v1/ci используемые в изолированной среде (GitHub Actions, Gitlab CI, Jenkins…) 

---
Навигатор и интеграция.

В каждом монорепозитории отдельного продукта (например, [/projects/ecommerce/v1/README.md]) — ссылка на разработческую/CI/CD-инфрастуру: "Организация пайплайнов, секретов, helm-чартов и инструментов деплоя.


Все секреты и scripts хранятся централизованно — быстрое масштабирование процессов доставки для новых и legacy проектов.


Вся команда может брать шаблоны из /ci_cd и /charts для ускоренного внедрения любого нового продукта.
