#
# Schema-Repo running on top of Linux Alpine
#

FROM openjdk:8u131-jdk-alpine
MAINTAINER Carlos Montemuiño

LABEL Description="This image runs Schema-Repo, with an in-memory backend as default."

# Install minimum set of needed packages
# Note 1: bash is installed in order to make it easier to run the schema-repo bash script file
# Note 2: curl added to facilitate healtchecks
RUN set -x && apk --update add --no-cache bash curl tar git

####################
# Security hardening
####################
# Avoid using root
RUN adduser -D -u 1000 -h /home/schemarepo schemarepo
USER schemarepo

# Unsets all SUID flags
RUN for i in `find / -perm +6000 -type f`; do chmod a-s $i; done

# Install Maven
ARG MAVEN_VERSION=3.5.2
ARG MAVEN_ARCHIVE=http://apache.cs.utah.edu/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz

RUN curl -L $MAVEN_ARCHIVE -o /tmp/maven.tar.gz \
    && tar -xf /tmp/maven.tar.gz -C $HOME

ENV MAVEN_HOME /home/schemarepo/apache-maven-$MAVEN_VERSION
ENV OLD_PATH $PATH
ENV PATH $PATH:$MAVEN_HOME/bin

# Build Schema-Repo
ARG SCHEMA_REPO_GIT=https://github.com/schema-repo/schema-repo.git
RUN git clone $SCHEMA_REPO_GIT $HOME/schema-repo \
    && cd $HOME/schema-repo \
    && mvn install \
    && chmod +x $HOME/schema-repo/run.sh

# Clean-up
RUN unset MAVEN_HOME \
    && rm /tmp/maven.tar.gz \
    && rm -rf $HOME/apache-maven-$MAVEN_VERSION \
    && rm -rf $HOME/.m2

ENV PATH $OLD_PATH

RUN unset OLD_PATH

# Run the schema-repo
ENV SCHEMA_REPO_BACKEND=in-memory
EXPOSE 2876

HEALTHCHECK --interval=60s --timeout=10s --retries=3 CMD curl -f http://localhost:2876/schema-repo/ || exit 1

ENTRYPOINT $HOME/schema-repo/run.sh $SCHEMA_REPO_BACKEND