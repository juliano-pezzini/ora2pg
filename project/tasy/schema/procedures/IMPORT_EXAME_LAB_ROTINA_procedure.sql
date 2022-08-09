-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_exame_lab_rotina (nm_usuario_p exame_laboratorio.nm_usuario%type) AS $body$
DECLARE

  nr_seq_grupo_w               grupo_exame_lab.nr_sequencia%TYPE;
  ds_grupo_w                   grupo_exame_lab.ds_grupo_exame_lab%TYPE;
  ds_grupo_lab_rotina_w        grupo_exame_lab_rotina.ds_grupo%TYPE;
	nm_usuario_w                 grupo_exame_lab.nm_usuario%TYPE;
	nm_usuario_nrec_w            grupo_exame_lab.nm_usuario_nrec%TYPE;
  nr_seq_grp_exam_lab_rotina_w grupo_exame_lab_rotina.nr_sequencia%TYPE;
  nr_seq_exame_w               exame_laboratorio.nr_seq_exame%TYPE;
  nm_exame_w                   exame_laboratorio.nm_exame%TYPE;
  cd_estabelecimento_w         exame_laboratorio.cd_estabelecimento%TYPE;
  nr_seq_exam_lab_rotina_w     exame_lab_rotina.nr_sequencia%TYPE;
  ds_observacao_w              exame_lab_rotina.ds_observacao%TYPE;
  nr_seq_grupo_lab_rotina_w    exame_lab_rotina.nr_seq_grupo%TYPE;
  nr_seq_exam_rotina_grupo_w   exame_rotina_grupo.nr_sequencia%TYPE;
  nr_seq_proc_interno_w        exame_laboratorio.nr_seq_proc_interno%TYPE;

C01 CURSOR FOR
SELECT a.nr_sequencia,
       a.ds_grupo_exame_lab,
       a.nm_usuario,
       a.nm_usuario_nrec
  FROM grupo_exame_lab a
 WHERE 1 = 1;

c02 CURSOR FOR
SELECT a.nr_seq_exame,
       a.nm_exame,
       a.nm_usuario,
       a.cd_estabelecimento,
       a.nr_seq_proc_interno
  FROM exame_laboratorio a
 WHERE a.nr_seq_grupo = nr_seq_grupo_w
   AND a.ie_situacao = 'A';


BEGIN

OPEN C01;
LOOP
FETCH C01 INTO
  nr_seq_grupo_w,
	ds_grupo_w,
	nm_usuario_w,
	nm_usuario_nrec_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

	BEGIN

  SELECT nextval('grupo_exame_lab_rotina_seq')
	  INTO STRICT nr_seq_grp_exam_lab_rotina_w
	;

  --Remover após validação
  ds_grupo_lab_rotina_w := ds_grupo_w || '-1666023';

  BEGIN

  INSERT INTO GRUPO_EXAME_LAB_ROTINA(
    nr_sequencia,
    cd_estabelecimento,
    dt_atualizacao,
    nm_usuario,
    dt_atualizacao_nrec,
    nm_usuario_nrec,
    ds_grupo,
    ie_situacao,
    nr_seq_apresentacao,
    ds_cor
  ) VALUES (
    nr_seq_grp_exam_lab_rotina_w,
    cd_estabelecimento_w,
    clock_timestamp(),
    nm_usuario_w,
    clock_timestamp(),
    nm_usuario_nrec_w,
    ds_grupo_lab_rotina_w,
    'A',
    999,
    NULL
  );

  COMMIT;

  EXCEPTION WHEN OTHERS THEN
		CALL gravar_log_tasy(10077, ' Criando grupo exame lab rotina: '||nr_seq_grupo_lab_rotina_w|| ' erro baca_import_exame_lab_rotina:'|| to_char(sqlerrm) ,nm_usuario_p);
	END;

  OPEN C02;
  LOOP
  FETCH C02 INTO
	  nr_seq_exame_w,
    nm_exame_w,
    nm_usuario_w,
    cd_estabelecimento_w,
    nr_seq_proc_interno_w;
	  EXIT WHEN NOT FOUND; /* apply on C02 */
	  BEGIN

    SELECT nextval('exame_lab_rotina_seq')
	    INTO STRICT nr_seq_exam_lab_rotina_w
	;

    --Remover após validação
    ds_observacao_w := 'OS-1666023';

    BEGIN

    INSERT INTO EXAME_LAB_ROTINA(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        nr_seq_exame,
        ds_prescricao,
        nr_seq_material,
        ie_rotina_uti,
        cd_especialidade,
        nr_seq_apres,
        ds_cor,
        ie_tipo_atendimento,
        ds_mat_esp,
        cd_classif_setor_pac,
        cd_intervalo,
        nr_seq_rotina,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        cd_setor_atendimento,
        cd_estabelecimento,
        ie_lado,
        cd_perfil,
        ie_clinica,
        cd_setor_prescr,
        ie_frase,
        ie_agora,
        ie_horario_prescr,
        ie_exame_externo,
        qt_hora_intervalo,
        qt_min_intervalo,
        ie_exige_indicacao,
        nr_seq_grupo,
        cd_convenio,
        ie_amostra,
        ie_orientacao,
        ie_observacao,
        ie_intervalo,
        ie_exige_justificativa,
        cd_perfil_excl,
        nr_seq_exame_interno,
        ie_questiona_agora,
        ds_observacao,
        ie_medico_exec,
        ie_questionar_forma,
        nr_seq_subgrupo,
        ie_outro_exame,
        cd_medico_exec,
        ie_situacao,
        ds_resumo_clinico,
        ie_apresenta_marcado,
        ie_acm,
        ie_se_necessario,
        ie_duracao
      ) VALUES (
        nr_seq_exam_lab_rotina_w,
        clock_timestamp(),
        nm_usuario_w,
        nr_seq_exame_w,
        nm_exame_w,
        NULL,
        'N',
        NULL,
        500,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        clock_timestamp(),
        nm_usuario_nrec_w,
        NULL,
        cd_estabelecimento_w,
        'N',
        NULL,
        NULL,
        NULL,
        'N',
        'N',
        NULL,
        NULL,
        NULL,
        NULL,
        'N',
        NULL,
        NULL,
        'N',
        'N',
        'N',
        'N',
        'N',
        NULL,
        nr_seq_proc_interno_w,
        'N',
        ds_observacao_w,
        'N',
        'N',
        NULL,
        'N',
        NULL,
        'A',
        NULL,
        NULL,
        'N',
        'N',
        NULL
      );
      COMMIT;

      EXCEPTION WHEN OTHERS THEN
		    CALL gravar_log_tasy(10077, ' Criando exame lab rotina: '||nr_seq_exam_lab_rotina_w|| ' erro baca_import_exame_lab_rotina:'|| to_char(sqlerrm) ,nm_usuario_p);
	    END;

      SELECT nextval('exame_rotina_grupo_seq')
	    INTO STRICT nr_seq_exam_rotina_grupo_w
	;

      BEGIN

      INSERT INTO EXAME_ROTINA_GRUPO(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_rotina,
        nr_seq_grupo
       ) VALUES (
        nr_seq_exam_rotina_grupo_w,
        clock_timestamp(),
        nm_usuario_w,
        clock_timestamp(),
        nm_usuario_w,
        nr_seq_exam_lab_rotina_w,
        nr_seq_grp_exam_lab_rotina_w
       );

      COMMIT;

      EXCEPTION WHEN OTHERS THEN
		    CALL gravar_log_tasy(10077, ' Criando exame rotina grupo: '||nr_seq_exam_rotina_grupo_w|| ' erro baca_import_exame_lab_rotina:'|| to_char(sqlerrm) ,nm_usuario_p);
	    END;
    END;
  END LOOP;
  CLOSE C02;

  END;
END LOOP;
CLOSE C01;

CALL cpoe_importar_lab_exam_proc(nm_usuario_p);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_exame_lab_rotina (nm_usuario_p exame_laboratorio.nm_usuario%type) FROM PUBLIC;
