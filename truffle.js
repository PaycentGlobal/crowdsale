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
        },
        rinkeby: {
            host: "localhost", // Connect to geth on the specified
            port: 8545,
            from: "0xF5AC35Ef1b1bc65040f0adAb82CD47521F4A8712", // default address to use for any transaction Truffle makes during migrations
            network_id: 4,
            gas: 4612388 // Gas limit used for deploys
        },
        ropsten: {
            host: "localhost",
            port: 8545,
            network_id: "3",
            from: "0xF5AC35Ef1b1bc65040f0adAb82CD47521F4A8712",
            gas: 4000000 // Gas limit used for deploys
        }
    }
};
