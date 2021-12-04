from brownie import accounts, config, SimpleStorage
import os


def deploy_simple_storage():
    # account = accounts[0] # ganache
    # print(account)
    # account = accounts.load("freecodecamp-account")
    # print(account)
    # account = accounts.add(os.getenv("PRIVATE_KEY"))
    # print(account)
    # account = accounts.add(config["wallets"]["from_key"])
    # print(account)
    account = accounts[0] # ganache
    simple_storage = SimpleStorage.deploy({"from":account})
    sotred_value = simple_storage.retrieve()
    # Transct
    # Call
    print(simple_storage)
    print("sotred_value: ",sotred_value)
    print("updating...")
    txn = simple_storage.store(15, {"from":account})
    txn.wait(1)
    updated_stored_value = simple_storage.retrieve()
    print("updated!!")
    print("updated_stored_value: ",updated_stored_value)

def main():
    deploy_simple_storage()