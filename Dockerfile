FROM node:21.2.0-bookworm@sha256:6b5c0daae8d06fc0da5a9bb835b3403654b466a956309e4e806f6a8da8d9807c AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.2.0-bookworm@sha256:6b5c0daae8d06fc0da5a9bb835b3403654b466a956309e4e806f6a8da8d9807c

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
