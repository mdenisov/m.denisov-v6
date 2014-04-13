<?php
/**
 * The template used for displaying portfolio content
 */
?>

<?php

$rootpath = get_stylesheet_directory_uri();
$timthumb_path = $rootpath . '/timthumb.php';

$width = 1920;
$height = 1080;

$post_id = $post->ID;
$images =& get_children( array(
		'post_parent' => $post_id,
		'post_status' => 'inherit',
		'post_type' => 'attachment',
		'post_mime_type' => 'image',
		'order' => 'ASC',
		'numberposts' => 100,
//		'orderby' => 'menu_order'
	)
);

if ($images) {
	foreach ( $images as $id => $image ) {
		$attatchmentID = $image->ID;
		$imagearray = wp_get_attachment_image_src( $attatchmentID , 'full', false);
		$imageURI = $imagearray[0];
		$imageID = get_post($attatchmentID);
		$imageTitle = apply_filters('the_title',$image->post_title);
		$imageDesc = apply_filters('the_title',$image->post_content);
		$postlink = get_permalink($image->post_parent);

		$real_imageURI = $imageURI;
		$resized_imageURI = $timthumb_path . '?src=' . $real_imageURI . '&w='. $width .'&h='. $height .'&q=72&zc=3';

		$count++;

		$data[] = array(
			'id' => $id,
			'title' => $imageTitle,
			'description' => $imageDesc,
			'url' => '',
			'source' => $resized_imageURI,
		);
	}
} else {
	$imageURI = featured_image_link( get_the_ID() );
	$imageTitle = apply_filters('the_title',$image->post_title);
	$imageDesc = apply_filters('the_title',$image->post_content);

	$data[] = array(
		'id' => $id,
		'title' => $imageTitle,
		'description' => $imageDesc,
		'url' => '',
		'source' => $imageURI,
	);
}

$tags_data = $data;

add_action('wp_head', 'add_fb_open_graph_tags');



?>

<article id="post-<?php the_ID(); ?>" class="portfolio__item" data-post-id="<?= $post_id ?>">
	<div class="portfolio__slider">
		<?php
			foreach ($data as $item) {
				?>

				<div class="portfolio__slider__item">
					<img class="portfolio__slider__item__img" data-id="<?=$item['id']?>" src="<?=$item['source']?>" alt="<?=$item['title']?>">
				</div>

				<?php
			}
		?>
	</div>

	<span class="portfolio__nav portfolio__nav--prev portfolio__nav--hidden" data-direction="prev" title="Prev photo"><i class="fa fa-angle-left"></i></span>
	<span class="portfolio__nav portfolio__nav--next" data-direction="next" title="Next photo"><i class="fa fa-angle-right"></i></span>

	<span class="portfolio__info" title="More info"><i class="portfolio__info__icon"></i></span>
	<aside class="portfolio__sidebar portfolio__sidebar--shown">
		<span class="portfolio__sidebar__close"></span>
		<header class="portfolio__header">
			<div class="portfolio__author">
				<div class="portfolio__author__avatar"><?php echo get_avatar( get_the_author_meta( 'ID' ), 50 ); ?> </div>
				<?php if ( get_the_author_meta( 'first_name' ) && get_the_author_meta( 'last_name' ) ) : ?>
					<div class="portfolio__author__name"><?php the_author_meta( 'first_name' ); ?> <?php the_author_meta( 'last_name' ); ?></div>
				<?php endif; ?>
			</div>
			<h1 class="portfolio__title">
				<a class="portfolio__link" href="<?=get_permalink(get_the_ID())?>"><?=get_the_title()?></a>
			</h1>
			<div class="portfolio__description">
				<?php the_content(); ?>
			</div>
			<ul class="portfolio__meta">
				<li class="portfolio__meta__item portfolio__meta__item--views"><i class="fa fa-calendar-o"></i>&nbsp; <?php the_time('F j, Y'); ?></li>
				<li class="portfolio__meta__item portfolio__meta__item--date"><i class="fa fa-eye"></i>&nbsp; <?= get_the_pageview(get_the_ID())?></li>
			</ul>
		</header>
		<div class="portfolio__social">
			<iframe src="//www.facebook.com/plugins/like.php?href=<?= get_permalink(get_the_ID()) ?>&amp;width=280&amp;layout=standard&amp;action=like&amp;show_faces=false&amp;share=true&amp;height=80&amp;appId=242541585808831&amp;colorscheme=dark" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:280px; height:26px;" allowTransparency="true"></iframe>
		</div>
		<div class="portfolio__social">
			<div class="portfolio__social__item portfolio__social__item--nolink" data-type="fave" title="Count of photos">
				<i class="fa fa-picture-o"></i> <span class="portfolio__social__count"><?= count($tags_data) ?></span>
			</div>
			<div class="portfolio__social__item" data-type="fave" title="Fave this gallery">
				<i class="fa fa-star-o"></i> <span class="portfolio__social__count"><?= get_the_fave(get_the_ID()) ?></span>
			</div>
			<div class="portfolio__social__item" data-type="comment" title="Comment">
				<i class="fa fa-comment-o"></i> <span class="portfolio__social__count"><?= get_comments_number() ?></span>
			</div>
<!--			<div class="portfolio__social__item" data-type="share" title="Share this gallery">-->
<!--				<i class="fa fa-external-link"></i>-->
<!--			</div>-->
		</div>
		<div class="portfolio__comments">
			<?php
			if ( comments_open() || get_comments_number() ) {
				comments_template();
			}
			?>
		</div>
	</aside>
</article>
