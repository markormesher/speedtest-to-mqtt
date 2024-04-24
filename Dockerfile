FROM node:21.7.3-bookworm@sha256:bda531283f4bafd1cb41294493de89ae3c4cf55933da14710e46df970e77365e AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.3-bookworm@sha256:bda531283f4bafd1cb41294493de89ae3c4cf55933da14710e46df970e77365e

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
