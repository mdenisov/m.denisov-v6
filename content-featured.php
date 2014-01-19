<?php
/**
 * The template for displaying featured content
 */
?>

<?php

$rootpath = get_stylesheet_directory_uri();
$timthumb_path = $rootpath . '/timthumb.php';

$real_imageURI = get_theme_mod('featured_image');

$resized_imageURI = $timthumb_path . '?src=' . $real_imageURI . '&w=640&h=640&q=72';

?>

<article id="post-1" class="portfolio__item portfolio__item--stub portfolio__size--big" data-rowspan="2" data-colspan="2">
	<div class="portfolio__item__block">
		<div class="portfolio__stub">
			<img class="portfolio__stub__img" src="<?= $rootpath . '/img/photography.png' ?>">
		</div>
		<div class="portfolio__link">
			<img class="portfolio__preview" src="<?= $resized_imageURI ?>">
		</div>
	</div>
</article>
