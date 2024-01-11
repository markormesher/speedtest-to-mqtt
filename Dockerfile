FROM node:21.5.0-bookworm@sha256:ca1e0e5a87da404c488223e35dc7203c331e4c49c583616cc75a86ec13a43f3c AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.5.0-bookworm@sha256:ca1e0e5a87da404c488223e35dc7203c331e4c49c583616cc75a86ec13a43f3c

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
