FROM node:21.4.0-bookworm@sha256:814a6dc5bfd4ecc5ef24652f6b4f2790e9f3552b52ee38a7b51fc4d4c0d6d7fd AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.4.0-bookworm@sha256:814a6dc5bfd4ecc5ef24652f6b4f2790e9f3552b52ee38a7b51fc4d4c0d6d7fd

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
