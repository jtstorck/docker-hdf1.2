# Create the VM that will run the HDF 1.2 image
docker-machine create --driver virtualbox --virtualbox-cpu-count "2" --virtualbox-memory "8192" hdf1-2

eval $(docker-machine env hdf1-2)

# Perform some setup
cd to dir with Dockerfile

mkdir ~/testfiles

sudo mkdir -p /zk-migration-test/testfiles

sudo chown -R <user>:<group> /zk-migration-test

./setup.sh ~/testfiles

ln -s ~/testfiles /zk-migration-test/testfiles

# Build the docker image
docker build -t hdf1-2 .

# Run the docker image in a container *hdf1-2*
docker run -ti --rm -p 8080:8080 -p 2181:2181 -v ~/zk-migration-test/testfiles:/zk-migration-test/testfiles -v /dev/urandom:/dev/random --name hdf1-2 hdf1-2
