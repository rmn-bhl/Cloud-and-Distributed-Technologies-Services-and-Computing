USE wordpress;

UPDATE wp_posts
SET post_title = 'This post was updated using external db connection'
WHERE ID = 1;