-- Customers With No Interactions in the Last 90 Days

SELECT
    customers.customer_id,
    customers.name
FROM
    customers
LEFT JOIN (
    SELECT
        interactions.customer_id,
        MAX(interactions.interaction_date) AS last_contact
    FROM
        interactions
    GROUP BY
        interactions.customer_id
) AS last_contact_info ON customers.customer_id = last_contact_info.customer_id
WHERE
    last_contact_info.last_contact < CURDATE() - INTERVAL 90 DAY;
    