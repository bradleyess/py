WITH heuristic_labels AS (
    SELECT
        label AS category,
        confidence AS category_confidence_score,
        LOWER(url) AS canonical_url
    FROM (VALUES ('{{ var('heuristic_labels') }}')) AS v1 (label)
),

-- Get the latest link detection event for each link and URL combination
latest_categorisation AS (
    SELECT
        sub.link_id,
        sub.canonical_url,
        sub.created_at,
        sub.model_label,
        sub.model_confidence
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY link_id, canonical_url ORDER BY created_at DESC
            ) AS latest_score
        FROM production.content_moderation.link_detection_events
        WHERE model_version IN ('GCP_NLP_MODEL_1.0.0', 'GCP_NLP_MODEL_2.0.0')
    ) AS sub
    WHERE sub.latest_score = 1
),

-- Classify the links and calculate the confidence score
classified_links AS (
    SELECT
        ll.account_id,
        ll.id AS link_id,
        ll.created_at,
        lc.scraped_at,
        ll.url,
        lc.url_resolved,
        COALESCE(hl.category, lc.model_label) AS category,
        COALESCE(
            hl.category_confidence_score, lc.model_confidence
        ) AS category_confidence_score
    FROM production.bi.links AS ll
    LEFT JOIN
        latest_categorisation AS lc
        ON ll.id = lc.link_id AND ll.url = lc.canonical_url
    LEFT JOIN heuristic_labels AS hl ON LOWER(ll.url) = hl.canonical_url
)

-- Select the desired columns from the classified_links view
SELECT * FROM classified_links
