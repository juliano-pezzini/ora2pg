-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_regras_contabil.ctb_gerar_cd_controle_tesour ( nr_lote_contabil_p LOTE_CONTABIL.NR_LOTE_CONTABIL%type, nm_usuario_p text ) AS $body$
DECLARE


    cd_tipo_lote_contabil_w     LOTE_CONTABIL.CD_TIPO_LOTE_CONTABIL%type;
    nr_seq_movt_trans_financ_w  MOVTO_TRANS_FINANC.NR_SEQUENCIA%type;
    ds_prefixo_w                REGRAS_TIPO_LOTE_CONTABIL.DS_PREFIXO%type;

    ie_tipo_transacao_w		varchar(3);
    ie_tipo_pagamento_w		varchar(3);
    nr_comprovante_w		varchar(255);
    arr_data_w                  arr_regra_prefix_t;

    c010 CURSOR FOR
        SELECT   NM_TABELA,
		 NR_SEQ_TAB_ORIG,
		 NR_CODIGO_CONTROLE
        FROM     W_MOVIMENTO_CONTABIL
        WHERE    NR_LOTE_CONTABIL = nr_lote_contabil_p
	GROUP BY NM_TABELA,
		 NR_SEQ_TAB_ORIG,
		 NR_CODIGO_CONTROLE;


BEGIN
	IF nr_lote_contabil_p > 0 THEN
	    CALL ctb_regras_contabil.restore_comprovante_from_cache(nr_lote_contabil_p, nm_usuario_p);

            SELECT  MAX(CD_TIPO_LOTE_CONTABIL)
            INTO STRICT    cd_tipo_lote_contabil_w
            FROM    LOTE_CONTABIL
            WHERE   NR_LOTE_CONTABIL = nr_lote_contabil_p;

            FOR operacao IN c010 LOOP
		IF (coalesce(operacao.nr_codigo_controle::text, '') = '') THEN
			nr_comprovante_w	:= ctb_regras_contabil.obter_comprovante_origem(operacao.nm_tabela, operacao.nr_seq_tab_orig);

			arr_data_w              := ctb_regras_contabil.obter_prefix_regra_rest(
							cd_tipo_lote_contabil_w,
							ctb_regras_contabil.verifica_operacao_tesouraria(cd_tipo_lote_contabil_w, operacao.nr_seq_tab_orig)
						);
			ds_prefixo_w            := arr_data_w(2);

			IF (coalesce(nr_comprovante_w::text, '') = '') THEN
				nr_comprovante_w	:= ctb_regras_contabil.verificar_estorno_tesouraria(operacao.nr_seq_tab_orig);
			END IF;

			IF (coalesce(nr_comprovante_w::text, '') = '' AND (ds_prefixo_w IS NOT NULL AND ds_prefixo_w::text <> '')) THEN
				nr_comprovante_w        := ctb_regras_contabil.gerar_seq_comprovante(ds_prefixo_w, nm_usuario_p);
			END IF;

			UPDATE  W_MOVIMENTO_CONTABIL
			SET     NR_CODIGO_CONTROLE = nr_comprovante_w
			WHERE   NR_LOTE_CONTABIL   = nr_lote_contabil_p
			AND     NM_TABELA          = operacao.nm_tabela
			AND     NR_SEQ_TAB_ORIG    = operacao.nr_seq_tab_orig
			AND	coalesce(NR_CODIGO_CONTROLE::text, '') = '';

			UPDATE  MOVTO_TRANS_FINANC
			SET     NR_CODIGO_CONTROLE = nr_comprovante_w
			WHERE   NR_SEQUENCIA       = operacao.nr_seq_tab_orig
			AND     coalesce(NR_CODIGO_CONTROLE::text, '') = '';
		END IF;
            END LOOP;
	    COMMIT;
        END IF;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_regras_contabil.ctb_gerar_cd_controle_tesour ( nr_lote_contabil_p LOTE_CONTABIL.NR_LOTE_CONTABIL%type, nm_usuario_p text ) FROM PUBLIC;