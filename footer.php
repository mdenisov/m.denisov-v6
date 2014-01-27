

	</div>

	<div id="welcome" class="welcome">
		<span class="welcome__logo"></span>
	</div>

	<div id="loader" class="loader">
		<span class="loader__progress">92</span>
	</div>

	<?php wp_footer(); ?>

	<script type="text/javascript">

		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', 'UA-33524021-1']);
		_gaq.push(['_trackPageview']);

		(function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		})();

	</script>

	<script data-main="<?php echo get_template_directory_uri(); ?>/js/main" src="<?php echo get_template_directory_uri(); ?>/js/vendor/bower_components/requirejs/require.js"></script>
</body>
</html>