FROM node:21.1.0-bookworm@sha256:0052410af98158173b17a26e0e2a46a3932095ac9a0ded660439a8ffae65b1e3 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.1.0-bookworm@sha256:0052410af98158173b17a26e0e2a46a3932095ac9a0ded660439a8ffae65b1e3

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
