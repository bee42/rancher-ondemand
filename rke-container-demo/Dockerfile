FROM alpine:3.8
# Maintainer
LABEL maintainer="maintainers@bee42.com"

# Environment variables
ENV TERRAFORM_VERSION="0.11.10"

# System preparation & terraform installation
RUN apk --no-cache add wget ca-certificates unzip git bash openssh-client && \
    wget -q -O /terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /terraform.zip -d /usr/local/bin && \
    apk del --purge wget unzip && \
    rm -rf /var/cache/apk/* /terraform.zip

ENV TERRAFORM_USER=terraform \
    TERRAFORM_UID=1000 \
    TERRAFORM_GID=1000 \
    TERRAFORM_HOME=/tf

RUN addgroup -S $TERRAFORM_USER -g ${TERRAFORM_GID} \
    && adduser -S  \
    -g $TERRAFORM_USER \
    -h $TERRAFORM_HOME \
    -u ${TERRAFORM_UID} \
    $TERRAFORM_USER

USER $TERRAFORM_USER

WORKDIR $TERRAFORM_HOME

COPY --chown=1000:1000 . /${TERRAFORM_HOME}

RUN terraform init
SHELL ["/bin/bash"]
VOLUME [ "${TERRAFORM_HOME}" ]
ENTRYPOINT [ "/tf/entrypoint.sh" ]
