-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mensalidade_contr ( nr_seq_lote_p bigint, nr_seq_contrato_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, ie_tipo_p text) AS $body$
DECLARE


qt_registros_w		bigint;
nr_seq_contrato_w	pls_contrato.nr_sequencia%type;
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
dt_referencia_w		timestamp;
nr_contrato_w		bigint;
dt_inicio_adesao_w	pls_lote_mensalidade.dt_inicio_adesao%type;
dt_fim_adesao_w		pls_lote_mensalidade.dt_fim_adesao%type;
qt_mes_competencia_w	bigint;


BEGIN

dt_referencia_w		:= trunc(dt_mesano_referencia_p,'month');
nr_seq_contrato_w	:= nr_seq_contrato_p;

if (nr_seq_segurado_p = 0) then
	nr_seq_segurado_w := null;
else
	nr_seq_segurado_w := nr_seq_segurado_p;
end if;

if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_mensalidade			b,
		pls_mensalidade_segurado	a
	where	b.nr_sequencia	= a.nr_seq_mensalidade
	and	a.nr_seq_segurado	= nr_seq_segurado_w
	and	a.dt_mesano_referencia	= dt_referencia_w
	and	coalesce(b.dt_cancelamento::text, '') = '';

	if (qt_registros_w	> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(199980); --Mensalidade já gerada para o beneficiário. Verifique!
	end if;

	select	nr_seq_contrato
	into STRICT	nr_seq_contrato_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;
end if;

if (coalesce(nr_seq_contrato_w,0) > 0) then
	select	count(1)
	into STRICT	qt_mes_competencia_w
	from	pls_competencia
	where	cd_estabelecimento = cd_estabelecimento_p
	and	trunc(dt_mes_competencia,'month') = dt_referencia_w;

	if (qt_mes_competencia_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1005288); --Não existe um mês de competência aberto para a data de geração da mensalidade.
	end if;

	select	nr_contrato
	into STRICT	nr_contrato_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;

	if (ie_tipo_p = 'P') then
		dt_inicio_adesao_w := null;
		dt_fim_adesao_w := null;
	elsif (ie_tipo_p = 'I') then
		dt_inicio_adesao_w	:= trunc(dt_mesano_referencia_p,'month');
		dt_fim_adesao_w := fim_mes(dt_mesano_referencia_p);
	end if;

	insert into pls_lote_mensalidade(nr_sequencia, nm_usuario, dt_atualizacao,
		dt_mesano_referencia, ie_status, dt_geracao,
		ie_tipo_contratacao, ie_regulamentacao, ie_fator_moderador,
		ie_participacao, nr_seq_contrato, cd_estabelecimento,
		vl_lote, dt_liberacao, dt_geracao_titulos,
		ds_observacao, ie_primeira_mensalidade, nr_contrato,
		ie_tipo_lote,ie_pagador_beneficio_obito, cd_perfil,
		dt_inicio_adesao, dt_fim_adesao, nr_seq_segurado,
		ie_mensalidade_mes_anterior, ie_visualizar_portal, ie_cobrar_retroativo,
		ie_gerar_mensalidade_futura, ie_tipo_pessoa_pagador, ie_geracao_nota_titulo)
	values (nr_seq_lote_p, nm_usuario_p, clock_timestamp(),
		dt_referencia_w, '1', null,
		'T', 'T', 'T',
		'T', nr_seq_contrato_w, cd_estabelecimento_p,
		0, null, null,
		'Mensalidade referente a 1° parcela do contrato nr. ' || nr_contrato_w, 'S', nr_contrato_w,
		'CO','N', wheb_usuario_pck.get_cd_perfil,
		dt_inicio_adesao_w, dt_fim_adesao_w, nr_seq_segurado_w,
		'N', 'N', 'N',
		'N', 'A', 'A');

	CALL pls_geracao_mensalidade(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mensalidade_contr ( nr_seq_lote_p bigint, nr_seq_contrato_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, ie_tipo_p text) FROM PUBLIC;

