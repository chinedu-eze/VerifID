# VerifID

## Overview

**VerifID** is a **decentralized identity verification smart contract** built in **Clarity**, designed to securely register, verify, and manage user identities on-chain. It ensures data integrity and controlled verification by assigning exclusive verification privileges to an admin wallet, creating a trustworthy framework for decentralized applications that require verified user credentials.

---

## Features

### 1. **Identity Registration**

Users can register their identity with a name and contact email.
Each wallet address can only have one identity record.

**Function:**

```clarity
(register-identity (full-name (string-utf8 100)) (contact-email (string-utf8 100)))
```

* Prevents duplicate entries.
* Stores identity data with a `false` verification status by default.
* Returns `(ok true)` upon successful registration.

---

### 2. **Admin-Based Verification**

Only the contract administrator can verify user identities.
Verification updates the user’s record to mark `is-verified` as `true`.

**Function:**

```clarity
(verify-identity (account-address principal))
```

* Restricted to the admin wallet.
* Ensures that the identity record exists before verification.
* Returns `(ok true)` upon successful verification.

---

### 3. **Identity Retrieval**

Anyone can query the blockchain to confirm the registration and verification status of a user.

**Function:**

```clarity
(get-identity (account-address principal))
```

* Returns user information (`full-name`, `contact-email`, `is-verified`).
* Returns an error if the entry does not exist.

---

### 4. **Identity Deletion**

Users retain full control of their identity records and can delete them at any time.

**Function:**

```clarity
(delete-identity)
```

* Callable only by the wallet owner who registered the identity.
* Permanently removes their record from the `user-registry`.
* Returns `(ok true)` on success.

---

## Data Structures

### Map: `user-registry`

Stores all registered user identities:

```clarity
principal => {
    full-name: (string-utf8 100),
    contact-email: (string-utf8 100),
    is-verified: bool
}
```

### Constant: `admin-wallet`

Holds the address of the contract administrator authorized to perform identity verifications.

---

## Error Codes

| Code    | Error Constant          | Description                                |
| ------- | ----------------------- | ------------------------------------------ |
| `u1001` | `ERROR_NOT_AUTHORIZED`  | Unauthorized attempt to verify an identity |
| `u1002` | `ERROR_DUPLICATE_ENTRY` | User already registered an identity        |
| `u1003` | `ERROR_ENTRY_MISSING`   | Identity record not found                  |

---

## Security & Validation

* **Access Control:** Only the designated admin wallet can verify identities.
* **Data Integrity:** Prevents overwriting or duplicating identity records.
* **User Autonomy:** Each user controls the creation and deletion of their own identity.
* **Error Handling:** Clear and specific error responses ensure predictable contract behavior.

---

## Summary

**VerifID** establishes a **secure, transparent, and user-owned** system for decentralized identity management.
It can serve as a foundational identity layer for applications such as decentralized KYC systems, reputation-based networks, or DAO membership verification, ensuring on-chain proof of verified human identity.
