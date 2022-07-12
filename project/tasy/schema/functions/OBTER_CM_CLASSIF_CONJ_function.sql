-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cm_classif_conj (nr_seq_conjunto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_classificacao_w		varchar(200);


BEGIN

select	b.ds_classificacao
into STRICT	ds_classificacao_w
from	cm_classif_conjunto b,
	cm_conjunto a
where	a.nr_seq_classif	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_conjunto_p;

return	ds_classificacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cm_classif_conj (nr_seq_conjunto_p bigint) FROM PUBLIC;

