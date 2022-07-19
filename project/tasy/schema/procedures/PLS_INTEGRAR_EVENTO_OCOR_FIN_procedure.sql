-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_integrar_evento_ocor_fin ( nr_seq_lote_p pls_evento_imp_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


qt_incons_w		integer;
nr_seq_evento_w		pls_evento.nr_sequencia%type;
dt_vigencia_w		timestamp;
ie_funcao_pagamento_w	pls_parametro_pagamento.ie_funcao_pagamento%type;

tb_vl_lancamento_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_w	pls_util_cta_pck.t_number_table;
tb_ds_observacao_w	pls_util_cta_pck.t_varchar2_table_255;

c01 CURSOR( nr_seq_lote_pc	pls_evento_imp_lote.nr_sequencia%type) FOR
	SELECT	coalesce(a.vl_lancamento, 0) vl_lancamento,
		a.nr_seq_prestador,
		a.ds_observacao
	from	pls_evento_imp_ocor_fin a
	where 	a.nr_seq_lote = nr_seq_lote_pc;


BEGIN

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	select	count(1)
	into STRICT	qt_incons_w
	from 	pls_evento_imp_ocor_fin
	where	nr_seq_lote = nr_seq_lote_p
	and	ie_consistente = 'N';

	-- se existir algum registro inconsistente então barra a integração
	if (qt_incons_w > 0) then

		-- Existem inconsistências. Favor verifique!
		CALL wheb_mensagem_pck.exibir_mensagem_abort(443622);
	end if;

	select	coalesce(max(ie_funcao_pagamento),1)
	into STRICT	ie_funcao_pagamento_w
	from	pls_parametro_pagamento
	where	cd_estabelecimento	= cd_estabelecimento_p;

	-- busca as informações do lote
	select	max(dt_referencia),
		max(nr_seq_evento)
	into STRICT	dt_vigencia_w,
		nr_seq_evento_w
	from	pls_evento_imp_lote
	where	nr_sequencia = nr_seq_lote_p;

	if (ie_funcao_pagamento_w = '1') then -- Pagamento Delphi
		open c01(nr_seq_lote_p);
		loop
			fetch c01 bulk collect into tb_vl_lancamento_w, tb_nr_seq_prest_w, tb_ds_observacao_w
			limit pls_util_pck.qt_registro_transacao_w;
			exit when tb_vl_lancamento_w.count = 0;

			forall i in tb_vl_lancamento_w.first..tb_vl_lancamento_w.last
				insert into pls_evento_regra_fixo(
					nr_sequencia, ds_observacao, dt_atualizacao,
					dt_atualizacao_nrec, dt_inicio_vigencia, ie_forma_incidencia,
					nr_seq_prestador, vl_regra, nm_usuario,
					nm_usuario_nrec, nr_seq_evento
				) values (
					nextval('pls_evento_regra_fixo_seq'), tb_ds_observacao_w(i), clock_timestamp(),
					clock_timestamp(), dt_vigencia_w, 'U',
					tb_nr_seq_prest_w(i), tb_vl_lancamento_w(i), nm_usuario_p,
					nm_usuario_p, nr_seq_evento_w
				);
				commit;
		end loop;

	elsif (ie_funcao_pagamento_w = '2') then -- Pagamento HTML
		open c01(nr_seq_lote_p);
		loop
			fetch c01 bulk collect into tb_vl_lancamento_w, tb_nr_seq_prest_w, tb_ds_observacao_w
			limit pls_util_pck.qt_registro_transacao_w;
			exit when tb_vl_lancamento_w.count = 0;

			forall i in tb_vl_lancamento_w.first..tb_vl_lancamento_w.last
				insert into pls_pp_lanc_programado(nr_sequencia,				dt_atualizacao,				nm_usuario,
					nm_usuario_nrec,			dt_inicio_vigencia,			dt_fim_vigencia,
					nr_seq_prestador,			ie_forma_incidencia,			vl_regra,
					nr_seq_prest_orig,			ie_cooperado,				ie_forma_valor,
					nr_seq_tipo_prestador,			ie_situacao_prest,			nr_seq_sit_coop,
					nr_seq_classe_titulo,			ds_observacao,				nr_seq_classe_tit_pagar,
					nr_seq_trans_fin_baixa,			nr_seq_trans_fin_contab,		cd_condicao_pagamento,
					qt_dia_venc,				ie_prestador_matriz,			dt_movimento,
					ie_titulo_pagar,			cd_pf_titulo_pagar,			cd_centro_custo,
					nr_seq_evento,				cd_prestador_cod,			dt_inicio_vigencia_ref,
					dt_fim_vigencia_ref,			ie_ordenacao_sugerida,			nr_ordem_execucao,
					ie_gerar_apos_tributacao,		cd_pj_titulo_pagar,			dt_atualizacao_nrec)
				values (nextval('pls_pp_lanc_programado_seq'),	clock_timestamp(),				nm_usuario_p,
					nm_usuario_p,				dt_vigencia_w,				null,
					tb_nr_seq_prest_w(i),			'U',					tb_vl_lancamento_w(i),
					null,					null,					'I',
					null,					'T',					null,
					null,					tb_ds_observacao_w(i),			null,
					null,					null,					null,
					null,					null,					null,
					null,					null,					null,
					nr_seq_evento_w,			null,					dt_vigencia_w,
					null,					'N',					1,
					'N',					null,					clock_timestamp());
				commit;
		end loop;
	end if;

	update	pls_evento_imp_lote
	set	dt_integracao = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_lote_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_integrar_evento_ocor_fin ( nr_seq_lote_p pls_evento_imp_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

