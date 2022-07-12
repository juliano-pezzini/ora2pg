-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_vigencia_plantao_terc ( nr_seq_terceiro_p bigint, cd_medico_p text, dt_plantao_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
qt_vig_w		bigint;


BEGIN

select 	count(1)
into STRICT	qt_vig_w
from 	terceiro_pessoa_fisica
where	nr_seq_terceiro		= nr_seq_terceiro_p
and	dt_plantao_p	 	between 	coalesce(dt_inicio_vigencia,dt_plantao_p) and coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days')
and	cd_pessoa_fisica = cd_medico_p;

if (qt_vig_w = 0) then
	select 	count(1)
	into STRICT	qt_vig_w
	from 	terceiro
	where	nr_sequencia		= nr_seq_terceiro_p
	and	dt_plantao_p	 	between 	coalesce(dt_inicio_vigencia,dt_plantao_p) and coalesce(dt_fim_vigencia,clock_timestamp() + interval '1 days')
	and	cd_pessoa_fisica = cd_medico_p;
end if;

if (qt_vig_w = 0) then
	ds_retorno_w	:= 'N';
else
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_vigencia_plantao_terc ( nr_seq_terceiro_p bigint, cd_medico_p text, dt_plantao_p timestamp) FROM PUBLIC;

