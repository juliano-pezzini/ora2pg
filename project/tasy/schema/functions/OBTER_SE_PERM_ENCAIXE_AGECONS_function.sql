-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_perm_encaixe_agecons ( cd_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

ie_perm_encaixe_w	varchar(01);


BEGIN 
ie_perm_encaixe_w	:= 'S';
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') then 
	begin 
 
	select	coalesce(max(ie_perm_encaixe),'S') 
	into STRICT	ie_perm_encaixe_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;
	 
	end;
end if;
 
return ie_perm_encaixe_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_perm_encaixe_agecons ( cd_agenda_p bigint) FROM PUBLIC;

