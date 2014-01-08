<?php

// Register Custom Post Type
function mtheme_portfolio() {

	$labels = array(
		'name'                => _x( 'Portfolio', 'Post Type General Name', 'mdenisov' ),
		'singular_name'       => _x( 'Portfolio', 'Post Type Singular Name', 'mdenisov' ),
		'menu_name'           => __( 'Portfolio', 'mdenisov' ),
		'parent_item_colon'   => __( 'Parent Portfolio:', 'mdenisov' ),
		'all_items'           => __( 'All Portfolio', 'mdenisov' ),
		'view_item'           => __( 'View Portfolio', 'mdenisov' ),
		'add_new_item'        => __( 'Add New Portfolio', 'mdenisov' ),
		'add_new'             => __( 'New Portfolio', 'mdenisov' ),
		'edit_item'           => __( 'Edit Portfolio', 'mdenisov' ),
		'update_item'         => __( 'Update Portfolio', 'mdenisov' ),
		'search_items'        => __( 'Search portfolio', 'mdenisov' ),
		'not_found'           => __( 'No portfolio found', 'mdenisov' ),
		'not_found_in_trash'  => __( 'No portfolio found in Trash', 'mdenisov' ),
	);

	$rewrite = array(
		'slug'                => 'gallery',
		'with_front'          => true,
		'pages'               => true,
		'feeds'               => true,
	);

	$args = array(
		'label'               => __( 'portfolio', 'mdenisov' ),
		'description'         => __( 'Portfolio information pages', 'mdenisov' ),
		'labels'              => $labels,
		'supports'            => array( 'title', 'editor', 'excerpt', 'thumbnail', 'comments', 'post-formats', ),
		'taxonomies'          => array( 'portfolio_tag' ),
		'hierarchical'        => false,
		'public'              => true,
		'show_ui'             => true,
		'show_in_menu'        => true,
		'show_in_nav_menus'   => true,
		'show_in_admin_bar'   => true,
		'menu_position'       => 5,
//		'menu_icon'           => '',
		'can_export'          => true,
		'has_archive'         => true,
		'exclude_from_search' => false,
		'publicly_queryable'  => true,
		'query_var'           => 'mtheme_portfolio',
		'rewrite'             => $rewrite,
		'capability_type'     => 'post',
	);
	register_post_type( 'mtheme_portfolio', $args );

}

// Hook into the 'init' action
add_action( 'init', 'mtheme_portfolio', 0 );

add_action("admin_init", "admin_init");
add_action('save_post', 'save_options');

function admin_init() {
	add_meta_box("mtheme_portfolio-meta", "Portfolio Options", "meta_options", "mtheme_portfolio", "normal", "low");
}

function meta_options(){
	global $post;
	$custom = get_post_custom($post->ID);

	$thumbnail = "";
	$video = "";
	$description = "";
	$custom_link = "";
	$portfolio_background_choice = "";
	$portfolio_videoembed="";
	$portfolio_page_header="";
	$portfolio_slide_height="";
	$portfolio_page_size="";
	$portfolio_type="";

	if ( isset($custom["thumbnail"][0]) ) { $thumbnail = $custom["thumbnail"][0]; }
	if ( isset($custom["video"][0]) ) { $video = $custom["video"][0]; }
	if ( isset($custom["description"][0]) ) { $description = $custom["description"][0]; }
	if ( isset($custom["custom_link"][0]) ) { $custom_link = $custom["custom_link"][0]; }
	if ( isset($custom["portfolio_background_choice"][0]) ) { $portfolio_background_choice = $custom["portfolio_background_choice"][0]; }
	if ( isset($custom["portfolio_videoembed"][0]) ) { $portfolio_videoembed = $custom["portfolio_videoembed"][0]; }
	if ( isset($custom["portfolio_page_header"][0]) ) { $portfolio_page_header = $custom["portfolio_page_header"][0]; }
	if ( isset($custom["portfolio_slide_height"][0]) ) { $portfolio_slide_height = $custom["portfolio_slide_height"][0]; }
	if ( isset($custom["portfolio_page_size"][0]) ) { $portfolio_page_size = $custom["portfolio_page_size"][0]; }
	if ( isset($custom["portfolio_type"][0]) ) { $portfolio_type = $custom["portfolio_type"][0]; }
	?>

	<label><h1><?php _e('Thumbnail gallery options','mthemelocal'); ?></h1></label>

	<?php
	echo '<p>';
	echo '<label><h4>Item type</h4></label>';
	echo '<select name="portfolio_page_size" id="portfolio_page_size">';
	echo '<option', $portfolio_page_size == "Default" ? ' selected="selected"' : '', '>Default</option>';
	echo '<option', $portfolio_page_size == "Small" ? ' selected="selected"' : '', '>Small</option>';
	echo '<option', $portfolio_page_size == "Medium" ? ' selected="selected"' : '', '>Medium</option>';
	echo '<option', $portfolio_page_size == "Big" ? ' selected="selected"' : '', '>Big</option>';
	echo '</select>';
	echo '</p>';
	?>

	<label><h1><?php _e('Post type','mthemelocal'); ?></h1></label>

	<?php
	echo '<p>';
	echo '<label><h4>Item size</h4></label>';
	echo '<select name="portfolio_type" id="portfolio_type">';
	echo '<option', $portfolio_type == "Image" ? ' selected="selected"' : '', '>Image</option>';
	echo '<option', $portfolio_type == "Text" ? ' selected="selected"' : '', '>Text</option>';
	echo '</select>';
	echo '</p>';
	?>

	<p><label><h4><?php _e('Description:','mthemelocal'); ?></h4></label><textarea style="width: 95%;" name="description"><?php echo $description; ?></textarea></p>
	<p><label><h4><?php _e('Optional Thumbnail:','mthemelocal'); ?></h4></label>
	<p class="description"><?php _e('Please provide optional thumbnail image path for your portfolio thumbnails. If empty the featured image attached will be cropped to show the thumbnail. <br/><strong>Small Portfolio thumbnail size</strong> 310px x 200px<br/><strong>Large Portfolio thumbnail size</strong> 475px x 300px<br/>','mthemelocal');?></p>
	<input style="width: 95%;" name="thumbnail" value="<?php echo $thumbnail; ?>" />
	</p>

	<p><label><h4><?php _e('Video URL:','mthemelocal'); ?></h4></label>
	<p class="description"><?php _e('Eg.<br/>http://www.youtube.com/watch?v=D78TYCEG4<br/>http://vimeo.com/172881<br/>http://www.adobe.com/products/flashplayer/include/marquee/design.swf?width=792&height=294','mthemelocal');?></p>
	<input style="width: 95%;" name="video" value="<?php echo $video; ?>" />
	</p>

	<p>
		<label>
			<h4><?php _e('Link to ( optional )','mthemelocal'); ?></h4>
		</label>
	<p class="description">This option will redirect to the given url instead of Portfolio page.</p>
	<input style="width: 95%;" name="custom_link" value="<?php if ( isset ($custom_link) ) { echo $custom_link; } ?>" />
	</p>

	<label><h1><?php _e('Portfolio details page options','mthemelocal'); ?></h1></label>

	<?php
	echo '<p>';
	echo '<label><h4>Background image Settings</h4></label>';
	echo '<p class="description">Sets fullscreen background image for the portfolio page from these settings</p>';
	echo '<select name="portfolio_background_choice" id="portfolio_background_choice">';
	echo '<option', $portfolio_background_choice == "Use theme option setting" ? ' selected="selected"' : '', '>Use theme option setting</option>';
	echo '<option', $portfolio_background_choice == "Use featured image" ? ' selected="selected"' : '', '>Use featured image</option>';
	echo '</select>';
	echo '</p>';
	?>

	<?php
	echo '<p>';
	echo '<label><h4>Portfolio Page header displays</h4></label>';
	echo '<p class="description">Portfolio page header. Slideshow is generated from image attachments inside the portfolio page.</p>';
	echo '<select name="portfolio_page_header" id="portfolio_page_header">';
	echo '<option', $portfolio_page_header == "None" ? ' selected="selected"' : '', '>None</option>';
	echo '<option', $portfolio_page_header == "Image" ? ' selected="selected"' : '', '>Image</option>';
	echo '<option', $portfolio_page_header == "Slideshow" ? ' selected="selected"' : '', '>Slideshow</option>';
	echo '<option', $portfolio_page_header == "Video Embed" ? ' selected="selected"' : '', '>Video Embed</option>';
	echo '</select>';
	echo '</p>';
	?>

	<p>
		<label>
			<h4><?php _e('Slideshow height','mthemelocal'); ?></h4>
		</label>
	<p class="description">Slideshow image height.</p>
	<input style="width: 200px;" name="portfolio_slide_height" value="<?php echo $portfolio_slide_height; ?>" />
	</p>

	<p>
		<label>
			<h4><?php _e('Video Embed Code','mthemelocal'); ?></h4>
		</label>
	<p class="description">Video embed code which displays any embed code video in the page header ( ideal width is 700px )</p>
	<textarea style="width: 95%;" name="portfolio_videoembed"><?php echo $portfolio_videoembed; ?></textarea>
	</p>

<?php
}

function save_options(){
	global $post;

	//Portfolio Data
	if ( isset($_POST["thumbnail"]) ) { update_post_meta($post->ID, "thumbnail", $_POST["thumbnail"]); }
	if ( isset($_POST["video"]) ) { update_post_meta($post->ID, "video", $_POST["video"]); }
	if ( isset($_POST["portfolio_videoembed"]) ) { update_post_meta($post->ID, "portfolio_videoembed", $_POST["portfolio_videoembed"]); }
	if ( isset($_POST["description"]) ) { update_post_meta($post->ID, "description", $_POST["description"]); }
	if ( isset($_POST["custom_link"]) ) { update_post_meta($post->ID, "custom_link", $_POST["custom_link"]); }
	if ( isset($_POST["portfolio_background_choice"]) ) { update_post_meta($post->ID, "portfolio_background_choice", $_POST["portfolio_background_choice"]); }
	if ( isset($_POST["portfolio_page_header"]) ) { update_post_meta($post->ID, "portfolio_page_header", $_POST["portfolio_page_header"]); }
	if ( isset($_POST["portfolio_slide_height"]) ) { update_post_meta($post->ID, "portfolio_slide_height", $_POST["portfolio_slide_height"]); }
	if ( isset($_POST["portfolio_page_size"]) ) { update_post_meta($post->ID, "portfolio_page_size", $_POST["portfolio_page_size"]); }
	if ( isset($_POST["portfolio_type"]) ) { update_post_meta($post->ID, "portfolio_type", $_POST["portfolio_type"]); }
}

register_taxonomy("types", array("mtheme_portfolio"), array("hierarchical" => true, "label" => "Work Type", "singular_label" => "Types", "rewrite" => true));

add_filter("manage_edit-mtheme_portfolio_columns", "mtheme_portfolio_edit_columns");
add_action("manage_posts_custom_column",  "mtheme_portfolio_custom_columns");

function mtheme_portfolio_edit_columns($columns){
	$columns = array(
		"cb" => "<input type=\"checkbox\" />",
		"title" => __('Portfolio Title'),
		"description" => __('Description'),
		"video" => __('Video'),
		"types" => __('Types'),
		"portfolio_image" => __('Image')
	);

	return $columns;
}

function mtheme_portfolio_custom_columns($column){
	global $post;
	$custom = get_post_custom();
	$image_url = wp_get_attachment_thumb_url( get_post_thumbnail_id( $post->ID ) );

	$full_image_id = get_post_thumbnail_id(($post->ID), 'full');
	$full_image_url = wp_get_attachment_image_src($full_image_id,'full');
	$full_image_url = $full_image_url[0];

	switch ($column)
	{
		case "portfolio_image":
			if ( isset($image_url) ) {
				echo '<a class="thickbox" href="'.$full_image_url.'"><img src="'.$image_url.'" width="40px" height="40px" alt="featured" /></a>';
			} else {
				echo __('Image not found','mthemelocal');
			}
			break;
		case "description":
			if ( isset($custom["description"][0]) ) { echo $custom["description"][0]; }
			break;
		case "video":
			if ( isset($custom["video"][0]) ) { echo $custom["video"][0]; }
			break;
		case "types":
			echo get_the_term_list($post->ID, 'types', '', ', ','');
			break;
	}
}

?>