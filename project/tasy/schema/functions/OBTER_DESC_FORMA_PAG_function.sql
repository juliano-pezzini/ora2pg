-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_forma_pag ( nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE

			
nr_seq_nota_fiscal_w	bigint;
nr_seq_forma_pagto_w	bigint := 0;
nr_ordem_compra_w	bigint;
ds_forma_pagamento_w	varchar(80);
cd_cgc_w		varchar(14);	
qt_forma_pagamento_w	bigint;


BEGIN

qt_forma_pagamento_w	:= 0;

select	coalesce(max(nr_seq_nota_fiscal),0),
		coalesce(max(cd_cgc),'X')
into STRICT	nr_seq_nota_fiscal_w,
		cd_cgc_w
from	titulo_pagar
where	nr_titulo	= nr_titulo_p;

if (nr_seq_nota_fiscal_w > 0) then
	begin

	/*Se tem nota fiscal, busca primeiro da Nota*/

	select	coalesce(max(nr_seq_forma_pagto), 0),
			coalesce(max(nr_ordem_compra),0)
	into STRICT	nr_seq_forma_pagto_w,
			nr_ordem_compra_w
	from	nota_fiscal
	where	nr_sequencia	= nr_seq_nota_fiscal_w;

	if (nr_seq_forma_pagto_w = 0) and (nr_ordem_compra_w > 0) then
		begin
		/*Se não tem na Nota e tem Ordem, busca da Ordem de compras*/

		select	coalesce(max(a.nr_seq_forma_pagto), 0)
		into STRICT	nr_seq_forma_pagto_w
		from	nota_fiscal b,
			ordem_compra a
		where	a.nr_ordem_compra = b.nr_ordem_compra
		and	b.nr_sequencia = nr_seq_nota_fiscal_w;
	
		end;
	end if;

	if (nr_seq_forma_pagto_w > 0) then
		select	ds_forma_pagamento
		into STRICT	ds_forma_pagamento_w
		from	forma_pagamento b
		where   nr_sequencia = nr_seq_forma_pagto_w;
	end if;

	end;
end if;


/*Se ainda não encontrou e tem fornecedor, busca do fornecedor*/

if (nr_seq_forma_pagto_w = 0) and (cd_cgc_w <> 'X') then

	select  substr(obter_valor_dominio(505,obter_dados_pf_pj_estab(1, null, cd_cgc_w, 'EFP')),1,80)
	into STRICT	ds_forma_pagamento_w	
	;

end if;

return	ds_forma_pagamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_forma_pag ( nr_titulo_p bigint) FROM PUBLIC;
