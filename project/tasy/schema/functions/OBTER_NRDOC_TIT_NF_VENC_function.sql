-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nrdoc_tit_nf_venc (nr_seq_nota_fiscal_p bigint, dt_vencimento_p timestamp) RETURNS varchar AS $body$
DECLARE


nr_titulo_w		bigint;
nr_nota_fiscal_w	varchar(255);
nr_documento_w		varchar(30);


BEGIN

select	nr_nota_fiscal
into STRICT	nr_nota_fiscal_w
from	nota_fiscal
where	nr_sequencia = nr_seq_nota_fiscal_p;

nr_titulo_w	:= null;
nr_documento_w  := null;

/* Primeiro busca nos títulos a pagar */

select	max(nr_titulo)
into STRICT	nr_titulo_w
from	titulo_pagar
where	nr_seq_nota_fiscal		= nr_seq_nota_fiscal_p
and	trunc(dt_vencimento_original, 'dd')	= trunc(dt_vencimento_p, 'dd');

if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
	begin

	select	substr(trim(both max(nr_documento)),1,30)
	into STRICT	nr_documento_w
	from	titulo_pagar
	where	nr_titulo = nr_titulo_w;

	end;
end if;

/* Se não achou procura nos títulos a receber pela sequencia da nota */

if (coalesce(nr_titulo_w::text, '') = '') then

	select	max(nr_titulo)
	into STRICT	nr_titulo_w
	from	titulo_receber
	where	nr_seq_nf_saida			= nr_seq_nota_fiscal_p
	and	trunc(dt_vencimento, 'dd')	= trunc(dt_vencimento_p, 'dd');

	/* Se não achou, busca então pelo número da nota */

	if (coalesce(nr_titulo_w::text, '') = '') then

		select	max(nr_titulo)
		into STRICT	nr_titulo_w
		from	titulo_receber
		where	nr_nota_fiscal			= nr_nota_fiscal_w
		and	(nr_nota_fiscal IS NOT NULL AND nr_nota_fiscal::text <> '')
		and	coalesce(nr_seq_nf_saida::text, '') = ''
		and	trunc(dt_vencimento, 'dd')	= trunc(dt_vencimento_p, 'dd');

	end if;

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		begin

		select	substr(trim(both max(nr_documento)),1,30)
		into STRICT	nr_documento_w
		from	titulo_receber
		where	nr_titulo = nr_titulo_w;

		end;
	end if;

end if;


return	nr_documento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nrdoc_tit_nf_venc (nr_seq_nota_fiscal_p bigint, dt_vencimento_p timestamp) FROM PUBLIC;

