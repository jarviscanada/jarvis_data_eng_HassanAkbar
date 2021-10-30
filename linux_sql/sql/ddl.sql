
CREATE TABLE PUBLIC.host_info 
  ( 
     id               SERIAL NOT NULL PRIMARY KEY, 
     hostname         VARCHAR NOT NULL, 
     cpu_architecture VARCHAR NOT NULL,
     cpu_model        VARCHAR NOT NULL,
     cpu_mhz          INTEGER NOT NULL,
     L2_cache         INTEGER NOT NULL,
     total_mem        INTEGER NOT NULL,
     "timestamp"      TIMESTAMP NOT NULL
  );

INSERT INTO host_info (id, hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, timestamp);	


	

CREATE TABLE PUBLIC.host_usage
  (
     "timestamp"      TIMESTAMP NOT NULL,
     host_id	      INTEGER NOT NULL FOREIGN KEY,
     memory_free      INTEGER NOT NULL,
     cpu_idle         INTEGER NOT NULL,
     cpu_kernel       INTEGER NOT NULL,
     disk_io          INTEGER NOT NULL,
     disk_available   INTEGER NOT NULL
  );

INSERT INTO host_usage (timestamp,host_id,memory_free,cpu_idle,cpu_kernel,disk_io,disk_available);


