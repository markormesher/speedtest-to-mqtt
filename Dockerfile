FROM node:22.11.0-bookworm@sha256:95fe7a759f854e06d2a34ed9ab9479e8c790814d649b45a73530979df3e74ac5 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:22.11.0-bookworm@sha256:95fe7a759f854e06d2a34ed9ab9479e8c790814d649b45a73530979df3e74ac5

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
