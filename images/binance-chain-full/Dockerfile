# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --update ca-certificates
WORKDIR /root

ADD https://github.com/binance-chain/node-binary/raw/master/fullnode/testnet/0.6.2/linux/bnbchaind /usr/local/bin/bnbchaind
RUN chmod +x /usr/local/bin/bnbchaind

VOLUME /bnc

EXPOSE 26656
EXPOSE 26657

CMD ["bnbchaind", "start", "--home=/bnc"]
