<?php
/**
 * The template used for displaying single portfolio content
 */

get_header(); ?>

<div id="main-content" class="main-content" data-module="galleryItem">
	<?php
		while ( have_posts() ) : the_post();

			set_pageviews(get_the_ID());

			get_template_part( 'content', 'portfolio-item' );

		endwhile;
	?>
</div>

<?php
get_footer();