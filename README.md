# PocketPay Payment

## Run Locally

Clone the project

```bash
  git clone https://github.com/pocketpayfinance/pocketpay-bnb-contract.git
```

Go to the project directory

```bash
  cd pocketpay-bnb-contract
```

Install dependencies

```bash
  npm install
```

Compile

```bash
  npx hardhat compile
```

Test

```bash
  npx hardhat test
```

Deploy on Arbitrum Goerli

```bash
  npx hardhat run scripts/deploy.ts --network opbnb_testnet
```

Help

```bash
  npx hardhat help
```
