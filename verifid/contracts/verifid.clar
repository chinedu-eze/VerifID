;; Decentralized Identity Verification Smart Contract

;; Define the contract owner
(define-constant owner-addr 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; Replace with your address

;; Map to store user identities
(define-map identities principal { 
    name: (string-utf8 100), 
    email: (string-utf8 100), 
    verified: bool 
})

;; Error codes
(define-constant ERR-UNAUTHORIZED (err u1001))
(define-constant ERR-DUPLICATE (err u1002))
(define-constant ERR-NOT-FOUND (err u1003))

;; Function to register identity
(define-public (register-identity (name (string-utf8 100)) (email (string-utf8 100)))
    (begin
        ;; Check if the caller already has an identity
        (asserts! (is-none (map-get? identities tx-sender)) ERR-DUPLICATE)
        
        ;; Store the identity
        (map-set identities tx-sender { name: name, email: email, verified: false })
        
        ;; Return success
        (ok true)
    )
)

;; Function to verify identity (only callable by contract owner)
(define-public (verify-identity (addr principal))
    (begin
        ;; Ensure only the contract owner can verify identities
        (asserts! (is-eq tx-sender owner-addr) ERR-UNAUTHORIZED)
        
        ;; Check if the user exists
        (asserts! (is-some (map-get? identities addr)) ERR-NOT-FOUND)
        
        ;; Update the verified status
        (map-set identities addr (merge (unwrap! (map-get? identities addr) ERR-NOT-FOUND) { verified: true }))
        
        ;; Return success
        (ok true)
    )
)

;; Function to get identity information
(define-read-only (get-identity (addr principal))
    (begin
        ;; Fetch the identity
        (match (map-get? identities addr)
            data (ok data)
            (err ERR-NOT-FOUND)
        )
    )
)

;; Function to delete identity (only callable by the user)
(define-public (delete-identity)
    (begin
        ;; Ensure the caller has an identity
        (asserts! (is-some (map-get? identities tx-sender)) ERR-NOT-FOUND)
        
        ;; Delete the identity
        (map-delete identities tx-sender)
        
        ;; Return success
        (ok true)
    )
)