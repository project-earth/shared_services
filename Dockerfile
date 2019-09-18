FROM baseimage

ENV SERVICE_NAME shared_services
ENV BASE_PATH $SVC_PATH/$shared_services
WORKDIR $BASE_PATH


# ============= Dependencies ============= #
RUN apt-get update --fix-missing
RUN apt-get install --assume-yes default-mysql-server curl apt-transport-https gnupg procps gettext

# Filebeat
RUN mkdir $LIB_PATH/filebeat
RUN curl -L https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.3.2-amd64.deb > $LIB_PATH/filebeat/filebeat-7.3.2-amd64.deb
RUN dpkg -i $LIB_PATH/filebeat/filebeat-7.3.2-amd64.deb

# ElasticSearch, Kibana
RUN mkdir $LIB_PATH/elastic
RUN curl -L https://artifacts.elastic.co/GPG-KEY-elasticsearch > $LIB_PATH/elastic/GPG-KEY-elasticsearch
RUN apt-key add $LIB_PATH/elastic/GPG-KEY-elasticsearch
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update
RUN apt-get install --assume-yes elasticsearch kibana


# ============= Source & Entrypoint ============= #
ADD . $BASE_PATH
ENTRYPOINT $LIB_PATH/baseimage/entrypoint.sh
