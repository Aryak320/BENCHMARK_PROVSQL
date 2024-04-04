#!/bin/bash

# Number of iterations
N=${1:-6}

# Database details
USER="sena"
PASSWORD="1234"
DATABASES=("tpc" "tpc_np") # tpc is provenance aware and tpc_np is without provenance
HOST="localhost"

# Directory and file paths
DIRECTORY="/home/slide/sena/BENCHMARK/DSGen-software-code-3.2.0rc1/query_templates/"
INPUT="/home/slide/sena/BENCHMARK/DSGen-software-code-3.2.0rc1/query_templates/templates.lst"
OUTPUT_DIR="/home/slide/sena/BENCHMARK/DSGen-software-code-3.2.0rc1/query_templates/"

# Dialect
DIALECT="ansi"

CSV="execution_times_qset_10gigs.csv"


echo "Query sets,tpc Execution Time (s),tpc_np Execution Time (s)" > $CSV

# Reload the database and measure the time taken
echo "reloading postgresql"
START=$(date +%s%N)
systemctl restart postgresql
END=$(date +%s%N)

# Loop to generate SQL files
for i in $(seq 1 $N)
do
  
  

  # Use the reload time as the RNGSEED value
  RNGSEED=$((END - START))

  # Run the dsqgen command
  /home/slide/sena/BENCHMARK/DSGen-software-code-3.2.0rc1/tools/dsqgen -DIRECTORY $DIRECTORY -INPUT $INPUT -OUTPUT_DIR $OUTPUT_DIR -DIALECT $DIALECT -RNGSEED $RNGSEED

  # Rename the output file
  mv $OUTPUT_DIR/query_0.sql $OUTPUT_DIR/qset_$i.sql

  # Add the RNGSEED value as a comment line in the SQL file
  echo "-- RNGSEED: $RNGSEED" | cat - $OUTPUT_DIR/qset_$i.sql > temp && mv temp $OUTPUT_DIR/qset_$i.sql

  # Initialize an array to store the execution times
  declare -A TIMES

  # Execute the SQL file on each database and measure the time taken
  for DB in "${DATABASES[@]}"
  do
    echo "Running qset_$i.sql on $DB database..."
    START=$(date +%s.%N)
    PGPASSWORD=$PASSWORD psql -U $USER -h $HOST -d $DB -f $OUTPUT_DIR/qset_$i.sql -o $DIRECTORY"qset_${i}_${DB}_output.txt"
    END=$(date +%s.%N)
    DIFF=$(echo "$END - $START" | bc)

    # Store the time taken in the array
    TIMES[$DB]=$DIFF
    
    echo "reloading postgresql"
    START=$(date +%s%N)
    systemctl restart postgresql
    END=$(date +%s%N)
    
  done

  # Append the times to the CSV file
  echo "qset_$i.sql,${TIMES['tpc']},${TIMES['tpc_np']}" >> execution_times_qset_10gigs.csv
done

python3 plot_csv_wo_log.py