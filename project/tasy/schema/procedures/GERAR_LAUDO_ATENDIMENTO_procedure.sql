-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_laudo_atendimento (nr_atendimento_p bigint, nr_seq_interno_p text, nm_usuario_p text) AS $body$
DECLARE


  tam_lista_w               bigint;
  ie_pos_virgula_w          smallint;
  nr_seq_interno_w          varchar(400);
  nr_seq_interno_ww         varchar(400);
  ie_contador_w             bigint := 0;
  cd_medico_resp_w          varchar(10);
  nr_prescricao_w           bigint;
  ds_titulo_laudo_w         varchar(1200);
  nr_seq_proc_w             bigint;
  nr_laudo_w                bigint;
  ds_laudo_w                varchar(255);
  nr_seq_prescr_w           integer;
  nr_seq_laudo_w            bigint;
  nr_sequencia_prescricao_w bigint;
  nm_usuario_w              varchar(255);
  nr_atendimento_w          bigint;


BEGIN

  nm_usuario_w := nm_usuario_p;
  nr_atendimento_w := nr_atendimento_p;
  nr_seq_interno_w := nr_seq_interno_p;

  SELECT coalesce(MAX(Obter_Valor_Param_Usuario(994, 18, Obter_Perfil_Ativo, nm_usuario_w, 0)), ' ')
  INTO STRICT ds_laudo_w
;

  WHILE (nr_seq_interno_w IS NOT NULL AND nr_seq_interno_w::text <> '') OR not null OR ie_contador_w > 200 LOOP
  BEGIN
    tam_lista_w      := LENGTH(nr_seq_interno_w);
    ie_pos_virgula_w := position(',' in nr_seq_interno_w);

    IF (ie_pos_virgula_w <> 0) THEN
      nr_seq_interno_ww := SUBSTR(nr_seq_interno_w, 1, (ie_pos_virgula_w - 1));
      nr_seq_interno_w  := SUBSTR(nr_seq_interno_w, (ie_pos_virgula_w + 1), tam_lista_w);
    END IF;

    SELECT coalesce(MAX(nr_laudo), 0) + 1
    INTO STRICT nr_laudo_w
    FROM laudo_paciente
    WHERE nr_atendimento = nr_atendimento_w;

    SELECT SUBSTR(obter_desc_prescr_proc(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno), 1, 1200), 
		   MAX(a.nr_sequencia) nr_sequencia,
           a.nr_prescricao,
           c.cd_medico,
           b.nr_sequencia,
           a.nr_sequencia_prescricao
    INTO STRICT ds_titulo_laudo_w,
         nr_seq_proc_w,
         nr_prescricao_w,
         cd_medico_resp_w,
         nr_seq_prescr_w,
         nr_sequencia_prescricao_w
    FROM procedimento_paciente a,
         prescr_procedimento   b,
         prescr_medica         c
    WHERE a.nr_prescricao = b.nr_prescricao
    AND c.nr_prescricao = b.nr_prescricao
    AND b.cd_procedimento = a.cd_procedimento
    AND b.ie_origem_proced = a.ie_origem_proced
    AND a.nr_atendimento = nr_atendimento_w
    AND b.nr_seq_interno = nr_seq_interno_ww
    AND b.nr_sequencia = a.nr_sequencia_prescricao
    GROUP BY substr(obter_desc_prescr_proc(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno), 1, 1200),
             a.nr_sequencia, 
             a.nr_prescricao, 
             c.cd_medico, 
             b.nr_sequencia, 
             a.nr_sequencia_prescricao;

    SELECT nextval('laudo_paciente_seq') INTO STRICT nr_seq_laudo_w;

    INSERT INTO laudo_paciente(nr_sequencia,
                                nr_prescricao,
                                nr_seq_prescricao,
                                nr_seq_proc,
                                nm_usuario_digitacao,
                                nr_atendimento,
                                nr_laudo,
                                nm_usuario,
                                dt_atualizacao,
                                cd_medico_resp,
                                qt_imagem,
                                ds_titulo_laudo,
                                ds_laudo,
                                dt_laudo,
                                dt_entrada_unidade)
    VALUES (nr_seq_laudo_w,
           nr_prescricao_w,
           nr_seq_prescr_w,
           nr_seq_proc_w,
           nm_usuario_w,
           nr_atendimento_w,
           nr_laudo_w,
           nm_usuario_w,
           clock_timestamp(),
           cd_medico_resp_w,
           0,
           ds_titulo_laudo_w,
           ds_laudo_w,
           clock_timestamp(),
           clock_timestamp());

     ie_contador_w := ie_contador_w + 1;

     CALL Vincular_Procedimento_Laudo(nr_seq_laudo_w, 'N', nm_usuario_w);
  END;
  END LOOP;

  COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_laudo_atendimento (nr_atendimento_p bigint, nr_seq_interno_p text, nm_usuario_p text) FROM PUBLIC;

