-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_agenda_integrada (nr_seq_agenda_p agenda_consulta.nr_sequencia%TYPE ,cd_motivo_cancelamento_p agenda_consulta.cd_motivo_cancelamento%TYPE ,ds_observacao_p agenda_consulta.ds_observacao%TYPE ,cd_pessoa_fisica_p agenda_consulta.cd_pessoa_fisica%TYPE ,dt_agenda_p agenda_consulta.dt_agenda%TYPE ,ie_cancelado_p text ,ie_resposta_dlg_p text ,ie_fazer_pergunta_p INOUT text ,ds_mensagem_aviso_p INOUT text ,ds_msg_p INOUT text ) AS $body$
DECLARE

  nm_usuario_w              usuario.nm_usuario%TYPE;
  cd_estabelecimento_w      establishment_locale.cd_estabelecimento%TYPE;
  ie_exige_mot_cancel_w     funcao_param_usuario.vl_parametro%TYPE;
  ie_pac_age_futura_w       varchar(255);
  ds_msg_w                  varchar(255);
  cancel_agenda_obito_w     funcao_param_usuario.vl_parametro%TYPE;
  ie_cancel_fut_obito_w     varchar(255);
  cd_motivo_cancelamento_w  agenda_consulta.cd_motivo_cancelamento%TYPE;
  ds_observacao_w           agenda_consulta.ds_observacao%TYPE;
  ie_exibe_msg_can_futuro_w funcao_param_usuario.vl_parametro%TYPE;

  PROCEDURE OBTER_PARAMETROS_USUARIO IS
;
BEGIN
    vl_parametro_p       => ie_exige_mot_cancel_w := OBTER_PARAM_USUARIO(cd_funcao_p          => 866 -- funcao Agenda de Servicos
, nr_sequencia_p       => 5, cd_perfil_p          => obter_perfil_ativo, nm_usuario_p         => nm_usuario_w, cd_estabelecimento_p => cd_estabelecimento_w, vl_parametro_p       => ie_exige_mot_cancel_w);

    vl_parametro_p       => cancel_agenda_obito_w := OBTER_PARAM_USUARIO(cd_funcao_p          => 866, nr_sequencia_p       => 96, cd_perfil_p          => obter_perfil_ativo, nm_usuario_p         => nm_usuario_w, cd_estabelecimento_p => cd_estabelecimento_w, vl_parametro_p       => cancel_agenda_obito_w);

    vl_parametro_p       => ie_exibe_msg_can_futuro_w := OBTER_PARAM_USUARIO(cd_funcao_p          => 866, nr_sequencia_p       => 111, cd_perfil_p          => obter_perfil_ativo, nm_usuario_p         => nm_usuario_w, cd_estabelecimento_p => cd_estabelecimento_w, vl_parametro_p       => ie_exibe_msg_can_futuro_w);
  END;

  FUNCTION RETORNO_PERGUNTA RETURN;
    protocolo_w             varchar2(25);
  BEGIN
    BEGIN
      SELECT coalesce(MAX(ie_exibir_protoc_canc),'N') ie_exibir_protoc_canc
        INTO STRICT ie_exibir_protoc_canc_w
        FROM parametro_agenda
       WHERE cd_estabelecimento = cd_estabelecimento_w;
    EXCEPTION
      WHEN no_data_found THEN
        ie_exibir_protoc_canc_w := 'N';
    END;

    IF (ie_exibir_protoc_canc_w = 'S') AND (ie_resposta_dlg_p = 'N') THEN
      protocolo_w := OBTER_PROTOCOLO_CANC_AGE(ie_tipo_agenda_p => 'C'
                                             ,nr_seq_agenda_p  => nr_seq_agenda_p);
      IF (protocolo_w IS NOT NULL AND protocolo_w::text <> '') THEN
        RETURN;
      END IF;
    END IF;
    
    RETURN;
  END;

BEGIN
  ie_fazer_pergunta_p  := 'N';
  ds_mensagem_aviso_p  := NULL;
  ds_msg_p             := NULL;
  nm_usuario_w         := WHEB_USUARIO_PCK.get_nm_usuario;
  cd_estabelecimento_w := WHEB_USUARIO_PCK.get_cd_estabelecimento;

  CALL wheb_usuario_pck.set_ie_commit('N');

  OBTER_PARAMETROS_USUARIO;

  IF ie_exige_mot_cancel_w = 'S' THEN
    CALL ATUALIZAR_MOTIVO_CANCEL_AGENDA(cd_motivo_cancelamento_p => cd_motivo_cancelamento_p
                                  ,ds_observacao_p          => ds_observacao_p
                                  ,nr_sequencia_p           => nr_seq_agenda_p
                                  ,nm_usuario_p             => nm_usuario_w );
  ELSE
    CALL CANCELAR_AGENDA_CONSULTA(nr_seq_agenda_p => nr_seq_agenda_p
                            ,nm_usuario_p    => nm_usuario_w);

    CALL GERAR_COMUNICACAO_ALTER_STATUS(ie_status_agenda_p   => 'C'
                                  ,nr_seq_agenda_p      => nr_seq_agenda_p
                                  ,nm_usuario_p         => nm_usuario_w
                                  ,cd_estabelecimento_p => cd_estabelecimento_w);
  END IF;

  IF ie_cancelado_p = 'N' THEN
    ie_cancel_fut_obito_w    := 'N';
    cd_motivo_cancelamento_w := NULL;
    ds_observacao_w          := NULL;

    IF ie_exige_mot_cancel_w = 'S' THEN
      IF cancel_agenda_obito_w = cd_motivo_cancelamento_p THEN
        ie_cancel_fut_obito_w  := 'S';
      END IF;
      cd_motivo_cancelamento_w := cd_motivo_cancelamento_p;
      ds_observacao_w          := ds_observacao_p;
    END IF;

    SELECT * FROM CANCEL_AGENDA_CONSULTA_AGESERV(nr_seq_agenda_p       => nr_seq_agenda_p, ie_cancel_fut_obito_p => ie_cancel_fut_obito_w, cd_pessoa_fisica_p    => cd_pessoa_fisica_p, dt_agenda_p           => dt_agenda_p, cd_motivo_p           => cd_motivo_cancelamento_w, ds_observacao_p       => ds_observacao_w, nm_usuario_p          => nm_usuario_w, ie_pac_age_futura_p   => ie_pac_age_futura_w, ds_msg_p              => ds_msg_w) INTO STRICT ie_pac_age_futura_p   => ie_pac_age_futura_w, ds_msg_p              => ds_msg_w;
    -- ds_msg_p = 49956 - "Este paciente tem agendas futuras. Deseja cancela-las"
    IF (ie_pac_age_futura_w = 'S') AND (ie_exibe_msg_can_futuro_w = 'S') THEN
      ie_fazer_pergunta_p := 'S';
      ds_msg_p            := ds_msg_w;
    END IF;

    ds_mensagem_aviso_p := RETORNO_PERGUNTA;
  END IF;

  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_agenda_integrada (nr_seq_agenda_p agenda_consulta.nr_sequencia%TYPE ,cd_motivo_cancelamento_p agenda_consulta.cd_motivo_cancelamento%TYPE ,ds_observacao_p agenda_consulta.ds_observacao%TYPE ,cd_pessoa_fisica_p agenda_consulta.cd_pessoa_fisica%TYPE ,dt_agenda_p agenda_consulta.dt_agenda%TYPE ,ie_cancelado_p text ,ie_resposta_dlg_p text ,ie_fazer_pergunta_p INOUT text ,ds_mensagem_aviso_p INOUT text ,ds_msg_p INOUT text ) FROM PUBLIC;
