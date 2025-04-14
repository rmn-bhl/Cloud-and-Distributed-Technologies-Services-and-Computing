<?php
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress' );
define( 'DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wordpress' );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'password' );
define( 'DB_HOST', '127.0.0.1' );

define('AUTH_KEY',         'generate-your-own-key');
define('SECURE_AUTH_KEY',  'generate-your-own-key');
define('LOGGED_IN_KEY',    'generate-your-own-key');
define('NONCE_KEY',        'generate-your-own-key');

define('WP_DEBUG', false);
$table_prefix = 'wp_';

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
