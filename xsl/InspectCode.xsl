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
                        margin: 0;
                        padding: 0;
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
                        border-radius: 2px;
                        padding: 10px 10px 15px 10px;
                    }

                    .metadata-title {
                        margin-bottom: 5px;
                    }

                    .metadata-values {
                        list-style: none;
                        padding: 0;
                        margin: 0;
                        font-size: 12px;
                    }

                    .metadata-values label {
                        width: 100px;
                        display: inline-block;
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
                                <option value="WARNING">Warning</option>
                                <option value="SUGGESTION">Suggestion</option>
                                <option value="ERROR">Error</option>
                            </select>
                        </div>
                        <div class="checkbox-list">
                            <label>Issue Types</label>
                            <ul class="checkbox-list-values">
                                {{#each issueTypes.keys()}}
                                <li class="checkbox">
                                    <input type="checkbox" name="issueType" value="{{key}}" />
                                    <label>{{value}}</label>
                                </li>
                                {{/each}}
                            </ul>
                        </div>
                        <div class="checkbox-list">
                            <label>Categories</label>
                            <ul class="checkbox-list-values">
                                <li class="checkbox">
                                    <input type="checkbox" name="category" value="category" />
                                    <label>categoryName</label>
                                </li>
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
                    <ul>
                        {{#each keys}}
                        {{/each}}
                    </ul>
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
                                        {type:&quot;<xsl:value-of select="@TypeId" />&quot;,file:&quot;<xsl:value-of select="replace(@File, '\\', '\\\\')" />&quot;,sev:&quot;<xsl:value-of select="@Severity" />&quot;,line:<xsl:value-of select="my:provideDefault(@Line)" />,msg:&quot;<xsl:value-of select="replace(@Message, '[\\&quot;]', '&amp;quot;')" />&quot;}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
                                    ]
                                }<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
                            ]
                        };
                        
                        var filterViewModel = {
                            categories: new Array(),
                            issueTypes: new Array(),
                            severities: [{"ALL", "All"}, {"SUGGESTION", "Suggestions"}, {"WARNING", "Warnings"}, {"ERROR", "Errors"}]
                        };

                        // ***************************************************************
                        // ** Populate filter view model with categories and issue types.
                        // ***************************************************************

                        /**
                         * Gathers statistics from the report that has been generated.
                         * @param {Object} report - The report that has been generated from ReSharper.
                         * @returns {Object} The statistics map/hash.
                         */
                        function gatherStatistics(report) {
                            var stats = new Map(),
                                totalIssues = 0;
                                issueTypeOccurrenceKey = "issueTypeOccurrence";

                            stats.set(issueTypeOccurrenceKey, new Map());

                            // Number of projects.
                            stats.set("totalProjects", report.projects.length);

                            for (var index = 0; index &lt; report.projects.length; index++) {
                                totalIssues += report.projects[index].issues.length;

                                for (var issueIndex = 0; issueIndex &lt; report.projects[index].issues.length; issueIndex++) {
                                    var issue = report.projects[index].issues[issueIndex],
                                        issueTypeOccurrences = stats.get(issueTypeOccurrenceKey),
                                        issueKey = "",
                                        issueCount = 0,
                                        severity = {};

                                    incrementSeverityCount(issue, report.issueTypes, stats);

                                    // Register issue type occurrence.
                                    incrementCount(issueTypeOccurrences, issue.type);
                                }
                            }

                            // Determine which three issue types occur the most.
                            var occurrences = new Array();

                            issueTypeOccurrences.forEach(function(value, key, map) {
                                occurrences.push({ type: key, count: value });
                            });

                            occurrences.sort(function (a, b) {
                                if (a.count &lt; b.count) {
                                    return 1;
                                } else if (a.count &gt; b.count) {
                                    return -1;
                                }
                                
                                return 0
                            });

                            stats.set(issueTypeOccurrenceKey, occurrences);
                            stats.set("totalIssues", totalIssues);
                            
                            console.log("Statistics", stats);

                            return stats;
                        }

                        /**
                         * Utility function to safely increment a count stored in a map.
                         * @param {Object} map - The map to use when looking up and incrementing values.
                         * @param {String} key - The key to manipulate.
                         */
                        function incrementCount(map, key) {
                            var value = Number(map.get(key));

                            if (!Number.isNaN(value)) {
                                map.set(key, value + 1);
                            } else {
                                map.set(key, 1);
                            }
                        }

                        /**
                         * Utility function for the gatherStatistics method to increment the count
                         * of the number of occurrence for a particular issue severity.
                         * @param {Object} issue - The issue that is being analyzed.
                         * @param {Object} issueTypes - The map of issue types found within the report.
                         * @param {Object} statsMap - The map representing the various pieces of statistical information collected.
                         */
                        function incrementSeverityCount(issue, issueTypes, statsMap) {
                            var severity = "",
                                severityCount = 0;
                            
                            // Is the severity rating on the issue?
                            if (issue.sev !== "") {
                                severity = issue.sev;
                            } else {
                                // Grab the severity by type.
                                severity = issueTypes.get(issue.type).sev;
                                issue.sev = severity;
                            }

                            incrementCount(statsMap, severity.toLowerCase() + "s");
                        }

                        function calculateResults(report, filterOptions, sortingOptions) {
                            // return organized report.
                        }

                        /**
                         * Used to populate the map/hash for issue type lookup.
                         */
                        function populateIssueTypeMap() {
                            <xsl:for-each select="//IssueTypes/IssueType">report.issueTypes.set(&quot;<xsl:value-of select="@Id" />&quot;, {cat: &quot;<xsl:value-of select="@Category" />&quot;,catId: &quot;<xsl:value-of select="@CategoryId" />&quot;,desc: &quot;<xsl:value-of select="@Description" />&quot;,sev: &quot;<xsl:value-of select="@Severity" />&quot;,url: &quot;<xsl:value-of select="@WikiUrl" />&quot;});</xsl:for-each>
                        }

                        /**
                         * Used to update the metadata template.
                         * @param {Object} metadata - The metadata object to be bound to the template.
                         */
                        function updateMetadata(metadata) {
                            metadataContainer.innerHTML = metadataTmpl(metadata);
                        }

                        function updateControls(report) {
                            controlsContainer.innerHTML = filterTmpl(report) + controlsContainer.innerHTML;
                        }

                        /**
                         * Used to update the statistics template.
                         * @param {Object} statistics - The statistics object to be bound to the template.
                         */
                        function updateStatistics(statistics) {
                            statisticsContainer.innerHTML = statisticsTmpl(statistics);
                        }

                        /**
                         * Used to update the report results template.
                         * @param {Object} projects - The newly sorted and filtered projects array.
                         */
                        function updateReportResults(projects) {
                            resultsContainer.innerHTML = reusltsTmpl(projects);
                        }

                        function main() {
                            populateIssueTypeMap();

                            updateMetadata(report.metadata);
                            updateControls(report);

                            gatherStatistics(report);

                            console.log("Report", report);
                        }

                        main();
                    }());
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>