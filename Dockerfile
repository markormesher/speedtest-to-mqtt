FROM node:21.2.0-bookworm@sha256:657d653b1d9538d114a79c83dc1212c2601aeb23dbcd0520bad8fcf58c1b10de AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.2.0-bookworm@sha256:657d653b1d9538d114a79c83dc1212c2601aeb23dbcd0520bad8fcf58c1b10de

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
