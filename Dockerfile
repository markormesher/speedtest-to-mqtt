FROM node:21.6.1-bookworm@sha256:3af9f785cb8fc1a9c60a77c7b31b1ba7f5c74a066d142c996fbce61d2420dd8c AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.6.1-bookworm@sha256:3af9f785cb8fc1a9c60a77c7b31b1ba7f5c74a066d142c996fbce61d2420dd8c

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
