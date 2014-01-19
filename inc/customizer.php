<?php


function themeslug_theme_customizer( $wp_customize ) {
	// Logo upload
	$wp_customize->add_section( 'featured_image_section' , array(
		'title'       => __( 'Featured image' ),
		'priority'    => 30,
		'description' => 'Upload a featured to replace the default image',
	) );
	$wp_customize->add_setting( 'featured_image' );
	$wp_customize->add_control( new WP_Customize_Image_Control( $wp_customize, 'featured_image', array(
		'label'        => __( 'Featured image' ),
		'section'    => 'featured_image_section',
		'settings'   => 'featured_image',
	) ) );
}

add_action('customize_register', 'themeslug_theme_customizer');
