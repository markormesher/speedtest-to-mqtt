FROM node:21.7.2-bookworm@sha256:b9c14d7c1251e52ff3a51080b1b5647de69a3d13ed04a5fe6189aac6d71fe26d AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.2-bookworm@sha256:b9c14d7c1251e52ff3a51080b1b5647de69a3d13ed04a5fe6189aac6d71fe26d

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
