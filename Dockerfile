FROM registry:5000/frolvlad/alpine-oraclejdk8:cleaned

WORKDIR /build
ADD . .

RUN apk --update add  openssl ca-certificates wget && \
    wget http://apache.mirrors.pair.com//ant/binaries/apache-ant-1.9.7-bin.tar.gz && \
    mkdir -p /opt/agent && \
    tar xvfvz apache-ant-1.9.7-bin.tar.gz -C /opt && \
    ln -s /opt/apache-ant-1.9.7 /opt/ant && \
    sh -c 'echo ANT_HOME=/opt/ant >> /etc/environment' && \
    ln -s /opt/ant/bin/ant /usr/bin/ant && \
    /build/setup --build && \
    cp /build/ant_build/lib/AWSKinesisStreamingDataAgent-1.1.jar /build/dependencies/ && \
    mv /build/dependencies /opt/agent/ && \
    mv /build/run.sh /opt/agent/run.sh && \
    mkdir /etc/aws-kinesis && \
    cp /build/configuration/example/agent.json /etc/aws-kinesis/agent.json && \
    rm -rf /build && \
    rm -rf /opt/apache-ant-1.9.7

CMD /opt/agent/run.sh -l /dev/stdout
