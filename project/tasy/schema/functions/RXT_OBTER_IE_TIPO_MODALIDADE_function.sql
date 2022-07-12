-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_ie_tipo_modalidade (nr_seq_modalidade_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	rxt_tipo_modalidade.ie_tipo%type;


BEGIN
if (nr_seq_modalidade_p IS NOT NULL AND nr_seq_modalidade_p::text <> '') then

	select	max(ie_tipo)
	into STRICT	ds_retorno_w
	from	rxt_tipo_modalidade
	where	nr_sequencia = nr_seq_modalidade_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_ie_tipo_modalidade (nr_seq_modalidade_p bigint) FROM PUBLIC;
