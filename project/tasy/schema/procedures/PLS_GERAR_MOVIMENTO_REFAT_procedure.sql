-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_movimento_refat (nr_seq_ajuste_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_conta_w			bigint;
nr_seq_evento_w			bigint;
nr_seq_lote_w			bigint;
nr_seq_prestador_w		bigint;
vl_movimento_w			double precision;
nr_seq_lote_disc_w		pls_lote_discussao.nr_sequencia%type;
ie_necessita_lib_w		pls_evento_conta_ajuste.ie_necessita_lib%type;

c01 CURSOR(nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	a.nr_seq_prestador_pgto nr_seq_prestador,
		coalesce(sum(a.vl_liberado),0) vl_movimento
	from	pls_conta_medica_resumo a
	where	a.nr_seq_conta = nr_seq_conta_pc
	and	(a.nr_seq_prestador_pgto IS NOT NULL AND a.nr_seq_prestador_pgto::text <> '')
	group 	by a.nr_seq_prestador_pgto;

c02 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_evento,
		coalesce(a.ie_origem_ajuste,'A') ie_origem_ajuste,
		coalesce(a.ie_necessita_lib,'N') ie_necessita_lib
	from	pls_evento b,
		pls_evento_conta_ajuste a
	where	a.nr_seq_evento	= b.nr_sequencia
	and	b.ie_situacao = 'A'
	and	a.ie_conta_ajuste = 'S'
	order by CASE WHEN coalesce(a.ie_necessita_lib,'N')='N' THEN 0  ELSE 1 END , 1;
BEGIN

select	max(a.nr_seq_conta),
	max(c.nr_seq_lote_disc)
into STRICT	nr_seq_conta_w,
	nr_seq_lote_disc_w
from	pls_conta b,
	pls_ajuste_fatura_conta a,
	pls_ajuste_fatura c
where	a.nr_sequencia = nr_seq_ajuste_conta_p
and	a.nr_seq_conta = b.nr_sequencia
and	c.nr_sequencia = a.nr_seq_ajuste_fatura;

if (coalesce(nr_seq_lote_disc_w::text, '') = '') then

	nr_seq_evento_w	:= null;
	for r_C02_w in C02 loop
		nr_seq_evento_w := r_C02_w.nr_seq_evento;
		if 	((r_C02_w.ie_origem_ajuste = 'RC') and (coalesce(nr_seq_lote_disc_w::text, '') = '')) then
			nr_seq_evento_w := null;
		elsif	(r_C02_w.ie_origem_ajuste = 'RF' AND nr_seq_lote_disc_w IS NOT NULL AND nr_seq_lote_disc_w::text <> '') then
			nr_seq_evento_w := null;
		end if;
		ie_necessita_lib_w := r_C02_w.ie_necessita_lib;
	end loop;

	if (coalesce(nr_seq_evento_w::text, '') = '') and (coalesce(nr_seq_lote_disc_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(252242); -- Não foi encontrada regra de evento para as contas ajustadas pelo refaturamento!	Verifique a função "OPS - Controle de Eventos e Ocorrências Financeiras", pasta "Eventos/Ajustes refaturamento".
	end if;

	if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_lote_w
		from	pls_lote_evento
		where	coalesce(dt_liberacao::text, '') = '';

		if (coalesce(nr_seq_lote_w::text, '') = '') or (ie_necessita_lib_w = 'S') then
			insert into pls_lote_evento(
				nr_sequencia,			dt_atualizacao,		nm_usuario,
				dt_competencia,			ie_origem,		nr_lote_contabil,
				cd_estabelecimento)
			values (	nextval('pls_lote_evento_seq'),	clock_timestamp(),		nm_usuario_p,
				clock_timestamp(),			'A',			0,
				cd_estabelecimento_p) returning nr_sequencia into nr_seq_lote_w;
		end if;

		for r_C01_w in C01(nr_seq_conta_w) loop
			insert	into pls_evento_movimento(nr_sequencia,				nr_seq_prestador,		dt_movimento,
				dt_venc_titulo,				vl_movimento,			nr_seq_evento,
				nr_seq_periodo,				nr_seq_lote_pgto,		ie_forma_pagto,
				cd_conta_credito,			cd_conta_debito,		cd_historico,
				nr_seq_esquema,				nr_lote_contabil,		cd_conta_contabil,
				nr_seq_classe_tit_rec,			nr_titulo_receber,		ds_observacao,
				nr_titulo_pagar,			nr_tit_rec_vinculado,		nr_tit_pagar_vinculado,
				nr_adiant_pago,				nr_seq_lote,			dt_atualizacao,
				nm_usuario,				dt_atualizacao_nrec,		nm_usuario_nrec,
				nr_seq_regra_fixo,			nr_seq_prest_plant_item,	nr_seq_lote_contest,
				nr_seq_lote_disc,			nr_seq_lote_pgto_orig,		dt_mes_comp_lote,
				cd_classif_cred,			cd_classif_deb,			nr_seq_conta_ajuste)
			values (	nextval('pls_evento_movimento_seq'),	r_C01_w.nr_seq_prestador,	clock_timestamp(),
				null,					abs(r_C01_w.vl_movimento)*-1,	nr_seq_evento_w,
				null,					null,				'P',
				'',					'',				null,
				null,					null,				'',
				null,					null,				'',
				null,					null,				null,
				null,					nr_seq_lote_w,			clock_timestamp(),
				nm_usuario_p,				clock_timestamp(),			nm_usuario_p,
				null,					null,				null,
				null,					null,				null,
				'',					'',				nr_seq_conta_w);
		end loop;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_movimento_refat (nr_seq_ajuste_conta_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

