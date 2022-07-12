-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pb_obter_desc_motivo_manut (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select 	max(DS_MOTIVO)
	into STRICT	DS_RETORNO_W
	from 	RP_MOTIVO_MANUTENCAO
	where	nr_sequencia = nr_sequencia_P;

end if;

return	DS_RETORNO_W;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pb_obter_desc_motivo_manut (nr_sequencia_p bigint) FROM PUBLIC;
