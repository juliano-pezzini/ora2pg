-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_carteira ( nr_seq_lote_p bigint, ie_situacao_p text, dt_mes_ref_p timestamp, ie_opcao_p text, nm_usuario_p text, ie_tipo_data_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*	IE_OPCAO_P
	"S" = Status
	"V" = Vencimento
	"VS" = Vencimento para Provisorio
*/
nr_seq_carteira_w		bigint;
nr_seq_lote_carteira_w		bigint;
nr_seq_seg_carteira_w		bigint;
dt_validade_carteira_w		timestamp;
qt_carteira_provisorio_w	integer	:= 0;
nr_seq_segurado_w		bigint;
ie_tipo_segurado_lote_w		varchar(3);
nr_via_emissao_w		bigint;
ie_controle_carteira_w		varchar(1);
dt_inicial_w			timestamp;
dt_final_w			timestamp;
dt_inicio_vigencia_w		timestamp;
ie_tipo_pessoa_w		varchar(5);
dt_inicio_w			timestamp;
dt_solicitacao_w		timestamp;
dt_escolha_w			timestamp;
qt_cart_definitivo_w		bigint;
nr_contrato_w			bigint;
nr_contrato_final_w		bigint;
ie_situacao_atend_w		varchar(1);
qt_carteira_vencimento_w	bigint;
ie_tipo_contrato_w		varchar(10);
nr_seq_contrato_inter_w		bigint;
cd_matricula_familia_w		bigint;
cd_matric_familia_inicial_w	bigint;
cd_matric_familia_final_w	bigint;
nr_via_solicitacao_w		bigint;
nr_via_inicial_w		bigint;
nr_via_final_w			bigint;
nr_seq_forma_cobranca_w		bigint;
ie_tipo_pessoa_contrato_w	varchar(2);
nr_seq_cart_venc_w		bigint;
nr_seq_cart_emissao_w		bigint;
ie_tipo_solicitacao_w		varchar(10);
nr_seq_destino_corresp_w	bigint;
ie_destino_correspondencia_w	varchar(10);
nm_usuario_solicitante_w	varchar(15);
nr_seq_regra_geracao_w		bigint;
nr_seq_contrato_w		bigint;
qt_registros_w			bigint;
ie_tipo_segurado_w		varchar(3);
ie_emissao_cart_repasse_pre_w	varchar(1);
ie_tipo_repasse_w		varchar(1);
ie_gerar_emissao_w		varchar(1);
ie_inadimplencia_via_adic_w	varchar(1);
dt_sysdate_trunc_dd_w		timestamp		:=	trunc(clock_timestamp(),'dd');
nr_seq_pagador_w		bigint;
qt_inadimplencia_w		bigint;
nm_beneficiario_w		varchar(255);
nr_seq_contrato_ww		pls_contrato.nr_sequencia%type;
nr_seq_intercambio_ww		pls_intercambio.nr_sequencia%type;
dt_validade_anterior_w		timestamp;
dt_validade_prorrogada_w	timestamp;
ie_situacao_trabalhista_w	varchar(1);
nr_seq_localizacao_benef_w	pls_lote_carteira.nr_seq_localizacao_benef%type;
nr_seq_grupo_contrato_w		pls_lote_carteira.nr_seq_grupo_contrato%type;
ie_tipo_pagador_w		pls_lote_carteira.ie_tipo_pagador%type;
ie_cartao_bloqueado_w		pls_lote_carteira.ie_cartao_bloqueado%type;
ie_tipo_pagador_benef_w		varchar(2);
ie_param_data_w			varchar(10);
nm_usuario_solic_w 		pls_segurado_carteira.nm_usuario_solicitante%type;
dt_solic_w			pls_segurado_carteira.dt_solicitacao%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_sequencia,
		a.dt_validade_carteira,
		CASE WHEN coalesce(c.cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
		b.nr_seq_pagador,
		b.nr_seq_contrato,
		CASE WHEN coalesce(d.cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END
	from	pls_segurado		b,
		pls_segurado_carteira	a,
		pls_contrato		c,
		pls_contrato_pagador	d
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_seq_contrato	= c.nr_sequencia
	and	b.nr_seq_pagador	= d.nr_sequencia
	and	a.dt_validade_carteira between coalesce(dt_inicial_w,a.dt_validade_carteira) and  fim_dia(coalesce(dt_final_w,a.dt_validade_carteira))
	and 	((a.dt_validade_carteira < b.dt_rescisao) or (coalesce(b.dt_rescisao::text, '') = ''))
	and	(((ie_param_data_w = '0') and (trunc(a.dt_inicio_vigencia,'dd') <= trunc(dt_inicial_w,'dd'))) or ((ie_param_data_w = '1') and (trunc(a.dt_inicio_vigencia,'dd') <= trunc(clock_timestamp(),'dd'))))
	and	((coalesce(b.dt_rescisao::text, '') = '') or (b.dt_rescisao > dt_final_w))
	and	coalesce(b.dt_cancelamento::text, '') = ''
	and	coalesce(b.ie_renovacao_carteira,'S') = 'S'
	and	ie_opcao_p = 'V'
	and	((b.ie_tipo_segurado = ie_tipo_segurado_lote_w) or (coalesce(ie_tipo_segurado_lote_w::text, '') = ''))
	and	coalesce(c.ie_controle_carteira,'A')	in ('A','V')
	and	((c.nr_contrato = nr_contrato_w) or (coalesce(nr_contrato_w::text, '') = ''))
	and	((b.ie_situacao_atend = ie_situacao_atend_w) or (ie_situacao_atend_w = 'T'))
	and	((ie_tipo_contrato_w = 'O') or (coalesce(ie_tipo_contrato_w::text, '') = ''))
	and	((b.ie_situacao_trabalhista = ie_situacao_trabalhista_w) or (coalesce(ie_situacao_trabalhista_w::text, '') = ''))
	and	((b.nr_seq_localizacao_benef = nr_seq_localizacao_benef_w) or (coalesce(nr_seq_localizacao_benef_w::text, '') = ''))
	and	((exists (	SELECT 	1
				from	pls_contrato_grupo d
				where	c.nr_sequencia = d.nr_seq_contrato
				and	d.nr_seq_grupo = nr_seq_grupo_contrato_w)) or (coalesce(nr_seq_grupo_contrato_w::text, '') = ''))
	and	((coalesce(a.dt_desbloqueio::text, '') = '' and ie_cartao_bloqueado_w = 'B')
		or ((a.dt_desbloqueio IS NOT NULL AND a.dt_desbloqueio::text <> '') and ie_cartao_bloqueado_w = 'D')
		or (ie_cartao_bloqueado_w = 'A'))		
	and	c.cd_estabelecimento = cd_estabelecimento_p
	
union

	select	a.nr_sequencia,
		b.nr_sequencia,
		a.dt_validade_carteira,
		CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
		b.nr_seq_pagador,
		b.nr_seq_contrato,
		CASE WHEN coalesce(d.cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END 
	from	pls_segurado		b,
		pls_segurado_carteira	a,
		pls_intercambio		c,
		pls_contrato_pagador	d
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_seq_intercambio	= c.nr_sequencia
	and	b.nr_seq_pagador	= d.nr_sequencia
	and	((coalesce(b.dt_rescisao::text, '') = '') or (b.dt_rescisao > dt_final_w))
	and	coalesce(b.dt_cancelamento::text, '') = ''
	and	a.dt_validade_carteira between coalesce(dt_inicial_w,a.dt_validade_carteira) and  fim_dia(coalesce(dt_final_w,a.dt_validade_carteira))
	and	(((ie_param_data_w = '0') and (trunc(a.dt_inicio_vigencia,'dd') <= trunc(dt_inicial_w,'dd'))) or ((ie_param_data_w = '1') and (trunc(a.dt_inicio_vigencia,'dd') <= trunc(clock_timestamp(),'dd'))))
	and	coalesce(b.ie_renovacao_carteira,'S') = 'S'
	and	coalesce(c.ie_controle_carteira,'A')	in ('A','V')
	and	ie_opcao_p	= 'V'
	and	((b.ie_tipo_segurado = ie_tipo_segurado_lote_w) or (coalesce(ie_tipo_segurado_lote_w::text, '') = ''))
	and	((c.nr_sequencia = nr_seq_contrato_inter_w) or (coalesce(nr_seq_contrato_inter_w::text, '') = ''))
	and	((ie_tipo_contrato_w = 'I') or (coalesce(ie_tipo_contrato_w::text, '') = ''))
	and	((b.ie_situacao_trabalhista = ie_situacao_trabalhista_w) or (coalesce(ie_situacao_trabalhista_w::text, '') = ''))
	and	((b.nr_seq_localizacao_benef = nr_seq_localizacao_benef_w) or (coalesce(nr_seq_localizacao_benef_w::text, '') = ''))
	and	((exists (	select	1
				from	pls_contrato_grupo d
				where	c.nr_sequencia = d.nr_seq_intercambio
				and	d.nr_seq_grupo = nr_seq_grupo_contrato_w)) or (coalesce(nr_seq_grupo_contrato_w::text, '') = ''))
	and	((coalesce(a.dt_desbloqueio::text, '') = '' and ie_cartao_bloqueado_w = 'B')
		or ((a.dt_desbloqueio IS NOT NULL AND a.dt_desbloqueio::text <> '') and ie_cartao_bloqueado_w = 'D')
		or (ie_cartao_bloqueado_w = 'A'))	
	and	c.cd_estabelecimento = cd_estabelecimento_p;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_sequencia,
		a.nr_via_solicitacao,
		a.dt_inicio_vigencia,
		a.dt_solicitacao,
		a.dt_validade_carteira,
		CASE WHEN coalesce(c.cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
		b.ie_tipo_segurado,
		CASE WHEN coalesce(d.cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END 		
	FROM pls_contrato c, pls_segurado b, pls_segurado_carteira a, pls_contrato_pagador d
LEFT OUTER JOIN pls_contrato_pagador_fin e ON (d.nr_sequencia = e.nr_seq_pagador)
WHERE a.nr_seq_segurado	= b.nr_sequencia and b.nr_seq_contrato	= c.nr_sequencia and b.nr_seq_pagador	= d.nr_sequencia  and ((coalesce(b.dt_rescisao::text, '') = '') or (b.dt_rescisao > coalesce(dt_final_w,clock_timestamp()))) and coalesce(b.dt_cancelamento::text, '') = '' and coalesce(b.ie_renovacao_carteira,'S') = 'S' and a.ie_situacao		= ie_situacao_p and ie_opcao_p		= 'S' and c.cd_estabelecimento	= cd_estabelecimento_p and ((coalesce(a.dt_desbloqueio::text, '') = '' and ie_cartao_bloqueado_w = 'B')
		or ((a.dt_desbloqueio IS NOT NULL AND a.dt_desbloqueio::text <> '') and ie_cartao_bloqueado_w = 'D')
		or (ie_cartao_bloqueado_w = 'A')) and ((b.ie_tipo_segurado = ie_tipo_segurado_lote_w) or (coalesce(ie_tipo_segurado_lote_w::text, '') = '')) and coalesce(c.ie_controle_carteira,'A')	in ('A','E') and ((ie_tipo_solicitacao_w	= coalesce(a.ie_processo,'M') and (ie_tipo_solicitacao_w IS NOT NULL AND ie_tipo_solicitacao_w::text <> '')) or (coalesce(ie_tipo_solicitacao_w::text, '') = '')) -- sideker OS: 301491  01/04/2011
  and (((nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') and (nr_contrato_final_w IS NOT NULL AND nr_contrato_final_w::text <> '') and (c.nr_contrato between nr_contrato_w and nr_contrato_final_w))
		or	((coalesce(nr_contrato_w::text, '') = '' and (nr_contrato_final_w IS NOT NULL AND nr_contrato_final_w::text <> '') and c.nr_contrato = nr_contrato_final_w)
		or ((nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') and coalesce(nr_contrato_final_w::text, '') = '' and c.nr_contrato = nr_contrato_w)
		or (coalesce(nr_contrato_w::text, '') = '' and coalesce(nr_contrato_final_w::text, '') = ''))) -- sideker OS: 301491  01/04/2011
  and (((cd_matric_familia_inicial_w IS NOT NULL AND cd_matric_familia_inicial_w::text <> '') and (cd_matric_familia_final_w IS NOT NULL AND cd_matric_familia_final_w::text <> '') and (b.cd_matricula_familia between cd_matric_familia_inicial_w and cd_matric_familia_final_w))
		or	((coalesce(cd_matric_familia_inicial_w::text, '') = '' and (cd_matric_familia_final_w IS NOT NULL AND cd_matric_familia_final_w::text <> '') and b.cd_matricula_familia = cd_matric_familia_final_w)
		or ((cd_matric_familia_inicial_w IS NOT NULL AND cd_matric_familia_inicial_w::text <> '') and coalesce(cd_matric_familia_final_w::text, '') = '' and b.cd_matricula_familia = cd_matric_familia_inicial_w)
		or (coalesce(cd_matric_familia_inicial_w::text, '') = '' and coalesce(cd_matric_familia_final_w::text, '') = ''))) -- sideker OS: 301491  01/04/2011
  and (((nr_via_inicial_w IS NOT NULL AND nr_via_inicial_w::text <> '') and (nr_via_final_w IS NOT NULL AND nr_via_final_w::text <> '') and (a.nr_via_solicitacao between nr_via_inicial_w and nr_via_final_w))
		or	((coalesce(nr_via_inicial_w::text, '') = '' and (nr_via_final_w IS NOT NULL AND nr_via_final_w::text <> '') and a.nr_via_solicitacao = nr_via_final_w)
		or ((nr_via_inicial_w IS NOT NULL AND nr_via_inicial_w::text <> '') and coalesce(nr_via_final_w::text, '') = '' and a.nr_via_solicitacao = nr_via_inicial_w)
		or (coalesce(nr_via_inicial_w::text, '') = '' and coalesce(nr_via_final_w::text, '') = ''))) and ((b.ie_situacao_atend	= ie_situacao_atend_w) or (ie_situacao_atend_w = 'T')) --aaschlote 12/04/2011 OS  305514
  and (((nr_seq_forma_cobranca_w IS NOT NULL AND nr_seq_forma_cobranca_w::text <> '') and e.nr_seq_forma_cobranca = nr_seq_forma_cobranca_w) or (coalesce(nr_seq_forma_cobranca_w::text, '') = '')) and ((ie_tipo_contrato_w = 'O') or (coalesce(ie_tipo_contrato_w::text, '') = '')) and ((d.nr_seq_destino_corresp	= nr_seq_destino_corresp_w and (nr_seq_destino_corresp_w IS NOT NULL AND nr_seq_destino_corresp_w::text <> '')) or (coalesce(nr_seq_destino_corresp_w::text, '') = '')) and ((ie_destino_correspondencia_w = 'S' and (d.nr_seq_destino_corresp IS NOT NULL AND d.nr_seq_destino_corresp::text <> '')) or (ie_destino_correspondencia_w = 'N')) and ((upper(a.nm_usuario_solicitante) = upper(nm_usuario_solicitante_w) and (nm_usuario_solicitante_w IS NOT NULL AND nm_usuario_solicitante_w::text <> '')) or (coalesce(nm_usuario_solicitante_w::text, '') = '')) and ((b.ie_situacao_trabalhista = ie_situacao_trabalhista_w) or (coalesce(ie_situacao_trabalhista_w::text, '') = '')) and ((b.nr_seq_localizacao_benef = nr_seq_localizacao_benef_w) or (coalesce(nr_seq_localizacao_benef_w::text, '') = '')) and (exists (	SELECT	1
				from	pls_contrato_grupo f
				where	f.nr_seq_contrato = c.nr_sequencia
				and	f.nr_seq_grupo = nr_seq_grupo_contrato_w) or (coalesce(nr_seq_grupo_contrato_w::text, '') = ''))
	
union

	select	a.nr_sequencia,
		b.nr_sequencia,
		a.nr_via_solicitacao,
		a.dt_inicio_vigencia,
		a.dt_solicitacao,
		a.dt_validade_carteira,
		CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END ,
		b.ie_tipo_segurado,
		CASE WHEN coalesce(d.cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END 		
	FROM pls_intercambio c, pls_segurado b, pls_segurado_carteira a, pls_contrato_pagador d
LEFT OUTER JOIN pls_contrato_pagador_fin e ON (d.nr_sequencia = e.nr_seq_pagador)
WHERE a.nr_seq_segurado	= b.nr_sequencia and b.nr_seq_intercambio	= c.nr_sequencia and b.nr_seq_pagador	= d.nr_sequencia  and a.ie_situacao		= ie_situacao_p and ((coalesce(b.dt_rescisao::text, '') = '') or (b.dt_rescisao > coalesce(dt_final_w,clock_timestamp()))) and coalesce(b.dt_cancelamento::text, '') = '' and coalesce(b.ie_renovacao_carteira,'S') = 'S' and ie_opcao_p		= 'S' and c.cd_estabelecimento	= cd_estabelecimento_p and ((coalesce(a.dt_desbloqueio::text, '') = '' and ie_cartao_bloqueado_w = 'B')
		or ((a.dt_desbloqueio IS NOT NULL AND a.dt_desbloqueio::text <> '') and ie_cartao_bloqueado_w = 'D')
		or (ie_cartao_bloqueado_w = 'A')) and ((b.ie_tipo_segurado = ie_tipo_segurado_lote_w) or (coalesce(ie_tipo_segurado_lote_w::text, '') = '')) and coalesce(c.ie_controle_carteira,'A')	in ('A','E') and ((ie_tipo_solicitacao_w	= coalesce(a.ie_processo,'M') and (ie_tipo_solicitacao_w IS NOT NULL AND ie_tipo_solicitacao_w::text <> '')) or (coalesce(ie_tipo_solicitacao_w::text, '') = '')) -- sideker OS: 301491  01/04/2011
  and (((cd_matric_familia_inicial_w IS NOT NULL AND cd_matric_familia_inicial_w::text <> '') and (cd_matric_familia_final_w IS NOT NULL AND cd_matric_familia_final_w::text <> '') and (b.cd_matricula_familia between cd_matric_familia_inicial_w and cd_matric_familia_final_w))
		or	((coalesce(cd_matric_familia_inicial_w::text, '') = '' and (cd_matric_familia_final_w IS NOT NULL AND cd_matric_familia_final_w::text <> '') and b.cd_matricula_familia = cd_matric_familia_final_w)
		or ((cd_matric_familia_inicial_w IS NOT NULL AND cd_matric_familia_inicial_w::text <> '') and coalesce(cd_matric_familia_final_w::text, '') = '' and b.cd_matricula_familia = cd_matric_familia_inicial_w)
		or (coalesce(cd_matric_familia_inicial_w::text, '') = '' and coalesce(cd_matric_familia_final_w::text, '') = ''))) -- sideker OS: 301491  01/04/2011
  and (((nr_via_inicial_w IS NOT NULL AND nr_via_inicial_w::text <> '') and (nr_via_final_w IS NOT NULL AND nr_via_final_w::text <> '') and (a.nr_via_solicitacao between nr_via_inicial_w and nr_via_final_w))
		or	((coalesce(nr_via_inicial_w::text, '') = '' and (nr_via_final_w IS NOT NULL AND nr_via_final_w::text <> '') and a.nr_via_solicitacao = nr_via_final_w)
		or ((nr_via_inicial_w IS NOT NULL AND nr_via_inicial_w::text <> '') and coalesce(nr_via_final_w::text, '') = '' and a.nr_via_solicitacao = nr_via_inicial_w)
		or (coalesce(nr_via_inicial_w::text, '') = '' and coalesce(nr_via_final_w::text, '') = ''))) and ((c.nr_sequencia = nr_seq_contrato_inter_w) or (coalesce(nr_seq_contrato_inter_w::text, '') = '')) --aaschlote 12/04/2011 OS  305514
  and (((nr_seq_forma_cobranca_w IS NOT NULL AND nr_seq_forma_cobranca_w::text <> '')  and e.nr_seq_forma_cobranca = nr_seq_forma_cobranca_w) or (coalesce(nr_seq_forma_cobranca_w::text, '') = '')) and ((ie_tipo_contrato_w = 'I') or (coalesce(ie_tipo_contrato_w::text, '') = '')) and ((upper(a.nm_usuario_solicitante) = upper(nm_usuario_solicitante_w) and (nm_usuario_solicitante_w IS NOT NULL AND nm_usuario_solicitante_w::text <> '')) or (coalesce(nm_usuario_solicitante_w::text, '') = '')) and ((b.ie_situacao_trabalhista = ie_situacao_trabalhista_w) or (coalesce(ie_situacao_trabalhista_w::text, '') = '')) and ((b.nr_seq_localizacao_benef = nr_seq_localizacao_benef_w) or (coalesce(nr_seq_localizacao_benef_w::text, '') = '')) and ((exists (	select	1
				from	pls_contrato_grupo f
				where	c.nr_sequencia = f.nr_seq_intercambio
				and	f.nr_seq_grupo = nr_seq_grupo_contrato_w)) or (coalesce(nr_seq_grupo_contrato_w::text, '') = ''));

C03 CURSOR FOR
	SELECT	d.nr_seq_seg_carteira,
		a.nr_seq_contrato,
		a.nr_seq_intercambio,
		c.dt_inicio_vigencia,
		c.nr_via_solicitacao,
		a.ie_tipo_segurado,
		a.nr_sequencia,
		d.dt_validade_anterior,
		d.dt_validade_prorrogada
	from	pls_segurado		a,
		pls_segurado_carteira	c,
		pls_carteira_vencimento	d
	where	a.nr_sequencia	= c.nr_seq_segurado
	and	c.nr_sequencia	= d.nr_seq_seg_carteira
	and	d.nr_seq_lote	= nr_seq_lote_p
	and	a.cd_estabelecimento = cd_estabelecimento_p;


BEGIN

ie_param_data_w := coalesce(obter_valor_param_usuario(1226, 13, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),0);
select	max(ie_emissao_cart_repasse_pre)
into STRICT	ie_emissao_cart_repasse_pre_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;
ie_emissao_cart_repasse_pre_w	:= coalesce(ie_emissao_cart_repasse_pre_w,'N');

/*Obter dados do lote*/

select	nr_contrato,
	nr_contrato_final,
	nr_seq_contrato_inter,
	cd_matric_familia_inicial,
	cd_matric_familia_final,
	nr_via_inicial,
	nr_via_final,
	ie_tipo_solicitacao,
	coalesce(ie_destino_correspondencia,'N'),
	trim(both nm_usuario_solicitante),
	nr_seq_regra_geracao,
	ie_tipo_pessoa,
	coalesce(ie_situacao_atend,'T'),
	ie_tipo_contrato,
	ie_tipo_beneficiario,
	nr_seq_forma_cobranca,
	nr_seq_destino_corresp,
	ie_situacao_trabalhista,
	nr_seq_localizacao_benef,
	nr_seq_grupo_contrato,
	ie_tipo_pagador,
	trunc(dt_inicial,'dd'),
	fim_dia(dt_final),
	ie_cartao_bloqueado
into STRICT	nr_contrato_w,
	nr_contrato_final_w,
	nr_seq_contrato_inter_w,
	cd_matric_familia_inicial_w,
	cd_matric_familia_final_w,
	nr_via_inicial_w,
	nr_via_final_w,
	ie_tipo_solicitacao_w,
	ie_destino_correspondencia_w,
	nm_usuario_solicitante_w,
	nr_seq_regra_geracao_w,
	ie_tipo_pessoa_w,
	ie_situacao_atend_w,
	ie_tipo_contrato_w,
	ie_tipo_segurado_lote_w,
	nr_seq_forma_cobranca_w,
	nr_seq_destino_corresp_w,
	ie_situacao_trabalhista_w,
	nr_seq_localizacao_benef_w,
	nr_seq_grupo_contrato_w,
	ie_tipo_pagador_w,
	dt_inicial_w,
	dt_final_w,
	ie_cartao_bloqueado_w
from	pls_lote_carteira
where	nr_sequencia	= nr_seq_lote_p;

if (ie_opcao_p = 'VS') then
	select	nextval('pls_lote_carteira_seq')
	into STRICT	nr_seq_lote_carteira_w
	;
	
	insert	into	pls_lote_carteira(nr_sequencia, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		dt_referencia_venc, ie_situacao, ie_tipo_lote,
		nr_seq_lote_vencimento,ie_tipo_contrato, nr_seq_localizacao_benef, nr_seq_grupo_contrato)
	values (	nr_seq_lote_carteira_w, cd_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		null, 'G', 'E',
		nr_seq_lote_p,ie_tipo_contrato_w, nr_seq_localizacao_benef_w, nr_seq_grupo_contrato_w);
	
	open C03;
	loop
	fetch C03 into
		nr_seq_seg_carteira_w,
		nr_seq_contrato_ww,
		nr_seq_intercambio_ww,
		dt_inicio_vigencia_w,
		nr_via_emissao_w,
		ie_tipo_segurado_w,
		nr_seq_segurado_w,
		dt_validade_anterior_w,
		dt_validade_prorrogada_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ie_gerar_emissao_w	:= 'S';
		ie_controle_carteira_w	:= null;
		
		if (nr_seq_contrato_ww IS NOT NULL AND nr_seq_contrato_ww::text <> '') then
			select	coalesce(ie_controle_carteira,'A')
			into STRICT	ie_controle_carteira_w
			from	pls_contrato
			where	nr_sequencia	= nr_seq_contrato_ww;
		elsif (nr_seq_intercambio_ww IS NOT NULL AND nr_seq_intercambio_ww::text <> '') then
			select	coalesce(ie_controle_carteira,'A')
			into STRICT	ie_controle_carteira_w
			from	pls_intercambio
			where	nr_sequencia	= nr_seq_intercambio_ww;
		end if;
		
		if	(ie_emissao_cart_repasse_pre_w = 'S' AND ie_tipo_segurado_w = 'R') then
			select	max(ie_tipo_repasse)
			into STRICT	ie_tipo_repasse_w
			from	pls_segurado_repasse
			where	nr_seq_segurado	= nr_seq_segurado_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and (coalesce(dt_fim_repasse::text, '') = ''
			or	dt_fim_repasse > clock_timestamp());
			
			if (ie_tipo_repasse_w = 'P') then
				ie_gerar_emissao_w	:= 'N';
			end if;
		end if;
		
		/*aaschlote 13/02/2014 OS 702365 - Apenas gerar o lote de emissao caso alterou a data de validade*/

		if (ie_gerar_emissao_w = 'S') then
			if (trunc(dt_validade_anterior_w,'dd') = trunc(dt_validade_prorrogada_w,'dd')) then
				ie_gerar_emissao_w	:= 'N';
			end if;
		end if;
		
		if (ie_controle_carteira_w in ('A','E')) and (ie_gerar_emissao_w = 'S') then

			select 	dt_solicitacao,
				 			nm_usuario_solicitante
			into STRICT   	dt_solic_w,
							nm_usuario_solic_w
			from   	pls_segurado_carteira
			where  	nr_sequencia = nr_seq_seg_carteira_w;
			

			select	nextval('pls_carteira_emissao_seq')
			into STRICT	nr_seq_cart_emissao_w
			;
			
			insert into pls_carteira_emissao(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_lote,
				nr_seq_seg_carteira, dt_recebimento, ie_situacao, nr_via_emissao, dt_solicitacao, nm_usuario_solic)
			values (	nr_seq_cart_emissao_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, nr_seq_lote_carteira_w,
				nr_seq_seg_carteira_w, null, 'P', nr_via_emissao_w, dt_solic_w, nm_usuario_solic_w);
			
			CALL pls_atualizar_campos_cart_emis(nr_seq_cart_emissao_w, nr_seq_seg_carteira_w, nm_usuario_p);
			
			update	pls_segurado_carteira
			set	nr_seq_lote_emissao = nr_seq_lote_carteira_w
			where	nr_seq_segurado = nr_seq_Segurado_w;
		else
			update	pls_segurado_carteira
			set	ie_situacao	= 'D'
			where	nr_sequencia	= nr_seq_seg_carteira_w;
			
			CALL pls_alterar_estagios_cartao(nr_seq_seg_carteira_w,clock_timestamp(),'6',cd_estabelecimento_p,nm_usuario_p);
		end if;
		
		end;
	end loop;
	close C03;
elsif (ie_opcao_p	= 'V') then
	delete	from	pls_carteira_vencimento
	where	nr_seq_lote = nr_seq_lote_p;

	open C01;
	loop
	fetch C01 into
		nr_seq_carteira_w,
		nr_seq_segurado_w,
		dt_validade_carteira_w,
		ie_tipo_pessoa_contrato_w,
		nr_seq_pagador_w,
		nr_seq_contrato_w,
		ie_tipo_pagador_benef_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (ie_tipo_pessoa_contrato_w = coalesce(ie_tipo_pessoa_w,'A')) or (coalesce(ie_tipo_pessoa_w,'A') = 'A') then
			
			if (ie_tipo_pagador_benef_w = ie_tipo_pagador_w) or (coalesce(ie_tipo_pagador_w,'A') = 'A') then
			
				select	max(ie_inadimplencia_via_adic)
				into STRICT	ie_inadimplencia_via_adic_w
				from	pls_contrato_pagador
				where	nr_sequencia = nr_seq_pagador_w;
				
				--OS 670105 verifica se deve consistir a inadimplencia do pagador
				if (ie_inadimplencia_via_adic_w = 'S') then
					select	count(1)
					into STRICT	qt_inadimplencia_w
					FROM pls_contrato_pagador e, pls_segurado c, pls_mensalidade_segurado b, pls_mensalidade a
LEFT OUTER JOIN titulo_receber f ON (a.nr_sequencia = f.nr_seq_mensalidade)
WHERE a.nr_sequencia = b.nr_seq_mensalidade and c.nr_sequencia = b.nr_seq_segurado and e.nr_sequencia = a.nr_seq_pagador  and e.nr_sequencia = nr_seq_pagador_w and f.dt_pagamento_previsto < dt_sysdate_trunc_dd_w and f.ie_situacao = '1';
					
					if (qt_inadimplencia_w > 0) then
						goto final_vencimento;
					end if;
				end if;
				
				/*aaschlote 15/11/2012 OS 516258*/

				if (nr_seq_regra_geracao_w IS NOT NULL AND nr_seq_regra_geracao_w::text <> '') then
					if (pls_obter_benef_regra_emissao(nr_seq_regra_geracao_w,nr_seq_segurado_w) = 'N') then
						goto final_vencimento;
					end if;
				end if;
				
				/*aaschlote 30/11/2010 - Nao duplicar os segurado que ja estao em vencimentos com status provisorios*/

				select	count(1)
				into STRICT	qt_carteira_vencimento_w
				from	pls_segurado_carteira	a,
					pls_carteira_vencimento	b,
					pls_lote_carteira	c
				where	a.nr_sequencia		= b.nr_seq_seg_carteira
				and	b.nr_seq_lote		= c.nr_sequencia
				and	c.ie_situacao		= 'P'
				and	a.nr_seq_segurado	= nr_seq_segurado_w;
				
				if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
					select	count(1)
					into STRICT	qt_registros_w
					from	pls_carteira_renovacao
					where	nr_seq_contrato	= nr_seq_contrato_w
					and	ie_nao_renovar_carteira = 'S';
				else
					qt_registros_w	:= 0;
				end if;
				
				if (qt_carteira_vencimento_w = 0) and (qt_registros_w = 0) then
					select	nextval('pls_carteira_vencimento_seq')
					into STRICT	nr_seq_cart_venc_w
					;
					
					insert into pls_carteira_vencimento(nr_sequencia, dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_lote,
						nr_seq_seg_carteira, dt_validade_anterior,dt_validade_prorrogada)
					values (nr_seq_cart_venc_w, clock_timestamp(), nm_usuario_p,
						clock_timestamp(), nm_usuario_p, nr_seq_lote_p,
						nr_seq_carteira_w, dt_validade_carteira_w,dt_validade_carteira_w);
				end if;
			end if;	
		end if;
		<<final_vencimento>>
		nr_seq_segurado_w	:= nr_seq_segurado_w;
		end;
	end loop;
	close C01;
	
	update	pls_lote_carteira
	set	ie_situacao	= 'G'
	where	nr_sequencia	= nr_seq_lote_p;
elsif (ie_opcao_p	= 'S') then
	delete	from	pls_carteira_emissao
	where	nr_seq_lote = nr_seq_lote_p;
	
	select	trunc(dt_inicial,'dd'),
		fim_dia(dt_final)
	into STRICT	dt_inicial_w,
		dt_final_w
	from	pls_lote_carteira
	where	nr_sequencia	= nr_seq_lote_p;
	
	open C02;
	loop
	fetch C02 into
		nr_seq_carteira_w,
		nr_seq_segurado_w,
		nr_via_emissao_w,
		dt_inicio_vigencia_w,
		dt_solicitacao_w,
		dt_validade_carteira_w,
		ie_tipo_pessoa_contrato_w,
		ie_tipo_segurado_w,
		ie_tipo_pagador_benef_w;		
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (ie_tipo_pessoa_contrato_w = coalesce(ie_tipo_pessoa_w,'A')) or (coalesce(ie_tipo_pessoa_w,'A') = 'A') then
			
			if (ie_tipo_pagador_benef_w = ie_tipo_pagador_w) or (coalesce(ie_tipo_pagador_w,'A') = 'A') then
				ie_gerar_emissao_w	:= 'S';
				
				if	(ie_emissao_cart_repasse_pre_w = 'S' AND ie_tipo_segurado_w = 'R') then
					select	max(ie_tipo_repasse)
					into STRICT	ie_tipo_repasse_w
					from	pls_segurado_repasse
					where	nr_seq_segurado	= nr_seq_segurado_w
					and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
					and (coalesce(dt_fim_repasse::text, '') = ''
					or	dt_fim_repasse > coalesce(dt_final_w,clock_timestamp()));
				
					if (ie_tipo_repasse_w = 'P') then
					ie_gerar_emissao_w	:= 'N';
					end if;
				end if;
			
				/*aaschlote 14/02/2012 OS 409710*/

				if (nr_seq_regra_geracao_w IS NOT NULL AND nr_seq_regra_geracao_w::text <> '') then
					if (pls_obter_benef_regra_emissao(nr_seq_regra_geracao_w,nr_seq_segurado_w) = 'N') then
					goto final;
					end if;
				end if;
				
				select	count(1)
				into STRICT	qt_carteira_provisorio_w
				from	pls_segurado_carteira	a,
					pls_carteira_emissao	b,
					pls_lote_carteira	c
				where	a.nr_sequencia		= b.nr_seq_seg_carteira
				and	b.nr_seq_lote		= c.nr_sequencia
				and	a.nr_seq_segurado	= nr_seq_segurado_w
				and	b.nr_via_emissao	= nr_via_emissao_w
				and	coalesce(b.ie_situacao,'P')	= 'P';
				/*and	c.ie_situacao		= 'D'; Paulo - OS 228104 - Nao inserir mesmo que esteja num lote provisorio */

				
				select	count(1)
				into STRICT	qt_cart_definitivo_w
				from	pls_segurado_carteira	a
				where	a.nr_seq_segurado	= nr_seq_segurado_w
				and	a.nr_via_solicitacao	= nr_via_emissao_w
				and	a.ie_situacao		= 'D';
				
				if (ie_tipo_data_p = 'V') then
					dt_escolha_w := coalesce(dt_inicio_vigencia_w,clock_timestamp());
				elsif (ie_tipo_data_p = 'S') then
					dt_escolha_w := coalesce(dt_solicitacao_w,clock_timestamp());
				elsif (ie_tipo_data_p = 'E') then
					dt_escolha_w := coalesce(dt_validade_carteira_w,clock_timestamp());
				else
					dt_escolha_w := trunc(clock_timestamp(),'dd');
				end if;
				
				if (dt_escolha_w between trunc(coalesce(dt_inicial_w,clock_timestamp()),'dd') and fim_dia(coalesce(dt_final_w,clock_timestamp()))) or (ie_tipo_data_p = 'N') then
					
					if (qt_carteira_provisorio_w = 0)  and (qt_cart_definitivo_w = 0 ) and (ie_gerar_emissao_w = 'S') then

						select 	dt_solicitacao,
				 						nm_usuario_solicitante
						into STRICT 		dt_solic_w,
										nm_usuario_solic_w
						from   	pls_segurado_carteira
						where  	nr_sequencia = nr_seq_carteira_w;

						select	nextval('pls_carteira_emissao_seq')
						into STRICT	nr_seq_cart_emissao_w
						;
						
						
						insert into pls_carteira_emissao(nr_sequencia, dt_atualizacao, nm_usuario,
							dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_lote,
							nr_seq_seg_carteira, dt_recebimento, nr_via_emissao,
							ie_situacao, dt_solicitacao, nm_usuario_solic)
						values (nr_seq_cart_emissao_w, clock_timestamp(), nm_usuario_p,
							clock_timestamp(), nm_usuario_p, nr_seq_lote_p,
							nr_seq_carteira_w, null, nr_via_emissao_w,
							'P', dt_solic_w, nm_usuario_solic_w);
						
						update	pls_segurado_carteira
						set	nr_seq_lote_emissao	= nr_seq_lote_p
						where	nr_sequencia		= nr_seq_carteira_w;
						
						CALL pls_atualizar_campos_cart_emis(nr_seq_cart_emissao_w, nr_seq_carteira_w, nm_usuario_p);
					end if;
				end if;
			end if;
		end if;
		<<FINAL>>
		nr_seq_carteira_w	:= nr_seq_carteira_w;
		end;
	end loop;
	close C02;
	
	update	pls_lote_carteira
	set	ie_situacao	= 'G'
	where	nr_sequencia	= nr_seq_lote_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_carteira ( nr_seq_lote_p bigint, ie_situacao_p text, dt_mes_ref_p timestamp, ie_opcao_p text, nm_usuario_p text, ie_tipo_data_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
