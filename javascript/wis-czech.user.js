// ==UserScript==
// // @name          Wis czech
// // @namespace     http://blaskovic.sk
// // @description   wis czech
// // @include       https://wis.fit.vutbr.cz/FIT/
// // @include       http://wis.fit.vutbr.cz/FIT/
// // ==/UserScript==

if(
    document.location.href.indexOf("wis.fit.vutbr.cz") > 0 &&
    document.location.href.indexOf(".php.cs") == -1 && 
    document.location.href.indexOf(".php") != -1
)
{
    var url = document.location.href;
    url = url.replace(".php.en", ".php");
    url = url.replace(".php", ".php.cs");
    document.location.href = url;
}
