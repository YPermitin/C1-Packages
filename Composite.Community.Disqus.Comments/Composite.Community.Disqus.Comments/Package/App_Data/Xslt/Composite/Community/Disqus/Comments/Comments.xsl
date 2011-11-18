﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:in="http://www.composite.net/ns/transformation/input/1.0"
	xmlns:lang="http://www.composite.net/ns/localization/1.0"
	xmlns:f="http://www.composite.net/ns/function/1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xsl in lang f">

	<xsl:param name="siteShortname" select="/in:inputs/in:param[@name='SiteShortname']" />

	<xsl:template match="/">
		<html>
			<head />
			<body>
				<div id="disqus_thread"></div>
				<script type="text/javascript">
					/* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
					var disqus_shortname = '<xsl:value-of select="$siteShortname" />'; // required: replace example with your forum shortname
					<xsl:if test="/in:inputs/in:param[@name='Developer'] = 'True'">
						var disqus_developer = 1; // developer mode
					</xsl:if>
					

					/* * * DON'T EDIT BELOW THIS LINE * * */
					(function() {
					var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
					dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
					(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
					})();
				</script>
				<noscript>
					Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a>
				</noscript>
				<a href="http://disqus.com" class="dsq-brlink">
					blog comments powered by <span class="logo-disqus">Disqus</span>
				</a>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
