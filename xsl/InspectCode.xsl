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
                <title>R# Code Inspection Report for &quot;<xsl:value-of select="replace(//Report/Information/Solution, '\\', '\\\\')" />&quot;</title>

                <link href="https://fonts.googleapis.com/css?family=Roboto:400,500" rel="stylesheet" />

                <style>
                    body {
                        font-family: "Roboto", sans-serif; 
                        font-weight: 400;
                        color: rgba(0,0,0,0.87);
                        background: #f5f5f5;
                        margin: 0;
                        padding: 0;
                    }

                    h1, h2, h3, h4, h5, h6 {
                        font-weight: normal;
                    }

                    .showbox {
                        position: absolute;
                        top: 0;
                        bottom: 0;
                        left: 0;
                        right: 0;
                        padding: 5%;
                    }

                    .loader {
                        position: relative;
                        margin: 0 auto;
                        width: 100px;
                    }

                    .loader:before {
                        content: '';
                        display: block;
                        padding-top: 100%;
                    }

                    .circular {
                        -webkit-animation: rotate 2s linear infinite;
                                animation: rotate 2s linear infinite;
                        height: 100%;
                        -webkit-transform-origin: center center;
                                transform-origin: center center;
                        width: 100%;
                        position: absolute;
                        top: 0;
                        bottom: 0;
                        left: 0;
                        right: 0;
                        margin: auto;
                    }

                    .path {
                        stroke-dasharray: 1, 200;
                        stroke-dashoffset: 0;
                        -webkit-animation: dash 1.5s ease-in-out infinite, color 6s ease-in-out infinite;
                                animation: dash 1.5s ease-in-out infinite, color 6s ease-in-out infinite;
                        stroke-linecap: round;
                    }

                    @-webkit-keyframes rotate {
                        100% {
                            -webkit-transform: rotate(360deg);
                                    transform: rotate(360deg);
                        }
                    }

                    @keyframes rotate {
                        100% {
                            -webkit-transform: rotate(360deg);
                                    transform: rotate(360deg);
                        }
                    }

                    @-webkit-keyframes dash {
                        0% {
                            stroke-dasharray: 1, 200;
                            stroke-dashoffset: 0;
                        }
                        50% {
                            stroke-dasharray: 89, 200;
                            stroke-dashoffset: -35px;
                        }
                        100% {
                            stroke-dasharray: 89, 200;
                            stroke-dashoffset: -124px;
                        }
                    }

                    @keyframes dash {
                        0% {
                            stroke-dasharray: 1, 200;
                            stroke-dashoffset: 0;
                        }
                        50% {
                            stroke-dasharray: 89, 200;
                            stroke-dashoffset: -35px;
                        }
                        100% {
                            stroke-dasharray: 89, 200;
                            stroke-dashoffset: -124px;
                        }
                    }

                    @-webkit-keyframes color {
                        100%,
                        0% {
                            stroke: #d62d20;
                        }
                        40% {
                            stroke: #0057e7;
                        }
                        66% {
                            stroke: #008744;
                        }
                        80%,
                        90% {
                            stroke: #ffa700;
                        }
                    }

                    @keyframes color {
                        100%,
                        0% {
                            stroke: #d62d20;
                        }
                        40% {
                            stroke: #0057e7;
                        }
                        66% {
                            stroke: #008744;
                        }
                        80%,
                        90% {
                            stroke: #ffa700;
                        }
                    }

                    .loading {
                        display: none;
                    }

                    .radio-button-list {
                        list-style: none;
                        padding: 0;
                        margin: 0;
                    }

                    .radio-button-list li {
                        padding: 5px 0;
                    }

                    .radio-button-list label {
                        padding-left: 10px;
                    }

                    .panel {
                        background: #fff;
                        border: 1px solid #ccc;
                        box-shadow: 0 1px 2px rgba(0,0,0,0.1);
                        padding: 10px 10px 20px 10px;
                        margin: 0 0 20px 0;
                    }

                    .panel h3 {
                        margin: 0 0 10px 0;
                        padding: 0;
                    }

                    .loading {
                        left: 0;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        background: #fff;
                        margin: 0;
                        padding: 0;
                    }

                    .loading .loader {
                        padding-top: 50%;
                    }

                    #container .loading {
                        position: absolute;
                        display: none; /*block;*/
                    }

                    #container .loader {
                        width: 200px;
                    }

                    #results .loading {
                        position: relative;
                    }

                    .header {
                        background: #3F51B5;
                        color: rgba(255,255,255,0.87);
                        padding: 20px;
                    }

                    .header-title {
                        margin: 0 0 10px 0;
                        padding: 0;
                    }

                    #metadata {
                        background: rgba(0,0,0,0.2);
                        float: left;
                    }

                    .metadata-values {
                        list-style: none;
                        padding: 0;
                        margin: 0;
                        font-size: 12px;
                    }

                    .metadata-values label {
                        width: 100px;
                    }

                    #statistics {
                        float: right;
                    }

                    .group:after {
                        content: "";
                        display: table;
                        clear: both;
                    }

                    input[type="button"] {
                        color: #fff;
                        background: #3d5afe;
                        text-transform: uppercase;
                        border: none;
                        border-radius: 2px;
                        padding: 0 16px;
                        min-width: 64px;
                        height: 36px;
                        font-family: "Roboto", sans-serif;
                        font-size: 14px;
                        font-weight: 500;
                        box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 3px 1px -2px rgba(0,0,0,0.2), 0 1px 5px 0 rgba(0,0,0,0.12);
                        cursor: pointer;
                    }

                    input[type="button"]:active {
                        box-shadow: 0 4px 5px 0 rgba(0,0,0,0.14), 0 1px 10px 0 rgba(0,0,0,0.12), 0 2px 4px -1px rgba(0,0,0,0.2);
                    }

                    #content {
                        position: relative;
                    }

                    #controls {
                        position: absolute;
                        width: 320px;
                        padding: 10px;
                        left: 0;
                        top: 0;
                        background-color: rgba(0,0,0,0.025);
                    }

                    #results {
                        position: relative;
                        margin-left: 340px;
                    }
                </style>
            </head>
            <body>
                <div id="container">
                    <header class="header">
                        <h1 class="header-title">R# Code Inspection Report</h1>
                        <div class="header-info group">
                            <div id="metadata"></div>
                            <div id="statistics"></div>
                        </div>
                    </header>
                    <div id="content" class="group">
                        <aside id="controls">
                            <form name="filterAndSortForm">
                                <div id="sorting" class="panel">
                                    <h3 class="panel-title">Sort By</h3>
                                    <ul class="radio-button-list">
                                        <li><input type="radio" id="sort-proj" name="sort" value="PROJECT" checked="" /><label for="sort-proj">Project</label></li>
                                        <li><input type="radio" id="sort-sev" name="sort" value="SEVERITY" /><label for="sort-sev">Severity</label></li>
                                        <li><input type="radio" id="sort-type" name="sort" value="TYPE" /><label for="sort-type">Issue Type</label></li>
                                        <li><input type="radio" id="sort-freq" name="sort" value="FREQUENCY" /><label for="sort-freq">Frequency</label></li>
                                    </ul>
                                </div>
                                <input type="button" value="Apply" />
                            </form>
                        </aside>
                        <section id="results">
                            <div class="loading showbox">
                                <div class="loader">
                                    <svg class="circular" viewBox="25 25 50 50">
                                        <circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"/>
                                    </svg>
                                </div>
                            </div>
                        </section>
                    </div>
                    <div class="loading showbox">
                        <div class="loader">
                            <svg class="circular" viewBox="25 25 50 50">
                                <circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"/>
                            </svg>
                        </div>
                    </div>
                </div>

                <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.7/handlebars.min.js"></script>
                <script id="filter-template" type="text/x-handlebars-template">
                    <div id="filters" class="panel">
                        <h3 class="panel-title">Filters</h3>
                        <div class="dropdown">
                            <label>Severity</label>
                            <select name="severity">
                                <option value="ALL">All</option>
                                {{#each severity}}
                                <option value="">{{severity}}</option>
                                {{/each}}
                            </select>
                        </div>
                        <div class="checkbox-list">
                            <label>Issue Types</label>
                            <ul class="checkbox-list-values">
                                {{#each issueTypes}}
                                <li class="checkbox">
                                    <input type="checkbox" name="issueType" value="{{issueType}}" />
                                    <label>{{issueTypeName}}</label>
                                </li>
                                {{/each}}
                            </ul>
                        </div>
                        <div class="checkbox-list">
                            <label>Categories</label>
                            <ul class="checkbox-list-values">
                                {{#each categories}}
                                <li class="checkbox">
                                    <input type="checkbox" name="category" value="{{category}}" />
                                    <label>{{categoryName}}</label>
                                </li>
                                {{/each}}
                            </ul>
                        </div>
                    </div>
                </script>
                <script id="metadata-template" type="text/x-handlebars-template">
                    <h4 class="metadata-title">Metadata</h4>
                    <ul class="metadata-values">
                        <li><label>Tools Version:</label> {{version}}</li>
                        <li><label>Solution:</label> {{{solution}}}</li>
                        <li><label>Scope:</label> {{scope}}</li>
                    </ul>
                </script>
                <script id="statistics-template" type="text/x-handlebars-template">
                    <h4>Statistics</h4>
                    <p>hello stats</p>
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
                        // Gather all DOM and template sources to cache.
                        var metadataTmpl = Handlebars.compile(document.getElementById('metadata-template').innerHTML),
                            statisticsTmpl = Handlebars.compile(document.getElementById('statistics-template').innerHTML),
                            filterTmpl = Handlebars.compile(document.getElementById('filter-template').innerHTML),
                            metadataContainer = document.getElementById('metadata'),
                            statisticsContainer = document.getElementById('statistics'),
                            controlsContainer = document.querySelectorAll('#controls form')[0],
                            resultsContainer = document.getElementById('results'),
                            resultsContainerLoader = document.querySelectorAll('#results .loading')[0],
                            appLoader = document.querySelectorAll('#container .loading')[0];

                        var report = document.report = {
                                metadata: {
                                    version: &quot;<xsl:value-of select="//Report/@ToolsVersion" />&quot;,
                                    solution: &quot;<xsl:value-of select="replace(//Report/Information/Solution, '\\', '\\\\')" />&quot;,
                                    scope: &quot;<xsl:value-of select="//Report/Information/InspectionScope/Element" />&quot;
                                },
                                issueTypes: new Map(),
                                projects: [<xsl:for-each select="//Issues/Project">
                                    {
                                        name: &quot;<xsl:value-of select="@Name" />&quot;,
                                        issues: [<xsl:for-each select="Issue">
                                            {type:&quot;<xsl:value-of select="@TypeId" />&quot;,file:&quot;<xsl:value-of select="replace(@File, '\\', '\\\\')" />&quot;,line:<xsl:value-of select="my:provideDefault(@Line)" />,msg:&quot;<xsl:value-of select="replace(@Message, '[\\&quot;]', '&amp;quot;')" />&quot;}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
                                        ]
                                    }<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
                                ]
                            };

                        function gatherStatistics(report) {
                            // return a stat object that can be bound to a template.
                        }

                        function calculateResults(report, filterOptions, sortingOptions) {
                            // return organized report.
                        }

                        function populateIssueTypeMap() {
                            <xsl:for-each select="//IssueTypes/IssueType">report.issueTypes.set(&quot;<xsl:value-of select="@Id" />&quot;, {cat: &quot;<xsl:value-of select="@Category" />&quot;,catId: &quot;<xsl:value-of select="@CategoryId" />&quot;,desc: &quot;<xsl:value-of select="@Description" />&quot;,sev: &quot;<xsl:value-of select="@Severity" />&quot;,url: &quot;<xsl:value-of select="@WikiUrl" />&quot;});</xsl:for-each>
                        }

                        function updateMetadata(metadata) {
                            metadataContainer.innerHTML = metadataTmpl(metadata);
                        }

                        function updateStatistics(statistics) {
                            statisticsContainer.innerHTML = statisticsTmpl(statistics);
                        }

                        function updateReportResults(projects) {
                            resultsContainer.innerHTML = reusltsTmpl(projects);
                        }

                        function main() {
                            updateMetadata(report.metadata);
                        }

                        main();
                    }());
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>