"use strict";var hn=Object.create;var j=Object.defineProperty;var Sn=Object.getOwnPropertyDescriptor;var yn=Object.getOwnPropertyNames;var gn=Object.getPrototypeOf,xn=Object.prototype.hasOwnProperty;var c=(e,t)=>()=>(t||e((t={exports:{}}).exports,t),t.exports),wn=(e,t)=>{for(var r in t)j(e,r,{get:t[r],enumerable:!0})},Ee=(e,t,r,n)=>{if(t&&typeof t=="object"||typeof t=="function")for(let s of yn(t))!xn.call(e,s)&&s!==r&&j(e,s,{get:()=>t[s],enumerable:!(n=Sn(t,s))||n.enumerable});return e};var Ie=(e,t,r)=>(r=e!=null?hn(gn(e)):{},Ee(t||!e||!e.__esModule?j(r,"default",{value:e,enumerable:!0}):r,e)),bn=e=>Ee(j({},"__esModule",{value:!0}),e);var Ae=c((gs,Ge)=>{Ge.exports=Ce;Ce.sync=En;var Te=require("fs");function vn(e,t){var r=t.pathExt!==void 0?t.pathExt:process.env.PATHEXT;if(!r||(r=r.split(";"),r.indexOf("")!==-1))return!0;for(var n=0;n<r.length;n++){var s=r[n].toLowerCase();if(s&&e.substr(-s.length).toLowerCase()===s)return!0}return!1}function Pe(e,t,r){return!e.isSymbolicLink()&&!e.isFile()?!1:vn(t,r)}function Ce(e,t,r){Te.stat(e,function(n,s){r(n,n?!1:Pe(s,e,t))})}function En(e,t){return Pe(Te.statSync(e),e,t)}});var ke=c((xs,Ne)=>{Ne.exports=Re;Re.sync=In;var Oe=require("fs");function Re(e,t,r){Oe.stat(e,function(n,s){r(n,n?!1:qe(s,t))})}function In(e,t){return qe(Oe.statSync(e),t)}function qe(e,t){return e.isFile()&&Tn(e,t)}function Tn(e,t){var r=e.mode,n=e.uid,s=e.gid,o=t.uid!==void 0?t.uid:process.getuid&&process.getuid(),i=t.gid!==void 0?t.gid:process.getgid&&process.getgid(),a=parseInt("100",8),u=parseInt("010",8),l=parseInt("001",8),f=a|u,h=r&l||r&u&&s===i||r&a&&n===o||r&f&&o===0;return h}});var $e=c((bs,_e)=>{var ws=require("fs"),M;process.platform==="win32"||global.TESTING_WINDOWS?M=Ae():M=ke();_e.exports=Z;Z.sync=Pn;function Z(e,t,r){if(typeof t=="function"&&(r=t,t={}),!r){if(typeof Promise!="function")throw new TypeError("callback not provided");return new Promise(function(n,s){Z(e,t||{},function(o,i){o?s(o):n(i)})})}M(e,t||{},function(n,s){n&&(n.code==="EACCES"||t&&t.ignoreErrors)&&(n=null,s=!1),r(n,s)})}function Pn(e,t){try{return M.sync(e,t||{})}catch(r){if(t&&t.ignoreErrors||r.code==="EACCES")return!1;throw r}}});var De=c((vs,Ue)=>{var I=process.platform==="win32"||process.env.OSTYPE==="cygwin"||process.env.OSTYPE==="msys",Be=require("path"),Cn=I?";":":",Le=$e(),je=e=>Object.assign(new Error(`not found: ${e}`),{code:"ENOENT"}),Me=(e,t)=>{let r=t.colon||Cn,n=e.match(/\//)||I&&e.match(/\\/)?[""]:[...I?[process.cwd()]:[],...(t.path||process.env.PATH||"").split(r)],s=I?t.pathExt||process.env.PATHEXT||".EXE;.CMD;.BAT;.COM":"",o=I?s.split(r):[""];return I&&e.indexOf(".")!==-1&&o[0]!==""&&o.unshift(""),{pathEnv:n,pathExt:o,pathExtExe:s}},Fe=(e,t,r)=>{typeof t=="function"&&(r=t,t={}),t||(t={});let{pathEnv:n,pathExt:s,pathExtExe:o}=Me(e,t),i=[],a=l=>new Promise((f,h)=>{if(l===n.length)return t.all&&i.length?f(i):h(je(e));let m=n[l],S=/^".*"$/.test(m)?m.slice(1,-1):m,y=Be.join(S,e),g=!S&&/^\.[\\\/]/.test(e)?e.slice(0,2)+y:y;f(u(g,l,0))}),u=(l,f,h)=>new Promise((m,S)=>{if(h===s.length)return m(a(f+1));let y=s[h];Le(l+y,{pathExt:o},(g,E)=>{if(!g&&E)if(t.all)i.push(l+y);else return m(l+y);return m(u(l,f,h+1))})});return r?a(0).then(l=>r(null,l),r):a(0)},Gn=(e,t)=>{t=t||{};let{pathEnv:r,pathExt:n,pathExtExe:s}=Me(e,t),o=[];for(let i=0;i<r.length;i++){let a=r[i],u=/^".*"$/.test(a)?a.slice(1,-1):a,l=Be.join(u,e),f=!u&&/^\.[\\\/]/.test(e)?e.slice(0,2)+l:l;for(let h=0;h<n.length;h++){let m=f+n[h];try{if(Le.sync(m,{pathExt:s}))if(t.all)o.push(m);else return m}catch{}}}if(t.all&&o.length)return o;if(t.nothrow)return null;throw je(e)};Ue.exports=Fe;Fe.sync=Gn});var te=c((Es,ee)=>{"use strict";var He=(e={})=>{let t=e.env||process.env;return(e.platform||process.platform)!=="win32"?"PATH":Object.keys(t).reverse().find(n=>n.toUpperCase()==="PATH")||"Path"};ee.exports=He;ee.exports.default=He});var ze=c((Is,We)=>{"use strict";var Ke=require("path"),An=De(),On=te();function Xe(e,t){let r=e.options.env||process.env,n=process.cwd(),s=e.options.cwd!=null,o=s&&process.chdir!==void 0&&!process.chdir.disabled;if(o)try{process.chdir(e.options.cwd)}catch{}let i;try{i=An.sync(e.command,{path:r[On({env:r})],pathExt:t?Ke.delimiter:void 0})}catch{}finally{o&&process.chdir(n)}return i&&(i=Ke.resolve(s?e.options.cwd:"",i)),i}function Rn(e){return Xe(e)||Xe(e,!0)}We.exports=Rn});var Ve=c((Ts,re)=>{"use strict";var ne=/([()\][%!^"`<>&|;, *?])/g;function qn(e){return e=e.replace(ne,"^$1"),e}function Nn(e,t){return e=`${e}`,e=e.replace(/(\\*)"/g,'$1$1\\"'),e=e.replace(/(\\*)$/,"$1$1"),e=`"${e}"`,e=e.replace(ne,"^$1"),t&&(e=e.replace(ne,"^$1")),e}re.exports.command=qn;re.exports.argument=Nn});var Je=c((Ps,Ye)=>{"use strict";Ye.exports=/^#!(.*)/});var Ze=c((Cs,Qe)=>{"use strict";var kn=Je();Qe.exports=(e="")=>{let t=e.match(kn);if(!t)return null;let[r,n]=t[0].replace(/#! ?/,"").split(" "),s=r.split("/").pop();return s==="env"?n:n?`${s} ${n}`:s}});var tt=c((Gs,et)=>{"use strict";var se=require("fs"),_n=Ze();function $n(e){let r=Buffer.alloc(150),n;try{n=se.openSync(e,"r"),se.readSync(n,r,0,150,0),se.closeSync(n)}catch{}return _n(r.toString())}et.exports=$n});var ot=c((As,st)=>{"use strict";var Bn=require("path"),nt=ze(),rt=Ve(),Ln=tt(),jn=process.platform==="win32",Mn=/\.(?:com|exe)$/i,Fn=/node_modules[\\/].bin[\\/][^\\/]+\.cmd$/i;function Un(e){e.file=nt(e);let t=e.file&&Ln(e.file);return t?(e.args.unshift(e.file),e.command=t,nt(e)):e.file}function Dn(e){if(!jn)return e;let t=Un(e),r=!Mn.test(t);if(e.options.forceShell||r){let n=Fn.test(t);e.command=Bn.normalize(e.command),e.command=rt.command(e.command),e.args=e.args.map(o=>rt.argument(o,n));let s=[e.command].concat(e.args).join(" ");e.args=["/d","/s","/c",`"${s}"`],e.command=process.env.comspec||"cmd.exe",e.options.windowsVerbatimArguments=!0}return e}function Hn(e,t,r){t&&!Array.isArray(t)&&(r=t,t=null),t=t?t.slice(0):[],r=Object.assign({},r);let n={command:e,args:t,options:r,file:void 0,original:{command:e,args:t}};return r.shell?n:Dn(n)}st.exports=Hn});var ct=c((Os,at)=>{"use strict";var oe=process.platform==="win32";function ie(e,t){return Object.assign(new Error(`${t} ${e.command} ENOENT`),{code:"ENOENT",errno:"ENOENT",syscall:`${t} ${e.command}`,path:e.command,spawnargs:e.args})}function Kn(e,t){if(!oe)return;let r=e.emit;e.emit=function(n,s){if(n==="exit"){let o=it(s,t,"spawn");if(o)return r.call(e,"error",o)}return r.apply(e,arguments)}}function it(e,t){return oe&&e===1&&!t.file?ie(t.original,"spawn"):null}function Xn(e,t){return oe&&e===1&&!t.file?ie(t.original,"spawnSync"):null}at.exports={hookChildProcess:Kn,verifyENOENT:it,verifyENOENTSync:Xn,notFoundError:ie}});var dt=c((Rs,T)=>{"use strict";var ut=require("child_process"),ae=ot(),ce=ct();function lt(e,t,r){let n=ae(e,t,r),s=ut.spawn(n.command,n.args,n.options);return ce.hookChildProcess(s,n),s}function Wn(e,t,r){let n=ae(e,t,r),s=ut.spawnSync(n.command,n.args,n.options);return s.error=s.error||ce.verifyENOENTSync(s.status,n),s}T.exports=lt;T.exports.spawn=lt;T.exports.sync=Wn;T.exports._parse=ae;T.exports._enoent=ce});var pt=c((qs,ft)=>{"use strict";ft.exports=e=>{let t=typeof e=="string"?`
`:10,r=typeof e=="string"?"\r":13;return e[e.length-1]===t&&(e=e.slice(0,e.length-1)),e[e.length-1]===r&&(e=e.slice(0,e.length-1)),e}});var St=c((Ns,N)=>{"use strict";var q=require("path"),mt=te(),ht=e=>{e={cwd:process.cwd(),path:process.env[mt()],execPath:process.execPath,...e};let t,r=q.resolve(e.cwd),n=[];for(;t!==r;)n.push(q.join(r,"node_modules/.bin")),t=r,r=q.resolve(r,"..");let s=q.resolve(e.cwd,e.execPath,"..");return n.push(s),n.concat(e.path).join(q.delimiter)};N.exports=ht;N.exports.default=ht;N.exports.env=e=>{e={env:process.env,...e};let t={...e.env},r=mt({env:t});return e.path=t[r],t[r]=N.exports(e),t}});var gt=c((ks,ue)=>{"use strict";var yt=(e,t)=>{for(let r of Reflect.ownKeys(t))Object.defineProperty(e,r,Object.getOwnPropertyDescriptor(t,r));return e};ue.exports=yt;ue.exports.default=yt});var wt=c((_s,U)=>{"use strict";var zn=gt(),F=new WeakMap,xt=(e,t={})=>{if(typeof e!="function")throw new TypeError("Expected a function");let r,n=0,s=e.displayName||e.name||"<anonymous>",o=function(...i){if(F.set(o,++n),n===1)r=e.apply(this,i),e=null;else if(t.throw===!0)throw new Error(`Function \`${s}\` can only be called once`);return r};return zn(o,e),F.set(o,n),o};U.exports=xt;U.exports.default=xt;U.exports.callCount=e=>{if(!F.has(e))throw new Error(`The given function \`${e.name}\` is not wrapped by the \`onetime\` package`);return F.get(e)}});var bt=c(D=>{"use strict";Object.defineProperty(D,"__esModule",{value:!0});D.SIGNALS=void 0;var Vn=[{name:"SIGHUP",number:1,action:"terminate",description:"Terminal closed",standard:"posix"},{name:"SIGINT",number:2,action:"terminate",description:"User interruption with CTRL-C",standard:"ansi"},{name:"SIGQUIT",number:3,action:"core",description:"User interruption with CTRL-\\",standard:"posix"},{name:"SIGILL",number:4,action:"core",description:"Invalid machine instruction",standard:"ansi"},{name:"SIGTRAP",number:5,action:"core",description:"Debugger breakpoint",standard:"posix"},{name:"SIGABRT",number:6,action:"core",description:"Aborted",standard:"ansi"},{name:"SIGIOT",number:6,action:"core",description:"Aborted",standard:"bsd"},{name:"SIGBUS",number:7,action:"core",description:"Bus error due to misaligned, non-existing address or paging error",standard:"bsd"},{name:"SIGEMT",number:7,action:"terminate",description:"Command should be emulated but is not implemented",standard:"other"},{name:"SIGFPE",number:8,action:"core",description:"Floating point arithmetic error",standard:"ansi"},{name:"SIGKILL",number:9,action:"terminate",description:"Forced termination",standard:"posix",forced:!0},{name:"SIGUSR1",number:10,action:"terminate",description:"Application-specific signal",standard:"posix"},{name:"SIGSEGV",number:11,action:"core",description:"Segmentation fault",standard:"ansi"},{name:"SIGUSR2",number:12,action:"terminate",description:"Application-specific signal",standard:"posix"},{name:"SIGPIPE",number:13,action:"terminate",description:"Broken pipe or socket",standard:"posix"},{name:"SIGALRM",number:14,action:"terminate",description:"Timeout or timer",standard:"posix"},{name:"SIGTERM",number:15,action:"terminate",description:"Termination",standard:"ansi"},{name:"SIGSTKFLT",number:16,action:"terminate",description:"Stack is empty or overflowed",standard:"other"},{name:"SIGCHLD",number:17,action:"ignore",description:"Child process terminated, paused or unpaused",standard:"posix"},{name:"SIGCLD",number:17,action:"ignore",description:"Child process terminated, paused or unpaused",standard:"other"},{name:"SIGCONT",number:18,action:"unpause",description:"Unpaused",standard:"posix",forced:!0},{name:"SIGSTOP",number:19,action:"pause",description:"Paused",standard:"posix",forced:!0},{name:"SIGTSTP",number:20,action:"pause",description:'Paused using CTRL-Z or "suspend"',standard:"posix"},{name:"SIGTTIN",number:21,action:"pause",description:"Background process cannot read terminal input",standard:"posix"},{name:"SIGBREAK",number:21,action:"terminate",description:"User interruption with CTRL-BREAK",standard:"other"},{name:"SIGTTOU",number:22,action:"pause",description:"Background process cannot write to terminal output",standard:"posix"},{name:"SIGURG",number:23,action:"ignore",description:"Socket received out-of-band data",standard:"bsd"},{name:"SIGXCPU",number:24,action:"core",description:"Process timed out",standard:"bsd"},{name:"SIGXFSZ",number:25,action:"core",description:"File too big",standard:"bsd"},{name:"SIGVTALRM",number:26,action:"terminate",description:"Timeout or timer",standard:"bsd"},{name:"SIGPROF",number:27,action:"terminate",description:"Timeout or timer",standard:"bsd"},{name:"SIGWINCH",number:28,action:"ignore",description:"Terminal window size changed",standard:"bsd"},{name:"SIGIO",number:29,action:"terminate",description:"I/O is available",standard:"other"},{name:"SIGPOLL",number:29,action:"terminate",description:"Watched event",standard:"other"},{name:"SIGINFO",number:29,action:"ignore",description:"Request for process information",standard:"other"},{name:"SIGPWR",number:30,action:"terminate",description:"Device running out of power",standard:"systemv"},{name:"SIGSYS",number:31,action:"core",description:"Invalid system call",standard:"other"},{name:"SIGUNUSED",number:31,action:"terminate",description:"Invalid system call",standard:"other"}];D.SIGNALS=Vn});var le=c(P=>{"use strict";Object.defineProperty(P,"__esModule",{value:!0});P.SIGRTMAX=P.getRealtimeSignals=void 0;var Yn=function(){let e=Et-vt+1;return Array.from({length:e},Jn)};P.getRealtimeSignals=Yn;var Jn=function(e,t){return{name:`SIGRT${t+1}`,number:vt+t,action:"terminate",description:"Application-specific signal (realtime)",standard:"posix"}},vt=34,Et=64;P.SIGRTMAX=Et});var It=c(H=>{"use strict";Object.defineProperty(H,"__esModule",{value:!0});H.getSignals=void 0;var Qn=require("os"),Zn=bt(),er=le(),tr=function(){let e=(0,er.getRealtimeSignals)();return[...Zn.SIGNALS,...e].map(nr)};H.getSignals=tr;var nr=function({name:e,number:t,description:r,action:n,forced:s=!1,standard:o}){let{signals:{[e]:i}}=Qn.constants,a=i!==void 0;return{name:e,number:a?i:t,description:r,supported:a,action:n,forced:s,standard:o}}});var Pt=c(C=>{"use strict";Object.defineProperty(C,"__esModule",{value:!0});C.signalsByNumber=C.signalsByName=void 0;var rr=require("os"),Tt=It(),sr=le(),or=function(){return(0,Tt.getSignals)().reduce(ir,{})},ir=function(e,{name:t,number:r,description:n,supported:s,action:o,forced:i,standard:a}){return{...e,[t]:{name:t,number:r,description:n,supported:s,action:o,forced:i,standard:a}}},ar=or();C.signalsByName=ar;var cr=function(){let e=(0,Tt.getSignals)(),t=sr.SIGRTMAX+1,r=Array.from({length:t},(n,s)=>ur(s,e));return Object.assign({},...r)},ur=function(e,t){let r=lr(e,t);if(r===void 0)return{};let{name:n,description:s,supported:o,action:i,forced:a,standard:u}=r;return{[e]:{name:n,number:e,description:s,supported:o,action:i,forced:a,standard:u}}},lr=function(e,t){let r=t.find(({name:n})=>rr.constants.signals[n]===e);return r!==void 0?r:t.find(n=>n.number===e)},dr=cr();C.signalsByNumber=dr});var Gt=c((Ms,Ct)=>{"use strict";var{signalsByName:fr}=Pt(),pr=({timedOut:e,timeout:t,errorCode:r,signal:n,signalDescription:s,exitCode:o,isCanceled:i})=>e?`timed out after ${t} milliseconds`:i?"was canceled":r!==void 0?`failed with ${r}`:n!==void 0?`was killed with ${n} (${s})`:o!==void 0?`failed with exit code ${o}`:"failed",mr=({stdout:e,stderr:t,all:r,error:n,signal:s,exitCode:o,command:i,escapedCommand:a,timedOut:u,isCanceled:l,killed:f,parsed:{options:{timeout:h}}})=>{o=o===null?void 0:o,s=s===null?void 0:s;let m=s===void 0?void 0:fr[s].description,S=n&&n.code,g=`Command ${pr({timedOut:u,timeout:h,errorCode:S,signal:s,signalDescription:m,exitCode:o,isCanceled:l})}: ${i}`,E=Object.prototype.toString.call(n)==="[object Error]",B=E?`${g}
${n.message}`:g,L=[B,t,e].filter(Boolean).join(`
`);return E?(n.originalMessage=n.message,n.message=L):n=new Error(L),n.shortMessage=B,n.command=i,n.escapedCommand=a,n.exitCode=o,n.signal=s,n.signalDescription=m,n.stdout=e,n.stderr=t,r!==void 0&&(n.all=r),"bufferedData"in n&&delete n.bufferedData,n.failed=!0,n.timedOut=!!u,n.isCanceled=l,n.killed=f&&!u,n};Ct.exports=mr});var Ot=c((Fs,de)=>{"use strict";var K=["stdin","stdout","stderr"],hr=e=>K.some(t=>e[t]!==void 0),At=e=>{if(!e)return;let{stdio:t}=e;if(t===void 0)return K.map(n=>e[n]);if(hr(e))throw new Error(`It's not possible to provide \`stdio\` in combination with one of ${K.map(n=>`\`${n}\``).join(", ")}`);if(typeof t=="string")return t;if(!Array.isArray(t))throw new TypeError(`Expected \`stdio\` to be of type \`string\` or \`Array\`, got \`${typeof t}\``);let r=Math.max(t.length,K.length);return Array.from({length:r},(n,s)=>t[s])};de.exports=At;de.exports.node=e=>{let t=At(e);return t==="ipc"?"ipc":t===void 0||typeof t=="string"?[t,t,t,"ipc"]:t.includes("ipc")?t:[...t,"ipc"]}});var Rt=c((Us,X)=>{X.exports=["SIGABRT","SIGALRM","SIGHUP","SIGINT","SIGTERM"];process.platform!=="win32"&&X.exports.push("SIGVTALRM","SIGXCPU","SIGXFSZ","SIGUSR2","SIGTRAP","SIGSYS","SIGQUIT","SIGIOT");process.platform==="linux"&&X.exports.push("SIGIO","SIGPOLL","SIGPWR","SIGSTKFLT","SIGUNUSED")});var $t=c((Ds,O)=>{var d=global.process,b=function(e){return e&&typeof e=="object"&&typeof e.removeListener=="function"&&typeof e.emit=="function"&&typeof e.reallyExit=="function"&&typeof e.listeners=="function"&&typeof e.kill=="function"&&typeof e.pid=="number"&&typeof e.on=="function"};b(d)?(qt=require("assert"),G=Rt(),Nt=/^win/i.test(d.platform),k=require("events"),typeof k!="function"&&(k=k.EventEmitter),d.__signal_exit_emitter__?p=d.__signal_exit_emitter__:(p=d.__signal_exit_emitter__=new k,p.count=0,p.emitted={}),p.infinite||(p.setMaxListeners(1/0),p.infinite=!0),O.exports=function(e,t){if(!b(global.process))return function(){};qt.equal(typeof e,"function","a callback must be provided for exit handler"),A===!1&&fe();var r="exit";t&&t.alwaysLast&&(r="afterexit");var n=function(){p.removeListener(r,e),p.listeners("exit").length===0&&p.listeners("afterexit").length===0&&W()};return p.on(r,e),n},W=function(){!A||!b(global.process)||(A=!1,G.forEach(function(t){try{d.removeListener(t,z[t])}catch{}}),d.emit=V,d.reallyExit=pe,p.count-=1)},O.exports.unload=W,v=function(t,r,n){p.emitted[t]||(p.emitted[t]=!0,p.emit(t,r,n))},z={},G.forEach(function(e){z[e]=function(){if(b(global.process)){var r=d.listeners(e);r.length===p.count&&(W(),v("exit",null,e),v("afterexit",null,e),Nt&&e==="SIGHUP"&&(e="SIGINT"),d.kill(d.pid,e))}}}),O.exports.signals=function(){return G},A=!1,fe=function(){A||!b(global.process)||(A=!0,p.count+=1,G=G.filter(function(t){try{return d.on(t,z[t]),!0}catch{return!1}}),d.emit=_t,d.reallyExit=kt)},O.exports.load=fe,pe=d.reallyExit,kt=function(t){b(global.process)&&(d.exitCode=t||0,v("exit",d.exitCode,null),v("afterexit",d.exitCode,null),pe.call(d,d.exitCode))},V=d.emit,_t=function(t,r){if(t==="exit"&&b(global.process)){r!==void 0&&(d.exitCode=r);var n=V.apply(this,arguments);return v("exit",d.exitCode,null),v("afterexit",d.exitCode,null),n}else return V.apply(this,arguments)}):O.exports=function(){return function(){}};var qt,G,Nt,k,p,W,v,z,A,fe,pe,kt,V,_t});var Lt=c((Hs,Bt)=>{"use strict";var Sr=require("os"),yr=$t(),gr=1e3*5,xr=(e,t="SIGTERM",r={})=>{let n=e(t);return wr(e,t,r,n),n},wr=(e,t,r,n)=>{if(!br(t,r,n))return;let s=Er(r),o=setTimeout(()=>{e("SIGKILL")},s);o.unref&&o.unref()},br=(e,{forceKillAfterTimeout:t},r)=>vr(e)&&t!==!1&&r,vr=e=>e===Sr.constants.signals.SIGTERM||typeof e=="string"&&e.toUpperCase()==="SIGTERM",Er=({forceKillAfterTimeout:e=!0})=>{if(e===!0)return gr;if(!Number.isFinite(e)||e<0)throw new TypeError(`Expected the \`forceKillAfterTimeout\` option to be a non-negative integer, got \`${e}\` (${typeof e})`);return e},Ir=(e,t)=>{e.kill()&&(t.isCanceled=!0)},Tr=(e,t,r)=>{e.kill(t),r(Object.assign(new Error("Timed out"),{timedOut:!0,signal:t}))},Pr=(e,{timeout:t,killSignal:r="SIGTERM"},n)=>{if(t===0||t===void 0)return n;let s,o=new Promise((a,u)=>{s=setTimeout(()=>{Tr(e,r,u)},t)}),i=n.finally(()=>{clearTimeout(s)});return Promise.race([o,i])},Cr=({timeout:e})=>{if(e!==void 0&&(!Number.isFinite(e)||e<0))throw new TypeError(`Expected the \`timeout\` option to be a non-negative integer, got \`${e}\` (${typeof e})`)},Gr=async(e,{cleanup:t,detached:r},n)=>{if(!t||r)return n;let s=yr(()=>{e.kill()});return n.finally(()=>{s()})};Bt.exports={spawnedKill:xr,spawnedCancel:Ir,setupTimeout:Pr,validateTimeout:Cr,setExitHandler:Gr}});var Mt=c((Ks,jt)=>{"use strict";var x=e=>e!==null&&typeof e=="object"&&typeof e.pipe=="function";x.writable=e=>x(e)&&e.writable!==!1&&typeof e._write=="function"&&typeof e._writableState=="object";x.readable=e=>x(e)&&e.readable!==!1&&typeof e._read=="function"&&typeof e._readableState=="object";x.duplex=e=>x.writable(e)&&x.readable(e);x.transform=e=>x.duplex(e)&&typeof e._transform=="function";jt.exports=x});var Ut=c((Xs,Ft)=>{"use strict";var{PassThrough:Ar}=require("stream");Ft.exports=e=>{e={...e};let{array:t}=e,{encoding:r}=e,n=r==="buffer",s=!1;t?s=!(r||n):r=r||"utf8",n&&(r=null);let o=new Ar({objectMode:s});r&&o.setEncoding(r);let i=0,a=[];return o.on("data",u=>{a.push(u),s?i=a.length:i+=u.length}),o.getBufferedValue=()=>t?a:n?Buffer.concat(a,i):a.join(""),o.getBufferedLength=()=>i,o}});var Dt=c((Ws,_)=>{"use strict";var{constants:Or}=require("buffer"),Rr=require("stream"),{promisify:qr}=require("util"),Nr=Ut(),kr=qr(Rr.pipeline),Y=class extends Error{constructor(){super("maxBuffer exceeded"),this.name="MaxBufferError"}};async function me(e,t){if(!e)throw new Error("Expected a stream");t={maxBuffer:1/0,...t};let{maxBuffer:r}=t,n=Nr(t);return await new Promise((s,o)=>{let i=a=>{a&&n.getBufferedLength()<=Or.MAX_LENGTH&&(a.bufferedData=n.getBufferedValue()),o(a)};(async()=>{try{await kr(e,n),s()}catch(a){i(a)}})(),n.on("data",()=>{n.getBufferedLength()>r&&i(new Y)})}),n.getBufferedValue()}_.exports=me;_.exports.buffer=(e,t)=>me(e,{...t,encoding:"buffer"});_.exports.array=(e,t)=>me(e,{...t,array:!0});_.exports.MaxBufferError=Y});var Kt=c((zs,Ht)=>{"use strict";var{PassThrough:_r}=require("stream");Ht.exports=function(){var e=[],t=new _r({objectMode:!0});return t.setMaxListeners(0),t.add=r,t.isEmpty=n,t.on("unpipe",s),Array.prototype.slice.call(arguments).forEach(r),t;function r(o){return Array.isArray(o)?(o.forEach(r),this):(e.push(o),o.once("end",s.bind(null,o)),o.once("error",t.emit.bind(t,"error")),o.pipe(t,{end:!1}),this)}function n(){return e.length==0}function s(o){e=e.filter(function(i){return i!==o}),!e.length&&t.readable&&t.end()}}});var Vt=c((Vs,zt)=>{"use strict";var Wt=Mt(),Xt=Dt(),$r=Kt(),Br=(e,t)=>{t===void 0||e.stdin===void 0||(Wt(t)?t.pipe(e.stdin):e.stdin.end(t))},Lr=(e,{all:t})=>{if(!t||!e.stdout&&!e.stderr)return;let r=$r();return e.stdout&&r.add(e.stdout),e.stderr&&r.add(e.stderr),r},he=async(e,t)=>{if(e){e.destroy();try{return await t}catch(r){return r.bufferedData}}},Se=(e,{encoding:t,buffer:r,maxBuffer:n})=>{if(!(!e||!r))return t?Xt(e,{encoding:t,maxBuffer:n}):Xt.buffer(e,{maxBuffer:n})},jr=async({stdout:e,stderr:t,all:r},{encoding:n,buffer:s,maxBuffer:o},i)=>{let a=Se(e,{encoding:n,buffer:s,maxBuffer:o}),u=Se(t,{encoding:n,buffer:s,maxBuffer:o}),l=Se(r,{encoding:n,buffer:s,maxBuffer:o*2});try{return await Promise.all([i,a,u,l])}catch(f){return Promise.all([{error:f,signal:f.signal,timedOut:f.timedOut},he(e,a),he(t,u),he(r,l)])}},Mr=({input:e})=>{if(Wt(e))throw new TypeError("The `input` option cannot be a stream in sync mode")};zt.exports={handleInput:Br,makeAllStream:Lr,getSpawnedResult:jr,validateInputSync:Mr}});var Jt=c((Ys,Yt)=>{"use strict";var Fr=(async()=>{})().constructor.prototype,Ur=["then","catch","finally"].map(e=>[e,Reflect.getOwnPropertyDescriptor(Fr,e)]),Dr=(e,t)=>{for(let[r,n]of Ur){let s=typeof t=="function"?(...o)=>Reflect.apply(n.value,t(),o):n.value.bind(t);Reflect.defineProperty(e,r,{...n,value:s})}return e},Hr=e=>new Promise((t,r)=>{e.on("exit",(n,s)=>{t({exitCode:n,signal:s})}),e.on("error",n=>{r(n)}),e.stdin&&e.stdin.on("error",n=>{r(n)})});Yt.exports={mergePromise:Dr,getSpawnedPromise:Hr}});var en=c((Js,Zt)=>{"use strict";var Qt=(e,t=[])=>Array.isArray(t)?[e,...t]:[e],Kr=/^[\w.-]+$/,Xr=/"/g,Wr=e=>typeof e!="string"||Kr.test(e)?e:`"${e.replace(Xr,'\\"')}"`,zr=(e,t)=>Qt(e,t).join(" "),Vr=(e,t)=>Qt(e,t).map(r=>Wr(r)).join(" "),Yr=/ +/g,Jr=e=>{let t=[];for(let r of e.trim().split(Yr)){let n=t[t.length-1];n&&n.endsWith("\\")?t[t.length-1]=`${n.slice(0,-1)} ${r}`:t.push(r)}return t};Zt.exports={joinCommand:zr,getEscapedCommand:Vr,parseCommand:Jr}});var cn=c((Qs,R)=>{"use strict";var Qr=require("path"),ye=require("child_process"),Zr=dt(),es=pt(),ts=St(),ns=wt(),J=Gt(),nn=Ot(),{spawnedKill:rs,spawnedCancel:ss,setupTimeout:os,validateTimeout:is,setExitHandler:as}=Lt(),{handleInput:cs,getSpawnedResult:us,makeAllStream:ls,validateInputSync:ds}=Vt(),{mergePromise:tn,getSpawnedPromise:fs}=Jt(),{joinCommand:rn,parseCommand:sn,getEscapedCommand:on}=en(),ps=1e3*1e3*100,ms=({env:e,extendEnv:t,preferLocal:r,localDir:n,execPath:s})=>{let o=t?{...process.env,...e}:e;return r?ts.env({env:o,cwd:n,execPath:s}):o},an=(e,t,r={})=>{let n=Zr._parse(e,t,r);return e=n.command,t=n.args,r=n.options,r={maxBuffer:ps,buffer:!0,stripFinalNewline:!0,extendEnv:!0,preferLocal:!1,localDir:r.cwd||process.cwd(),execPath:process.execPath,encoding:"utf8",reject:!0,cleanup:!0,all:!1,windowsHide:!0,...r},r.env=ms(r),r.stdio=nn(r),process.platform==="win32"&&Qr.basename(e,".exe")==="cmd"&&t.unshift("/q"),{file:e,args:t,options:r,parsed:n}},$=(e,t,r)=>typeof t!="string"&&!Buffer.isBuffer(t)?r===void 0?void 0:"":e.stripFinalNewline?es(t):t,Q=(e,t,r)=>{let n=an(e,t,r),s=rn(e,t),o=on(e,t);is(n.options);let i;try{i=ye.spawn(n.file,n.args,n.options)}catch(S){let y=new ye.ChildProcess,g=Promise.reject(J({error:S,stdout:"",stderr:"",all:"",command:s,escapedCommand:o,parsed:n,timedOut:!1,isCanceled:!1,killed:!1}));return tn(y,g)}let a=fs(i),u=os(i,n.options,a),l=as(i,n.options,u),f={isCanceled:!1};i.kill=rs.bind(null,i.kill.bind(i)),i.cancel=ss.bind(null,i,f);let m=ns(async()=>{let[{error:S,exitCode:y,signal:g,timedOut:E},B,L,mn]=await us(i,n.options,l),xe=$(n.options,B),we=$(n.options,L),be=$(n.options,mn);if(S||y!==0||g!==null){let ve=J({error:S,exitCode:y,signal:g,stdout:xe,stderr:we,all:be,command:s,escapedCommand:o,parsed:n,timedOut:E,isCanceled:f.isCanceled,killed:i.killed});if(!n.options.reject)return ve;throw ve}return{command:s,escapedCommand:o,exitCode:0,stdout:xe,stderr:we,all:be,failed:!1,timedOut:!1,isCanceled:!1,killed:!1}});return cs(i,n.options.input),i.all=ls(i,n.options),tn(i,m)};R.exports=Q;R.exports.sync=(e,t,r)=>{let n=an(e,t,r),s=rn(e,t),o=on(e,t);ds(n.options);let i;try{i=ye.spawnSync(n.file,n.args,n.options)}catch(l){throw J({error:l,stdout:"",stderr:"",all:"",command:s,escapedCommand:o,parsed:n,timedOut:!1,isCanceled:!1,killed:!1})}let a=$(n.options,i.stdout,i.error),u=$(n.options,i.stderr,i.error);if(i.error||i.status!==0||i.signal!==null){let l=J({stdout:a,stderr:u,error:i.error,signal:i.signal,exitCode:i.status,command:s,escapedCommand:o,parsed:n,timedOut:i.error&&i.error.code==="ETIMEDOUT",isCanceled:!1,killed:i.signal!==null});if(!n.options.reject)return l;throw l}return{command:s,escapedCommand:o,exitCode:0,stdout:a,stderr:u,failed:!1,timedOut:!1,isCanceled:!1,killed:!1}};R.exports.command=(e,t)=>{let[r,...n]=sn(e);return Q(r,n,t)};R.exports.commandSync=(e,t)=>{let[r,...n]=sn(e);return Q.sync(r,n,t)};R.exports.node=(e,t,r={})=>{t&&!Array.isArray(t)&&typeof t=="object"&&(r=t,t=[]);let n=nn.node(r),s=process.execArgv.filter(a=>!a.startsWith("--inspect")),{nodePath:o=process.execPath,nodeOptions:i=s}=r;return Q(o,[...i,e,...Array.isArray(t)?t:[]],{...r,stdin:void 0,stdout:void 0,stderr:void 0,stdio:n,shell:!1})}});var Ss={};wn(Ss,{default:()=>pn});module.exports=bn(Ss);var un=Ie(require("node:process"),1),ln=Ie(cn(),1);async function dn(e,{humanReadableOutput:t=!0}={}){if(un.default.platform!=="darwin")throw new Error("macOS only");let r=t?[]:["-ss"],{stdout:n}=await(0,ln.default)("osascript",["-e",e,r]);return n}var fn=require("@raycast/api");var w=require("@raycast/api");async function hs(){return(await(0,w.getApplications)()).some(({bundleId:r})=>r==="net.shinystone.OKJSON")}async function ge(){return await hs()?Promise.resolve(!0):(await(0,w.confirmAlert)({title:"OK JSON is not installed.",message:"Do you want to install it right now?",primaryAction:{title:"Install",onAction:async()=>{(0,w.open)("https://apps.apple.com/app/ok-json-offline-private/id1576121509?mt=12"),await(0,w.popToRoot)({clearSearchBar:!1})}},dismissAction:{title:"Cancel",onAction:async()=>{await(0,w.popToRoot)({clearSearchBar:!1})}}}),Promise.resolve(!1))}async function pn(){await ge()&&(await dn(`
  tell application id "net.shinystone.OKJSON"
		show History
  end tell
`),await(0,fn.closeMainWindow)({clearRootSearch:!0}))}
