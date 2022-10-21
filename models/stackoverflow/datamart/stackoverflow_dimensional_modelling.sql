WITH 
post_questions AS (
SELECT
    id,
    title,
    body,
    accepted_answer_id,
    SUM(answer_count) AS answer_count,
    SUM(comment_count) AS comment_count,
    community_owned_date,
    creation_date,
    SUM(favorite_count) AS favorite_count,
    last_activity_date,
    last_edit_date,
    last_editors_display_name,
    last_editors_user_id,
    owner_display_name,
    owner_user_id,
    parent_id,
    post_type_id,
    SUM(score),
    tags, 
    SUM(view_count)
FROM 
    {{ ref('stackoverflow_post-questions_prep') }} 
GROUP BY 
    id,
    title,
    accepted_answer_id,
    community_owned_date,
    creation_date,
    last_activity_date,
    last_edit_date,
    last_editors_display_name,
    last_editors_user_id,
    owner_display_name,
    owner_user_id,
    parent_id,
    post_type_id,
    tags
),
post_answers AS (
SELECT 
    id,
    title,
    body,
    accepted_answer_id,
    SUM(answer_count),
    SUM(comment_count),
    community_owned_date,
    creation_date,
    SUM(favorite_count) AS favorite_count,
    last_editors_display_name,
    owner_user_id,
    parent_id,
    post_type_id,
    SUM(score),
    tags, 
    SUM(view_count)
FROM 
    {{ ref('stackoverflow_post-answers_prep') }} 
GROUP BY 
    id,
    title
    accepted_answer_id,
    community_owned_date
    last_editors_display_name,
    owner_user_id,
    parent_id,
    post_type_id,
    tags
),

comments AS (
SELECT 
    id,
    text,
    creation_date,
    post_id,
    user_id,
    user_display_name,
    SUM(score)
FROM 
    {{ ref('stackoverflow_comments_prep') }} 
GROUP BY 
    id, 
    creation_date,
    post_id
    user_id,
    user_display_name
),

tags AS (
SELECT 
    id,
    tag_name,
    SUM(count) AS count,
    excerpt_post_id,
    wiki_post_id
FROM 
    {{ ref('stackoverflow_tags_prep') }} 
GROUP BY 
    id,
    tag_name,
    excerpt_post_id,
    wiki_post_id
),

votes AS (
SELECT 
    id,
    creation_date,
    post_id,
    vote_type_id
FROM 
    {{ ref('stackoverflow_votes_prep') }} 
GROUP BY 
    id,
    creation_date,
    post_id,
    vote_type_id
),

users AS (
SELECT 
    id,
    display_name,
    about_me,
    age,
    creation_date,
    last_access_date,
    location, 
    SUM(reputation) AS reputation,
    SUM(up_votes) AS up_votes,
    SUM(down_votes) AS down_votes,
    SUM(views) AS views,
    profile_image_url,
    website_url
FROM 
    {{ ref('stackoverflow_users_prep') }} 
GROUP BY 
    id,
    display_name,
    age,
    creation_date,
    last_access_date,
    location,
    profile_image_url,
    website_url
),

fact AS (
SELECT
    *
FROM 
    post_questions
INNER JOIN post_answers
ON post_questions.parent_id = post_answers.id
)





SELECT
    *
FROM 
    fact