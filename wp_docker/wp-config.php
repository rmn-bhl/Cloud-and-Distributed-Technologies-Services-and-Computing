<?php
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress' );
define( 'DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wordpress' );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'password' );

$db_host = getenv('WORDPRESS_DB_HOST') ?: 'db';
define('DB_HOST', $db_host);

define('AUTH_KEY',         'your-auth-key');
define('SECURE_AUTH_KEY',  'your-secure-auth-key');
define('LOGGED_IN_KEY',    'your-logged-in-key');
define('NONCE_KEY',        'your-nonce-key');

define('WP_DEBUG', false);
$table_prefix = 'wp_';
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';
?>
