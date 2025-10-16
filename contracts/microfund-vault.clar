;; Added all missing error constants
(define-constant ERR-PROJECT-CLOSED (err u100))
(define-constant ERR-TRANSFER-FAILED (err u101))
(define-constant ERR-NO-SUCH-PROJECT (err u102))
(define-constant ERR-NOT-OWNER (err u103))
(define-constant ERR-GOAL-NOT-REACHED (err u104))
(define-constant ERR-INSUFFICIENT-FUNDS (err u105))

;; Define the projects map
(define-map projects
  { id: uint }
  { owner: principal, goal: uint, raised: uint, active: bool })

;; Added missing contributions map definition
(define-map contributions
  { project-id: uint, contributor: principal }
  { amount: uint })

;; Contribute to a project
(define-public (contribute (project-id uint) (amount uint))
  (let ((project (map-get? projects { id: project-id })))
    (match project
      project-data
        (begin
          (asserts! (get active project-data) ERR-PROJECT-CLOSED)
          (asserts! (> amount u0) (err u0))
          (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
          (let ((new-total (+ (get raised project-data) amount)))
            (map-set projects { id: project-id }
              (merge project-data { raised: new-total }))
            (map-set contributions
              { project-id: project-id, contributor: tx-sender }
              { amount: amount })
            (ok new-total)))
      ERR-NO-SUCH-PROJECT)))

;; Withdraw funds once goal is reached
(define-public (withdraw-funds (project-id uint))
  (let ((project (map-get? projects { id: project-id })))
    (match project
      project-data
        (begin
          (asserts! (is-eq (get owner project-data) tx-sender) ERR-NOT-OWNER)
          (asserts! (>= (get raised project-data) (get goal project-data)) ERR-GOAL-NOT-REACHED)
          (try! (stx-transfer? (get raised project-data) (as-contract tx-sender) tx-sender))
          (map-set projects { id: project-id }
            (merge project-data { active: false }))
          (ok (get raised project-data)))
      ERR-NO-SUCH-PROJECT)))

;; Refund contributors if project fails or expires
(define-public (refund (project-id uint))
  (let ((project (map-get? projects { id: project-id }))
        (contribution (map-get? contributions { project-id: project-id, contributor: tx-sender })))
    (match contribution
      contrib
        (begin
          (asserts! (not (get active (unwrap! project ERR-NO-SUCH-PROJECT))) ERR-PROJECT-CLOSED)
          (try! (stx-transfer? (get amount contrib) (as-contract tx-sender) tx-sender))
          (map-delete contributions { project-id: project-id, contributor: tx-sender })
          (ok (get amount contrib)))
      ERR-INSUFFICIENT-FUNDS)))
