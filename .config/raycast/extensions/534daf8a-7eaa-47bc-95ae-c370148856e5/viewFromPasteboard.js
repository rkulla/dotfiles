"use strict";var s=Object.defineProperty;var p=Object.getOwnPropertyDescriptor;var m=Object.getOwnPropertyNames;var f=Object.prototype.hasOwnProperty;var u=(a,t)=>{for(var n in t)s(a,n,{get:t[n],enumerable:!0})},d=(a,t,n,r)=>{if(t&&typeof t=="object"||typeof t=="function")for(let e of m(t))!f.call(a,e)&&e!==n&&s(a,e,{get:()=>t[e],enumerable:!(r=p(t,e))||r.enumerable});return a};var w=a=>d(s({},"__esModule",{value:!0}),a);var y={};u(y,{default:()=>c});module.exports=w(y);var i=require("@raycast/api");var o=require("@raycast/api");async function h(){return(await(0,o.getApplications)()).some(({bundleId:n})=>n==="net.shinystone.OKJSON")}async function l(){return await h()?Promise.resolve(!0):(await(0,o.confirmAlert)({title:"OK JSON is not installed.",message:"Do you want to install it right now?",primaryAction:{title:"Install",onAction:async()=>{(0,o.open)("https://apps.apple.com/app/ok-json-offline-private/id1576121509?mt=12"),await(0,o.popToRoot)({clearSearchBar:!1})}},dismissAction:{title:"Cancel",onAction:async()=>{await(0,o.popToRoot)({clearSearchBar:!1})}}}),Promise.resolve(!1))}async function c(){await l()&&((0,i.open)("okjson://paste"),await(0,i.closeMainWindow)({clearRootSearch:!0}))}
