-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_desc_posicao ( nr_seq_posicao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);


BEGIN
if (nr_seq_posicao_p IS NOT NULL AND nr_seq_posicao_p::text <> '') then

	select	max(ds_posicao)
	into STRICT	ds_retorno_w
	from	rxt_posicao
	where	nr_sequencia = nr_seq_posicao_p;

end if;
return	ds_retorno_W;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_desc_posicao ( nr_seq_posicao_p bigint) FROM PUBLIC;
