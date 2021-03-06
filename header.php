<!DOCTYPE html>
<!--[if IE 7]>
<html class="ie ie7" <?php language_attributes(); ?>>
<![endif]-->
<!--[if IE 8]>
<html class="ie ie8" <?php language_attributes(); ?>>
<![endif]-->
<!--[if !(IE 7) | !(IE 8) ]><!-->
<html <?php language_attributes(); ?>>
<!--<![endif]-->
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width">
	<title><?php wp_title( '|', true, 'right' ); ?></title>
	<link rel="shortcut icon" href="<?php echo get_template_directory_uri(); ?>/favicon.ico">
	<link rel="profile" href="http://gmpg.org/xfn/11">
	<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>">
	<!--[if lt IE 9]>
	<script src="<?php echo get_template_directory_uri(); ?>/js/html5.js"></script>
	<![endif]-->
	<?php wp_head(); ?>
	<script>
		var baseUrl = "<?= site_url(); ?>",
			ajaxurl = "<?= admin_url('admin-ajax.php'); ?>";
	</script>
	<script src="<?php echo get_template_directory_uri(); ?>/js/qbaka.js"></script>
</head>

<body <?php body_class(); ?>>

	<div class="header">
		<header class="header__container">
			<a class="header__logo" href="<?php echo esc_url( home_url( '/' ) ); ?>" rel="home"></a>
			<nav id="primary-navigation" class="header__menu" role="navigation">
				<?php wp_nav_menu( array( 'theme_location' => 'primary', 'menu_class' => 'nav-menu' ) ); ?>
			</nav>
		</header>
	</div>

	<div id="main" class="main">
