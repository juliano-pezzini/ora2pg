-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_nome_oar (nr_seq_oar_p bigint) RETURNS varchar AS $body$
DECLARE


ds_oar_w	varchar(80);


BEGIN
if (nr_seq_oar_p IS NOT NULL AND nr_seq_oar_p::text <> '') then

	select	max(ds_orgao)
	into STRICT	ds_oar_w
	from	rxt_orgam_at_risk
	where	nr_sequencia = nr_seq_oar_p;

end if;

return ds_oar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_nome_oar (nr_seq_oar_p bigint) FROM PUBLIC;
