#To run - export any variables then execute below:
#curl -sSL https://gist.github.com/abajwa-hw/7794ea013c96f3f41c4a8b10aeeccd4d/raw | sudo -E sh

yum install -y git python-argparse
git clone https://github.com/seanorama/ambari-bootstrap.git

export ambari_version=2.5.0.3
export host_count=${host_count:-ask}   #choose number of nodes
export ambari_services=${ambari_services:-HDFS HIVE PIG SPARK MAPREDUCE2 TEZ YARN ZOOKEEPER AMBARI_METRICS ATLAS}
export hdp_ver=${hdp_ver:-2.6}

#remove unneeded repos for some AMIs
if [ -f /etc/yum.repos.d/zfs.repo ]; then
  rm -f /etc/yum.repos.d/zfs.repo
fi

if [ -f /etc/yum.repos.d/lustre.repo ]; then
  rm -f /etc/yum.repos.d/lustre.repo
fi

export install_ambari_server=true
curl -sSL https://raw.githubusercontent.com/seanorama/ambari-bootstrap/master/ambari-bootstrap.sh | sudo -E sh

sleep 30

export ambari_stack_version=${hdp_ver}
if [ "${hdp_ver}" != "2.4" ]; then
  export recommendation_strategy="ALWAYS_APPLY_DONT_OVERRIDE_CUSTOM_VALUES"
fi

bash ./ambari-bootstrap/deploy/deploy-recommended-cluster.bash
