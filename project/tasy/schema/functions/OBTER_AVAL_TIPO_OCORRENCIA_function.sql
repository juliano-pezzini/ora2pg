-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_aval_tipo_ocorrencia (cd_tipo_ocorrencia_p text) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	bigint;


BEGIN

if (cd_tipo_ocorrencia_p	is not	null) then

	select 	max(nr_seq_tipo_avaliacao)
	into STRICT	ds_Retorno_w
	from	tipo_ocorrencia_turno
	where	cd_tipo_ocorrencia	= cd_tipo_ocorrencia_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_aval_tipo_ocorrencia (cd_tipo_ocorrencia_p text) FROM PUBLIC;

