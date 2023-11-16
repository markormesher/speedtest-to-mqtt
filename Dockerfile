FROM node:21.2.0-bookworm@sha256:46b2db8baeb8bc448cb87eb90c41517554836eb8ae508d5934ebdf42ddd0f5cc AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.2.0-bookworm@sha256:46b2db8baeb8bc448cb87eb90c41517554836eb8ae508d5934ebdf42ddd0f5cc

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
