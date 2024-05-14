FROM node:21.7.3-bookworm@sha256:64f5f12ea1ae509f7d114b089325fa6521e151a9437dd1e1ff943a111823569d AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.3-bookworm@sha256:64f5f12ea1ae509f7d114b089325fa6521e151a9437dd1e1ff943a111823569d

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
