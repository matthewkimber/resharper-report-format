<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:my="http://my" 
                version="2.0">
    <xsl:output method="html" indent="yes" encoding="utf-8" />

    <xsl:function name="my:provideDefault">
        <xsl:param name="arg" />

        <xsl:choose>
            <xsl:when test="not($arg)">
                0
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$arg" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <html>
            <head>
                <title>Code Inspection Report</title>

                <style>
                    body {
                        font-family: sans-serif;
                        color: #333;
                    }
                </style>
            </head>
            <body>
                <h1>Code Inspection Report</h1>
                <div id="content"></div>

                <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.7/handlebars.min.js"></script>
                <script id="metadata-template" type="text/x-handlebars-template">
                    <dl>
                        <dt>Tools Version</dt>
                        <dd>{{metadata.toolsVersion}}</dd>
                        <dt>Solution</dt>
                        <dd>{{{metadata.solution}}}</dd>
                        <dt>Scope</dt>
                        <dd>{{metadata.scope}}</dd>
                    </dl>
                </script>
                <script id="project-template" type="text/x-handlebars-template">
                    <div class="project">
                        {{#each projects}}
                        <h3>{{name}}</h3>
                        <ul>
                            {{#each issues}}
                                <li>{{file}}:{{line}}</li>
                            {{/each}}
                        </ul>
                        {{/each}}
                    </div>
                </script>
                <script>
                    (function() {
                        var report = {
                            metadata: {
                                toolsVersion: &quot;<xsl:value-of select="//Report/@ToolsVersion" />&quot;,
                                solution: &quot;<xsl:value-of select="replace(//Report/Information/Solution, '\\', '\\\\')" />&quot;,
                                scope: &quot;<xsl:value-of select="//Report/Information/InspectionScope/Element" />&quot;
                            },
                            issueTypes: [<xsl:for-each select="//IssueTypes/IssueType">
                                {
                                    id: &quot;<xsl:value-of select="@Id" />&quot;,category: &quot;<xsl:value-of select="@Category" />&quot;,categoryId: &quot;<xsl:value-of select="@CategoryId" />&quot;,description: &quot;<xsl:value-of select="@Description" />&quot;,severity: &quot;<xsl:value-of select="@Severity" />&quot;,wikiUrl: &quot;<xsl:value-of select="@WikiUrl" />&quot;
                                }<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
                            projects: [<xsl:for-each select="//Issues/Project">
                                {
                                    name: &quot;<xsl:value-of select="@Name" />&quot;,
                                    issues: [<xsl:for-each select="Issue">
                                        {typeId:&quot;<xsl:value-of select="@TypeId" />&quot;,file:&quot;<xsl:value-of select="replace(@File, '\\', '\\\\')" />&quot;,line:<xsl:value-of select="my:provideDefault(@Line)" />,msg:&quot;<xsl:value-of select="replace(@Message, '[\\&quot;]', '&amp;quot;')" />&quot;}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
                                    ]
                                }<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
                            ]
                        };

                        var content = document.getElementById('content');

                        var observer = new MutationObserver(function(mutations) {
                            mutations.forEach(function(mutation) {
                                console.log(mutation);
                            });
                        });

                        var observerConfig = {
                            subtree: true
                        };

                        observer.observe(content, observerConfig);

                        var metadataTempl = Handlebars.compile(document.getElementById('metadata-template').innerHTML);
                        var projectTempl = Handlebars.compile(document.getElementById('project-template').innerHTML);

                        content.innerHTML = metadataTempl(report);
                        content.innerHTML += projectTempl(report);
                    }());
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>