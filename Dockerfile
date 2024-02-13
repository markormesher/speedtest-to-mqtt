FROM node:21.6.1-bookworm@sha256:1861f135f2d61d146e9d3547df0c2275fe6a43c3647075d16d909ba0f5690771 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.6.1-bookworm@sha256:1861f135f2d61d146e9d3547df0c2275fe6a43c3647075d16d909ba0f5690771

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
