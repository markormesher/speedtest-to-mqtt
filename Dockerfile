FROM node:21.3.0-bookworm@sha256:04300613a87512b58a0555a122f35b2fb7a7dd528b6435e87b0d34b67f53a86a AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.3.0-bookworm@sha256:04300613a87512b58a0555a122f35b2fb7a7dd528b6435e87b0d34b67f53a86a

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
