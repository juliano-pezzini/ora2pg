-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_sib_qtde_movimentacao ( nr_seq_lote_p pls_sib_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS integer AS $body$
DECLARE


qt_registro_w		bigint;
ie_tipo_lote_w		pls_sib_lote.ie_tipo_lote%type;
ie_gerar_correcao_w	pls_sib_lote.ie_gerar_correcao%type;
dt_inicio_mov_w		pls_sib_lote.dt_inicio_mov%type;
dt_fim_mov_w		pls_sib_lote.dt_fim_mov%type;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	select	ie_tipo_lote,
		coalesce(ie_gerar_correcao,'N'),
		trunc(dt_inicio_mov,'dd'),
		fim_dia(dt_fim_mov)
	into STRICT	ie_tipo_lote_w,
		ie_gerar_correcao_w,
		dt_inicio_mov_w,
		dt_fim_mov_w
	from	pls_sib_lote
	where	nr_sequencia = nr_seq_lote_p;

	if (ie_tipo_lote_w = 'M') then --Movimentação
		select	count(1)
		into STRICT	qt_registro_w
		from (	SELECT	nr_seq_agrup
			from (	select	a.nr_seq_segurado nr_seq_agrup
				from	pls_segurado_status a,
					pls_segurado b
				where	a.nr_seq_segurado = b.nr_sequencia
				and	b.ie_tipo_segurado in ('B','R')
				and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
				and	coalesce(b.dt_cancelamento::text, '') = ''
				and	a.dt_inicial between dt_inicio_mov_w and dt_fim_mov_w
				and	b.cd_estabelecimento = cd_estabelecimento_p
				
union

				SELECT	a.nr_seq_segurado nr_seq_agrup
				from	pls_segurado_status a,
					pls_segurado b
				where	a.nr_seq_segurado = b.nr_sequencia
				and	b.ie_tipo_segurado in ('B','R')
				and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
				and	coalesce(b.dt_cancelamento::text, '') = ''
				and	(b.cd_cco IS NOT NULL AND b.cd_cco::text <> '')
				and	a.dt_final between dt_inicio_mov_w and dt_fim_mov_w
				and	b.cd_estabelecimento = cd_estabelecimento_p
				
union

				select	a.nr_seq_segurado nr_seq_agrup
				from	pls_segurado_historico a,
					pls_segurado b
				where	a.nr_seq_segurado = b.nr_sequencia
				and	b.ie_tipo_segurado in ('B','R')
				and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
				and	coalesce(b.dt_cancelamento::text, '') = ''
				and	(b.cd_cco IS NOT NULL AND b.cd_cco::text <> '')
				and	a.ie_envio_sib = 'S'
				and	a.dt_ocorrencia_sib between dt_inicio_mov_w and dt_fim_mov_w
				and	b.cd_estabelecimento = cd_estabelecimento_p
				
union

				select	b.nr_sequencia nr_seq_agrup
				from	pls_pessoa_fisica_sib a,
					pls_segurado b
				where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
				and	b.ie_tipo_segurado in ('B','R')
				and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
				and	coalesce(b.dt_cancelamento::text, '') = ''
				and	(b.cd_cco IS NOT NULL AND b.cd_cco::text <> '')
				and (coalesce(b.dt_rescisao::text, '') = '' or b.dt_rescisao >= dt_fim_mov_w)
				and	a.dt_ocorrencia_sib between dt_inicio_mov_w and dt_fim_mov_w
				and	b.cd_estabelecimento = cd_estabelecimento_p
				
union

				select	a.nr_sequencia nr_seq_agrup
				from	pls_sib_reenvio a
				where	a.cd_estabelecimento = cd_estabelecimento_p
				and	(a.ie_tipo_movimento IS NOT NULL AND a.ie_tipo_movimento::text <> '')
				and	coalesce(a.nr_seq_lote_sib::text, '') = ''
				and	(a.nr_seq_segurado IS NOT NULL AND a.nr_seq_segurado::text <> '')
				and	ie_gerar_correcao_w = 'S' --No lote de Movimentação, só considera correções se a opção estiver marcada no lote
				) alias22
			group by nr_seq_agrup) alias23;
	elsif (ie_tipo_lote_w = 'C') then --Correção
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_sib_reenvio a
		where	a.cd_estabelecimento = cd_estabelecimento_p
		and	(a.ie_tipo_movimento IS NOT NULL AND a.ie_tipo_movimento::text <> '')
		and	coalesce(a.nr_seq_lote_sib::text, '') = ''
		and	(a.nr_seq_segurado IS NOT NULL AND a.nr_seq_segurado::text <> '');
	elsif (ie_tipo_lote_w in ('I','E')) then --Inclusão/Exclusão de todos beneficiários ativos
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_segurado a,
			pls_contrato b
		where	b.nr_sequencia = a.nr_seq_contrato
		and	a.ie_tipo_segurado in ('B','R')
		and	b.cd_estabelecimento = cd_estabelecimento_p
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_cancelamento::text, '') = ''
		and (coalesce(a.dt_rescisao::text, '') = '' or a.dt_rescisao > clock_timestamp())
		and	b.ie_tipo_beneficiario <> 'ENB';
	else
		qt_registro_w	:= 0;
	end if;
end if;

return coalesce(qt_registro_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_sib_qtde_movimentacao ( nr_seq_lote_p pls_sib_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
