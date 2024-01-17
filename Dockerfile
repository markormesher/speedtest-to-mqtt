FROM node:21.6.0-bookworm@sha256:9e6120b29e110250185d7cf7738f2aaa3d0ac404d648b8f49ddc3762e39ab76e AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.6.0-bookworm@sha256:9e6120b29e110250185d7cf7738f2aaa3d0ac404d648b8f49ddc3762e39ab76e

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
