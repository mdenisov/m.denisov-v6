<?php
/**
 * Template Name: Gallery
 */

get_header(); ?>

<div id="main-content" class="main-content" data-module="gallery">

	<div class="portfolio__list">

		<?php
		$portfolio_category = get_post_meta($post->ID, MTHEME . '_portfolio_category', true);
		$portfolio_perpage = get_post_meta($post->ID, MTHEME . '_portfolio_perpage', true);
		$portfolio_link = get_post_meta($post->ID, MTHEME . '_portfolio_link', true);

		$portfolio_perpage = "-1";

		$portfolio_cat = get_term_by ( 'name', $portfolio_category, 'types' );
		$portfolio_cat_slug = $portfolio_cat -> slug;
		$portfolio_cat_ID = $portfolio_cat -> term_id;

		$portfolio_category = $portfolio_cat_slug;

		$newquery = array(
			'post_type' => 'mtheme_portfolio',
			'types' => $portfolio_cat_slug,
			'orderby' => 'menu_order',
			'post_status' => 'publish',
			'order' => 'ASC',
			'posts_per_page' => -1,
		);

		query_posts($newquery);

		while ( have_posts() ) : the_post();

			get_template_part( 'content', 'portfolio' );

		endwhile;

		?>

	</div>

</div>

<?php
get_footer();
