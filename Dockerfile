FROM node:21.7.3-bookworm@sha256:162d92c5f1467ad877bf6d8a098d9b04d7303879017a2f3644bfb1de1fc88ff0 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.3-bookworm@sha256:162d92c5f1467ad877bf6d8a098d9b04d7303879017a2f3644bfb1de1fc88ff0

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
