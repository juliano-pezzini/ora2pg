-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_trat_princ (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(50);


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	select	max(substr(rp_obter_tipo_tratamento(nr_seq_tipo_tratamento),1,255))
	into STRICT	ds_retorno_w
	from	RP_TRATAMENTO
	where	NR_SEQ_PAC_REAV = nr_sequencia_p
	and	IE_TRAT_PRINCIPAL = 'S';

	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_trat_princ (nr_sequencia_p bigint) FROM PUBLIC;

