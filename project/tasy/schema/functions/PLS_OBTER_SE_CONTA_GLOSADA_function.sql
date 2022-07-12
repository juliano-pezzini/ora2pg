-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_conta_glosada (nr_seq_conta_p pls_conta.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'N';
qt_itens_w		integer;


BEGIN
select	sum(x)
into STRICT	qt_itens_w
from (
	SELECT	CASE WHEN ie_status='D' THEN  0  ELSE CASE WHEN ie_glosa='S' THEN  0  ELSE 1 END  END  x
	from	pls_conta_proc
	where	nr_seq_conta  = nr_seq_conta_p
	
union all

	SELECT  CASE WHEN ie_status='D' THEN  0  ELSE CASE WHEN ie_glosa='S' THEN  0  ELSE 1 END  END  x
	from	pls_conta_mat
	where	nr_seq_conta  = nr_seq_conta_p
       ) alias1;

if ( qt_itens_w = 0 ) then
	ie_retorno_w := 'S';
else
	qt_itens_w := 0;
	select 	count(1)
	into STRICT	qt_itens_w
	from	pls_conta	c
	where	c.nr_sequencia = nr_seq_conta_p
	and	c.ie_glosa = 'S'
	and	exists (SELECT	1
			 from	pls_conta_glosa cg
			 where	cg.nr_seq_conta	= c.nr_sequencia
			 and	coalesce(cg.nr_seq_conta_proc::text, '') = ''
			 and	coalesce(cg.nr_seq_conta_mat::text, '') = ''
			 and	cg.ie_situacao		= 'A');

	if (qt_itens_w > 0) then
		ie_retorno_w := 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_conta_glosada (nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;

