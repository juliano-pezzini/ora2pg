-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_pe_prescr_item_result ( cd_perfil_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) AS $body$
DECLARE

  nr_avaliacao_anterior_w bigint;
  nr_seq_modelo_w         bigint;
  prescr_atualizada_w     boolean;
  nr_seq_evid_ant_w pe_prescr_item_result.nr_sequencia%type;
  nr_seq_pr_item_res_new_w pe_prescr_item_result.nr_sequencia%type;
  nr_seq_pr_item_res_diag_w pe_prescr_item_result_diag.nr_sequencia%type;
  nr_seq_pr_diag_new_w pe_prescr_diag.nr_sequencia%type;
  seq_encontrada_w pe_prescr_diag.nr_sequencia%type;
  dt_prescr_diag_start_w pe_prescr_diag.dt_start%type;
  evidencias CURSOR FOR
    SELECT *
    FROM pe_prescr_item_result
    WHERE nr_seq_prescr = nr_avaliacao_anterior_w;
  diag_evid CURSOR FOR
    SELECT b.*
    FROM pe_prescr_item_result_diag a,
      pe_prescr_diag b
    WHERE a.nr_seq_item    = nr_seq_evid_ant_w
    AND b.nr_sequencia     = a.nr_seq_diag
    AND coalesce(b.dt_end::text, '') = ''
    AND coalesce(b.dt_cancelamento::text, '') = '';
BEGIN
  SELECT * FROM obter_info_avaliacao_anterior(cd_perfil_p, nr_atendimento_p, cd_pessoa_fisica_p, nm_usuario_p, nr_seq_prescr_p, nr_avaliacao_anterior_w, nr_seq_modelo_w) INTO STRICT nr_avaliacao_anterior_w, nr_seq_modelo_w;
  IF nr_avaliacao_anterior_w > 0 THEN
    BEGIN
      prescr_atualizada_w := false;
      FOR c_evidencias IN evidencias
      LOOP
        nr_seq_evid_ant_w := c_evidencias.nr_sequencia;
        --evidencia
        SELECT nextval('pe_prescr_item_result_seq')
        INTO STRICT nr_seq_pr_item_res_new_w
;
        INSERT
        INTO pe_prescr_item_result(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_item,
            nr_seq_result,
            nr_seq_prescr,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            nr_seq_topografia,
            ie_lado,
            qt_ponto
          )
          VALUES (
            nr_seq_pr_item_res_new_w,
            clock_timestamp(),
            nm_usuario_p,
            c_evidencias.nr_seq_item,
            c_evidencias.nr_seq_result,
            nr_seq_prescr_p,
            clock_timestamp(),
            nm_usuario_p,
            c_evidencias.nr_seq_topografia,
            c_evidencias.ie_lado,
            c_evidencias.qt_ponto
          );
        -- ligacao prescricao atual/anterior
        IF (NOT prescr_atualizada_w) THEN
          UPDATE pe_prescricao
          SET nr_seq_prev_prescr = nr_avaliacao_anterior_w
          WHERE nr_sequencia     = nr_seq_prescr_p;
          prescr_atualizada_w   := true;
        END IF;
        FOR c_diag_evid IN diag_evid
        LOOP
          --verifica se o diagnostico ja foi gravado
          SELECT coalesce(MAX(nr_sequencia),0)
          INTO STRICT seq_encontrada_w
          FROM pe_prescr_diag
          WHERE nr_seq_prescr = nr_seq_prescr_p
          AND nr_seq_diag     = c_diag_evid.nr_seq_diag;
          IF seq_encontrada_w = 0 THEN
            ----diagnostico
            SELECT dt_inicio_prescr
            INTO STRICT dt_prescr_diag_start_w
            FROM pe_prescricao
            WHERE nr_sequencia = nr_seq_prescr_p;

            SELECT nextval('pe_prescr_diag_seq')
            INTO STRICT nr_seq_pr_diag_new_w
;
            INSERT
            INTO pe_prescr_diag(
                nr_sequencia,
                nr_seq_prescr,
                nr_seq_diag,
                nm_usuario,
                dt_atualizacao,
                nm_usuario_nrec,
                dt_atualizacao_nrec,
                ie_recorrencia,
                nr_seq_ordenacao,
                ie_diag_colab,
                nr_prioridade,
                dt_start
              )
              VALUES (
                nr_seq_pr_diag_new_w,
                nr_seq_prescr_p,
                c_diag_evid.nr_seq_diag,
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                c_diag_evid.ie_recorrencia,
                c_diag_evid.nr_seq_ordenacao,
                c_diag_evid.ie_diag_colab,
                c_diag_evid.nr_prioridade,
                dt_prescr_diag_start_w
              );
            CALL CP_COPIAR_PRESCR_PROC(nr_seq_prescr_p,nr_avaliacao_anterior_w,null,null,nr_seq_pr_diag_new_w,c_diag_evid.NR_SEQUENCIA,NM_USUARIO_P);
            CALL cp_copiar_metas(c_diag_evid.nr_sequencia,nr_seq_pr_diag_new_w,nm_usuario_p,nr_seq_prescr_p);
            CALL cp_copiar_plano_interv(c_diag_evid.nr_sequencia,nr_seq_pr_diag_new_w,nm_usuario_p);
            CALL cp_copiar_fat_rel_ris(c_diag_evid.nr_sequencia,nr_seq_pr_diag_new_w,nm_usuario_p);
          ELSE
            nr_seq_pr_diag_new_w := seq_encontrada_w;
          END IF;
          --ligacao evidencia/diagnostico
          SELECT nextval('pe_prescr_item_result_diag_seq')
          INTO STRICT nr_seq_pr_item_res_diag_w
;
          INSERT
          INTO pe_prescr_item_result_diag(
              nr_sequencia,
              nr_seq_diag,
              nr_seq_item,
              dt_atualizacao,
              nm_usuario,
              dt_atualizacao_nrec,
              nm_usuario_nrec
            )
            VALUES (
              nr_seq_pr_item_res_diag_w,
              nr_seq_pr_diag_new_w,
              nr_seq_pr_item_res_new_w,
              clock_timestamp(),
              nm_usuario_p,
              clock_timestamp(),
              nm_usuario_p
            );
        END LOOP;
      END LOOP;
      CALL CP_COPIAR_FREE_ITEM(nr_seq_prescr_p,nr_avaliacao_anterior_w,nm_usuario_p);
      COMMIT;
    END;
  END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_pe_prescr_item_result ( cd_perfil_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) FROM PUBLIC;
