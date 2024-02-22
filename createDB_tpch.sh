#!/bin/bash
#this script creates 2 tpch databases and adds provenance to the first one
#change database details before running

# Database details
USER="xxxx"
PASSWORD="xxxx"
DATABASES=("xxx1" "xxx2")
HOST="localhost"


for DATABASE in ${DATABASES[@]}
    do
        
     echo "Creating database $DATABASE "  
     
     PGPASSWORD=$PASSWORD createdb $DATABASE -U $USER -h $HOST
     PGPASSWORD=$PASSWORD psql -U $USER -d $DATABASE -h $HOST -f dss.ddl
     ./dbgen -vf -s 1

     for i in `ls *.tbl`; 
      do
       table=${i/.tbl/}
       echo "Loading $table..."
       sed 's/|$//' $i > /tmp/$i
       PGPASSWORD=$PASSWORD psql -U $USER -d $DATABASE -h $HOST -q -c "TRUNCATE $table"
       PGPASSWORD=$PASSWORD psql -U $USER -d $DATABASE -h $HOST -c "\\copy $table FROM '/tmp/$i' CSV DELIMITER '|'"
      done

    done


echo "adding provenance to ${DATABASES[0]}"

PGPASSWORD=$PASSWORD psql -U $USER -d ${DATABASES[0]} -h $HOST <add_provenance.sql

