-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_agenda_cir (cd_agenda_p bigint) RETURNS bigint AS $body$
DECLARE

nr_retorno_w	bigint;

BEGIN
 
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') then 
	select	max(nr_seq_classif) 
	into STRICT	nr_retorno_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;
	 
end if;
 
return	nr_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_agenda_cir (cd_agenda_p bigint) FROM PUBLIC;

