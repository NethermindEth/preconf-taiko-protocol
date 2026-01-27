FROM node:24-slim
WORKDIR /app

# Install system dependencies and clean up in one layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    jq \
    curl \
    ca-certificates \
    git && \
    rm -rf /var/lib/apt/lists/*

RUN git init && \
    curl -L https://foundry.paradigm.xyz | bash && \
    npm install -g pnpm && \
    . ~/.bashrc && \
    foundryup && \
    forge install && \
    rm -rf /root/.foundry/cache/* && \
    rm -rf /tmp/*

ENV PATH="/root/.foundry/bin:$PATH"

COPY ./taiko-mono/packages/protocol/package.json ./

# Copy the rest of the source code (including pnpm-lock.yaml from parent)
COPY ./taiko-mono/packages/protocol ./
COPY ./const.sh ./
COPY ./setup.sh ./
COPY ./checksum.sh ./

RUN ./checksum.sh

# We need this to fix a bug in the taiko-alethia-protocol-v2.3.1 branch
RUN sed -i '/"eigenlayer-contracts": "github:Layr-labs\/eigenlayer-contracts#dev",/d' package.json

# Install dependencies
RUN pnpm install

CMD ["sh", "-c", "echo Please verify the environment variables and command."]