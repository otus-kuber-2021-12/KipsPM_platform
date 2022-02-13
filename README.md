# KipsPM_platform
KipsPM Platform repository

Homework #1
0. В качество рабочей станции использовалась macos, соответственно все инсталляции производились с помощью brew.
1. Установлен kubectl, docker engine, minukube
2. Настроено автодополнение для oh my zsh
3. Запущен k8s, испробованы проверки на восстановление подов:
   - поды kubedns управляются replicaset'ами, которые в свою очередь созданы соответствующими deployment'ами
   - kube-apiserver управляется сервисом kubelet и его манифест хранится на файловой системе мастер-ноды
4. Написан dockerfile для простенького web-сервера на python:3.7-alpine, проверена работоспособность с помощью docker run.
5. Написан манифест web-pod.yaml, в процессе он был дополнен init контейнера и volume.
6. Проверена работоспособность с помощью kubectl port-forward
7. Склонировано и собрано приложение frontend из предоставленного репозитория.
8. Запущено приложение frontend в ad-hoc режиме.
9. Задание со звездочкой. Приложению для корректного запуска не хватало переменных. Определил данные переменные в манифесте (значения заглушка) и добился 1/1 Running.

Homework #2
0. Установлен kind, в процессе пришлось добавить ОЗУ на докер десктоп, потому что все дико тупило.
1. Создан kubernetes кластер в kind.
2. Запущен ReplicaSet с приложением frontend, проведены эксперименты с реплицированием.
3. Собрано приложение второй версии, проведены эксперименты с обновлением, обновление версии приложения в манифесте ReplicaSet не влияет на версию приложения в запущенных подах, так как контроллер ReplicaSet следит только за количеством запущенных pod, а не за конфигурацией.
4. Собрано приложение payments и проведены все предыдущие изыскания уже с ним.
5. Написан Deployment для приложения payments. Проведены эксперименты с RollingUpdate.
6. * Написаны Deployment для blue-green и reverse rolling деплоя.
7. Приложению frontend добавлен readinessProbe, проведены эксперименты с ним.
8. * Написан DaemonSet для node exporter.
9. ** Для того, чтобы экспортер запускался и на контрол-плейн нодах добавлена настройка:
      tolerations:
      - operator: Exists
      Которая позволяет игнорировать любые ограничения, в том числе NoSchedule на мастер-нодах.

Homework #3
1. Создан kubernetes кластер в kind.

2. Написаны манифесты для serviceaccount'ов bob и dave (sa-bob.yaml, sa-dave.yaml)
3. Написан манифест clusterrolebinding.yaml для выдачи роли admin аккаунту bob.

4. Написаны манифесты для namespace prometheus и serviceaccount carol (namespace.yaml, sa-carol.yaml)
5. Всем serviceaccount'ам в namespace prometheus дана возможность делать get, list, watch в отношении Pods всего кластера (clusterrole.yaml, clusterrolebinding.yaml)

5. Написаны манифесты для namespace dev и serviceaccount'ов jane и ken (namespace.yaml, sa-jane.yaml, sa-ken.yaml)
6. jane дана роль admin в рамках namespace dev (rolebinding-jane.yaml)
7. ken дана роль view в рамках namespace dev (rolebinding-ken.yaml)

Homework #4
1. Исследованы различные сетевые варианты доступа к подам.
2. Установлен и установлен MetalLB.
3. *** Создан LoadBalancer для доступа к CoreDNS (tcp-dns.yaml, udp-dns.yaml)
4. Установлен ingress-controller, настроен доступ к headless веб-серверу через с помощью Ingress.
5. *** Установлен kubernetes-dashboard из официального репозитория, настроен ingress для доступа к нему с помощью prefix /dashboard (./dashboard/dashboard-ingress.yaml). Также в процессе отладки сделал пользователя для доступа к dashboard.
6. ***
- Реализован канареечный деплой с помощью ingress. Было написано 2 одинаковых Deployment с одинаковым приложением echo, разница только в целевых неймспейсах.
- Написан ingress для "production" версии приложения (echo-prod-ingress.yaml)
- Написан ingress для "canary" версии приложения (echo-canary-ingress.yaml)
- В канареечной версии указаны следующие annotions:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-by-header: "env"
    nginx.ingress.kubernetes.io/canary-by-header-pattern: "canary"
- Таким образом если сделать запрос к ingress curl -k https://192.168.64.6/ - попадаем на production среду
- Если сделать запрос curl -k -H 'env:canary' https://192.168.64.6/ - попадаем в канареечную версию приложения (это видно по логам):
172.17.0.7 - - [22/Jan/2022:15:45:23 +0000] "GET / HTTP/1.1" 200 740 "-" "curl/7.77.0"

Homework #5
1. Запущен statefulset c MinIO
2. Запущен headless сервис для MinIO
3. *** Исправлена конфигурация StatefulSet для использования секрета (minio-secrets.yaml)

Homework #6
1. Развернут кластер kubernetes в GCP.
2. Установлен nginx-ingress с помощью helm.
3. Установлен cert-manager, настроено получение стейджинг и продакшн сертификатов.
4. Установлен chartmuseum.
5. *** Для сохранения своих чартов в chartmuseum был установлен плагин helm push и создан пустой sample-chart.
   *** helm push sample-chart/ chartmuseum && helm repo update && helm search repo -l chartmuseum/
6. Установлен harbor из репозитория https://github.com/goharbor/harbor-helm
7. *** Описана установка nginx-ingress, cert-manager и harbor в helmfile
8. Создан свой helm chart для hipster-shop
9. addservice не поднимался, так как указанной версии уже нет в репозитории, обновил версию в чарте.
10. Минимально шаблонизирован chart frontend с помощью values.yaml
11. Chart frontend вынесен в зависимости для основного чарта.
12. *** Redis также вынесен в зависимости через Chart.yaml.
13. Изучена работа helm-secrets (в последствии файлы secret.yaml и secrets.yaml удалены за ненадобностью в текущем проекте)
14. Все получившиеся чарты были запушены в harbor.
15. Установлен порождение сатаны kubecfg. Методичка в этом пункте устарела напрочь, удалите это задание, никто не должен пользоваться этим ужасом.
16. Paymentservice и shippingservice установлены с помощью kubecfg.
17. *** В качестве другого решения на основе jsonnet была выбрана tanka по совету Димы Зайцева.
    *** Было принято решение установить grafana+prometheus с помощью tanka
    *** Пользовался мануалом https://tanka.dev/tutorial/jsonnet
18. Напоследок был установлен Kustomize и описан сервис recommendation.

