/*------------------------------------------------------------------------------------------ 
  PROGRAMMER   : Nick Newbill - nick.newbill@sas.com 
  PURPOSE      : MULTI-LOAD DATA EXAMPLE
 
|------------------------------------------------------------------------------------------| 
|  MAINTENANCE HISTORY                                                                
|------------------------------------------------------------------------------------------| 
|  DATE    |     BY    | DESCRIPTION OF CHANGE                              
|----------|-----------|-------------------------------------------------------------------|   
| 8/9/18   | Developer | Initial release 
|------------------------------------------------------------------------------------------|
|  The following code tests multi-load functionality with supported file
|  types that is shared across CAS worker nodes.  
|-----------------------------------------------------------------------------------------*/

%let sharedPath=/opt/sas/project/data;
%let sharedPath2=/opt/sas/project/data/sample;

%let sessid=&sysuserid ;
%put My Userid is: &sessid;
%let session=&sessid.Session;
options msglevel=i ;

options cashost="localhost" casport=5570;
cas &session uuidmac=&sessid._uuid 
           sessopts=(metrics=true timeout=3600 locale="en_US");

/* Both methods below process the same, only shows different ways of doing it. */
caslib casdnfs path="&sharedPath" type=dnfs global;
caslib casdnfs2 datasource=(srctype="dnfs") path="&sharedPath2";

proc casutil ;
   list files incaslib="casdnfs" ;
   list files incaslib="casdnfs2" ;
quit ;

cas &session sessopts=(caslib="casdnfs") ;

proc casutil;
	load casdata="health.csv" casout="health" replace ;
run;
quit;

cas &session sessopts=(caslib="casdnfs2") ;

proc casutil;
	load casdata="cars.sashdat" casout="cars" replace ;
run;
quit;

proc cas;
  table.dropcaslib / caslib='casdnfs';
  run;
cas &session terminate;