<?php
/**
 * The template used for displaying portfolio content
 */
?>

<?php

$rootpath = get_stylesheet_directory_uri();
$timthumb_path = $rootpath . '/timthumb.php';

$custom = get_post_custom(get_the_ID());
$portfolio_cats = get_the_terms( get_the_ID(), 'types' );
$video_url = "";
$thumbnail = "";
$link_url = "";

if ( isset($custom["video"][0]) ) { $video_url=$custom["video"][0]; }
if ( isset($custom["thumbnail"][0]) ) { $thumbnail=$custom["thumbnail"][0]; }
if ( isset($custom["custom_link"][0]) ) { $link_url=$custom["custom_link"][0]; }

if ( isset($custom["portfolio_type"][0]) )
	$type = strtolower($custom["portfolio_type"][0]);
else
	$type = 'image';

$height = 320;
$width = 320;
$rowspan = 1;
$colspan = 1;

if ( isset($custom["portfolio_page_size"][0]) )
	$size = strtolower($custom["portfolio_page_size"][0]);
else
	$size = 'small';

switch ( $size ) {
	case 'small' :
		$height = 320;
		$width = 320;
		break;

	case 'medium' :
		$height = 320;
		$width = 320;
		break;

	case 'big' :
		$height = 640;
		$width = 640;
		$rowspan = 2;
		$colspan = 2;
		break;

	default :
		$height = 320;
		$width = 320;
		break;
}

$tags = array();

if ($portfolio_cats) {
	foreach ($portfolio_cats as $taxonomy) {
		$tags[] = $taxonomy->slug;
	}
}

if ( $type == 'image' ) {
	$imageURI = featured_image_link( get_the_ID() );
	$real_imageURI = wpmu_image_path ( $imageURI );
	$resized_imageURI = $timthumb_path . '?src=' . $real_imageURI . '&w='. $width .'&h='. $height .'&q=72';
} else {
	$imageURI = '';
	$resized_imageURI = '';
}

?>

<article id="post-<?php the_ID(); ?>" class="portfolio__item portfolio__size--<?= $size ?>" <?php //post_class(); ?> data-rowspan="<?= $rowspan ?>" data-colspan="<?= $colspan ?>">
	<div class="portfolio__item__block">
		<a class="portfolio__link" href="<?=get_permalink(get_the_ID())?>">
			<img class="portfolio__preview" src="<?=$resized_imageURI?>" alt="<?=get_the_title()?>">
		</a>
		<div class="portfolio__content">
			<header class="portfolio__header">
				<h1 class="portfolio__title">
					<a class="portfolio__link" href="<?=get_permalink(get_the_ID())?>"><?=get_the_title()?></a>
				</h1>
			</header>
		</div>
	</div>
</article>
