-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION con_pr_conecimento_tasy (cd_consultor_p bigint) RETURNS varchar AS $body$
DECLARE


soma_pr_fun_tasy_w	bigint;
soma_pr_fun_con_w	bigint;
vl_retorno_w		varchar(15);


BEGIN

select (count(distinct cd_funcao) * 100)
into STRICT	soma_pr_fun_tasy_w
from   funcao
where  ie_situacao = 'A';

select	sum(d.pr_conhecimento)
into STRICT	soma_pr_fun_con_w
from	com_cons_gest_con_mod a,
	modulo_implantacao b,
	com_canal_consultor c,
	com_cons_gest_con_fun d
where	a.nr_seq_mod_impl = b.nr_sequencia
and	c.nr_sequencia = a.nr_seq_consultor
and	a.nr_sequencia = d.nr_seq_conhecimento
and	c.cd_pessoa_fisica = cd_consultor_p;

select	substr(campo_mascara_virgula_casas(((soma_pr_fun_con_w / soma_pr_fun_tasy_w) * 100),2),1,255) || ' %'
into STRICT	vl_retorno_w
;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION con_pr_conecimento_tasy (cd_consultor_p bigint) FROM PUBLIC;

