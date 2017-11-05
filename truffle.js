module.exports = {
    networks: {
        test: {
            host: "localhost",
            port: 8545,
            network_id: "*", // Match any network id
        },
        live: {
            network_id: "1",
            host: "localhost",
            port: 8545
        }
    }
};
