#!/bin/bash
#replace database details and directories before running

# Database details
USER="xxxx"
PASSWORD="xxxx"
DATABASES=("xxxx" "xxxx") 
HOST="localhost"

# Directory for the queries
DIR="x"

# CSV file for execution times
CSV="execution_times.csv"


echo "SQL File,tpc Execution Time (ms),tpc_np Execution Time (ms)" > $CSV


TOTAL_FILES=$(ls -l $DIR/*.sql | wc -l)


COUNTER=0

# Looping over each SQL file
for SQL_FILE in $DIR/*.sql
do
    
    ((COUNTER++))

    SQL_FILE_NAME=$(basename $SQL_FILE)

    
    EXECUTION_TIMES="$SQL_FILE_NAME"
    
    # Looping over each database
    for DATABASE in ${DATABASES[@]}
    do
        
        START_TIME=$(date +%s%3N)

        # Run the SQL file and store the output to a separate output file
        PGPASSWORD=$PASSWORD psql -U $USER -d $DATABASE -h $HOST -f $SQL_FILE > "${SQL_FILE}_${DATABASE}_output.txt"

        
        END_TIME=$(date +%s%3N)

        
        EXECUTION_TIME=$((END_TIME - START_TIME))

        
        EXECUTION_TIMES="$EXECUTION_TIMES,$EXECUTION_TIME"
    done

    # Adding the execution times to the CSV file
    echo "$EXECUTION_TIMES" >> $CSV

    PERCENT=$((200*$COUNTER/$TOTAL_FILES % 2 + 100*$COUNTER/$TOTAL_FILES))

    
    printf 'Progress: %s%% [%s>%s]\r' $PERCENT $(printf '#%.0s' $(seq 1 $((PERCENT/2)))) $(printf ' %.0s' $(seq $((PERCENT/2 + 1)) 50))
done

echo ""

python3 plot_csv.py
