#!/bin/bash
for NAME in `dps | grep postgis | awk '{print $13}'`; 
do 
  # ensure we have the same version of pg_dump as on the server
  # we dont know if we have 9.3 or 9.4 etc so try to copy both -one will win
  docker cp $NAME:/usr/lib/postgresql/9.3/bin/pg_dump .
  docker cp $NAME:/usr/lib/postgresql/9.4/bin/pg_dump .
  HOST=`dipall | grep $NAME | awk '{ print $3 }'`; 
  echo "$NAME $HOST"; 
  PGPASSWORD=docker ./pg_dump -Fc -f PG_${NAME}_`date +%d-%B-%Y`.dmp -U docker -h $HOST gis; 
done
