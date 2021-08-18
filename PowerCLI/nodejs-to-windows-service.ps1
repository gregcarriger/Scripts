var Service = require('node-windows').Service; 
var svc = new Service({ 
 name:'CustomServiceName', 
  description: 'CustomServiceName', 
  script: 'F:\\Program Files\\nodejs\\node.exe', 
  scriptOptions: '--file F:\\CustomServiceName\\CustomServiceName.js' 
}); 
 svc.on('install',function(){ 
  svc.start(); 
}); 
svc.install(); 
