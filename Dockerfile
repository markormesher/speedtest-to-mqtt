FROM node:21.7.1-bookworm@sha256:10c4b26c00c438bba4bfcb632435e0d46fac6e6b63db925d14b16769d6fb5f89 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.1-bookworm@sha256:10c4b26c00c438bba4bfcb632435e0d46fac6e6b63db925d14b16769d6fb5f89

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
