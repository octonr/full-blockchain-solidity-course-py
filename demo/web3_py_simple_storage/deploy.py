from solcx import compile_standard, install_solc
from web3 import Web3
import json
import os
from dotenv import load_dotenv

install_solc("0.6.0")

load_dotenv()

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]
# print(abi)

# for connectiong to ganache
# w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545")) # ganache address
w3 = Web3(
    Web3.HTTPProvider("https://rinkeby.infura.io/v3/220f337b9c16457c98944524a42c41d0")
)
# chain_id = 1337
chain_id = 4  # rinkeby network chainid
# my_address = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1" # Ganache address
my_address = (
    "0xBa602C61F879925af85dcE1Dd844d04A66ce4544"  # METAMASK myAccount Account1 address
)

# have to add 0x to front
# you have not to set hard-cord private_key in program
# so you can use `.env` with `python-dotenv`
private_key = os.getenv("PRIVATE_KEY")
print(private_key)

# Create the contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
# print(SimpleStorage) # to check successly created contract

# Get the latest transaction
nonce = w3.eth.getTransactionCount(my_address)
print("nonce: ", nonce)
# 1. Build a transaction
# 2. Sign a transaction
# 3. Send a transaction
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
        "gasPrice": w3.eth.gas_price,
    }
)
# print(transaction)
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
# print(signed_txn)
# Send this signed transaction
# you can check transaction at ganache TRANSACTIONS.
print("Deploying contract...")
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

print("Deployed!!")

# Working with the contract, you always need
# Contract Address
# Contract ABI
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# Call -> Simulate making the call and getting a return value
# Transact -> Actually make a state change
print("call retrieve(): ", simple_storage.functions.retrieve().call())
print("call store(15): ", simple_storage.functions.store(15).call())

print("Updating Contract...")
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce + 1,
        "gasPrice": w3.eth.gas_price,
    }
)
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

print("Updated!!")
print(simple_storage.functions.retrieve().call())
