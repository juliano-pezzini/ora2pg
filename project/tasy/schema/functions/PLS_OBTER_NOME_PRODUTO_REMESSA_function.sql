-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_produto_remessa ( nr_seq_mensalidade_p bigint, nr_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


nm_produto_w			varchar(100);
nm_produto_ret_w		varchar(100)	:= null;
nr_ordem_w			bigint	:=0;
ie_ordem_w			bigint;

c01 CURSOR FOR
	SELECT	1 ie_ordem,
		substr(c.ds_plano,1,40) ||'   '|| CASE WHEN coalesce(nr_protocolo_ans::text, '') = '' THEN 'SCPA ' || c.cd_scpa  ELSE 'ANS ' || c.nr_protocolo_ans END  nm_produto
	from	pls_plano	c,
		pls_segurado	b,
		pls_mensalidade_segurado a
	where	a.nr_seq_mensalidade	= nr_seq_mensalidade_p
	and	a.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	order by ie_ordem;


BEGIN
open c01;
loop
fetch c01 into
	ie_ordem_w,
	nm_produto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	nr_ordem_w := nr_ordem_w + 1;

	if (nr_ordem_w = nr_ordem_p) then
		nm_produto_ret_w	:=	nm_produto_w;
	end if;
	end;
end loop;
close c01;

return	nm_produto_ret_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_produto_remessa ( nr_seq_mensalidade_p bigint, nr_ordem_p bigint) FROM PUBLIC;
