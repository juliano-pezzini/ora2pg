-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_unid_escala_dia (nr_seq_escala_dia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);


BEGIN
if (nr_seq_escala_dia_p IS NOT NULL AND nr_seq_escala_dia_p::text <> '') then
	select	max(substr(hd_obter_desc_unid_dialise(a.NR_SEQ_UNID_DIALISE),1,80))
	into STRICT	ds_retorno_w
	from	hd_escala_dialise a,
		hd_escala_dialise_dia b
	where	a.nr_sequencia = b.nr_seq_escala
	and	b.nr_sequencia = nr_seq_escala_dia_p;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_unid_escala_dia (nr_seq_escala_dia_p bigint) FROM PUBLIC;

