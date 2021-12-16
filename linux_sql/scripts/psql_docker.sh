#! /bin/bash

# Assign arguments
cmd=$1
db_username=$2
db_password=$3

#Start docker
sudo systemctl status docker || systemctl start docker

#check container status
docker container inspect jrvs-psql
container_status=$?

#User switch case to handle create|stop|start operations
case $cmd in 
  create)
  
  #Validate if container is already created
  if [ $container_status -eq 0 ]; then
  	echo 'Container already exists'
	exit 1
  fi
  
  #Validate # of arguments
  if [ $# -ne 3 ]; then
    echo 'Create requires username and password'
    exit 1
  fi
  
 
  #create a new volume if not exist
  docker volume create pgdata
  
  #create a container using psql image with name=jrvs-psql
  docker run --name jrvs-psql -e POSTGRES_PASSWORD=$PGPASSWORD -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
	
  exit $?
  ;;

  #start/stop a container
  docker container stop jrvs-psql
  docker container start jrvs-psql
  
   # Check if the container is already created
  if [ $container_status -eq 0 ]; then
	echo 'Container already exists'
	exit 1	
  fi

  #Start or stop the container
  docker container $cmd jrvs-psql
  exit $?
  ;;	
  
  *)
  echo 'Illegal command'
  echo 'Commands: start|stop|create'
  exit 1
  ;;
esac 


