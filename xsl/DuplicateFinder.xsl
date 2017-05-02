<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" doctype-system="about:legacy-compat"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Duplicate Finder Report</title>

                <style>
                    body {
                        font-family: sans-serif;
                        color: #333;
                    }

                    .hljs{display:block;overflow-x:auto;padding:0.5em;background:#F0F0F0}.hljs,.hljs-subst{color:#444}.hljs-comment{color:#888888}.hljs-keyword,.hljs-attribute,.hljs-selector-tag,.hljs-meta-keyword,.hljs-doctag,.hljs-name{font-weight:bold}.hljs-type,.hljs-string,.hljs-number,.hljs-selector-id,.hljs-selector-class,.hljs-quote,.hljs-template-tag,.hljs-deletion{color:#880000}.hljs-title,.hljs-section{color:#880000;font-weight:bold}.hljs-regexp,.hljs-symbol,.hljs-variable,.hljs-template-variable,.hljs-link,.hljs-selector-attr,.hljs-selector-pseudo{color:#BC6060}.hljs-literal{color:#78A960}.hljs-built_in,.hljs-bullet,.hljs-code,.hljs-addition{color:#397300}.hljs-meta{color:#1f7199}.hljs-meta-string{color:#4d99bf}.hljs-emphasis{font-style:italic}.hljs-strong{font-weight:bold}
                </style>
            </head>
            <body>
                <h1>Statistics</h1>
                <p>Total codebase size: <xsl:value-of select="format-number(//CodebaseCost, '#,###')"/></p>
                <p>Code to analyze: <xsl:value-of select="format-number(//TotalDuplicatesCost, '#,###')"/></p>
                <p>Total size of duplicated fragments: <xsl:value-of select="format-number(//CodebaseCost, '#,###')" /></p>
                <p>Total number of duplicates found: <xsl:value-of select="format-number(count(//Duplicates/Duplicate), '#,###')" /></p>
                <h1>Detected Duplicates</h1>
                <xsl:for-each select="//Duplicates/Duplicate">
                    <h3>Cost: <xsl:value-of  select="format-number(@Cost, '#,###')"/></h3>
                    <xsl:for-each select="Fragment">
                        <xsl:variable name="i" select="position()"/>
                        <details>
                            <summary>Fragment <xsl:value-of select="$i"/>  in file <xsl:value-of select="FileName"/> (lines <xsl:value-of select="LineRange/@Start"/> - <xsl:value-of select="LineRange/@End"/>)</summary>
                            <pre><code class="cs"><xsl:value-of select="Text"/></code></pre>
                        </details>
                    </xsl:for-each>
                </xsl:for-each>

                <script src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.11.0/highlight.min.js"></script>
                <script>hljs.initHighlightingOnLoad();</script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>