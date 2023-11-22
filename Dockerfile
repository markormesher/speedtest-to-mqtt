FROM node:21.2.0-bookworm@sha256:84bb4077fd52933a935e7057ba9991e7cb18487b0ba444835dd44975aa94b7b2 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.2.0-bookworm@sha256:84bb4077fd52933a935e7057ba9991e7cb18487b0ba444835dd44975aa94b7b2

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
