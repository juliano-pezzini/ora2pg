-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_saida_pac (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


dt_saida_w	timestamp;

BEGIN

begin
select	max(dt_saida)
into STRICT	dt_saida_w
from	hd_prc_chegada
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	trunc(dt_chegada)	= trunc(clock_timestamp());
exception
	when others then
	dt_saida_w		:= null;
end;

return to_char(dt_saida_w, 'dd/mm/yyyy hh24:mi:ss');


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_saida_pac (cd_pessoa_fisica_p text) FROM PUBLIC;

