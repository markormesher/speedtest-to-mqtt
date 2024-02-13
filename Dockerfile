FROM node:21.6.1-bookworm@sha256:5951e42dd697b63a6bd9a4dfd610da952097f9db829ea659257104e7fd4fdfa6 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.6.1-bookworm@sha256:5951e42dd697b63a6bd9a4dfd610da952097f9db829ea659257104e7fd4fdfa6

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
