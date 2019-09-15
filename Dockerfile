FROM baseimage

ENV SERVICE_NAME shared_services
ENV BASE_PATH $SVC_PATH/$shared_services
WORKDIR $BASE_PATH
RUN mkdir $BASE_PATH/logs

# ============= Dependencies ============= #
RUN apt-get update --fix-missing
RUN apt-get install --assume-yes default-mysql-server

ADD . $BASE_PATH
ENTRYPOINT $LIB_PATH/baseimage/entrypoint.sh
