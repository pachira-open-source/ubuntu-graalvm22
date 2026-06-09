FROM ubuntu:24.04

ARG GRAALVM_VERSION=22.3.3
ARG GRAALVM_INSTALLER=graalvm-ce-java17-linux-amd64-${GRAALVM_VERSION}.tar.gz
ARG GRAALVM_DOWNLOAD_URL=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/${GRAALVM_INSTALLER}
ARG GRAALJS_INSTALLER=js-installable-svm-java17-linux-amd64-${GRAALVM_VERSION}.jar
ARG GRAALJS_DOWNLOAD_URL=https://github.com/oracle/graaljs/releases/download/vm-${GRAALVM_VERSION}/${GRAALJS_INSTALLER}

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends curl iputils-ping ca-certificates vim-tiny tar unzip libc6 libstdc++6 libgcc-s1 libjemalloc2 && \
    apt-get install -y --no-install-recommends tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV GRAALVM_HOME=/usr/lib/graalvm-ce-java17-${GRAALVM_VERSION}

RUN mkdir -p $GRAALVM_HOME \
    && curl -fsSL -o /tmp/${GRAALVM_INSTALLER} ${GRAALVM_DOWNLOAD_URL} \
    && curl -fsSL -o /tmp/${GRAALJS_INSTALLER} ${GRAALJS_DOWNLOAD_URL} \
    && tar -xzf /tmp/${GRAALVM_INSTALLER} -C $GRAALVM_HOME --strip-components=1 \
    && chmod +x $GRAALVM_HOME/bin/* \
    && $GRAALVM_HOME/bin/gu install --local-file /tmp/${GRAALJS_INSTALLER} \
    && rm -rf /tmp/${GRAALVM_INSTALLER} /tmp/${GRAALJS_INSTALLER} \
    && rm -rf /tmp/* /var/tmp/*

ENV PATH=$GRAALVM_HOME/bin:$PATH
ENV JAVA_HOME=$GRAALVM_HOME

CMD ["/bin/bash"]
