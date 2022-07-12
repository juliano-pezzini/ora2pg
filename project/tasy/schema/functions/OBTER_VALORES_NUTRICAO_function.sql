-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_nutricao ( ie_tipo_elemento_p text, nr_seq_nut_pac_p bigint) RETURNS bigint AS $body$
DECLARE


pr_total_w	double precision;


BEGIN

select	sum(a.pr_total)
into STRICT	pr_total_w
from	nut_pac_elemento a,
	nut_elemento b
where	a.nr_seq_nut_pac	= nr_seq_nut_pac_p
and	a.nr_seq_elemento	= b.nr_sequencia
and	b.ie_tipo_elemento	= ie_tipo_elemento_p;

return	pr_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_nutricao ( ie_tipo_elemento_p text, nr_seq_nut_pac_p bigint) FROM PUBLIC;

