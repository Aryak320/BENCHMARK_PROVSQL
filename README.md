# BENCHMARK_PROVSQL
This is a very simple benchmark of PROVSQL, where selected tpch queries are run on two identical databases generated from tpch except for the fact that one has provsql support and the other doesn't. Bar graphs are plotted over the execution times of these selected queries on both the databases. This way you can see the time PROVSQL-armed databases take to execute queries and compare it with the execution times of the same queries on the database with provenance removed.


1.Download tpch-dbgen source code from https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp

2.Extract the zip file.

3.Inside the source code folder edit ```makefile.suite``` keeping in mind your machine and compilers you are using. For example if you are using linux it should look like this:
```
   CC=gcc
   DATABASE=ORACLE
   MACHINE=LINUX
   WORKLOAD=TPCH
```
**NOTE: Keep database=ORACLE as there is no support for postgresql by default in tpch-dbgen. The compatibility issues are dealt with in the scripts**

4.Install dbgen by runing make:
```
make -f makefile.suite
```
5. Clone this repo 
6. Copy the ```dbgen``` executable file, ```dists.dss``` file and ```dss.ddl``` file inside the repo folder.

7.Edit the database details in ```createDB_tpch.sh``` and then run it.This will create two databases using dbgen one without provsql and the other with provsql support.

8. The 22 template queries given by TPCH will not run on POSTGRESQL databases by default due to syntax differences. Also, PROVSQL does not support sub-queries inside where clause and inner aggregations. For these reasons the original template queries had to be modified. Queries 2, 4, 16, 18, 20, 21, 22, and 8 have been left out for this benchmark.
The modified tpch queries are in GOOD_QUERIES directory. Edit the database details and directory informations in ```bnchmrk_vanilla.sh``` and then run it.
 
Voila!

**NOTE: It is assumed that you already have postgres and PROVSQL installed and running. For installing PROVSQL you can head in to the repo https://github.com/PierreSenellart/provsql**
