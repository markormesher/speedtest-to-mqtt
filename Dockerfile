FROM node:21.6.0-bookworm@sha256:0ded28778059262bd3c066b609186e5b6c89550a9362dce4309ad67c95af0d77 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.6.0-bookworm@sha256:0ded28778059262bd3c066b609186e5b6c89550a9362dce4309ad67c95af0d77

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
