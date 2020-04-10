# Postgres exporter

```
$ sudo wget https://github.com/wrouesnel/postgres_exporter/releases/download/v0.7.0/postgres_exporter_v0.7.0_linux-amd64.tar.gz
```

```

postgres=#
postgres=# SELECT * FROM pg_available_extensions WHERE name = 'pg_stat_statements';
        name        | default_version | installed_version |                          comment
--------------------+-----------------+-------------------+-----------------------------------------------------------
 pg_stat_statements | 1.6             |                   | track execution statistics of all SQL statements executed
(1 row)

postgres=# CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION
postgres=# SELECT * FROM pg_available_extensions WHERE name = 'pg_stat_statements';
        name        | default_version | installed_version |                          comment
--------------------+-----------------+-------------------+-----------------------------------------------------------
 pg_stat_statements | 1.6             | 1.6               | track execution statistics of all SQL statements executed
(1 row)

```