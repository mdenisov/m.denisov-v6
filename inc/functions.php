<?php

/*-------------------------------------------------------------------------*/
/* Show featured image real link */
/*-------------------------------------------------------------------------*/
function featured_image_link ($ID) {

	$image_id = get_post_thumbnail_id($ID, 'full');
	$image_url = wp_get_attachment_image_src($image_id,'full');
	$image_url = $image_url[0];
	return $image_url;
}

/*-------------------------------------------------------------------------*/
/* Show attached image link */
/*-------------------------------------------------------------------------*/
function featured_image_real_link ($ID) {

	$image_id = get_post_thumbnail_id($ID, 'full');
	$image_url = wp_get_attachment_image_src($image_id,'full');
	$image_url = $image_url[0];

	$image=wpmu_image_path($image_url);
	return $image;
}

/*-------------------------------------------------------------------------*/
/* Generate WP MU image path */
/*-------------------------------------------------------------------------*/
function wpmu_image_path ($theImageSrc) {

	if ( is_multisite() ) {
		$blog_id=get_current_blog_id();
		if (isset($blog_id) && $blog_id > 0) {
			$imageParts = explode('/files/', $theImageSrc);
			if (isset($imageParts[1])) {
				//$theImageSrc = $imageParts[0] . '/blogs.dir/' . $blog_id . '/files/' . $imageParts[1];
				$theImageSrc = '/blogs.dir/' . $blog_id . '/files/' . $imageParts[1];
			}
		}
	}
	return $theImageSrc;
}

/*-------------------------------------------------------------------------*/
/* Comments */
/*-------------------------------------------------------------------------*/
function print_comments($comment, $args, $depth) {
	$GLOBALS['comment'] = $comment;
	extract($args, EXTR_SKIP);

	if ( 'div' == $args['style'] ) {
		$add_below = 'comment';
	} else {
		$add_below = 'div-comment';
	}
	?>

	<div <?php //comment_class(empty( $args['has_children'] ) ? '' : 'parent') ?> id="comment-<?php comment_ID() ?>" class="comments__item">

		<div class="comments__item__avatar"><?php if ($args['avatar_size'] != 0) echo get_avatar( $comment, $args['avatar_size'] ); ?></div>
		<div id="div-comment-<?php comment_ID() ?>" class="comments__item__content">
			<h5 class="comments__item__user"><?= get_comment_author(); ?></h5>
			<div class="comments__item__date"><?php printf( __('%1$s at %2$s'), get_comment_date(),  get_comment_time()) ?></div>

			<?php //comment_reply_link(array_merge( $args, array('add_below' => $add_below, 'depth' => $depth, 'max_depth' => $args['max_depth']))) ?>
			<?php edit_comment_link(__('(Edit)'),'  ','' ); ?>

			<?php if ($comment->comment_approved == '0') : ?>
				<p>
					<em class="comment-awaiting-moderation"><?php _e('Your comment is awaiting moderation.') ?></em>
					<br />
				</p>
			<?php endif; ?>

			<?php comment_text() ?>
		</div>

	</div>
	<div class="clearfix"></div>
<?php
}

?>