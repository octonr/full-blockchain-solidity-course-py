from brownie import SimpleStorage, accounts, config, network

def read_contract():
    # print(SimpleStorage[0]) # deploy and get this read_value.py deploy address. you can check build/deployments/chainId/<address>
    print("SimpleStorage[0]: ", SimpleStorage[0])
    print("SimpleStorage[0].retrieve(): ", SimpleStorage[0].retrieve())
    print("updating... : SimpleStorage[0] store 25")
    SimpleStorage[0].store(25, {'from': get_account()})
    print("updated!!")
    print("SimpleStorage[0].retrieve(): ", SimpleStorage[0].retrieve())
    
    print("---")
    
    simple_storage = SimpleStorage[-1] # index [-1] call previous deploy address
    # go take the index thats one less than the length
    # ABI
    # Address
    print(simple_storage.retrieve())
    print("SimpleStorage[-1]: ", SimpleStorage[-1])
    print("SimpleStorage[-1].retrieve(): ", SimpleStorage[-1].retrieve())
    pass

def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def main():
    read_contract()