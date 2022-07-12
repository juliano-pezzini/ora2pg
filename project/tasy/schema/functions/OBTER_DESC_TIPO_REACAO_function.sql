-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_reacao (NR_SEQ_REACAO_P bigint) RETURNS varchar AS $body$
DECLARE


ds_tipo_reacao_w		varchar(100);


BEGIN


if (nr_seq_reacao_p IS NOT NULL AND nr_seq_reacao_p::text <> '') then
	select	ds_tipo_reacao
	into STRICT	ds_tipo_reacao_w
	from	san_tipo_reacao
	where	nr_seq_reacao_p = nr_sequencia;
end if;

return	ds_tipo_reacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_reacao (NR_SEQ_REACAO_P bigint) FROM PUBLIC;

