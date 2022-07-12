-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_contr_patrimonio_bolivia.ajuste_pat_aitb ( nr_lote_contabil_p W_MOVIMENTO_CONTABIL.NR_LOTE_CONTABIL%type ) AS $body$
DECLARE

	qt_registros_w			bigint;
	nr_seq_regra_conta_w		bigint;
	dt_ref_inicial_w		timestamp;
	dt_ref_final_w			timestamp;
	cd_estabelecimento_w		smallint;
	dt_referencia_w			timestamp;
	cd_tipo_lote_contabil_w		bigint;
	ie_compl_hist_w			varchar(1);
	cd_empresa_w			bigint;
	cd_conta_contabil_w		varchar(20);
	cd_conta_baixa_w		varchar(20);
	cd_conta_debito_w		varchar(20);
	cd_conta_credito_w		varchar(20);
	nr_sequencia_movto_w		integer;
	dt_movimento_w			timestamp;
	cd_centro_debito_w		integer;
	cd_centro_credito_w		integer;
	nm_agrupador_w			varchar(255);
	ds_mesano_w			varchar(255);
	nr_seq_agrupamento_w		W_MOVIMENTO_CONTABIL.NR_SEQ_AGRUPAMENTO%type := 0;
	cd_bem_w			PAT_BEM.CD_BEM%type;
	ds_bem_w			PAT_BEM.DS_BEM%type;
	ds_compl_historico_w		PAT_BEM.CD_BEM%type;
	ie_tipo_valor_w			PAT_BEM.IE_TIPO_VALOR%type;
	tb_dados_conta_w       		tb_dados_conta;

	c010 CURSOR FOR
		SELECT	1,
			a.CD_CONTA_CONTABIL,
			b.CD_CENTRO_CUSTO,
			d.VL_AITB_PERIODO,
			d.VL_DEPRECIACAO_ACUMULADA,
			d.VL_DEPRECIACAO_ATUAL,
			d.VL_DEPRECIACAO_LIQUIDA,
			d.NR_CODIGO_CONTROLE,
			a.NR_SEQUENCIA,
			'MEMORIA_CALCULO_AITB' NM_TABELA,
			'VL_AITB_PERIODO' NM_ATRIBUTO,
			83 NR_SEQ_INFO_CTB,
			a.CD_BEM,
			d.NR_SEQUENCIA NR_SEQ_TAB_ORIG
		FROM	MEMORIA_CALCULO_AITB d,
			PAT_VALOR_BEM b,
			PAT_BEM a
		WHERE	d.NR_SEQ_BEM = a.NR_SEQUENCIA
		AND	b.NR_SEQ_BEM = a.NR_SEQUENCIA
		AND	dt_referencia_w		BETWEEN d.DT_INICIO_PERIODO AND d.DT_FIM_PERIODO
		AND	b.DT_VALOR		BETWEEN dt_ref_inicial_w    AND dt_ref_final_w
		AND 	b.NR_LOTE_CONTABIL 	= nr_lote_contabil_p;

	
BEGIN
		SELECT  TRUNC(a.DT_REFERENCIA,'MONTH'),
			a.CD_ESTABELECIMENTO,
			a.CD_TIPO_LOTE_CONTABIL,
			OBTER_SE_COMPL_TIPO_LOTE(a.CD_ESTABELECIMENTO, a.CD_TIPO_LOTE_CONTABIL),
			b.CD_EMPRESA
		INTO STRICT	dt_referencia_w,
			cd_estabelecimento_w,
			cd_tipo_lote_contabil_w,
			ie_compl_hist_w,
			cd_empresa_w
		FROM	LOTE_CONTABIL a,
			ESTABELECIMENTO b
		WHERE	NR_LOTE_CONTABIL	= nr_lote_contabil_p
		AND	a.CD_ESTABELECIMENTO	= b.CD_ESTABELECIMENTO;

		dt_movimento_w		:= LAST_DAY(dt_referencia_w);
		dt_ref_inicial_w	:= TRUNC(dt_referencia_w,'MONTH');
		dt_ref_final_w		:= (LAST_DAY(TRUNC(dt_referencia_w,'MONTH')) + 86399/86400);

		BEGIN
			SELECT	MAX(a.NR_SEQUENCIA)
			INTO STRICT	nr_sequencia_movto_w
			FROM	W_MOVIMENTO_CONTABIL a
			WHERE	a.NR_LOTE_CONTABIL = nr_lote_contabil_p;
		EXCEPTION
			WHEN no_data_found THEN nr_sequencia_movto_w := 0;
		END;

		nm_agrupador_w		:= coalesce(trim(both OBTER_AGRUPADOR_CONTABIL(17)),'DS_MES_ANO');

		FOR pat_aitb IN c010 LOOP
			nr_sequencia_movto_w := nr_sequencia_movto_w + 1;
			ds_compl_historico_w := NULL;

			SELECT	coalesce(MAX(NR_SEQ_REGRA_CONTA),0),
				MAX(IE_TIPO_VALOR)
			INTO STRICT 	nr_seq_regra_conta_w,
				ie_tipo_valor_w
			FROM	PAT_BEM
			WHERE	NR_SEQUENCIA = pat_aitb.nr_sequencia;

			SELECT	COUNT(1)
			INTO STRICT	qt_registros_w
			FROM	PAT_CONTA_ALTERACAO
			WHERE	NR_SEQ_BEM = pat_aitb.nr_sequencia;

			IF (qt_registros_w > 0) THEN
				nr_seq_regra_conta_w := coalesce(PAT_OBTER_REGRA_CONTA_BEM(pat_aitb.nr_sequencia, dt_referencia_w), nr_seq_regra_conta_w);
			END IF;

			IF (nr_seq_regra_conta_w = 0) THEN
				BEGIN
					tb_dados_conta_w := ctb_contr_patrimonio_bolivia.obter_dados_conta_contabil(null, cd_estabelecimento_w, pat_aitb.cd_conta_contabil, cd_empresa_w, dt_referencia_w);
				EXCEPTION
					WHEN no_data_found THEN	CALL ctb_contr_patrimonio_bolivia.abort_ajuste_pat_aitb(pat_aitb.nr_sequencia, cd_conta_contabil_w);
				END;
			ELSE
				BEGIN
					tb_dados_conta_w := ctb_contr_patrimonio_bolivia.obter_dados_conta_contabil(nr_seq_regra_conta_w);
				EXCEPTION
					WHEN no_data_found THEN CALL ctb_contr_patrimonio_bolivia.abort_ajuste_pat_aitb(nr_seq_regra_conta_w, cd_conta_contabil_w);
				END;

				IF (pat_aitb.nr_sequencia > 0) THEN
					BEGIN
						SELECT	MAX(CD_BEM)
						INTO STRICT	ds_compl_historico_w
						FROM	PAT_BEM
						WHERE	NR_SEQUENCIA = pat_aitb.nr_sequencia;
					EXCEPTION
						WHEN no_data_found THEN ds_compl_historico_w := NULL;
					END;
				ELSE
					ds_compl_historico_w := NULL;
				END IF;

				ds_mesano_w := TO_CHAR(dt_referencia_w,'MMYYYY');

				IF (nm_agrupador_w = 'NR_SEQ_BEM') THEN
					nr_seq_agrupamento_w := pat_aitb.nr_sequencia;
				ELSIF (nm_agrupador_w = 'DS_MES_ANO') THEN
					nr_seq_agrupamento_w := ds_mesano_w;
				END IF;

				IF (coalesce(nr_seq_agrupamento_w,0) = 0) THEN
					nr_seq_agrupamento_w := ds_mesano_w;
				END IF;

				IF (pat_aitb.nr_sequencia > 0) THEN
					SELECT	MAX(CD_BEM)
					INTO STRICT 	ds_compl_historico_w
					FROM	PAT_BEM
					WHERE	NR_SEQUENCIA = pat_aitb.nr_sequencia;
				ELSE
					ds_compl_historico_w := NULL;
				END IF;

				IF pat_aitb.vl_aitb_periodo > 0 THEN
					FOR i IN 1 .. 2 LOOP
						CALL ctb_contr_patrimonio_bolivia.consolida_ajuste_pat_aitb(
							nr_lote_contabil_p	=> nr_lote_contabil_p,
							nr_sequencia_p		=> nr_sequencia_movto_w,
							cd_conta_contabil_p	=> (CASE WHEN i = 1 THEN pat_aitb.cd_conta_contabil ELSE tb_dados_conta_w[1].cd_conta_ativo_aitb END),
							ie_debito_credito_p	=> (CASE WHEN i = 1 THEN 'D' ELSE 'C' END),
							cd_historico_p		=> tb_dados_conta_w[1].cd_historico,
							dt_movimento_p		=> dt_movimento_w,
							vl_movimento_p		=> pat_aitb.vl_aitb_periodo,
							ds_compl_historico_p	=> ds_compl_historico_w,
							nr_seq_agrupamento_p	=> nr_seq_agrupamento_w,
							nr_seq_info_p		=> pat_aitb.nr_seq_info_ctb,
							nr_seq_tab_orig_p	=> pat_aitb.nr_seq_tab_orig,
							nm_tabela_p		=> pat_aitb.nm_tabela,
							nm_atributo_p		=> 'VL_AITB_PERIODO',
							cd_estabelecimento_p	=> cd_estabelecimento_w
						);

						nr_sequencia_movto_w := nr_sequencia_movto_w + 1;
					END LOOP;
				END IF;

				IF pat_aitb.vl_depreciacao_acumulada > 0 THEN
					FOR i IN 1 .. 2 LOOP
						CALL ctb_contr_patrimonio_bolivia.consolida_ajuste_pat_aitb(
							nr_lote_contabil_p	=> nr_lote_contabil_p,
							nr_sequencia_p		=> nr_sequencia_movto_w,
							cd_conta_contabil_p	=> (CASE WHEN i = 1 THEN tb_dados_conta_w[1].cd_conta_passivo_aitb ELSE tb_dados_conta_w[1].cd_conta_deprec_acum END),
							ie_debito_credito_p	=> (CASE WHEN i = 1 THEN 'D' ELSE 'C' END),
							cd_historico_p		=> tb_dados_conta_w[1].cd_historico,
							dt_movimento_p		=> dt_movimento_w,
							vl_movimento_p		=> pat_aitb.vl_depreciacao_acumulada,
							ds_compl_historico_p	=> ds_compl_historico_w,
							nr_seq_agrupamento_p	=> nr_seq_agrupamento_w,
							nr_seq_info_p		=> pat_aitb.nr_seq_info_ctb,
							nr_seq_tab_orig_p	=> pat_aitb.nr_seq_tab_orig,
							nm_tabela_p		=> pat_aitb.nm_tabela,
							nm_atributo_p		=> 'VL_DEPRECIACAO_ACUMULADA',
							cd_estabelecimento_p	=> cd_estabelecimento_w
						);

						nr_sequencia_movto_w := nr_sequencia_movto_w + 1;
					END LOOP;
				END IF;

				IF pat_aitb.vl_depreciacao_atual > 0 THEN
					FOR i IN 1 .. 2 LOOP
						CALL ctb_contr_patrimonio_bolivia.consolida_ajuste_pat_aitb(
							nr_lote_contabil_p	=> nr_lote_contabil_p,
							nr_sequencia_p		=> nr_sequencia_movto_w,
							cd_conta_contabil_p	=> (CASE WHEN i = 1 THEN tb_dados_conta_w[1].cd_conta_deprec_res ELSE tb_dados_conta_w[1].cd_conta_deprec_acum END),
							ie_debito_credito_p	=> (CASE WHEN i = 1 THEN 'D' ELSE 'C' END),
							cd_historico_p		=> tb_dados_conta_w[1].cd_historico,
							dt_movimento_p		=> dt_movimento_w,
							vl_movimento_p		=> pat_aitb.vl_depreciacao_atual,
							ds_compl_historico_p	=> ds_compl_historico_w,
							nr_seq_agrupamento_p	=> nr_seq_agrupamento_w,
							nr_seq_info_p		=> pat_aitb.nr_seq_info_ctb,
							nr_seq_tab_orig_p	=> pat_aitb.nr_seq_tab_orig,
							nm_tabela_p		=> pat_aitb.nm_tabela,
							nm_atributo_p		=> 'VL_DEPRECIACAO_ATUAL',
							cd_estabelecimento_p	=> cd_estabelecimento_w
						);

						nr_sequencia_movto_w := nr_sequencia_movto_w + 1;
					END LOOP;
				END IF;

				IF pat_aitb.vl_depreciacao_atual > 0 THEN
					FOR i IN 1 .. 2 LOOP
						CALL ctb_contr_patrimonio_bolivia.consolida_ajuste_pat_aitb(
							nr_lote_contabil_p	=> nr_lote_contabil_p,
							nr_sequencia_p		=> nr_sequencia_movto_w,
							cd_conta_contabil_p	=> (CASE WHEN i = 1 THEN tb_dados_conta_w[1].cd_conta_deprec_acum ELSE pat_aitb.cd_conta_contabil END),
							ie_debito_credito_p	=> (CASE WHEN i = 1 THEN 'D' ELSE 'C' END),
							cd_historico_p		=> tb_dados_conta_w[1].cd_historico,
							dt_movimento_p		=> dt_movimento_w,
							vl_movimento_p		=> pat_aitb.vl_depreciacao_liquida,
							ds_compl_historico_p	=> ds_compl_historico_w,
							nr_seq_agrupamento_p	=> nr_seq_agrupamento_w,
							nr_seq_info_p		=> pat_aitb.nr_seq_info_ctb,
							nr_seq_tab_orig_p	=> pat_aitb.nr_seq_tab_orig,
							nm_tabela_p		=> pat_aitb.nm_tabela,
							nm_atributo_p		=> 'VL_DEPRECIACAO_LIQUIDA',
							cd_estabelecimento_p	=> cd_estabelecimento_w
						);

						nr_sequencia_movto_w := nr_sequencia_movto_w + 1;
					END LOOP;
				END IF;
			END IF;
		END LOOP;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_contr_patrimonio_bolivia.ajuste_pat_aitb ( nr_lote_contabil_p W_MOVIMENTO_CONTABIL.NR_LOTE_CONTABIL%type ) FROM PUBLIC;
