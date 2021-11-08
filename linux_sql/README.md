# Linux Cluster Monitoring Agent


# Introduction
The project is to design a host monitoring agent that is used to monitor a Linux cluster of 10 nodes/servers running CentOS 7. The host monitor agent program will collect the hardware specifications and resource usages of each node by running bash scripts. The collected data will be stored in a Docker provisioned PostgreSQL database.

# Quick Start
- Start the psql docker container using psql_docker.sh
  - `bash linux_sql/scripts/psql_docker.sh start`

- Execute ddl.sql script on the host_agent database against the psql instance
  - `psql -h psql_host -U psql_user -d db_name -f sql/ddl.sql`

- Script to Insert hardware specs data into the DB using host_info.shcl
  - `bash scripts/host_info.sh psql_host psql_port db_name psql_user psql_password`

- Script to Insert hardware usage data into the DB using host_usage.sh
  - `bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password`

- Setup Corntab to run host_usage.sh scripts after every one min
  - `crontab -e`
  - `* * * * * bash /home/[local_path]/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log`

# Implemenation
To implement the project, the monitoring agent program is designed by using Linux command lines, Bash scripts, PostgreSQL, Docker, and IntelliJ IDE. Hardware specs and server usage data of each node are stored in PostgreSQL database. Collected data get tested against  SQL queries to answer some business questions such as calculating the average memory usage in percentage over 1 mins interval for each node. The program code source is managed by Github.

## Architecture
![image](https://github.com/jarviscanada/jarvis_data_eng_HassanAkbar/blob/feature/psql_docker/linux_sql/Assets/image.png)
- Node 1 is the host agent and has a PostgreSQL database setup. It stores hardware specs and usage data of Node 2 and Node 3 by running bash scripts on each node. All three nodes are connected through the switch.

## Scripts
Shell script description and usage 

- `psql_docker.sh` - The script is used to start PostgreSQL instance using docker 
- `host_info.sh` - The Script is used to run on every node to collect hardware configuration information and insert all collected data to psql database table.
- `host_usage.sh` - The script is used to run on every node to collect hardware usage data and insert all collected data to the psql database table every minute.
- `crontab`- Linux utility that allows tasks to be automatically run in the background at regular intervals by the cron daemon
- `queries.sql`- is used to run the SQL queries on host_agent tables to measure or calculate average memory use and grouping nodes against the number of CPU and total memory

## Database Modeling
Database host_agent is consists of two tables called host_info and host_usage. host_info does not change as it is the hardware specs that are constant. host_usage data changes as the usage of node keep on changing after some interval.

host_info table contains the following data:

- `id` - It is a unique value and is a primary key, which auto increment for each node.
- `hostname` - It is the unique value of each node and represents hostname.
- `cpu_number` - It is an integer value and represents the number of cores of each node's CPU.
- `cpu_architecture` - It is a char value and represents the CPU architecture.
- `cpu_model` - It is an integer value and tells CPU model number.
- `cpu_mhz` -  It is a floating value and tells the CPU speed. 
- `L2_cache` - It is an integer value and tells CPU L2 cache size in kb
- `total_mem` - It is an integer value and gives the total space size of hardware of node
- `"timestamp"`-  It is the current date and time in UTC.

host_usage table contains the following data:

- `"timestamp"` - It is the current date and time in UTC.
- `host_id`	 - It is the node's id and represents a foreign key.
- `memory_free` - It is the memory space that is available in MB.
- `cpu_idle` - It is the time CPU doing nothing. 
- `cpu_kernel` - It is CPU time running kernel
- `disk_io`  - Disk input/output operations in KB/s
- `disk_available`  - Disk space available in MB

# Test
Testing is done by running bash scripts on a single machine instead of a Linux cluster. For bash scripts, testing of all functionalities is performed manually.

For SQL queries, results are verified against test data created by the developer.

# Deployment
Used the GitHub database to host the source code of the monitoring agent and used Docker to provision the PostgreSQL database. The monitoring agent program is scheduled using Crontab. 

# Improvements
1. Hardware specs table data should be updated after a certain time automatically in case you do not miss any hardware modification done on any node.
2. Create an alert, that should notify the user about different node resource usage if usage goes high or low to a certain percentage.
