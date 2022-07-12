-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_online_index_build () RETURNS varchar AS $body$
DECLARE

 
ie_online_index_build_w		varchar(1):= 'N';
--ie_online_redefinition_w	varchar2(1):= 'N'; 
BEGIN 
 
select 	substr(max('S'),1,1) 
into STRICT	ie_online_index_build_w 
from	gv$option 
where	lower(parameter) = 'online index build' 
and	upper(value) = 'TRUE';
 
/* 
Não precisa 
select 	substr(max('S'),1,1) 
into	ie_online_redefinition_w 
from	gv$option 
where	lower(parameter) = 'online redefinition' 
and	upper(value) = 'TRUE';*/
 
 
--if	( ie_online_redefinition_w = 'S' ) and 
if ( ie_online_index_build_w = 'S' ) then 
	return	'S';
else 
	return	'N';
end	if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_online_index_build () FROM PUBLIC;

