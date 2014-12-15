
# update targetV3
<pre>
vi targetV3/webapp/application/views/scripts/shared/copyright.phtml
</pre>
edit:
ca.src = ('https:' == document.location.protocol ? 'https://ss|' : 'http://') + '192.168.80.131:8000/js/agent.js';

<pre>
vi targetV3/webapp/public/js/agent.js
</pre>
edit:
function T(b){this.v={ol:{httppre:"",httpspre:"ssl",domain:"192.168.80.131:8000"}
