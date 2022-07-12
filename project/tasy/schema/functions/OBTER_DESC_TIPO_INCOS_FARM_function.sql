-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_incos_farm (nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(200);


BEGIN

if (coalesce(nr_seq_tipo_p,0) > 0) then
	select 	max(ds_tipo)
	into STRICT 	ds_retorno_w
	from 	tipo_inconsistencia_farm
	where 	nr_sequencia = nr_seq_tipo_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_incos_farm (nr_seq_tipo_p bigint) FROM PUBLIC;
