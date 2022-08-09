-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_cadastro_agenda_cons (cd_agenda_destino_p bigint, cd_agenda_copia_p bigint, ie_turno_p text, ie_bloqueio_p text, ie_regra_p text, ie_permissao_p text, nm_usuario_p text, cd_categoria_p text, ds_erro_p INOUT text, ie_classificacao_p text default 'N') AS $body$
DECLARE


/* globais */

qt_cadastro_w			bigint;
ie_turno_w			varchar(1) := 'S';
ie_turno_esp_w			varchar(1) := 'S';
ie_regra_w			varchar(1) := 'S';
ie_bloqueio_w			varchar(1) := 'S';
ie_permissao_w      varchar(1) := 'S';
ie_classificacao_w    varchar(1) := 'S';
ds_cadastro_w      varchar(255);
ds_erro_w      varchar(255);
cd_medico_agenda_w    varchar(10);

/* turnos */

nr_sequencia_w      bigint;
nr_seq_turno_w      bigint;
ie_dia_semana_w      smallint;
hr_inicial_w      timestamp;
hr_final_w      timestamp;
nr_minuto_intervalo_w    bigint;
dt_inicio_vigencia_w    timestamp;
dt_final_vigencia_w    timestamp;
ie_classif_agenda_w    varchar(5);
nr_seq_sala_w      bigint;
cd_convenio_padrao_w    integer;
ds_observacao_w      varchar(255);
qt_idade_min_w      bigint;
qt_idade_max_w      bigint;
ie_encaixe_w      varchar(1);
ie_frequencia_w      varchar(15);

/* regras convenio x turno */

nr_seq_turno_conv_w    bigint;
cd_convenio_w      bigint;
qt_permissao_w      bigint;
pr_permissao_w      bigint;
ie_atende_convenio_w    varchar(1);
hr_inicial_conv_w    timestamp;
ie_dia_semana_conv_w    smallint;
cd_categoria_w      varchar(10);
qt_perm_encaixe_w agenda_turno_conv.qt_perm_encaixe%type;
ie_valida_zerada_w agenda_turno_conv.ie_valida_zerada%type;

/* turnos especiais */

nr_seq_turno_esp_orig_w    bigint;
nr_seq_turno_esp_w    bigint;
dt_agenda_w      timestamp;
ie_horario_adicional_w    varchar(1);
ie_classif_agenda_esp_w    varchar(5);
hr_inicial_esp_w    timestamp;
hr_final_esp_w      timestamp;
nr_minuto_interv_esp_w    bigint;

/* regras convenio x turno especiais*/

nr_seq_turno_esp_conv_w    bigint;

/* bloqueios */

nr_seq_bloqueio_w    bigint;
dt_inicial_w      timestamp;
dt_final_w      timestamp;
hr_inicio_bloqueio_w    timestamp;
hr_final_bloqueio_w    timestamp;
ie_dia_semana_bloq_w    integer;
ie_motivo_bloqueio_w    varchar(15);
ie_classif_bloqueio_w    varchar(5);
ds_observacao_bloq_w    varchar(255);

/* permissoes */

nr_seq_permissao_w    bigint;
cd_pessoa_fisica_w    varchar(10);
cd_perfil_w      integer;
cd_setor_atendimento_w    integer;
ie_paciente_w      varchar(1);
ie_atendimento_w    varchar(1);
ie_evolucao_w      varchar(1);
ie_protocolo_w      varchar(1);
ie_receita_w      varchar(1);
ie_solic_exame_w    varchar(1);
ie_agenda_w      varchar(1);
ie_resultado_w      varchar(1);
ie_consulta_w      varchar(1);
ie_fechar_atend_w    varchar(1);
ie_med_padrao_w      varchar(1);
ie_exame_padrao_w    varchar(1);
ie_permissao_med_w    varchar(1);
ie_config_relat_w    varchar(1);
ie_grupo_medico_w    varchar(1);
ie_diagnostico_w    varchar(1);
ie_texto_adicional_w    varchar(1);
ie_referencia_w      varchar(1);
ie_eis_w      varchar(1);
ie_enderecos_w      varchar(1);
ie_texto_padrao_w    varchar(1);
ie_parametro_w      varchar(1);
ie_config_agenda_w    varchar(1);
ie_permite_excluir_agenda_w  varchar(1);
ie_permite_bloquear_agenda_w    varchar(1);
ie_valor_normal_w    varchar(1);
ie_sit_class_per_w      regra_classif_agenda.ie_situacao%Type;
ie_classif_agenda_per_w    regra_classif_agenda.ie_classif_agenda%Type;

VarMOdeloAgenda      bigint  := 3;
cd_estab_agenda_w    smallint;
ie_tipo_convenio_w    bigint;

/* obter turnos */

c01 CURSOR FOR
SELECT  nr_sequencia,
  ie_dia_semana,
  hr_inicial,
  hr_final,
  nr_minuto_intervalo,
  dt_inicio_vigencia,
  dt_final_vigencia,
  ie_classif_agenda,
  nr_seq_sala,
  cd_convenio_padrao,
  ds_observacao,
  qt_idade_min,
  qt_idade_max,
  ie_encaixe,
  ie_frequencia
FROM  agenda_turno
WHERE  cd_agenda = cd_agenda_copia_p
ORDER BY
  ie_dia_semana;

/* obter regras convenio x turno */

c02 CURSOR FOR
SELECT  cd_convenio,
  qt_permissao,
  pr_permissao,
  ie_atende_convenio,
  hr_inicial,
  ie_dia_semana,
  cd_categoria,
  ie_tipo_convenio,
  qt_perm_encaixe,
  ie_valida_zerada
FROM  agenda_turno_conv
WHERE  nr_seq_turno = nr_seq_turno_w;


/* obter turnos especiais */

c03 CURSOR FOR
SELECT  dt_agenda,
  ie_horario_adicional,
  ie_classif_agenda,
  hr_inicial,
  hr_final,
  nr_minuto_intervalo,
  nr_sequencia
FROM  agenda_turno_esp
WHERE  cd_agenda = cd_agenda_copia_p
ORDER BY
  dt_agenda;


/* obter regras convenio x turno especiais*/

c06 CURSOR FOR
SELECT  cd_convenio,
  qt_permissao,
  pr_permissao,
  ie_atende_convenio,
  hr_inicial,
  cd_categoria,
  ie_tipo_convenio,
  qt_perm_encaixe,
  ie_valida_zerada
FROM  agenda_turno_esp_conv
WHERE  nr_seq_turno_esp = nr_seq_turno_esp_orig_w;


/* obter bloqueios */

c04 CURSOR FOR
SELECT  dt_inicial,
  dt_final,
  hr_inicio_bloqueio,
  hr_final_bloqueio,
  ie_dia_semana,
  ie_motivo_bloqueio,
  ie_classif_bloqueio,
  ds_observacao
FROM  agenda_bloqueio
WHERE  cd_agenda = cd_agenda_copia_p
ORDER BY
  dt_inicial,
  dt_final;

/* permissoes */

c05 CURSOR FOR
SELECT  cd_pessoa_fisica,
  cd_perfil,
  cd_setor_atendimento,
  ie_paciente,
  ie_atendimento,
  ie_evolucao,
  ie_protocolo,
  ie_receita,
  ie_solic_exame,
  ie_agenda,
  ie_resultado,
  ie_consulta,
  ie_fechar_atend,
  ie_med_padrao,
  ie_exame_padrao,
  ie_permissao,
  ie_config_relat,
  ie_grupo_medico,
  ie_diagnostico,
  ie_texto_adicional,
  ie_referencia,
  ie_eis,
  ie_enderecos,
  ie_texto_padrao,
  ie_parametro,
  ie_config_agenda,
  ie_permite_excluir_agenda,
  ie_permite_bloquear_agenda,
  ie_valor_normal
FROM  med_permissao
WHERE  cd_agenda = cd_agenda_copia_p;

/* Classificações Liberadas */

C07 CURSOR FOR
  SELECT  ie_situacao,
      ie_classif_agenda
  from  regra_classif_agenda
  where  cd_agenda = cd_agenda_copia_p;

BEGIN

IF (cd_agenda_destino_p IS NOT NULL AND cd_agenda_destino_p::text <> '') AND (cd_agenda_copia_p IS NOT NULL AND cd_agenda_copia_p::text <> '') AND
  ((ie_turno_p = 'S') OR (ie_bloqueio_p = 'S') OR (ie_regra_p = 'S') OR (ie_permissao_p = 'S') or (ie_classificacao_p = 'S')) THEN
  /* gerar turnos */

  IF (ie_turno_p = 'S') THEN
    /* validar turnos */

    SELECT  coalesce(COUNT(*),0)
    INTO STRICT  qt_cadastro_w
    FROM  agenda_turno
    WHERE  cd_agenda = cd_agenda_destino_p;

    /* turnos normais */

    IF (qt_cadastro_w = 0) THEN
      OPEN c01;
      LOOP
      FETCH c01 INTO  nr_seq_turno_w,
          ie_dia_semana_w,
          hr_inicial_w,
          hr_final_w,
          nr_minuto_intervalo_w,
          dt_inicio_vigencia_w,
          dt_final_vigencia_w,
          ie_classif_agenda_w,
          nr_seq_sala_w,
          cd_convenio_padrao_w,
          ds_observacao_w,
          qt_idade_min_w,
          qt_idade_max_w,
          ie_encaixe_w,
          ie_frequencia_w;
      EXIT WHEN NOT FOUND; /* apply on c01 */
        BEGIN
        SELECT  nextval('agenda_turno_seq')
        INTO STRICT  nr_sequencia_w
;

        INSERT INTO agenda_turno(
            cd_agenda,
            ie_dia_semana,
            hr_inicial,
            hr_final,
            nr_minuto_intervalo,
            dt_inicio_vigencia,
            dt_final_vigencia,
            ie_classif_agenda,
            nr_seq_sala,
            cd_convenio_padrao,
            ds_observacao,
            qt_idade_min,
            qt_idade_max,
            ie_encaixe,
            nm_usuario,
            dt_atualizacao,
            nr_sequencia,
            ie_frequencia
            )
        VALUES (
            cd_agenda_destino_p,
            ie_dia_semana_w,
            hr_inicial_w,
            hr_final_w,
            nr_minuto_intervalo_w,
            dt_inicio_vigencia_w,
            dt_final_vigencia_w,
            ie_classif_agenda_w,
            nr_seq_sala_w,
            cd_convenio_padrao_w,
            ds_observacao_w,
            qt_idade_min_w,
            qt_idade_max_w,
            ie_encaixe_w,
            nm_usuario_p,
            clock_timestamp(),
            nr_sequencia_w,
            ie_frequencia_w
            );
        /* verifica se tem regra convenio x turno */

        IF (ie_regra_p  = 'S') THEN
          SELECT  coalesce(COUNT(*),0)
          INTO STRICT  qt_cadastro_w
          FROM  agenda_turno_conv
          WHERE  nr_seq_turno = nr_seq_turno_w
          AND  cd_agenda = cd_agenda_destino_p;

          IF (qt_cadastro_w = 0 ) THEN
            /* regras convenios x turno */

            OPEN c02;
            LOOP
            FETCH c02 INTO  cd_convenio_w,
                qt_permissao_w,
                pr_permissao_w,
                ie_atende_convenio_w,
                hr_inicial_conv_w,
                ie_dia_semana_conv_w,
                cd_categoria_w,
                ie_tipo_convenio_w,
                qt_perm_encaixe_w,
                ie_valida_zerada_w;
            EXIT WHEN NOT FOUND; /* apply on c02 */
              BEGIN
              SELECT  nextval('agenda_turno_conv_seq')
              INTO STRICT  nr_seq_turno_conv_w
;

              INSERT INTO agenda_turno_conv(
                  nr_sequencia,
                  cd_agenda,
                  hr_inicial,
                  cd_convenio,
                  dt_atualizacao,
                  nm_usuario,
                  qt_permissao,
                  pr_permissao,
                  ie_atende_convenio,
                  ie_dia_semana,
                  nr_seq_turno,
                  cd_categoria,
                  ie_tipo_convenio,
                  qt_perm_encaixe,
                  ie_valida_zerada
                  )
              VALUES (
                  nr_seq_turno_conv_w,
                  cd_agenda_destino_p,
                  hr_inicial_conv_w,
                  cd_convenio_w,
                  clock_timestamp(),
                  nm_usuario_p,
                  qt_permissao_w,
                  pr_permissao_w,
                  ie_atende_convenio_w,
                  ie_dia_semana_conv_w,
                  nr_sequencia_w,
                  cd_categoria_w,
                  ie_tipo_convenio_w,
                  qt_perm_encaixe_w,
                  ie_valida_zerada_w
                  );
              END;
            END LOOP;
            CLOSE c02;
          ELSE
            ie_regra_w:= 'N';
          END IF;
        END IF;
        END;
      END LOOP;
      CLOSE c01;
    ELSE
      ie_turno_w := 'N';
    END IF;

    /* validar turnos especiais */

    SELECT  coalesce(COUNT(*),0)
    INTO STRICT  qt_cadastro_w
    FROM  agenda_turno_esp
    WHERE  cd_agenda = cd_agenda_destino_p;

    /* turnos especiais */

    IF (qt_cadastro_w = 0) THEN
      OPEN c03;
      LOOP
      FETCH c03 INTO  dt_agenda_w,
          ie_horario_adicional_w,
          ie_classif_agenda_esp_w,
          hr_inicial_esp_w,
          hr_final_esp_w,
          nr_minuto_interv_esp_w,
          nr_seq_turno_esp_orig_w;
      EXIT WHEN NOT FOUND; /* apply on c03 */
        BEGIN
        SELECT  nextval('agenda_turno_esp_seq')
        INTO STRICT  nr_seq_turno_esp_w
;

        INSERT INTO agenda_turno_esp(
            nr_sequencia,
            cd_agenda,
            dt_agenda,
            dt_atualizacao,
            nm_usuario,
            hr_inicial,
            hr_final,
            nr_minuto_intervalo,
            ie_classif_agenda,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            ie_horario_adicional
            )
        VALUES (
            nr_seq_turno_esp_w,
            cd_agenda_destino_p,
            dt_agenda_w,
            clock_timestamp(),
            nm_usuario_p,
            hr_inicial_esp_w,
            hr_final_esp_w,
            nr_minuto_interv_esp_w,
            ie_classif_agenda_esp_w,
            clock_timestamp(),
            nm_usuario_p,
            ie_horario_adicional_w
            );


        /* verifica se tem regra convenio x turno especial*/

        IF (ie_regra_p  = 'S') THEN

          SELECT  coalesce(COUNT(*),0)
          INTO STRICT  qt_cadastro_w
          FROM  agenda_turno_esp_conv
          WHERE  nr_seq_turno_esp = nr_seq_turno_esp_w
          AND  cd_agenda    = cd_agenda_destino_p;

          IF (qt_cadastro_w = 0 ) THEN
            /* regras convenios x turno especial*/

            FOR c06_w IN c06 LOOP
              SELECT  nextval('agenda_turno_esp_conv_seq')
              INTO STRICT  nr_seq_turno_esp_conv_w
;

              INSERT INTO agenda_turno_esp_conv(
                  nr_sequencia,
                  cd_agenda,
                  hr_inicial,
                  cd_convenio,
                  dt_atualizacao,
                  nm_usuario,
                  qt_permissao,
                  pr_permissao,
                  ie_atende_convenio,
                  nr_seq_turno_esp,
                  cd_categoria,
                  ie_tipo_convenio,
                  qt_perm_encaixe,
                  ie_valida_zerada
                  )
              VALUES (
                  nr_seq_turno_esp_conv_w,
                  cd_agenda_destino_p,
                  c06_w.hr_inicial,
                  c06_w.cd_convenio,
                  clock_timestamp(),
                  nm_usuario_p,
                  c06_w.qt_permissao,
                  c06_w.pr_permissao,
                  c06_w.ie_atende_convenio,
		  nr_seq_turno_esp_w,
		  c06_w.cd_categoria,
		  c06_w.ie_tipo_convenio,
		  c06_w.qt_perm_encaixe,
		  c06_w.ie_valida_zerada
                  );
            END LOOP;
          ELSE
            ie_regra_w:= 'N';
          END IF;
        END IF;


        END;
      END LOOP;
      CLOSE c03;
    ELSE
      ie_turno_esp_w := 'N';
    END IF;
  END IF;

  /* gerar bloqueios */

  IF (ie_bloqueio_p = 'S') THEN
    /* validar bloqueios */

    SELECT  coalesce(COUNT(*),0)
    INTO STRICT  qt_cadastro_w
    FROM  agenda_bloqueio
    WHERE  cd_agenda = cd_agenda_destino_p;

    IF (qt_cadastro_w = 0) THEN
      OPEN c04;
      LOOP
      FETCH c04 INTO  dt_inicial_w,
          dt_final_w,
          hr_inicio_bloqueio_w,
          hr_final_bloqueio_w,
          ie_dia_semana_bloq_w,
          ie_motivo_bloqueio_w,
          ie_classif_bloqueio_w,
          ds_observacao_bloq_w;
      EXIT WHEN NOT FOUND; /* apply on c04 */
        BEGIN
        SELECT  nextval('agenda_bloqueio_seq')
        INTO STRICT  nr_seq_bloqueio_w
;

        INSERT INTO agenda_bloqueio(
            cd_agenda,
            dt_inicial,
            dt_final,
            ie_motivo_bloqueio,
            dt_atualizacao,
            nm_usuario,
            ds_observacao,
            ie_dia_semana,
            hr_inicio_bloqueio,
            hr_final_bloqueio,
            nr_sequencia,
            ie_classif_bloqueio
            )
        VALUES (
            cd_agenda_destino_p,
            dt_inicial_w,
            dt_final_w,
            ie_motivo_bloqueio_w,
            clock_timestamp(),
            nm_usuario_p,
            ds_observacao_bloq_w,
            ie_dia_semana_bloq_w,
            hr_inicio_bloqueio_w,
            hr_final_bloqueio_w,
            nr_seq_bloqueio_w,
            ie_classif_bloqueio_w
            );
        END;
      END LOOP;
      CLOSE c04;
    ELSE
      ie_bloqueio_w := 'N';
    END IF;
  END IF;

  /* gerar permissões */

  IF (ie_permissao_p = 'S') THEN
    /* verifica permissões */

    SELECT  coalesce(COUNT(*),0)
    INTO STRICT  qt_cadastro_w
    FROM  med_permissao
    WHERE  cd_agenda = cd_agenda_destino_p;

    SELECT  MAX(cd_pessoa_fisica),
      MAX(cd_estabelecimento)
    INTO STRICT  cd_medico_agenda_w,
      cd_estab_agenda_w
    FROM  agenda
    WHERE  cd_agenda = cd_agenda_destino_p;

    VarMOdeloAgenda := Obter_Param_Usuario(821, 26, obter_perfil_ativo, nm_usuario_p, cd_estab_agenda_w, VarMOdeloAgenda);

    /* permissões */

    IF (qt_cadastro_w = 0) THEN
      OPEN c05;
      LOOP
      FETCH c05 INTO  cd_pessoa_fisica_w,
          cd_perfil_w,
          cd_setor_atendimento_w,
          ie_paciente_w,
          ie_atendimento_w,
          ie_evolucao_w,
          ie_protocolo_w,
          ie_receita_w,
          ie_solic_exame_w,
          ie_agenda_w,
          ie_resultado_w,
          ie_consulta_w,
          ie_fechar_atend_w,
          ie_med_padrao_w,
          ie_exame_padrao_w,
          ie_permissao_med_w,
          ie_config_relat_w,
          ie_grupo_medico_w,
          ie_diagnostico_w,
          ie_texto_adicional_w,
          ie_referencia_w,
          ie_eis_w,
          ie_enderecos_w,
          ie_texto_padrao_w,
          ie_parametro_w,
          ie_config_agenda_w,
          ie_permite_excluir_agenda_w,
          ie_permite_bloquear_agenda_w,
          ie_valor_normal_w;
      EXIT WHEN NOT FOUND; /* apply on c05 */
        BEGIN
        SELECT  nextval('med_permissao_seq')
        INTO STRICT  nr_seq_permissao_w
;

        IF (VarMOdeloAgenda = 3) THEN

          INSERT INTO med_permissao(
              nr_sequencia,
              dt_atualizacao,
              nm_usuario,
              ie_paciente,
              ie_atendimento,
              ie_evolucao,
              ie_protocolo,
              ie_receita,
              ie_solic_exame,
              ie_agenda,
              ie_resultado,
              ie_consulta,
              ie_fechar_atend,
              ie_med_padrao,
              ie_exame_padrao,
              ie_permissao,
              ie_config_relat,
              ie_grupo_medico,
              ie_diagnostico,
              ie_texto_adicional,
              ie_referencia,
              ie_eis,
              ie_enderecos,
              ie_texto_padrao,
              ie_parametro,
              ie_config_agenda,
              ie_permite_excluir_agenda,
              ie_permite_bloquear_agenda,
              cd_pessoa_fisica,
              cd_perfil,
              cd_setor_atendimento,
              cd_agenda,
              cd_medico_prop,
              ie_valor_normal)
          VALUES (
              nr_seq_permissao_w,
              clock_timestamp(),
              nm_usuario_p,
              ie_paciente_w,
              ie_atendimento_w,
              ie_evolucao_w,
              ie_protocolo_w,
              ie_receita_w,
              ie_solic_exame_w,
              ie_agenda_w,
              ie_resultado_w,
              ie_consulta_w,
              ie_fechar_atend_w,
              ie_med_padrao_w,
              ie_exame_padrao_w,
              ie_permissao_med_w,
              ie_config_relat_w,
              ie_grupo_medico_w,
              ie_diagnostico_w,
              ie_texto_adicional_w,
              ie_referencia_w,
              ie_eis_w,
              ie_enderecos_w,
              ie_texto_padrao_w,
              ie_parametro_w,
              ie_config_agenda_w,
              ie_permite_excluir_agenda_w,
              ie_permite_bloquear_agenda_w,
              cd_pessoa_fisica_w,
              cd_perfil_w,
              cd_setor_atendimento_w,
              cd_agenda_destino_p,
              cd_medico_agenda_w,
              ie_valor_normal_w);
        ELSE
          INSERT INTO med_permissao(
              nr_sequencia,
              dt_atualizacao,
              nm_usuario,
              ie_paciente,
              ie_atendimento,
              ie_evolucao,
              ie_protocolo,
              ie_receita,
              ie_solic_exame,
              ie_agenda,
              ie_resultado,
              ie_consulta,
              ie_fechar_atend,
              ie_med_padrao,
              ie_exame_padrao,
              ie_permissao,
              ie_config_relat,
              ie_grupo_medico,
              ie_diagnostico,
              ie_texto_adicional,
              ie_referencia,
              ie_eis,
              ie_enderecos,
              ie_texto_padrao,
              ie_parametro,
              ie_config_agenda,
              ie_permite_excluir_agenda,
              ie_permite_bloquear_agenda,
              cd_pessoa_fisica,
              cd_perfil,
              cd_setor_atendimento,
              cd_agenda,
              ie_valor_normal)
          VALUES (
              nr_seq_permissao_w,
              clock_timestamp(),
              nm_usuario_p,
              ie_paciente_w,
              ie_atendimento_w,
              ie_evolucao_w,
              ie_protocolo_w,
              ie_receita_w,
              ie_solic_exame_w,
              ie_agenda_w,
              ie_resultado_w,
              ie_consulta_w,
              ie_fechar_atend_w,
              ie_med_padrao_w,
              ie_exame_padrao_w,
              ie_permissao_med_w,
              ie_config_relat_w,
              ie_grupo_medico_w,
              ie_diagnostico_w,
              ie_texto_adicional_w,
              ie_referencia_w,
              ie_eis_w,
              ie_enderecos_w,
              ie_texto_padrao_w,
              ie_parametro_w,
              ie_config_agenda_w,
              ie_permite_excluir_agenda_w,
              ie_permite_bloquear_agenda_w,
              cd_pessoa_fisica_w,
              cd_perfil_w,
              cd_setor_atendimento_w,
              cd_agenda_destino_p,
              ie_valor_normal_w);
        end if;

        END;
      END LOOP;
      CLOSE c05;
    ELSE
      ie_permissao_w := 'N';
    END IF;
  END IF;


  /* gerar Classificações */

  if (ie_classificacao_p = 'S') then
    /* verifica classificações */

    select  coalesce(count(*),0)
    into STRICT  qt_cadastro_w
    from  regra_classif_agenda
    where  cd_agenda = cd_agenda_destino_p;

    if (qt_cadastro_w = 0) then
      open C07;
      loop
      fetch C07 into
        ie_sit_class_per_w,
        ie_classif_agenda_per_w;
      EXIT WHEN NOT FOUND; /* apply on C07 */
        begin
        insert into regra_classif_agenda(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            ie_situacao,
            cd_agenda,
            ie_classif_agenda
          ) values (
            nextval('regra_classif_agenda_seq'),
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            ie_sit_class_per_w,
            cd_agenda_destino_p,
            ie_classif_agenda_per_w
          );
        end;
      end loop;
      close C07;

    else
      ie_classificacao_w := 'N';
    end if;
  end if;

ELSIF (ie_turno_p = 'N') AND (ie_bloqueio_p = 'N') AND (ie_regra_p = 'N') AND (ie_permissao_p = 'N') and (ie_classificacao_p = 'N') THEN
  ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(278563,null);
END IF;



IF (ie_turno_w = 'N') OR (ie_turno_esp_w = 'N') OR (ie_bloqueio_w = 'N') OR (ie_regra_w = 'N') OR (ie_permissao_w = 'N') or (ie_classificacao_w = 'N') THEN
  IF (ie_turno_w = 'N') THEN
    ds_cadastro_w := ds_cadastro_w || WHEB_MENSAGEM_PCK.get_texto(280429,null) || ', ';
  END IF;
  IF (ie_turno_esp_w = 'N') THEN
    ds_cadastro_w := ds_cadastro_w || WHEB_MENSAGEM_PCK.get_texto(280430,null) || ', ';
  END IF;
  IF (ie_bloqueio_w = 'N') THEN
    ds_cadastro_w := ds_cadastro_w || WHEB_MENSAGEM_PCK.get_texto(280431,null) || ', ';
  END IF;
  IF (ie_regra_w = 'N') THEN
    ds_cadastro_w := ds_cadastro_w || WHEB_MENSAGEM_PCK.get_texto(280433,null) || ', ';
  END IF;
  IF (ie_permissao_w = 'N') THEN
    ds_cadastro_w := ds_cadastro_w || WHEB_MENSAGEM_PCK.get_texto(280435,null) || ', ';
  END IF;
  if (ie_classificacao_w = 'N') then
    ds_cadastro_w := ds_cadastro_w || wheb_mensagem_pck.get_texto(496890,null) || ', ';
  end if;
  ds_erro_w := wheb_mensagem_pck.get_texto(278583,'DS_CADASTRO='|| ds_cadastro_w);
END IF;

ds_erro_p := ds_erro_w;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_cadastro_agenda_cons (cd_agenda_destino_p bigint, cd_agenda_copia_p bigint, ie_turno_p text, ie_bloqueio_p text, ie_regra_p text, ie_permissao_p text, nm_usuario_p text, cd_categoria_p text, ds_erro_p INOUT text, ie_classificacao_p text default 'N') FROM PUBLIC;
