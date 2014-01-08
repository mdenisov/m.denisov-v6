<?php
/**
 * Template Name: Full Width Page
 */

get_header(); ?>

<div id="main-content" class="main-content" data-module="text">

	<?php
		// Start the Loop.
		while ( have_posts() ) : the_post();

			// Include the page content template.
			get_template_part( 'content', 'page' );

			// If comments are open or we have at least one comment, load up the comment template.
			if ( comments_open() || get_comments_number() ) {
				comments_template();
			}
		endwhile;
	?>
</div>

<?php
get_footer();
