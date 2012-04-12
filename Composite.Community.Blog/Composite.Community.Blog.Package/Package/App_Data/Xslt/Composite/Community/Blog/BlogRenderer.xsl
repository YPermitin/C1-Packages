﻿<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:in="http://www.composite.net/ns/transformation/input/1.0" xmlns:lang="http://www.composite.net/ns/localization/1.0" xmlns:f="http://www.composite.net/ns/function/1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:c1="http://c1.composite.net/StandardFunctions" xmlns:mp="#MarkupParserExtensions" xmlns:be="#BlogXsltExtensionsFunction" xmlns:addthis="http://addthis.com/plugins" exclude-result-prefixes="xsl in lang f c1 mp be">
	<xsl:param name="pageId" select="/in:inputs/in:result[@name='GetPageId']" />
	<xsl:param name="pagingInfo" select="/in:inputs/in:result[@name='GetEntriesXml']/PagingInfo" />
	<xsl:variable name="isBlogItem" select="be:IsBlogList()" />
	<xsl:variable name="currentCultureName" select="be:GetCurrentCultureName()" />
	<xsl:variable name="blogListOptions" select="/in:inputs/in:param[@name='BlogListOptions']" />
	<xsl:variable name="blogItemOptions" select="/in:inputs/in:param[@name='BlogItemOptions']" />
	<xsl:template match="/">
		<html>
			<head>
				<xsl:if test="$isBlogItem='true'">
					<title>
						<xsl:value-of select="/in:inputs/in:result[@name='GetEntriesXml']/Entries/@Title" />
					</title>
				</xsl:if>
				<link id="BlogStyles" rel="stylesheet" type="text/css" href="~/Frontend/Composite/Community/Blog/Styles.css" />
			</head>
			<body>
				<div class="Blog">
					<xsl:choose>
						<xsl:when test="$isBlogItem='true'">
							<xsl:apply-templates mode="BlogItem" select="/in:inputs/in:result[@name='GetEntriesXml']/Entries">
								<xsl:with-param name="options" select="$blogItemOptions" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="/in:inputs/in:result[@name='GetEntriesXml']/Entries">
								<xsl:apply-templates mode="BlogItem" select=".">
									<xsl:with-param name="options" select="$blogListOptions" />
								</xsl:apply-templates>
								<div class="line-separator"></div>
							</xsl:for-each>
							<xsl:if test="$pagingInfo/@TotalPageCount &gt; 1">
								<div class="BlogPaging">
									<xsl:apply-templates select="$pagingInfo" />
								</div>
							</xsl:if>
							<xsl:if test="contains($blogListOptions, 'Show RSS')">
								<div class="BlogRSS">
									<a title="Blog Feed" href="~/BlogRssFeed.ashx?bid={$pageId}&amp;cultureName={$currentCultureName}">Blog RSS</a>
									&#160;|&#160;
									<a title="Blog Comments Feed" href="~/BlogCommentsRssFeed.ashx">Comments RSS</a>
								</div>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="be:SetNoCache()" />
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template mode="BlogItem" match="*">
		<xsl:param name="options" />
		<div class="BlogItem">
			<div class="BlogTitle">
				<h1>
					<xsl:choose>
						<xsl:when test="$isBlogItem='true'">
							<xsl:value-of select="@Title" />
						</xsl:when>
						<xsl:otherwise>
							<a href="{be:GetBlogUrl(@Date, @Title)}" title="{@Title}">
								<xsl:value-of select="@Title" />
							</a>
							<xsl:if test="@DisplayComments = 'true'">
								<a class="t-count" href="{be:GetBlogUrl(@Date, @Title)}#newcomment">
									<span>
										<xsl:call-template name="CommentsCount" />
									</span>
								</a>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</h1>
			</div>
			<xsl:if test="@Image.Id != '' and contains($options, 'Show image')">
				<img class="BlogImage" border="0" src="~/media({@Image.Id})" alt="{@Image.Title}" />
			</xsl:if>
			<xsl:if test="contains($options, 'Show author')">
				<xsl:call-template name="Author" />
			</xsl:if>
			<xsl:if test="contains($options, 'Show date')">
				<xsl:call-template name="Date" />
			</xsl:if>
			<xsl:variable name="Tags" select="be:GetBlogTags(@Tags)/Tag" />
			<xsl:if test="count($Tags)&gt;0 and contains($options, 'Show tags')">
				<div class="BlogTags">
					<span>
						<xsl:value-of select="be:GetLocalized('Blog','subjectsText')" />
					</span>
					<xsl:apply-templates mode="TagsList" select="$Tags" />
				</div>
			</xsl:if>
			<xsl:if test="contains($options, 'Show teaser')">
				<div class="BlogTeaser">
					<xsl:value-of select="@Teaser" />
				</div>
			</xsl:if>
			<xsl:if test="contains($options, 'Show content')">
				<div class="BlogContent">
					<xsl:copy-of select="mp:ParseXhtmlBodyFragment(@Content)" />
				</div>
			</xsl:if>
			<xsl:if test="contains($options, 'Show share icons')">
				<xsl:call-template name="AddThis" />
			</xsl:if>
			<xsl:if test="$isBlogItem='true'">
				<xsl:if test="@DisplayComments = 'true'">
					<xsl:variable name="blogComments">
						<f:function name="Composite.Community.Blog.Comments">
							<f:param name="BlogEntryGuid" value="{@Id}" />
							<f:param name="AllowNewComments" value="{@AllowNewComments}" />
						</f:function>
					</xsl:variable>
					<xsl:copy-of select="c1:CallFunction($blogComments)" />
				</xsl:if>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="Author">
		<xsl:if test="@Author.Picture != ''">
			<img class="BlogAuthorPicture" border="0" src="~/Renderers/ShowMedia.ashx?i={@Author.Picture}" alt="{@Author.Name}" />
		</xsl:if>
		<div class="BlogAuthor">
			<span>
				<xsl:value-of select="be:GetLocalized('Blog','writtenByText')" />
			</span>&#160;
			<xsl:choose>
				<xsl:when test="@Author.Email != '' and @Author.DisplayEmail = 'true'">
					<a href="mailto:{@Author.Email}">
						<xsl:value-of select="@Author.Name" />
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@Author.Name" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template name="Date">
		<div class="BlogDate">
			<span>
				<xsl:value-of select="be:GetLocalized('Blog','dateText')" />
			</span>&#160;
			<xsl:value-of select="be:CustomDateFormat(@Date, 'dd MMMM yyyy')" />
		</div>
	</xsl:template>
	<xsl:template mode="TagsList" match="*">
		<a href="{be:GetCurrentPageUrl()}/{be:Encode(string(.))}" title="{.}">
			<xsl:value-of select="." />
		</a>
	</xsl:template>
	<xsl:template name="CommentsCount">
		<xsl:variable name="commentsCount" select="/in:inputs/in:result[@name='GetCommentsCount']/Comment[@Id=current()/@Id]/@Count" />
		<xsl:variable name="Count">
			<xsl:choose>
				<xsl:when test="$commentsCount">
					<xsl:value-of select="$commentsCount" />
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$Count" />
	</xsl:template>
	<xsl:template name="AddThis">
		<a class="AddThis" href="http://www.addthis.com/bookmark.php?v=250&amp;url={be:GetFullBlogUrl(@Date, @Title)}&amp;title={@Title}">
			<img src="http://s7.addthis.com/static/btn/v2/lg-share-en.gif" width="125" height="16" alt="Bookmark and Share" style="border:0" />
		</a>
	</xsl:template>
	<xsl:template match="PagingInfo">
		<xsl:param name="page" select="1" />
		<xsl:if test="$page &lt; @TotalPageCount + 1">
			<xsl:if test="$page = @CurrentPageNumber">
				<span>
					<xsl:value-of select="$page" />
				</span>
			</xsl:if>
			<xsl:if test="not($page = @CurrentPageNumber)">
				<a href="{be:GetCurrentPageUrl()}?p={$page}">
					<xsl:value-of select="$page" />
				</a>
			</xsl:if>
			<xsl:apply-templates select=".">
				<xsl:with-param name="page" select="$page+1" />
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>