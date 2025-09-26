FROM node:24
WORKDIR /app

# Copy package.json first for better caching
COPY ./taiko-mono/packages/protocol/package.json ./

RUN apt-get update && apt-get install -y jq

RUN git init && \
    curl -L https://foundry.paradigm.xyz | bash && \
    npm install -g pnpm && \
    . ~/.bashrc && \
    foundryup && \
    forge install

ENV PATH="/root/.foundry/bin:$PATH"

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