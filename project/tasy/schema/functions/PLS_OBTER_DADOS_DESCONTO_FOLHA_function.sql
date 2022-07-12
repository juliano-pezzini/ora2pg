-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_desconto_folha ( nr_seq_lote_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*IE_OPCAO_P
B	=	Número de beneficiários
M	=	Matrícula Desconto em folha
E	=	Empresa desconto em folha
P	=	Pagadores
T	=	Total beneficiarios lote*/
nr_seq_pagador_w	numeric(20);
ds_retorno_w		varchar(400);
nr_sequencia_w		numeric(20);


BEGIN

select	max(nr_seq_pagador)
into STRICT	nr_seq_pagador_w
from	pls_mensalidade
where	nr_seq_lote = nr_seq_lote_p;

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	pls_mensalidade
where	nr_seq_lote = nr_seq_lote_p;

if (ie_opcao_p = 'M') then
	select	max(cd_matricula)
	into STRICT	ds_retorno_w
	from	pls_contrato_pagador_fin	a,
		pls_contrato_pagador		b,
		pls_mensalidade			c
	where	c.nr_seq_pagador = b.nr_sequencia
	and	a.nr_seq_pagador = b.nr_sequencia
	and	c.nr_seq_pagador = nr_seq_pagador_w;
elsif (ie_opcao_p = 'B') then
	select	count(*)
	into STRICT	ds_retorno_w
	from	pls_mensalidade_segurado
	where	nr_seq_mensalidade = nr_sequencia_w;
elsif (ie_opcao_p = 'P') then
	select	count(*)
	into STRICT	ds_retorno_w
	from	pls_mensalidade
	where	nr_seq_lote = nr_seq_lote_p
	and	coalesce(ie_cancelamento::text, '') = '';
elsif (ie_opcao_p = 'T') then
	select count(*)
	into STRICT	ds_retorno_w
	from	pls_mensalidade_segurado	a,
		pls_mensalidade			b,
		pls_lote_mensalidade		c
	where	b.nr_seq_lote = c.nr_sequencia
	and	a.nr_seq_mensalidade = b.nr_sequencia
	and	b.nr_seq_lote = nr_seq_lote_p
	and	coalesce(b.ie_cancelamento::text, '') = '';
elsif (ie_opcao_p = 'E') then
	select	max(substr(pls_obter_dados_empresa(a.nr_seq_empresa,'D'),1,250))
	into STRICT	ds_retorno_w
	from	pls_contrato_pagador_fin	a,
		pls_contrato_pagador		b,
		pls_mensalidade			c
	where	c.nr_seq_pagador = b.nr_sequencia
	and	a.nr_seq_pagador = b.nr_sequencia
	and	c.nr_seq_pagador = nr_seq_pagador_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_desconto_folha ( nr_seq_lote_p bigint, ie_opcao_p text) FROM PUBLIC;
