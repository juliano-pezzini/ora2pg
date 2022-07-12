-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_mens_seg ( nr_seq_mens_seg_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*	ie_opcao_p
		SS - Nr. sequencia segurado
		NS - Nome do segurado
		DR - Data de referencia
		V - Valor da mensalidade
		I - Idade
		C - Contrato
		NC - Numero do contrato (NR_CONTRATO)
		PB - Parcela Beneficiario
		PC - Parcela contrato
		E - Estipulante
		PA - Pagador
		TC - Tipo contrato
		VR - Valor pre-estabelecido
		DA - Data de adesao no contrato
		DL - Data de liquidacao do titulo
		VE - Vendedor
		DV - Descricao vendedor
		LM - Lote mensalidade
		M - Mensalidade
*/
ds_retorno_w			varchar(255);
nr_seq_segurado_w		bigint;
nm_segurado_w			varchar(255);
dt_mesano_referencia_w		timestamp;
vl_mensalidade_w		double precision;
qt_idade_w			smallint;
nr_seq_contrato_w		bigint;
nr_parcela_benef_w		bigint;
nr_parcela_contr_w		bigint;
nm_estipulante_w		varchar(255);
nm_pagador_w			varchar(255);
vl_pre_estab_w			double precision;
ie_tipo_contrato_w		varchar(2);
dt_adesao_w			timestamp;
dt_liquidacao_w			timestamp;
nr_seq_mensalidade_w		bigint;
nr_seq_vendedor_pf_w		bigint;
nm_vendedor_vinculado_w		varchar(255);
nr_seq_lote_w			bigint;
nr_contrato_w			bigint;


BEGIN

select	a.nr_seq_segurado,
	substr(pls_obter_dados_segurado(a.nr_seq_segurado,'NS'),1,255),
	a.dt_mesano_referencia,
	a.vl_mensalidade,
	a.qt_idade,
	c.nr_seq_contrato,
	a.nr_parcela,
	a.nr_parcela_contrato,
	substr(pls_obter_valor_item_mens(a.nr_sequencia,'1'),1,100),
	b.nr_sequencia,
	b.nr_seq_lote
into STRICT	nr_seq_segurado_w,
	nm_segurado_w,
	dt_mesano_referencia_w,
	vl_mensalidade_w,
	qt_idade_w,
	nr_seq_contrato_w,
	nr_parcela_benef_w,
	nr_parcela_contr_w,
	vl_pre_estab_w,
	nr_seq_mensalidade_w,
	nr_seq_lote_w
from	pls_mensalidade_segurado a,
	pls_mensalidade b,
	pls_contrato_pagador c
where	a.nr_seq_mensalidade	= b.nr_sequencia
and	b.nr_seq_pagador	= c.nr_sequencia
and	a.nr_sequencia		= nr_seq_mens_seg_p;

select	max(a.nr_seq_vendedor_pf),
	max(obter_nome_pf(b.cd_pessoa_fisica))
into STRICT	nr_seq_vendedor_pf_w,
	nm_vendedor_vinculado_w
from	pls_segurado a,
	pls_vendedor_vinculado b
where	b.nr_sequencia	= a.nr_seq_vendedor_pf
and	a.nr_sequencia	= nr_seq_segurado_w;

if (ie_opcao_p	= 'SS') then
	ds_retorno_w := to_char(nr_seq_segurado_w);
elsif (ie_opcao_p = 'NS') then
	ds_retorno_w := nm_segurado_w;
elsif (ie_opcao_p = 'DR') then
	ds_retorno_w := to_char(dt_mesano_referencia_w,'dd/mm/yyyy');
elsif (ie_opcao_p = 'V') then
	ds_retorno_w := to_char(vl_mensalidade_w);
elsif (ie_opcao_p = 'I') then
	ds_retorno_w := to_char(qt_idade_w);
elsif (ie_opcao_p = 'C') then
	ds_retorno_w := to_char(nr_seq_contrato_w);
elsif (ie_opcao_p = 'NC') then
	select	nr_contrato
	into STRICT	nr_contrato_w
	from	pls_contrato
	where	nr_sequencia = nr_seq_contrato_w;
	
	ds_retorno_w := to_char(nr_contrato_w);
elsif (ie_opcao_p = 'PB') then
	ds_retorno_w := to_char(nr_parcela_benef_w);
elsif (ie_opcao_p = 'PC') then
	ds_retorno_w := to_char(nr_parcela_contr_w);
elsif (ie_opcao_p = 'E') then
	select	substr(obter_nome_pf_pj(cd_pf_estipulante,cd_cgc_estipulante),1,255)
	into STRICT	nm_estipulante_w
	from	pls_contrato
	where	nr_sequencia = nr_seq_contrato_w;
	
	ds_retorno_w := nm_estipulante_w;
elsif (ie_opcao_p = 'PA') then
	select	substr(pls_obter_dados_pagador(nr_seq_pagador,'N'),1,255)
	into STRICT	nm_pagador_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
	
	ds_retorno_w := nm_pagador_w;
elsif (ie_opcao_p = 'TC') then
	select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN 'PJ'  ELSE 'PF' END
	into STRICT	ie_tipo_contrato_w
	from	pls_contrato
	where	nr_sequencia = nr_seq_contrato_w;
	
	ds_retorno_w := ie_tipo_contrato_w;
elsif (ie_opcao_p = 'VR') then
	ds_retorno_w := to_char(vl_pre_estab_w);
elsif (ie_opcao_p = 'DA') then
	select	trunc(dt_contratacao,'dd')
	into STRICT	dt_adesao_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
	
	ds_retorno_w := to_char(dt_adesao_w,'dd/mm/yyyy');
elsif (ie_opcao_p = 'DL') then
	select	substr(Obter_Dados_Titulo_Receber(pls_obter_titulo_mensalidade(nr_seq_mensalidade_w,null),'L'),1,255)
	into STRICT	dt_liquidacao_w
	from	pls_mensalidade
	where	nr_sequencia = nr_seq_mensalidade_w;
	
	ds_retorno_w := to_char(dt_liquidacao_w,'dd/mm/yyyy');
elsif (ie_opcao_p = 'VE') then
	ds_retorno_w := to_char(nr_seq_vendedor_pf_w);
elsif (ie_opcao_p = 'DV') then
	ds_retorno_w := nm_vendedor_vinculado_w;
elsif (ie_opcao_p = 'LM') then
	ds_retorno_w := to_char(nr_seq_lote_w);
elsif (ie_opcao_p = 'M') then
	ds_retorno_w := to_char(nr_seq_mensalidade_w);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_mens_seg ( nr_seq_mens_seg_p bigint, ie_opcao_p text) FROM PUBLIC;

