<!DOCTYPE html>
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en"> <!--<![endif]-->

<head>
  <title>/README.md | jhester/persist-eagle-libs | Buffet</title>
	<meta charset="utf-8">
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
	<meta name="description" content="Buffet Resource Management System">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

  <!-- Stylesheets -->
  <link rel="stylesheet" href="//code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
	<link rel="stylesheet" href="/static/base.css">
	<link rel="stylesheet" href="/static/skeleton.css">
	<link rel="stylesheet" href="/static/layout.css">
  <link rel="stylesheet" href="/static/buffet.css">
  <link rel='stylesheet' href='/static/vcs/buffet.css' />
<link rel='stylesheet' href='/static/sqldb/buffet.css' />
  
  <link rel='stylesheet' href='/static/vcs/pygments.css' />


  <script type="text/javascript" src="//code.jquery.com/jquery-1.11.0.min.js"></script>
  <script type="text/javascript" src="//code.jquery.com/ui/1.11.0/jquery-ui.min.js"></script>
  <script type="text/javascript" src="/static/core/core.js"></script>
  
  
  
  <link rel="shortcut icon" href="/static/favicon.ico" />
  

  
</head>
<body>
<div id='viewport'>
  <div class='container'>
    <div class="sixteen columns" id="site_bar">
      <ul class='imagelinks'>
        <li><a id='home' title='Home' href='/'>Home</a></li>
        
        
        <li><a id='login' title='Login'
               href='/accounts/login/?next=/vcs/u/jhester/persist-eagle-libs/rev/34c1e22ca896d45b5234107931cc91dde20a8108/README.md'>Login</a>
        </li>
        
      </ul>

      <form action="/search/" method='get'>
        <input id="id_query" name="query" placeholder="Search" type="text" />
      </form>
    </div>

    <div class='sixteen columns' id='app_bar'>
      <div class='two-thirds column alpha' id="page_header">
<h1>
  <a href='/users/jhester/'>jhester</a>/<a href='/vcs/u/jhester/persist-eagle-libs/'>persist-eagle-libs</a>
</h1>

</div>
      <div class='one-third column omega' id="app_buttons"></div>
    </div>

    
    
    

    <div
        id='content_header'
        style='display: block'
        class='sixteen columns
               '>
      <div class='inner'>
        
<ul class='resource-pager'>
  <li><a href='/vcs/u/jhester/persist-eagle-libs/'>Overview</a></li>
  <li><a href='/vcs/u/jhester/persist-eagle-libs/source/'>Browse</a></li>
  
  <li><a href='/vcs/u/jhester/persist-eagle-libs/commits/'>Commits</a></li>
  
  
  
  <li><a href='/vcs/u/jhester/persist-eagle-libs/forks/'>Forks</a></li>
  
  
</ul>

      </div>
    </div>
    <div
        id='content_left'
        style='display: none'
        class='one-third column'>
      <div class='inner'>
        
      </div>
    </div>
    <div
        id='content'
        class='sixteen columns'>
      <div class='inner'>
        
<h4>/ <a href='/vcs/u/jhester/persist-eagle-libs/source/'>persist-eagle-libs</a>


  / <strong>README.md</strong>


</h4>


<span id="browse-file-buttons">
  <a class='button' href='?raw'>Raw</a>
  <a class='button' href='/vcs/u/jhester/persist-eagle-libs/blame/34c1e22ca896d45b5234107931cc91dde20a8108//README.md'>Blame</a>
</span>

  
    <table class="highlighttable"><tr><td class="linenos"><div class="linenodiv"><pre> 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26</pre></div></td><td class="code"><div class="highlight"><pre><span class="n">PERSIST</span> <span class="n">Lab</span> <span class="n">EAGLE</span> <span class="n">Part</span> <span class="n">Libraries</span>
<span class="o">===================</span>
<span class="n">This</span> <span class="n">repository</span> <span class="n">contains</span> <span class="n">a</span> <span class="n">bunch</span> <span class="n">of</span> <span class="n">EAGLE</span> <span class="n">parts</span> <span class="n">used</span> <span class="n">in</span> <span class="n">lab</span> <span class="n">harware</span> <span class="n">projects</span><span class="p">.</span> <span class="n">All</span> <span class="n">parts</span> <span class="n">have</span> <span class="n">been</span> <span class="n">tested</span> <span class="n">and</span> <span class="n">used</span> <span class="n">in</span> <span class="n">real</span> <span class="n">hardware</span><span class="p">.</span>

<span class="cp">#### Usage</span>
<span class="n">Include</span> <span class="n">this</span> <span class="n">repository</span> <span class="n">in</span> <span class="n">your</span> <span class="n">EAGLE</span> <span class="n">libraries</span> <span class="n">search</span> <span class="n">path</span><span class="p">.</span>

<span class="cp">#### Adding Parts</span>
<span class="n">Make</span> <span class="n">sure</span> <span class="n">you</span> <span class="n">document</span> <span class="n">the</span> <span class="n">part</span> <span class="n">in</span> <span class="n">the</span> <span class="n">library</span> <span class="p">(</span><span class="n">Description</span><span class="p">,</span> <span class="n">part</span> <span class="n">number</span><span class="p">,</span> <span class="n">etc</span><span class="p">,</span> <span class="n">copy</span> <span class="o">/</span> <span class="n">paste</span> <span class="n">from</span> <span class="n">datasheet</span><span class="p">),</span> <span class="n">and</span> <span class="n">update</span> <span class="n">the</span> <span class="n">README</span><span class="p">,</span> <span class="n">including</span> <span class="n">the</span> <span class="n">part</span> <span class="n">and</span> <span class="n">a</span> <span class="kt">short</span> <span class="n">description</span><span class="p">.</span>

<span class="cp">#### Notes:</span>
<span class="n">Generally</span><span class="p">,</span> <span class="n">each</span> <span class="n">library</span> <span class="n">holds</span> <span class="n">one</span> <span class="n">part</span> <span class="p">(</span><span class="n">and</span> <span class="n">is</span> <span class="n">named</span> <span class="n">by</span> <span class="n">that</span> <span class="n">part</span><span class="p">),</span> <span class="n">because</span> <span class="n">often</span> <span class="n">packages</span> <span class="n">can</span> <span class="n">differ</span> <span class="n">slightly</span> <span class="n">even</span> <span class="k">if</span> <span class="n">they</span> <span class="n">are</span> <span class="n">the</span> <span class="s">&quot;same,&quot;</span> <span class="n">this</span> <span class="n">also</span> <span class="n">allows</span> <span class="k">for</span> <span class="n">repository</span> <span class="n">control</span><span class="p">,</span> <span class="n">as</span> <span class="n">libraries</span> <span class="n">are</span> <span class="n">binary</span><span class="p">,</span> <span class="n">so</span> <span class="n">a</span> <span class="n">change</span> <span class="n">in</span> <span class="n">one</span> <span class="n">part</span> <span class="n">in</span> <span class="n">a</span> <span class="n">large</span> <span class="n">library</span> <span class="n">requires</span> <span class="n">the</span> <span class="n">entire</span> <span class="n">library</span> <span class="n">to</span> <span class="n">be</span> <span class="n">re</span><span class="o">-</span><span class="n">synced</span><span class="p">,</span> <span class="n">this</span> <span class="n">makes</span> <span class="n">it</span> <span class="n">difficult</span> <span class="n">to</span> <span class="n">track</span> <span class="n">changes</span><span class="p">.</span>

<span class="cp">#### TODO</span>
<span class="n">Autogenerate</span> <span class="n">the</span> <span class="n">parts</span> <span class="n">list</span><span class="p">,</span> <span class="n">and</span> <span class="n">descriptiont</span> <span class="n">from</span> <span class="n">the</span> <span class="n">library</span> <span class="n">files</span><span class="p">.</span>

<span class="cp">#### Parts</span>
<span class="o">-</span> <span class="n">ad5242</span><span class="p">.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">ad8253</span><span class="p">.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">cc1101</span><span class="p">.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">fc</span><span class="o">-</span><span class="mf">135.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">frames</span><span class="p">.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">hammond</span><span class="p">.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">max9939</span><span class="p">.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">msp430</span><span class="p">.</span><span class="n">lbr</span>
<span class="o">-</span> <span class="n">ncp583</span><span class="p">.</span><span class="n">lbr</span>
</pre></div>
</td></tr></table>
  
  

      </div>
    </div>
    <div
        id='content_right'
        style='display: none'
        class='
               '>
      <div class='inner'>
        
      </div>
    </div>
    
  </div>
  <div id='footer'>
    
      
      &copy; 2014 Clemson University
      | Buffet 0.2.1
      | Icons based on <a target='_blank' href='http://icons8.com/'>Icons8</a>
        (<a target='_blank' href='//creativecommons.org/licenses/by-nd/3.0/'>CC BY-ND 3.0</a>)
      
| <a href="/static/privacy.html">Privacy Policy</a>

    
  </div>
</div>
</body>
</html>
