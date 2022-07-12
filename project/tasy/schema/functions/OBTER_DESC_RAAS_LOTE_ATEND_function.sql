-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_raas_lote_atend ( nr_seq_lote_atend_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(300);


BEGIN
if (nr_seq_lote_atend_p IS NOT NULL AND nr_seq_lote_atend_p::text <> '') then
	begin
	select	ds_lote
	into STRICT	ds_retorno_w
	from	raas_lote_atendimentos
	where	nr_sequencia = nr_seq_lote_atend_p;
	end;
end if;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_raas_lote_atend ( nr_seq_lote_atend_p bigint) FROM PUBLIC;

