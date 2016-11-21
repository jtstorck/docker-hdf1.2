from java:7-jre

run apt-get update
run apt-get -y install sudo

arg nifi=http://public-repo-1.hortonworks.com/HDF/centos6/1.x/updates/1.2.0.0/HDF-1.2.0.0-91.tar.gz
arg testdir=/zk-migration-test
arg user=nifi

# set up the user that will run nifi
run useradd --shell /bin/bash -m nifi

run curl -O $nifi
run tar -xzf /HDF-1.2.0.0-91.tar.gz -C /
run cp -r /HDF-1.2.0.0/nifi /HDF-1.2.0.0/ncm

add start.sh /root/
run chmod +x /root/start.sh
add setup.sh /root/
run chmod +x /root/setup.sh

# add flow to NCM and nifi node
add flow.xml /root/
run tar -C /root -cvf /HDF-1.2.0.0/ncm/conf/flow.tar flow.xml

workdir /HDF-1.2.0.0
# configure NCM properties
run sed -i "s/run\.as=/run.as=$user/g" ncm/conf/bootstrap.conf
run sed -i "s/nifi\.cluster\.is\.manager=false/nifi.cluster.is.manager=true/g" ncm/conf/nifi.properties
run sed -i "s/nifi\.cluster\.manager\.protocol\.port=/nifi.cluster.manager.protocol.port=5555/g" ncm/conf/nifi.properties

# configure node properties
run sed -i "s/run\.as=/run.as=$user/g" nifi/conf/bootstrap.conf
run sed -i "s/nifi\.web\.http\.port=8080/nifi.web.http.port=9090/g" nifi/conf/nifi.properties
run sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" nifi/conf/nifi.properties
run sed -i "s/nifi\.cluster\.node\.protocol\.port=/nifi.cluster.node.protocol.port=5556/g" nifi/conf/nifi.properties
run sed -i "s/nifi\.cluster\.node\.unicast\.manager\.protocol\.port=/nifi.cluster.node.unicast.manager.protocol.port=5555/g" nifi/conf/nifi.properties
run sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=false/nifi.state.management.embedded.zookeeper.start=true/g" nifi/conf/nifi.properties

# configure zookeeper on node
run mkdir nifi/state
run mkdir nifi/state/zookeeper
run echo 1 > nifi/state/zookeeper/myid
run sed -i "s/name=\"Connect String\"><\/property>/name=\"Connect String\">localhost:2181<\/property>/g" nifi/conf/state-management.xml
run sed -i "s/server.1=/server.1=localhost:2888:3888/g" nifi/conf/zookeeper.properties

# change ownership of files uder /HDF-1.2.0.0 for the configured user
run chown -R $user:$user /HDF-1.2.0.0

# expose NCM UI port
expose 8080
# expose ZooKeeper server port
expose 2181

entrypoint  ["/root/start.sh"]
