<?php
/*
* Register Featured Post Manager
*/
add_action('init', 'mtheme_featured_register');

function mtheme_featured_register(){
    $args = array(
        'label' => __('Fullscreen Pages'),
		'description' => __('Manage your Fullscreen posts'),
        'singular_label' => __('Fullscreen'),
        'public' => true,
        'show_ui' => true,
        'capability_type' => 'post',
        'hierarchical' => false,
		'menu_position' => 5,
//    	'menu_icon' => get_template_directory_uri().'/framework/admin/images/featured.png',
        'rewrite' => array('slug' => 'fullscreen'),//Use a slug like "work" or "project" that shouldnt be same with your page name
        'supports' => array('title', 'editor', 'thumbnail')//Boxes will be shown in the panel
       );

    register_post_type( 'mtheme_featured' , $args );
}

/*
* Register Popular Post Manager
*/
add_action('init', 'mtheme_portfolio_register');//Always use a shortname like "mtheme_" not to see any 404 errors
 
function mtheme_portfolio_register(){
    $args = array(
        'label' => __('Portfolio List'),
        'singular_label' => __('Portfolio'),
        'public' => true,
        'show_ui' => true,
        'capability_type' => 'post',
        'hierarchical' => false,
		'menu_position' => 6,
//    	'menu_icon' => get_template_directory_uri().'/framework/admin/images/portfolio.png',
        'rewrite' => array('slug' => 'gallery'),//Use a slug like "work" or "project" that shouldnt be same with your page name
        'supports' => array('title', 'editor', 'thumbnail','comments')//Boxes will be shown in the panel
       );
 
    register_post_type( 'mtheme_portfolio1' , $args );
}
 
/*
* Call Initializer and Save options
*/
add_action("admin_init", "admin_init");
add_action('save_post', 'save_options');

/*
* Call Meta functions
*/
function admin_init(){
    add_meta_box("mtheme_featured-meta", "Featured Options", "featured_options", "mtheme_featured", "normal", "low");
	add_meta_box("mtheme_portfolioInfo-meta", "Portfolio Options", "meta_options", "mtheme_portfolio", "normal", "low");
}


/*
* Featured Meta Options
*/

function featured_options(){
    global $post;
    $featured_description="";
	$featured_link="";
	$fullscreen_type="";
	$slideshow_thumbnails="";
	$fullscreen_video_id="";
	$fullscreen_vimeo_id="";
	$fullscreen_slideshow_audio_mp3="";
	$fullscreen_slideshow_audio_oga="";
	$fullscreen_slideshow_audio_m4a="";
	$fullscreen_html_video="";
	
	$custom = get_post_custom($post->ID);
    if ( isset($custom["featured_description"][0]) ) { $featured_description = $custom["featured_description"][0]; }
	if ( isset($custom["featured_link"][0]) ) { $featured_link = $custom["featured_link"][0]; }
	
	if ( isset($custom["fullscreen_type"][0]) ) { $fullscreen_type = $custom["fullscreen_type"][0]; }
	if ( isset($custom["slideshow_thumbnails"][0]) ) { $slideshow_thumbnails = $custom["slideshow_thumbnails"][0]; }
	if ( isset($custom["fullscreen_video_id"][0]) ) { $fullscreen_video_id = $custom["fullscreen_video_id"][0]; }
	if ( isset($custom["fullscreen_vimeo_id"][0]) ) { $fullscreen_vimeo_id = $custom["fullscreen_vimeo_id"][0]; }
	if ( isset($custom["fullscreen_slideshow_audio_mp3"][0]) ) { $fullscreen_slideshow_audio_mp3 = $custom["fullscreen_slideshow_audio_mp3"][0]; }
	if ( isset($custom["fullscreen_slideshow_audio_m4a"][0]) ) { $fullscreen_slideshow_audio_m4a = $custom["fullscreen_slideshow_audio_m4a"][0]; }
	if ( isset($custom["fullscreen_slideshow_audio_oga"][0]) ) { $fullscreen_slideshow_audio_oga = $custom["fullscreen_slideshow_audio_oga"][0]; }
	if ( isset($custom["fullscreen_html_video"][0]) ) { $fullscreen_html_video = $custom["fullscreen_html_video"][0]; }
	
    ?>
	
	<?php
	echo '<p>';
	echo '<h2>Fullscreen page type</h2>';
	echo '<select name="fullscreen_type" id="fullscreen_type">';
	echo '<option', $fullscreen_type == "Slideshow" ? ' selected="selected"' : '', '>Slideshow</option>';
	echo '<option', $fullscreen_type == "Slideshow-plus-captions" ? ' selected="selected"' : '', '>Slideshow-plus-captions</option>';
	echo '<option', $fullscreen_type == "Fullscreen-Video" ? ' selected="selected"' : '', '>Fullscreen-Video</option>';
	echo '</select>';
	echo '</p>';
	?>
	
	<?php
	echo '<p>';
	echo '<h2>Slideshow Thumbnails</h2>';
	echo '<select name="slideshow_thumbnails" id="slideshow_thumbnails">';
	echo '<option', $slideshow_thumbnails == "Disable" ? ' selected="selected"' : '', '>Disable</option>';
	echo '<option', $slideshow_thumbnails == "Enable" ? ' selected="selected"' : '', '>Enable</option>';
	echo '</select>';
	echo '</p>';
	?>
	
    <p><label><h2><?php _e('Slideshow Audio files (optional)','mthemelocal'); ?></h2></label>
	<p class="description"><strong><?php _e('All entered files will be used with fallback for best cross browser experience','mthemelocal');?></strong></p>
	<p class="description"><?php _e('Enter MP3 file path for Slideshow','mthemelocal');?></p>
	<input style="width: 500px;" name="fullscreen_slideshow_audio_mp3" value="<?php if ( isset ($fullscreen_slideshow_audio_mp3) ) { echo $fullscreen_slideshow_audio_mp3; } ?>" />
	</p>
	
	<p class="description"><?php _e('Enter OGA file path for Slideshow','mthemelocal');?></p>
	<input style="width: 500px;" name="fullscreen_slideshow_audio_oga" value="<?php if ( isset ($fullscreen_slideshow_audio_oga) ) { echo $fullscreen_slideshow_audio_oga; } ?>" />
	</p>
	
	<p class="description"><?php _e('Enter M4A file path for Slideshow','mthemelocal');?></p>
	<input style="width: 500px;" name="fullscreen_slideshow_audio_m4a" value="<?php if ( isset ($fullscreen_slideshow_audio_m4a) ) { echo $fullscreen_slideshow_audio_m4a; } ?>" />
	</p>
	
    <p><label><h2><?php _e('Youtube or FLV video file path','mthemelocal'); ?></h2></label>
	<p class="description"><?php _e('
	Youtube URLS</br>
	http://www.youtube.com/watch?v=ylLzyHk54Z0
	<br/>
	','mthemelocal');?></p>
	<input style="width: 500px;" name="fullscreen_video_id" value="<?php if ( isset ($fullscreen_video_id) ) { echo $fullscreen_video_id; } ?>" />
	</p>
	
    <p><label><h2><?php _e('HTML5 Video url'); ?></h2></label>
	<p class="description"><?php _e('Plays fullscreen HTML5 video with fallback to Flash for HTML5 unsupported browsers','mthemelocal');?></p>
	<input style="width: 500px;" name="fullscreen_html_video" value="<?php if ( isset ($fullscreen_html_video) ) { echo $fullscreen_html_video; } ?>" />
	</p>
	

	
    <p><label><h2><?php _e('Vimeo video ID','mthemelocal'); ?></h2></label>
	<p class="description"><?php _e('Enter Vimeo video ID for fullscreen playback','mthemelocal');?></p>
	<input style="width: 500px;" name="fullscreen_vimeo_id" value="<?php if ( isset ($fullscreen_vimeo_id) ) { echo $fullscreen_vimeo_id; } ?>" />
	</p>
<?php
}

/*
* Initialize Admin Featured Viewable columns
*/
add_filter("manage_edit-mtheme_featured_columns", "mtheme_featured_edit_columns");
add_action("manage_posts_custom_column",  "mtheme_featured_custom_columns");

function mtheme_featured_edit_columns($columns){
    $columns = array(
        "cb" => "<input type=\"checkbox\" />",
        "title" => __('Featured Title'),
		"fullscreen_type" => __('Fullscreen Type')
    );
 
    return $columns;
}


/*
* Display Admin Featured Columns
*/

function mtheme_featured_custom_columns($column){
    global $post;
    $custom = get_post_custom();
	$image_url=wp_get_attachment_thumb_url( get_post_thumbnail_id( $post->ID ) );
	
	$full_image_id = get_post_thumbnail_id(($post->ID), 'full'); 
	$full_image_url = wp_get_attachment_image_src($full_image_id,'full');  
	$full_image_url = $full_image_url[0];
	
    switch ($column)
    {
        case "featured_image":
			if ( isset($image_url) ) {
            echo '<a class="thickbox" href="'.$full_image_url.'"><img src="'.$image_url.'" width="40px" height="40px" alt="featured" /></a>';
			} else {
			echo 'Image not found';
			}
            break;
        case "featured_description":
            if ( isset($custom["featured_description"][0]) ) {echo $custom["featured_description"][0]; }
            break;
        case "fullscreen_type":
            if ( isset($custom["fullscreen_type"][0]) ) { echo $custom["fullscreen_type"][0]; }
            break;
    } 
}

/*
* Meta options for Portfolio post type
*/
 
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

/*
* Save the Meta functions - Combined Featured and Portfolio
*/
 
function save_options(){
    global $post;
	
    //Fullscreen Data
	if ( isset($_POST["featured_description"]) ) { update_post_meta($post->ID, "featured_description", $_POST["featured_description"]); }
	if ( isset($_POST["featured_link"]) ) { update_post_meta($post->ID, "featured_link", $_POST["featured_link"]); }
	if ( isset($_POST["fullscreen_type"]) ) { update_post_meta($post->ID, "fullscreen_type", $_POST["fullscreen_type"]); }
	if ( isset($_POST["slideshow_thumbnails"]) ) { update_post_meta($post->ID, "slideshow_thumbnails", $_POST["slideshow_thumbnails"]); }
	if ( isset($_POST["fullscreen_video_id"]) ) { update_post_meta($post->ID, "fullscreen_video_id", $_POST["fullscreen_video_id"]); }
	if ( isset($_POST["fullscreen_vimeo_id"]) ) { update_post_meta($post->ID, "fullscreen_vimeo_id", $_POST["fullscreen_vimeo_id"]); }
	if ( isset($_POST["fullscreen_slideshow_audio_mp3"]) ) { update_post_meta($post->ID, "fullscreen_slideshow_audio_mp3", $_POST["fullscreen_slideshow_audio_mp3"]); }
	if ( isset($_POST["fullscreen_slideshow_audio_oga"]) ) { update_post_meta($post->ID, "fullscreen_slideshow_audio_oga", $_POST["fullscreen_slideshow_audio_oga"]); }
	if ( isset($_POST["fullscreen_slideshow_audio_m4a"]) ) { update_post_meta($post->ID, "fullscreen_slideshow_audio_m4a", $_POST["fullscreen_slideshow_audio_m4a"]); }
	if ( isset($_POST["fullscreen_html_video"]) ) { update_post_meta($post->ID, "fullscreen_html_video", $_POST["fullscreen_html_video"]); }
	
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
 
/*
* Add Taxonomy for Portfolio 'Type'
*/
register_taxonomy("types", array("mtheme_portfolio"), array("hierarchical" => true, "label" => "Work Type", "singular_label" => "Types", "rewrite" => true));
 
/*
* Hooks for the Portfolio and Featured viewables
*/
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

/*
* Portfolio Admin columns
*/
 
function mtheme_portfolio_custom_columns($column){
    global $post;
    $custom = get_post_custom();
	$image_url=wp_get_attachment_thumb_url( get_post_thumbnail_id( $post->ID ) );
	
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