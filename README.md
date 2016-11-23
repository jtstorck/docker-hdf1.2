# Create the VM that will run the HDF 1.2 image
docker-machine create --driver virtualbox --virtualbox-cpu-count "1" --virtualbox-memory "2048" hdf1-2

eval $(docker-machine env hdf1-2)

# Perform some setup
cd to dir with Dockerfile

./setup.sh ~/zk-migration-test

# Build the docker image
#### add `--build-arg user=<username>` to change default user "nifi"
docker build -t hdf1-2 .

# Run the docker image in a container **hdf1-2**
#### replace `nifi` with username in `--build-arg` if it was supplied in when `docker build` was invoked
docker run -ti -p 8080:8080 -p 2181:2181 -v ~/zk-migration-test:/home/nifi/zk-migration-test -v /dev/urandom:/dev/random --name hdf1-2 hdf1-2
