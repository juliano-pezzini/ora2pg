-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nf_cobranca_ordenacao (nr_titulo_p bigint) RETURNS bigint AS $body$
DECLARE

			
ds_retorno_w		numeric(38);
nr_nota_fiscal_w	titulo_receber.nr_nota_fiscal%type;

/*Rotina criada para atender a coluna NR_NOTA_FISCAL_ORDENACAO na tabela COBRANCA, coluna function, que tem por objeto trazer a informacao de nr_nota_fiscal do titulo ou NF vinculada ao titulo, 
considerando apenas numeros, e ser possivel ordernar do menor para maior, por isso o return dessa function eh number, se retornar varchar a ordenacao fica incorreta*/
BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	select	coalesce(max(nr_nota_fiscal),'0')
	into STRICT	nr_nota_fiscal_w
	from	titulo_receber
	where	nr_titulo = nr_titulo_p;
	
	if (nr_nota_fiscal_w = '0') then
		select	obter_dados_titulo_receber(nr_titulo, 'NF')
		into STRICT	nr_nota_fiscal_w
		from	titulo_receber
		where	nr_titulo = nr_titulo_p;
	end if;
	
end if;

begin

	nr_nota_fiscal_w := somente_numero_char(nr_nota_fiscal_w); --Deixar somente numeros
	if (nr_nota_fiscal_w IS NOT NULL AND nr_nota_fiscal_w::text <> '') then
		ds_retorno_w := (nr_nota_fiscal_w)::numeric;
	else
		ds_retorno_w := null;
	end if;
	
exception when others then
	ds_retorno_w := null;
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nf_cobranca_ordenacao (nr_titulo_p bigint) FROM PUBLIC;
