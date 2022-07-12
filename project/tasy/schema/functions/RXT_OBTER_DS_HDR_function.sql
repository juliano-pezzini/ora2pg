-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_ds_hdr ( nr_seq_aplic_trat_p bigint, nr_seq_campo_p bigint, nr_insercao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w varchar(255);


BEGIN

if ((nr_seq_aplic_trat_p IS NOT NULL AND nr_seq_aplic_trat_p::text <> '')
	and (nr_seq_campo_p IS NOT NULL AND nr_seq_campo_p::text <> '')
	and (nr_insercao_p IS NOT NULL AND nr_insercao_p::text <> '')) then

	select	nr_insercao_p || '/' || max(b.nr_insercao)
	into STRICT	ds_resultado_w
	from	rxt_braq_campo_aplic_trat b
	where	b.nr_seq_aplic_trat = nr_seq_aplic_trat_p
	and		b.nr_seq_campo = nr_seq_campo_p;

end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_ds_hdr ( nr_seq_aplic_trat_p bigint, nr_seq_campo_p bigint, nr_insercao_p bigint) FROM PUBLIC;

