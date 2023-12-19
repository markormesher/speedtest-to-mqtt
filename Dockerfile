FROM node:21.4.0-bookworm@sha256:52206db44f7bb76dca465a9fae016922b6878c39261c87c9b719ae4d892fecfd AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.4.0-bookworm@sha256:52206db44f7bb76dca465a9fae016922b6878c39261c87c9b719ae4d892fecfd

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
