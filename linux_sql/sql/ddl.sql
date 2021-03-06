
CREATE TABLE PUBLIC.host_info 
  ( 
     id               SERIAL NOT NULL PRIMARY KEY, 
     hostname         VARCHAR NOT NULL UNIQUE, 
     cpu_number       INT NOT NULL,
     cpu_architecture VARCHAR NOT NULL,
     cpu_model        INT NOT NULL,
     cpu_mhz          FLOAT NOT NULL,
     L2_cache         INT NOT NULL,
     total_mem        INT NOT NULL,
     "timestamp"      TIMESTAMP NOT NULL
  );


CREATE TABLE PUBLIC.host_usage
  (
     "timestamp"      TIMESTAMP NOT NULL,
     host_id	        SERIAL NOT NULL,
     memory_free      INTEGER NOT NULL,
     cpu_idle         INTEGER NOT NULL,
     cpu_kernel       INTEGER NOT NULL,
     disk_io          INTEGER NOT NULL,
     disk_available   INTEGER NOT NULL,
     FOREIGN KEY (id) REFERENCES host_info (id)
);

