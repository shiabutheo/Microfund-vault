MicroFund-Vault Smart Contract

A Decentralized Micro-Funding Vault System Built on Stacks

---

Overview
**MicroFund-Vault** is a Clarity-based smart contract that enables decentralized **micro-funding** and **community-based capital pooling** on the **Stacks blockchain**.  
It provides a transparent, secure, and automated way for individuals or organizations to create funding vaults, receive small-scale contributions, and withdraw collected STX funds in a trustless manner.

By leveraging Bitcoin-secured Stacks technology, this contract empowers micro-investors and project owners to collaborate without intermediaries.

---

Key Features
- **Vault Creation:** Any user can create a new vault with a defined funding goal.  
- **STX Contributions:** Contributors can deposit STX tokens into active vaults.  
- **Trustless Withdrawals:** Vault owners can securely withdraw collected funds based on conditions.  
- **On-Chain Transparency:** All contributions and transactions are publicly viewable.  
- **Automated Distribution:** Supports configurable rules for fund release and allocation.  

---

Smart Contract Details
- **Contract Name:** `microfund-vault.clar`  
- **Language:** Clarity  
- **Blockchain:** Stacks (secured by Bitcoin)  
- **Primary Token:** STX  

---

Core Functions

| Function | Description |
|-----------|-------------|
| `create-vault (goal uint)` | Initializes a new vault with a funding target. |
| `contribute (id uint, amount uint)` | Allows users to deposit STX into a vault. |
| `withdraw (id uint, amount uint)` | Enables the vault creator to withdraw collected funds. |
| `get-vault (id uint)` | Returns details of a vault (goal, balance, contributors). |
| `get-contributors (id uint)` | Lists all contributors and their contributions. |

---

Testing & Validation
The contract has been tested using **Clarinet**:
- Syntax and logic verification passed  
- Correct handling of STX transfers  
- Successful creation, funding, and withdrawal workflows  
- Error handling for invalid vaults or unauthorized access  

---

 Deployment
To deploy the MicroFund-Vault smart contract locally:

```bash
clarinet console
(contract-call? .microfund-vault create-vault u1000000)
