FROM node:21.7.0-bookworm@sha256:104b26b5d34f9907f1f1e5e51fd9e557845f1a354f07ee9f28814dd9574a6154 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.0-bookworm@sha256:104b26b5d34f9907f1f1e5e51fd9e557845f1a354f07ee9f28814dd9574a6154

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
