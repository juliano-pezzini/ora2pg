-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_possui_regra_ap ( nr_seq_regra_p pls_regra_reembolso.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


qt_quantidade_w		bigint := 0;


BEGIN

select 	count(1)
into STRICT	qt_quantidade_w
from 	pls_regra_reemb_acao a,
	pls_regra_reemb_aprop b,
	pls_conta_proc_aprop c
where 	a.nr_sequencia = b.nr_seq_regra_acao
and     b.nr_sequencia = c.nr_seq_regra_aprop
and 	a.nr_seq_regra = nr_seq_regra_p;

if (qt_quantidade_w = 0)	then
	select 	count(1)
	into STRICT	qt_quantidade_w
	from 	pls_regra_reemb_acao a,
		pls_regra_reemb_aprop b,
		pls_conta_mat_aprop c
	where 	a.nr_sequencia = b.nr_seq_regra_acao
	and     b.nr_sequencia = c.nr_seq_regra_aprop
	and 	a.nr_seq_regra = nr_seq_regra_p;
end if;

if (qt_quantidade_w > 0) 	then
	return 'S';
else
	return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_possui_regra_ap ( nr_seq_regra_p pls_regra_reembolso.nr_sequencia%type) FROM PUBLIC;

