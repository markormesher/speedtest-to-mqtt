FROM node:21.4.0-bookworm@sha256:db2672e3c200b85e0b813cdb294fac16764711d7a66b41315e6261f2231f2331 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.4.0-bookworm@sha256:db2672e3c200b85e0b813cdb294fac16764711d7a66b41315e6261f2231f2331

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
