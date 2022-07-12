-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_pac_dia_dialise ( cd_pessoa_fisica_p text, ie_dia_semana_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

nr_seq_escala_w		bigint;
ds_retorno_w		varchar(1) := 'N';


BEGIN

select 	hd_obter_escala_prc(cd_pessoa_fisica_p, 'C')
into STRICT	nr_seq_escala_w
;

if (coalesce(nr_seq_escala_w,0) > 0) then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	hd_escala_dia_semana
	where	nr_seq_escala = nr_seq_escala_w
	and	ie_dia_semana = ie_dia_semana_p;

end if;
return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_pac_dia_dialise ( cd_pessoa_fisica_p text, ie_dia_semana_p bigint, ie_opcao_p text) FROM PUBLIC;

