FROM node:21.7.1-bookworm@sha256:f952a494a2a70367beb148c885fab6b455085fc5969a7fd7409b1929b9336db8 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.1-bookworm@sha256:f952a494a2a70367beb148c885fab6b455085fc5969a7fd7409b1929b9336db8

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
