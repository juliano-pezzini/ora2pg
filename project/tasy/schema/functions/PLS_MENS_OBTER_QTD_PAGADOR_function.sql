-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_mens_obter_qtd_pagador ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w			bigint	:= 0;
nr_contrato_w			bigint;
nr_dia_inicial_venc_w		smallint;
nr_dia_final_venc_w		smallint;
nr_seq_pagador_mens_w		bigint;
nr_contrato_principal_w		bigint;
nr_seq_grupo_contrato_w		bigint;
nr_seq_empresa_w		bigint;
nr_seq_forma_cobranca_lote_w	bigint;
dt_mesano_referencia_w		timestamp;
cd_banco_lote_w			integer;
ie_tipo_lote_w			varchar(2);
nr_contrato_intercambio_w	bigint;
dt_mesano_referencia_fimdia_w	timestamp;
cd_tipo_portador_w		integer;
cd_portador_w			bigint;
nr_seq_grupo_preco_w		bigint;
qt_w				smallint;
ie_tipo_contrato_intercambio_w	varchar(2);
ie_pagador_beneficio_obito_w	varchar(2);
nr_seq_grupo_inter_w		bigint;
ie_endereco_boleto_lote_w	varchar(4);
ie_tipo_pessoa_pagador_w	varchar(2);
nr_seq_classif_benef_w		pls_classificacao_benef.nr_sequencia%type;

C01 CURSOR FOR /* Pagador ***Responsável por fazer o insert na pls_mensalidade *** */
	SELECT	1
	FROM pls_segurado b, pls_contrato_grupo g
LEFT OUTER JOIN pls_grupo_contrato f ON (g.nr_seq_grupo = f.nr_sequencia)
, pls_contrato c
LEFT OUTER JOIN pls_contrato_grupo g ON (c.nr_sequencia = g.nr_seq_contrato)
LEFT OUTER JOIN pls_preco_contrato h ON (c.nr_sequencia = h.nr_seq_contrato)
LEFT OUTER JOIN pls_preco_grupo_contrato i ON (h.nr_seq_grupo = i.nr_sequencia)
, pls_contrato_pagador a
LEFT OUTER JOIN pls_contrato_pagador_fin d ON (a.nr_sequencia = d.nr_seq_pagador)
LEFT OUTER JOIN pls_desc_empresa e ON (d.nr_seq_empresa = e.nr_sequencia)
WHERE a.nr_seq_contrato	= c.nr_sequencia and b.nr_seq_pagador	= a.nr_sequencia       and c.cd_estabelecimento	= cd_estabelecimento_p and ((a.nr_sequencia	= nr_seq_pagador_mens_w and	(nr_seq_pagador_mens_w IS NOT NULL AND nr_seq_pagador_mens_w::text <> '')) or coalesce(nr_seq_pagador_mens_w::text, '') = '') and ((coalesce(nr_dia_inicial_venc_w::text, '') = '') or (d.dt_dia_vencimento >= nr_dia_inicial_venc_w)) and ((coalesce(nr_dia_final_venc_w::text, '') = '') or (d.dt_dia_vencimento <= nr_dia_final_venc_w)) and (coalesce(nr_contrato_w::text, '') = '' or ((c.nr_sequencia = nr_contrato_w) or (c.nr_contrato_principal = nr_contrato_w))) and ((f.nr_sequencia = nr_seq_grupo_contrato_w) or (coalesce(nr_seq_grupo_contrato_w::text, '') = '')) and ((i.nr_sequencia = nr_seq_grupo_preco_w) or (coalesce(nr_seq_grupo_preco_w::text, '') = '')) and ((coalesce(cd_banco_lote_w::text, '') = '') or (d.cd_banco = cd_banco_lote_w)) and ((coalesce(nr_seq_forma_cobranca_lote_w::text, '') = '') or (d.nr_seq_forma_cobranca = nr_seq_forma_cobranca_lote_w)) and ((e.nr_seq_empresa_superior = nr_seq_empresa_w or e.nr_sequencia = nr_seq_empresa_w) or (coalesce(nr_seq_empresa_w::text, '') = '')) and ((d.cd_tipo_portador = cd_tipo_portador_w) or (coalesce(cd_tipo_portador_w::text, '') = '')) and ((d.cd_portador = cd_portador_w) or (coalesce(cd_portador_w::text, '') = '')) and coalesce(d.dt_inicio_vigencia,dt_mesano_referencia_fimdia_w) <= dt_mesano_referencia_fimdia_w and ((d.dt_fim_vigencia >= dt_mesano_referencia_fimdia_w) or (coalesce(d.dt_fim_vigencia::text, '') = '')) and coalesce(nr_contrato_intercambio_w::text, '') = '' and ((ie_tipo_lote_w	= 'A') or (ie_tipo_lote_w	= 'CO')) /* aaschlote 26/10/2010 - OS - 256840 Gerar mensalidade apenas dos tipos de lote Ambos ou Contratos da Operadora*/
  and ((ie_pagador_beneficio_obito_w = 'S' and (a.nr_seq_regra_obito IS NOT NULL AND a.nr_seq_regra_obito::text <> '')) or (ie_pagador_beneficio_obito_w = 'N')) and ((a.ie_endereco_boleto = ie_endereco_boleto_lote_w) or (coalesce(ie_endereco_boleto_lote_w::text, '') = '')) and ((ie_tipo_pessoa_pagador_w = 'A') or (ie_tipo_pessoa_pagador_w = 'PF' and (a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')) or (ie_tipo_pessoa_pagador_w = 'PJ' and (a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> ''))) and ((b.nr_seq_classificacao = nr_seq_classif_benef_w) or (coalesce(nr_seq_classif_benef_w::text, '') = ''))
	
UNION ALL

	/* ITEM */

	SELECT	1
	FROM pls_pagador_item_mens h, pls_segurado b, pls_contrato_grupo g
LEFT OUTER JOIN pls_grupo_contrato f ON (g.nr_seq_grupo = f.nr_sequencia)
, pls_contrato c
LEFT OUTER JOIN pls_contrato_grupo g ON (c.nr_sequencia = g.nr_seq_contrato)
LEFT OUTER JOIN pls_preco_contrato i ON (c.nr_sequencia = i.nr_seq_contrato)
LEFT OUTER JOIN pls_preco_grupo_contrato j ON (i.nr_seq_grupo = j.nr_sequencia)
, pls_contrato_pagador a
LEFT OUTER JOIN pls_contrato_pagador_fin d ON (a.nr_sequencia = d.nr_seq_pagador)
LEFT OUTER JOIN pls_desc_empresa e ON (d.nr_seq_empresa = e.nr_sequencia)
WHERE a.nr_seq_contrato	= c.nr_sequencia and b.nr_seq_pagador	= h.nr_seq_pagador     and h.nr_seq_pagador_item	= a.nr_sequencia   and c.cd_estabelecimento	= cd_estabelecimento_p and ((a.nr_sequencia	= nr_seq_pagador_mens_w and	(nr_seq_pagador_mens_w IS NOT NULL AND nr_seq_pagador_mens_w::text <> '')) or coalesce(nr_seq_pagador_mens_w::text, '') = '') and ((coalesce(nr_dia_inicial_venc_w::text, '') = '') or (d.dt_dia_vencimento >= nr_dia_inicial_venc_w)) and ((coalesce(nr_dia_final_venc_w::text, '') = '') or (d.dt_dia_vencimento <= nr_dia_final_venc_w)) and (coalesce(nr_contrato_w::text, '') = '' or ((c.nr_sequencia = nr_contrato_w) or (c.nr_contrato_principal = nr_contrato_w))) and ((f.nr_sequencia = nr_seq_grupo_contrato_w) or (coalesce(nr_seq_grupo_contrato_w::text, '') = '')) and ((j.nr_sequencia = nr_seq_grupo_preco_w) or (coalesce(nr_seq_grupo_preco_w::text, '') = '')) and ((coalesce(cd_banco_lote_w::text, '') = '') or (d.cd_banco = cd_banco_lote_w)) and ((coalesce(nr_seq_forma_cobranca_lote_w::text, '') = '') or (d.nr_seq_forma_cobranca = nr_seq_forma_cobranca_lote_w)) and ((e.nr_seq_empresa_superior = nr_seq_empresa_w or e.nr_sequencia = nr_seq_empresa_w) or (coalesce(nr_seq_empresa_w::text, '') = '')) and ((d.cd_tipo_portador = cd_tipo_portador_w) or (coalesce(cd_tipo_portador_w::text, '') = '')) and ((d.cd_portador = cd_portador_w) or (coalesce(cd_portador_w::text, '') = '')) and coalesce(d.dt_inicio_vigencia,dt_mesano_referencia_fimdia_w) <= dt_mesano_referencia_fimdia_w and ((d.dt_fim_vigencia >= dt_mesano_referencia_fimdia_w) or (coalesce(d.dt_fim_vigencia::text, '') = '')) and coalesce(nr_contrato_intercambio_w::text, '') = '' and ((ie_tipo_lote_w	= 'A') or (ie_tipo_lote_w	= 'CO')) and ((ie_pagador_beneficio_obito_w = 'S' and (a.nr_seq_regra_obito IS NOT NULL AND a.nr_seq_regra_obito::text <> '')) or (ie_pagador_beneficio_obito_w = 'N')) and ((a.ie_endereco_boleto = ie_endereco_boleto_lote_w) or (coalesce(ie_endereco_boleto_lote_w::text, '') = '')) and ((ie_tipo_pessoa_pagador_w = 'A') or (ie_tipo_pessoa_pagador_w = 'PF' and (a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')) or (ie_tipo_pessoa_pagador_w = 'PJ' and (a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> ''))) and ((b.nr_seq_classificacao = nr_seq_classif_benef_w) or (coalesce(nr_seq_classif_benef_w::text, '') = '')) /* FIM ITEM */

 
union all

	select	1
	FROM pls_sca_vinculo h, pls_segurado b, pls_contrato_grupo g
LEFT OUTER JOIN pls_grupo_contrato f ON (g.nr_seq_grupo = f.nr_sequencia)
, pls_contrato c
LEFT OUTER JOIN pls_contrato_grupo g ON (c.nr_sequencia = g.nr_seq_contrato)
LEFT OUTER JOIN pls_preco_contrato i ON (c.nr_sequencia = i.nr_seq_contrato)
LEFT OUTER JOIN pls_preco_grupo_contrato j ON (i.nr_seq_grupo = j.nr_sequencia)
, pls_contrato_pagador a
LEFT OUTER JOIN pls_contrato_pagador_fin d ON (a.nr_sequencia = d.nr_seq_pagador)
LEFT OUTER JOIN pls_desc_empresa e ON (d.nr_seq_empresa = e.nr_sequencia)
WHERE a.nr_seq_contrato	= c.nr_sequencia and a.nr_sequencia		= h.nr_seq_pagador and b.nr_sequencia		= h.nr_seq_segurado       and c.cd_estabelecimento	= cd_estabelecimento_p and ((a.nr_sequencia	= nr_seq_pagador_mens_w and	(nr_seq_pagador_mens_w IS NOT NULL AND nr_seq_pagador_mens_w::text <> '')) or coalesce(nr_seq_pagador_mens_w::text, '') = '') and ((coalesce(nr_dia_inicial_venc_w::text, '') = '') or (d.dt_dia_vencimento >= nr_dia_inicial_venc_w)) and ((coalesce(nr_dia_final_venc_w::text, '') = '') or (d.dt_dia_vencimento <= nr_dia_final_venc_w)) and (coalesce(nr_contrato_w::text, '') = '' or ((c.nr_sequencia = nr_contrato_w) or (c.nr_contrato_principal = nr_contrato_w))) and ((f.nr_sequencia = nr_seq_grupo_contrato_w) or (coalesce(nr_seq_grupo_contrato_w::text, '') = '')) and ((j.nr_sequencia = nr_seq_grupo_preco_w) or (coalesce(nr_seq_grupo_preco_w::text, '') = '')) and (coalesce(cd_banco_lote_w::text, '') = '' or d.cd_banco = cd_banco_lote_w) and (coalesce(nr_seq_forma_cobranca_lote_w::text, '') = '' or d.nr_seq_forma_cobranca = nr_seq_forma_cobranca_lote_w) and ((e.nr_seq_empresa_superior = nr_seq_empresa_w or e.nr_sequencia = nr_seq_empresa_w) or (coalesce(nr_seq_empresa_w::text, '') = '')) and ((d.cd_tipo_portador = cd_tipo_portador_w) or (coalesce(cd_tipo_portador_w::text, '') = '')) and ((d.cd_portador = cd_portador_w) or (coalesce(cd_portador_w::text, '') = '')) and coalesce(d.dt_inicio_vigencia,dt_mesano_referencia_fimdia_w) <= dt_mesano_referencia_fimdia_w and ((d.dt_fim_vigencia >= dt_mesano_referencia_fimdia_w) or (coalesce(d.dt_fim_vigencia::text, '') = '')) and coalesce(nr_contrato_intercambio_w::text, '') = '' and ((ie_tipo_lote_w	= 'A') or (ie_tipo_lote_w	= 'CO')) /* aaschlote 26/10/2010 - OS - 256840 Gerar mensalidade apenas dos tipos de lote Ambos ou Contratos da Operadora*/
  and ((ie_pagador_beneficio_obito_w = 'S' and (a.nr_seq_regra_obito IS NOT NULL AND a.nr_seq_regra_obito::text <> '')) or (ie_pagador_beneficio_obito_w = 'N')) and ((a.ie_endereco_boleto = ie_endereco_boleto_lote_w) or (coalesce(ie_endereco_boleto_lote_w::text, '') = '')) and ((ie_tipo_pessoa_pagador_w = 'A') or (ie_tipo_pessoa_pagador_w = 'PF' and (a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')) or (ie_tipo_pessoa_pagador_w = 'PJ' and (a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> ''))) and ((b.nr_seq_classificacao = nr_seq_classif_benef_w) or (coalesce(nr_seq_classif_benef_w::text, '') = ''))
	 
union all

	select	1
	FROM pls_segurado b, pls_contrato_pagador a, pls_contrato_pagador_fin d
LEFT OUTER JOIN pls_desc_empresa e ON (d.nr_seq_empresa = e.nr_sequencia)
, pls_intercambio c
LEFT OUTER JOIN pls_preco_contrato f ON (c.nr_sequencia = f.nr_seq_intercambio)
LEFT OUTER JOIN pls_preco_grupo_contrato g ON (f.nr_seq_grupo = g.nr_sequencia)
WHERE a.nr_sequencia		= b.nr_seq_pagador and b.nr_seq_intercambio	= c.nr_sequencia and d.nr_seq_pagador	= a.nr_sequencia    and c.cd_estabelecimento	= cd_estabelecimento_p and ((a.nr_sequencia	= nr_seq_pagador_mens_w and	(nr_seq_pagador_mens_w IS NOT NULL AND nr_seq_pagador_mens_w::text <> '')) or coalesce(nr_seq_pagador_mens_w::text, '') = '') and ((coalesce(nr_dia_inicial_venc_w::text, '') = '') or (d.dt_dia_vencimento >= nr_dia_inicial_venc_w)) and ((coalesce(nr_dia_final_venc_w::text, '') = '') or (d.dt_dia_vencimento <= nr_dia_final_venc_w)) and ((coalesce(nr_contrato_intercambio_w::text, '') = '') or (c.nr_sequencia = nr_contrato_intercambio_w)) and ((coalesce(nr_seq_grupo_inter_w::text, '') = '') or (c.nr_seq_grupo_intercambio = nr_seq_grupo_inter_w)) and ((coalesce(ie_tipo_contrato_intercambio_w::text, '') = '') or (c.ie_tipo_contrato = ie_tipo_contrato_intercambio_w)) and ((g.nr_sequencia = nr_seq_grupo_preco_w) or (coalesce(nr_seq_grupo_preco_w::text, '') = '')) and (coalesce(cd_banco_lote_w::text, '') = '' or d.cd_banco = cd_banco_lote_w) and (coalesce(nr_seq_forma_cobranca_lote_w::text, '') = '' or d.nr_seq_forma_cobranca = nr_seq_forma_cobranca_lote_w) and ((e.nr_seq_empresa_superior = nr_seq_empresa_w or e.nr_sequencia = nr_seq_empresa_w) or (coalesce(nr_seq_empresa_w::text, '') = '')) and ((d.cd_tipo_portador = cd_tipo_portador_w) or (coalesce(cd_tipo_portador_w::text, '') = '')) and ((d.cd_portador = cd_portador_w) or (coalesce(cd_portador_w::text, '') = '')) and d.dt_inicio_vigencia <= dt_mesano_referencia_fimdia_w and ((d.dt_fim_vigencia >= dt_mesano_referencia_fimdia_w) or (coalesce(d.dt_fim_vigencia::text, '') = '')) and coalesce(nr_contrato_w::text, '') = '' and ((ie_tipo_lote_w	= 'A') or (ie_tipo_lote_w	= 'CI')) /* aaschlote 26/10/2010 - OS - 256840 Gerar mensalidade apenas dos tipos de lote Ambos ou Contratos da Intercâmbio*/
  and ((ie_pagador_beneficio_obito_w = 'S' and (a.nr_seq_regra_obito IS NOT NULL AND a.nr_seq_regra_obito::text <> '')) or (ie_pagador_beneficio_obito_w = 'N')) and ((a.ie_endereco_boleto = ie_endereco_boleto_lote_w) or (coalesce(ie_endereco_boleto_lote_w::text, '') = '')) and ((ie_tipo_pessoa_pagador_w = 'A') or (ie_tipo_pessoa_pagador_w = 'PF' and (a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')) or (ie_tipo_pessoa_pagador_w = 'PJ' and (a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> ''))) and ((b.nr_seq_classificacao = nr_seq_classif_benef_w) or (coalesce(nr_seq_classif_benef_w::text, '') = ''))
	 
union all

	select	1
	FROM pls_contrato_pagador a, pls_contrato_pagador_fin d
LEFT OUTER JOIN pls_desc_empresa e ON (d.nr_seq_empresa = e.nr_sequencia)
WHERE d.nr_seq_pagador	= a.nr_sequencia  and (nr_contrato_intercambio_w IS NOT NULL AND nr_contrato_intercambio_w::text <> '') and (ie_tipo_lote_w	<> 'A' AND ie_tipo_lote_w	<> 'CI') and ((a.ie_endereco_boleto = ie_endereco_boleto_lote_w) or (coalesce(ie_endereco_boleto_lote_w::text, '') = '')) and a.nr_seq_pagador_compl in (	select	a.nr_sequencia
						from	pls_contrato_pagador	a,
							pls_intercambio		b
						where	a.nr_seq_pagador_intercambio = b.nr_sequencia
						and	((coalesce(nr_contrato_intercambio_w::text, '') = '') or (b.nr_sequencia = nr_contrato_intercambio_w))
						and	((coalesce(nr_seq_grupo_inter_w::text, '') = '') or (b.nr_seq_grupo_intercambio = nr_seq_grupo_inter_w))
						and	((coalesce(ie_tipo_contrato_intercambio_w::text, '') = '') or (b.ie_tipo_contrato = ie_tipo_contrato_intercambio_w))) and ((ie_tipo_pessoa_pagador_w = 'A') or (ie_tipo_pessoa_pagador_w = 'PF' and (a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')) or (ie_tipo_pessoa_pagador_w = 'PJ' and (a.cd_cgc IS NOT NULL AND a.cd_cgc::text <> '')));


BEGIN

select	nr_seq_contrato,
	nr_seq_pagador,
	nr_dia_inicial_venc,
	nr_dia_final_venc,
	nr_seq_grupo_contrato,
	cd_banco,
	nr_seq_empresa,
	nr_seq_forma_cobranca,
	trunc(dt_mesano_referencia, 'month'),
	ie_tipo_lote,
	nr_seq_contrato_inter,
	cd_tipo_portador,
	cd_portador,
	nr_seq_grupo_preco,
	ie_tipo_contrato,
	nr_seq_grupo_inter,
	coalesce(ie_pagador_beneficio_obito,'N'),
	ie_endereco_boleto,
	coalesce(ie_tipo_pessoa_pagador,'A'),
	nr_seq_classif_benef
into STRICT	nr_contrato_w,
	nr_seq_pagador_mens_w,
	nr_dia_inicial_venc_w,
	nr_dia_final_venc_w,
	nr_seq_grupo_contrato_w,
	cd_banco_lote_w,
	nr_seq_empresa_w,
	nr_seq_forma_cobranca_lote_w,
	dt_mesano_referencia_w,
	ie_tipo_lote_w,
	nr_contrato_intercambio_w,
	cd_tipo_portador_w,
	cd_portador_w,
	nr_seq_grupo_preco_w,
	ie_tipo_contrato_intercambio_w,
	nr_seq_grupo_inter_w,
	ie_pagador_beneficio_obito_w,
	ie_endereco_boleto_lote_w,
	ie_tipo_pessoa_pagador_w,
	nr_seq_classif_benef_w
from	pls_lote_mensalidade
where	nr_sequencia	= nr_seq_lote_p;

dt_mesano_referencia_fimdia_w	:= fim_dia(dt_mesano_referencia_w);

qt_retorno_w	:= 0;

open C01;
loop
fetch C01 into
	qt_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_retorno_w	:= qt_retorno_w + 1;
	end;
end loop;
close C01;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_mens_obter_qtd_pagador ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
