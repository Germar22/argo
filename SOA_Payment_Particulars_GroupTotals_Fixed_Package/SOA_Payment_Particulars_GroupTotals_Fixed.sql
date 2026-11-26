/*
  ActiveOne SOA unified transaction query - crash-safe pipeline version
  Configure/paste this SQL into the existing report data pipeline named plOpenInvoices.
  IMPORTANT: Keep the RTM's DataPipeline/DataPipelineName as plOpenInvoices.

  Grain:
    - One row per invoice
    - One row per payment_invoices allocation
  Payment particulars identify the invoice receiving the allocation.
  This query intentionally does not join a customer-level payment summary, which
  would repeat payments against every invoice for the same customer.

  Scope note: this is the invoice + applied-payment ledger only. It does not yet
  reproduce discount, tax-credit, credit-memo, other adjustment, or original
  aging-bucket logic. Reconcile those before production use.
*/
WITH transaction_rows AS (
    SELECT
        i.CUSTOMER_ID AS CUSTOMER_ID,
        c.NAME AS CUSTOMER_NAME,
        i.ID AS DOCUMENT_ID,
        i.CODE AS DOCUMENT_CODE,
        i.DATE AS DOCUMENT_DATE,
        i.DUE_DATE AS DUE_DATE,
        'Invoice' AS DOCUMENT_TYPE_DESC,
        10 AS SORT_ORDER,
        CONCAT('Invoice #', i.CODE) AS LINE_INFO,
        CAST(COALESCE(i.AMOUNT, 0) AS DECIMAL(18,4)) AS AMOUNT
    FROM invoice i
    INNER JOIN contact c
        ON c.ID = i.CUSTOMER_ID

    UNION ALL

    SELECT
        p.CUSTOMER_ID AS CUSTOMER_ID,
        c.NAME AS CUSTOMER_NAME,
        p.ID AS DOCUMENT_ID,
        p.CODE AS DOCUMENT_CODE,
        p.DATE AS DOCUMENT_DATE,
        p.DATE AS DUE_DATE,
        'Payment' AS DOCUMENT_TYPE_DESC,
        20 AS SORT_ORDER,
        CONCAT(
            'Applied to Invoice #', i.CODE,
            ' / Applied: ', FORMAT(pi.AMOUNT_APPLIED, 2)
        ) AS LINE_INFO,
        CAST(-COALESCE(pi.AMOUNT_APPLIED, 0) AS DECIMAL(18,4)) AS AMOUNT
    FROM payment p
    INNER JOIN payment_invoices pi
        ON pi.PAYMENT_ID = p.ID
    INNER JOIN invoice i
        ON i.ID = pi.INVOICE_ID
    INNER JOIN contact c
        ON c.ID = p.CUSTOMER_ID
    WHERE COALESCE(pi.AMOUNT_APPLIED, 0) <> 0
),
ledger AS (
    SELECT
        tr.*,
        CAST(
            SUM(tr.AMOUNT) OVER (
                PARTITION BY tr.CUSTOMER_ID
                ORDER BY tr.DOCUMENT_DATE, tr.SORT_ORDER, tr.DOCUMENT_ID, tr.DOCUMENT_CODE
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS DECIMAL(18,4)
        ) AS RUNNING_BALANCE
    FROM transaction_rows tr
)
SELECT
    CUSTOMER_ID,
    CUSTOMER_NAME,
    DOCUMENT_ID,
    DOCUMENT_CODE,
    DOCUMENT_DATE,
    DUE_DATE,
    DOCUMENT_TYPE_DESC,
    LINE_INFO,
    AMOUNT,
    RUNNING_BALANCE
FROM ledger
ORDER BY CUSTOMER_NAME, CUSTOMER_ID, DOCUMENT_DATE, SORT_ORDER, DOCUMENT_ID, DOCUMENT_CODE;
