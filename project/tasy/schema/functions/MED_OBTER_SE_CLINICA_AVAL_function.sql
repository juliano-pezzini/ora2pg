-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_se_clinica_aval (nr_seq_tipo_aval_p bigint, ie_clinica_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(1) := 'S';


BEGIN


if (ie_clinica_p > 0) then
	select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ds_retorno_w
	from	med_clinica_avaliacao;

	if (ds_retorno_w = 'N') then

		select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ds_retorno_w
		from	med_clinica_avaliacao
		where	ie_clinica = ie_clinica_p
		and	nr_seq_tipo_aval = nr_seq_tipo_aval_p;

	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_se_clinica_aval (nr_seq_tipo_aval_p bigint, ie_clinica_p bigint) FROM PUBLIC;
