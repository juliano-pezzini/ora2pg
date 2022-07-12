-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_proc_mat_item_upd ON prescr_proc_mat_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_proc_mat_item_upd() RETURNS trigger AS $BODY$
DECLARE
    nr_prescricao_w           prescr_medica.nr_prescricao%TYPE;
    cd_estabelecimento_w      estabelecimento.cd_estabelecimento%TYPE;
    nr_seq_exame_w            exame_laboratorio.nr_seq_exame%TYPE;
    nr_atendimento_w          atendimento_paciente.nr_atendimento%TYPE;
    ie_status_envio_w         lab_parametro.ie_status_envio%TYPE;
    nr_ordem_amostra_w        exame_laboratorio.nr_ordem_amostra%TYPE;
    ie_formato_resultado_w    varchar(10);
    qt_prescr_proc_material_w bigint;
    ds_sep_bv_w               varchar(100);
    ds_param_integ_hl7_w      varchar(2000);
    ie_status_envio_abbot_w   lab_parametro.ie_status_envio_abbot%TYPE;
    qt_reg_w    			  smallint;
BEGIN

    IF (wheb_usuario_pck.get_ie_executar_trigger  = 'N') THEN
       GOTO Final;
    END IF;

    IF ( wheb_usuario_pck.Is_evento_ativo(84) = 'S' ) THEN
    
      SELECT Max(nr_prescricao)
      INTO STRICT   nr_prescricao_w
      FROM   prescr_proc_material
      WHERE  nr_sequencia = NEW.nr_seq_prescr_proc_mat;

      SELECT Max(nr_atendimento),
             Max(cd_estabelecimento)
      INTO STRICT   nr_atendimento_w, cd_estabelecimento_w
      FROM   prescr_medica a
      WHERE  a.nr_prescricao = nr_prescricao_w;

      SELECT Max(ie_status_envio)
      INTO STRICT   ie_status_envio_w
      FROM   lab_parametro
      WHERE  cd_estabelecimento = cd_estabelecimento_w;

      IF ( NEW.ie_status = ie_status_envio_w  AND  OLD.ie_status < ie_status_envio_w ) THEN
        /*SELECT  MAX(a.nr_seq_exame)
        INTO  nr_seq_exame_w
        FROM  prescR_procedimento a
        WHERE  a.nr_prescricao = nr_prescricao_w
        AND  a.nr_sequencia = :NEW.nr_seq_prescr;*/

        nr_seq_exame_w := Lab_obter_exame_pragma(nr_prescricao_w,
                          NEW.nr_seq_prescr);

        SELECT Max(ie_formato_resultado)
        INTO STRICT   ie_formato_resultado_w
        FROM   exame_laboratorio
        WHERE  nr_seq_exame = nr_seq_exame_w;

        SELECT Count(*)
        INTO STRICT   nr_ordem_amostra_w
        FROM   exame_laboratorio
        WHERE  nr_seq_superior = nr_seq_exame_w
               AND nr_ordem_amostra IS NOT NULL;

        ds_sep_bv_w := obter_separador_bv;

        IF ( ie_formato_resultado_w NOT IN ( 'SM', 'SDM' ) )
           AND ( nr_ordem_amostra_w > 0 ) THEN
          ds_param_integ_hl7_w := 'nr_atendimento='
                                  || nr_atendimento_w
                                  || ds_sep_bv_w
                                  || 'nr_prescricao='
                                  || nr_prescricao_w
                                  || ds_sep_bv_w
                                  || 'nr_seq_presc='
                                  || NEW.nr_seq_prescr
                                  || ds_sep_bv_w
                                  || 'nr_seq_prescr_proc_mat='
                                  ||NEW.nr_seq_prescr_proc_mat
                                  || ds_sep_bv_w;

          CALL Gravar_agend_integracao(84, ds_param_integ_hl7_w);
        END IF;
      END IF;
    END IF;

    IF ( wheb_usuario_pck.Is_evento_ativo(705) = 'S' ) THEN
      SELECT Max(nr_prescricao)
      INTO STRICT   nr_prescricao_w
      FROM   prescr_proc_material
      WHERE  nr_sequencia = NEW.nr_seq_prescr_proc_mat;

      SELECT Max(nr_atendimento),
             Max(cd_estabelecimento)
      INTO STRICT   nr_atendimento_w, cd_estabelecimento_w
      FROM   prescr_medica a
      WHERE  a.nr_prescricao = nr_prescricao_w;

      SELECT Max(ie_status_envio),
             ie_status_envio_abbot
      INTO STRICT   ie_status_envio_w, ie_status_envio_abbot_w
      FROM   lab_parametro
      WHERE  cd_estabelecimento = cd_estabelecimento_w
      GROUP  BY ie_status_envio_abbot;

      IF ( ie_status_envio_abbot_w = 'S' ) THEN
        IF ( NEW.ie_status = ie_status_envio_w )
           AND ( OLD.ie_status < ie_status_envio_w ) THEN
          CALL Abbott_enviar_prescr(NEW.nr_prescricao, NEW.nr_seq_prescr,
          NEW.nr_seq_prescr_proc_mat);
        END IF;
      ELSE
        IF ( NEW.ie_status = 20 )
           AND ( OLD.ie_status < 20 ) THEN
          CALL Abbott_enviar_prescr(NEW.nr_prescricao, NEW.nr_seq_prescr,
          NEW.nr_seq_prescr_proc_mat);
        ELSIF ( NEW.ie_status = 10 )
              AND ( OLD.ie_status > NEW.ie_status ) THEN
          CALL Abbott_enviar_prescr(NEW.nr_prescricao, NEW.nr_seq_prescr,
          NEW.nr_seq_prescr_proc_mat, 'RR');
        END IF;
      END IF;
    END IF;

<<Final>>
qt_reg_w :=0;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_proc_mat_item_upd() FROM PUBLIC;

CREATE TRIGGER prescr_proc_mat_item_upd
	BEFORE UPDATE ON prescr_proc_mat_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_proc_mat_item_upd();
