-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


  ----------------------------------------------------------------------
  /*
  Rotina de apoio define_preco_procedimento_vet
  */
CREATE OR REPLACE FUNCTION smart_schedule_data_process.obter_se_conv_lib_agenda_emp (cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp) RETURNS varchar AS $body$
DECLARE


    ie_liberado_w        varchar(01) := 'S';
    ie_parametro         parametro_agenda.ie_ativa_categ_plano%TYPE;
    current_setting('smart_schedule_data_process.qt_regra_w')::smallint           bigint;
    dt_atendimento_w     timestamp;
    cd_estabelecimento_w bigint := wheb_usuario_pck.get_cd_estabelecimento;
    current_setting('smart_schedule_data_process.dt_agenda_w')::timestamp          bigint;


BEGIN
    /*
    funcao adaptada para verificar Estabelecimento passado como parametro.
    origem :agi_obter_plano_lib_cat_multie / obter_plano_lib_categ_agi

    */
    --dbms_output.put_line('---- OBTER_SE_CONV_LIB_AGENDA_EMP ---');
    PERFORM set_config('smart_schedule_data_process.dt_agenda_w', (to_char(dt_atendimento_p, 'J'))::numeric , false);
    IF current_setting('smart_schedule_data_process.conv_lib_agenda_emp_w')::conv_lib_agenda_emp_data.exists(cd_estabelecimento_p) AND
       current_setting('smart_schedule_data_process.conv_lib_agenda_emp_w')::conv_lib_agenda_emp_data[cd_estabelecimento_p].exists (current_setting('smart_schedule_data_process.dt_agenda_w')::timestamp) THEN
      ie_liberado_w := current_setting('smart_schedule_data_process.conv_lib_agenda_emp_w')::conv_lib_agenda_emp_data(cd_estabelecimento_p)(current_setting('smart_schedule_data_process.dt_agenda_w')::timestamp).ds_resultado;
      --dbms_output.put_line(' Estab.: ' || cd_estabelecimento_p || ' Data :' ||
      --                     to_char(dt_atendimento_p, 'dd/mm/yyyy'));
    ELSE
      SELECT coalesce(MAX(pa.ie_ativa_categ_plano), 'N') INTO STRICT ie_parametro FROM parametro_agenda pa WHERE pa.cd_estabelecimento = cd_estabelecimento_w;

      IF ie_parametro = 'S' THEN
        --dbms_output.put_line('*** Aqui **');
        SELECT COUNT(*)
          INTO STRICT current_setting('smart_schedule_data_process.qt_regra_w')::smallint
          FROM categoria_plano
         WHERE cd_convenio = cd_convenio_p
           AND cd_categoria = coalesce(cd_categoria_p, cd_categoria)
           AND ie_situacao = 'A';

        dt_atendimento_w := trunc(dt_atendimento_p);

        IF (current_setting('smart_schedule_data_process.qt_regra_w')::smallint > 0) THEN
          SELECT coalesce(MAX('S'), 'N')
            INTO STRICT ie_liberado_w
            FROM categoria_plano
           WHERE cd_convenio = cd_convenio_p
             AND cd_categoria = coalesce(cd_categoria_p, cd_categoria)
             AND cd_plano = coalesce(cd_plano_p, cd_plano)
             AND coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
             AND ie_situacao = 'A'
             AND dt_atendimento_w BETWEEN coalesce(dt_inicio_vigencia, dt_atendimento_w) - 1 AND fim_dia(coalesce(dt_final_vigencia, dt_atendimento_w));

        END IF;
      END IF;
      current_setting('smart_schedule_data_process.conv_lib_agenda_emp_w')::conv_lib_agenda_emp_data(cd_estabelecimento_p)(current_setting('smart_schedule_data_process.dt_agenda_w')::timestamp).ds_resultado := ie_liberado_w;
      --dbms_output.put_line(' Convenio: ' || cd_convenio_p || ' Cat.: ' || cd_categoria_p || ' Plano: ' || cd_plano_p ||
      --             ' Estab.: ' || cd_estabelecimento_p || ' Data :' ||
      --             to_char(dt_atendimento_p, 'dd/mm/yyyy hh24:mi:ss'));
    END IF;

    --dbms_output.put_line('Res.: ' || ie_liberado_w);
    --dbms_output.put_line('-------------------------------------------------------');
    RETURN ie_liberado_w;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION smart_schedule_data_process.obter_se_conv_lib_agenda_emp (cd_convenio_p bigint, cd_categoria_p text, cd_plano_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp) FROM PUBLIC;