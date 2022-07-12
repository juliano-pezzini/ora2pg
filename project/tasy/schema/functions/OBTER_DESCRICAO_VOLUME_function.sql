-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_volume (nr_seq_volume_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(90);


BEGIN

if (nr_seq_volume_p IS NOT NULL AND nr_seq_volume_p::text <> '') then

	select	substr(max(ds_volume),1,90)
	into STRICT	ds_retorno_w
	from	rxt_volume_tratamento
	where	nr_sequencia = nr_seq_volume_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_volume (nr_seq_volume_p bigint) FROM PUBLIC;
