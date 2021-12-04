---
new: 2021-12-04
---

# [doc](https://eth-brownie.readthedocs.io/en/stable/)

# brownie commands
## brownie init
  - init directory like as `git init`
## brownie run "filename"
  - ex) `brownie run scripts/deploy.py`
## brownie test "filename"
  - ex) `brownie test tests/test_simple_storage.py`
  - option)
    * brownie test "filename" -k "scripts function"
      * this can chose test function
    * brownie test "filename" --pdp
      * if script is failed, shell into the pytest mode. 

# python scripts for brownie
## scripts
  - `def main()` is called by brownie run
  - `from brownie import <contracts/yourContracts>`
    * Then you can deploy using `<conracts/yourContracts>.deploy({"from":PRIVATE_KEY})`
  - `from brownie import accounts`
    * Then you can use default PRIVATE_KEY from Ganache using `accounts[0]`
  - you put brownie-cpnfig.yaml on brownie home path like as
    ```
    dotenv: .env
    wallets:
      from_key: ${PRIVATE_KEY}
    ```
    * Set `.env` file to dotenv
    * and you can call $PRIVATE_KEY that environment variable using `config["wallets"]["from_key"]` with `from brownie import config`

## tests
  - 1. Arrange
  - 2. Act
  - 3. Assert 