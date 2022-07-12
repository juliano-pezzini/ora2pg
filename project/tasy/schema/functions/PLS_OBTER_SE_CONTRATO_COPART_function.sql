-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_contrato_copart ( nr_seq_contrato_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(10);
qt_registros_w		bigint;


BEGIN

ds_retorno_w	:= 'N';

if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_regra_coparticipacao
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	clock_timestamp() between coalesce(dt_inicio_vigencia, clock_timestamp()) and coalesce(dt_fim_vigencia, clock_timestamp())  LIMIT 1;

	if (qt_registros_w > 0) then
		ds_retorno_w	:= 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_contrato_copart ( nr_seq_contrato_p bigint) FROM PUBLIC;
