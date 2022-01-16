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
