FROM node:21.7.2-bookworm@sha256:fa5e7e628c8fe0ebfd13239b0103de36df36903fc7fee18da9755d022b2b910f AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.2-bookworm@sha256:fa5e7e628c8fe0ebfd13239b0103de36df36903fc7fee18da9755d022b2b910f

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
