-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_chegada_paciente ( cd_pessoa_fisica_p text, ie_pac_faltou_p text default 'T') RETURNS varchar AS $body$
DECLARE


dt_chegada_w		timestamp;


BEGIN

begin
select	max(dt_chegada)
into STRICT	dt_chegada_w
from	hd_prc_chegada
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and		dt_chegada between  trunc(clock_timestamp()) and fim_dia(clock_timestamp())
and		((coalesce(ie_pac_faltou,'N') = coalesce(ie_pac_faltou_p,'N')) or (ie_pac_faltou_p = 'T'));
exception
	when others then
	dt_chegada_w		:= null;
end;

return to_char(dt_chegada_w, 'dd/mm/yyyy hh24:mi:ss');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_chegada_paciente ( cd_pessoa_fisica_p text, ie_pac_faltou_p text default 'T') FROM PUBLIC;
