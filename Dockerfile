FROM node:21.7.2-bookworm@sha256:64f5c0619b62db2dfdd13dfa1b8c3361dcc95ec4bcbbb82b63146e9efa5f1e7e AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.2-bookworm@sha256:64f5c0619b62db2dfdd13dfa1b8c3361dcc95ec4bcbbb82b63146e9efa5f1e7e

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
