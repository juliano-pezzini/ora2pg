-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_cor_classif_agenda (nr_seq_classif_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_w	varchar(15);


BEGIN
if (nr_seq_classif_p IS NOT NULL AND nr_seq_classif_p::text <> '') then

	select	max(ds_cor)
	into STRICT	ds_cor_w
	from	rxt_classif_agenda
	where	nr_sequencia = nr_seq_classif_p;

end if;

return ds_cor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_cor_classif_agenda (nr_seq_classif_p bigint) FROM PUBLIC;

