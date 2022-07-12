-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_lote_pagamento (nr_seq_lote_pagamento_p pls_lote_pagamento.nr_sequencia%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
ie_opcao_p
	DN	- Data de emissão da nota fiscal
	ON	- Operação da nota fiscal
	NN	- Natureza da nota fiscal
	VL	- Valor lote líquido
	VB	- Valor bruto trás o valor bruto antes de qualquer desconto
	VLP	- Para retornar os valores do PLS_PAGAMENTO_PRESTADOR.VL_PAGAMENTO com valor positivos.
	VLR	- Para retornar os valores do PLS_PAGAMENTO_PRESTADOR.VL_PAGAMENTO com valor negativos.
	VLB	- Valor bruto lote, neste campo consideram apenas os eventos de provento menos os descontos
*/
ds_retorno_w		varchar(255);
nr_seq_nota_w		bigint;
dt_emissao_w		timestamp;
cd_operacao_nf_w	smallint;
cd_natureza_operacao_w	smallint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_nota_w
from	nota_fiscal
where	nr_seq_lote_res_pls = nr_seq_lote_pagamento_p;

if (nr_seq_nota_w IS NOT NULL AND nr_seq_nota_w::text <> '') then

	select	dt_emissao,
		cd_operacao_nf,
		cd_natureza_operacao
	into STRICT	dt_emissao_w,
		cd_operacao_nf_w,
		cd_natureza_operacao_w
	from	nota_fiscal
	where	nr_sequencia = nr_seq_nota_w;

	if (ie_opcao_p = 'DN') then

		ds_retorno_w	:= dt_emissao_w;

	elsif (ie_opcao_p = 'ON') and (coalesce(cd_operacao_nf_w,0) <> 0) then
		select	ds_operacao_nf
		into STRICT	ds_retorno_w
		from	operacao_nota
		where	cd_operacao_nf	= cd_operacao_nf_w;

	elsif (ie_opcao_p = 'NN') and (coalesce(cd_natureza_operacao_w,0) <> 0) then
		select	ds_natureza_operacao
		into STRICT	ds_retorno_w
		from	natureza_operacao
		where	cd_natureza_operacao = cd_natureza_operacao_w;
	end if;

elsif (ie_opcao_p = 'VL') then

	select	coalesce(sum(a.vl_pagamento), 0)
	into STRICT	ds_retorno_w
	from	pls_pagamento_prestador a
	where	a.nr_seq_lote = nr_seq_lote_pagamento_p
	and	coalesce(a.ie_cancelamento::text, '') = '';

elsif (ie_opcao_p = 'VLP') then

	select	coalesce(sum(a.vl_pagamento), 0)
	into STRICT	ds_retorno_w
	from	pls_pagamento_prestador a
	where	coalesce(a.vl_pagamento,0) > 0
	and	a.nr_seq_lote = nr_seq_lote_pagamento_p
	and	coalesce(a.ie_cancelamento::text, '') = '';

elsif (ie_opcao_p = 'VLR') then

	select	coalesce(sum(a.vl_pagamento), 0)
	into STRICT	ds_retorno_w
	from	pls_pagamento_prestador a
	where	coalesce(a.vl_pagamento,0) < 0
	and	a.nr_seq_lote = nr_seq_lote_pagamento_p
	and	coalesce(a.ie_cancelamento::text, '') = '';

elsif (ie_opcao_p = 'VB') then

	select	coalesce(sum(b.vl_item), 0)
	into STRICT	ds_retorno_w
	from	pls_evento c,
		pls_pagamento_item b,
		pls_pagamento_prestador a
	where	a.nr_sequencia = b.nr_seq_pagamento
	and	c.nr_sequencia = b.nr_seq_evento
	and	c.ie_natureza = 'P'
	and	coalesce(b.vl_item,0) > 0
	and	a.nr_seq_lote = nr_seq_lote_pagamento_p
	and 	coalesce(a.ie_cancelamento::text, '') = '';

elsif (ie_opcao_p = 'VLB') then

	select	coalesce(sum(b.vl_item), 0)
	into STRICT	ds_retorno_w
	from	pls_pagamento_prestador a,
		pls_pagamento_item b
	where	a.nr_seq_lote = nr_seq_lote_pagamento_p
	and  	b.nr_seq_pagamento = a.nr_sequencia
	and 	coalesce(a.ie_cancelamento::text, '') = '';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_lote_pagamento (nr_seq_lote_pagamento_p pls_lote_pagamento.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;

