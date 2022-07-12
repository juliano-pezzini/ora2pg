-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_req_executada ( nr_seq_requisicao_p bigint) RETURNS varchar AS $body$
DECLARE


qt_reg_w			bigint	:= 0;
qt_guias_proc_w			bigint	:= 0;
qt_guias_mat_w			bigint	:= 0;
qt_guias_w			bigint	:= 0;
ds_retorno_w			varchar(1) := 'N';


BEGIN

select	count(1)
into STRICT	qt_reg_w
from	pls_execucao_req_item
where	nr_seq_requisicao = nr_seq_requisicao_p;

select	count(1)
into STRICT	qt_guias_proc_w
from	pls_guia_plano		c,
	pls_execucao_req_item	b,
	pls_requisicao_proc	a
where	a.nr_sequencia		= b.nr_seq_req_proc
and	a.nr_seq_guia		= c.nr_sequencia
and	a.nr_seq_requisicao	= nr_seq_requisicao_p
and 	c.ie_estagio        	<> 8;

select	count(1)
into STRICT	qt_guias_mat_w
from	pls_guia_plano		c,
	pls_execucao_req_item	b,
	pls_requisicao_mat	a
where	a.nr_sequencia		= b.nr_seq_req_mat
and	a.nr_seq_guia		= c.nr_sequencia
and	a.nr_seq_requisicao	= nr_seq_requisicao_p
and 	c.ie_estagio        	<> 8;

qt_guias_w	:= qt_guias_proc_w + qt_guias_mat_w;

if (qt_reg_w > 0) and (qt_guias_w	> 0) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_req_executada ( nr_seq_requisicao_p bigint) FROM PUBLIC;

