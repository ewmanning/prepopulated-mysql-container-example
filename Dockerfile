FROM mysql:5.7 as builder

LABEL stage=intermediate

# That file does the DB initialization but also runs mysql daemon, by removing the last line it will only init
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]

# needed for intialization
ENV MYSQL_ROOT_PASSWORD=root

# ENV MYSQL_DATABASE myexample

ARG sqlfile
COPY $sqlfile /docker-entrypoint-initdb.d/

# Need to change the datadir to something else that /var/lib/mysql because the parent docker file defines it as a volume.
# https://docs.docker.com/engine/reference/builder/#volume :
#       Changing the volume from within the Dockerfile: If any build steps change the data within the volume after
#       it has been declared, those changes will be discarded.
RUN ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--datadir", "/initialized-db"]

#############################################################################

FROM mysql:5.7

RUN mkdir -p /var/lib/mysqldata

# Need to change the datadir to something other than /var/lib/mysql because the parent docker file defines it as a volume.
RUN sed -i 's|/var/lib/mysql|/var/lib/mysqldata|g' /etc/mysql/mysql.conf.d/mysqld.cnf

COPY --from=builder /initialized-db /var/lib/mysqldata
