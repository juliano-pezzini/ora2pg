-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION con_pr_conhecimento_modulo (cd_consultor_p bigint, nr_seq_conhecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(15);


BEGIN

select	round(((sum(b.pr_conhecimento))/(count(b.cd_funcao)*100))*100,2)
into STRICT	ds_retorno_w
from	com_cons_gest_con_mod a,
	com_cons_gest_con_fun b,
	com_canal_consultor c
where	a.nr_sequencia = b.nr_seq_conhecimento
and	c.nr_sequencia = a.nr_seq_consultor
and	b.nr_seq_conhecimento 	= nr_seq_conhecimento_p
and	c.cd_pessoa_fisica 	= cd_consultor_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION con_pr_conhecimento_modulo (cd_consultor_p bigint, nr_seq_conhecimento_p bigint) FROM PUBLIC;

