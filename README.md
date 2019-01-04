A prepopulated mysql container ?
================================

A mysql/5.7 variant of [lindycoder's Dockerfile for mariadb](https://github.com/lindycoder/prepopulated-mysql-container-example)

Building
========

```
docker build --build-arg sqlfile=setup.sql --tag my-prepopulated-image .
```

Remove Intermediate Images
==========================

```
docker rmi -f $(docker images -q --filter label=stage=intermediate)
```

Running
=======

```
docker run -it --rm -p 3306:3306 --name my-container my-prepopulated-image
```

Connecting
==========

```
mysql -h127.0.0.1 -P 3306 -u root -p
```
