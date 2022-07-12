-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ageint_sugerir_html5_pck.ageint_consiste_regra_conv_pck (cd_convenio_p bigint, cd_categoria_p text, cd_agenda_p bigint, cd_setor_atendimento_p bigint, cd_plano_convenio_p text, cd_pessoa_fisica_p text, nr_seq_grupo_selec_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


    nr_seq_regra_w      bigint;
    ie_agenda_w         varchar(1);
    ds_mensagem_w       varchar(255);
    cd_especialidade_w  integer;
    cd_medico_w         agenda.cd_pessoa_fisica%TYPE;
    cd_municipio_ibge_w varchar(6);


BEGIN
    ds_erro_p := 'N';
    IF (cd_convenio_p > 0) THEN

      SELECT MAX(cd_municipio_ibge)
        INTO STRICT cd_municipio_ibge_w
        FROM compl_pessoa_fisica
       WHERE cd_pessoa_fisica = cd_pessoa_fisica_p
         AND ie_tipo_complemento = 1;

      SELECT MAX(cd_especialidade),
             MAX(cd_pessoa_fisica)
        INTO STRICT cd_especialidade_w,
             cd_medico_w
        FROM agenda
       WHERE cd_agenda = cd_agenda_p;

      SELECT MAX(nr_sequencia)
        INTO STRICT nr_seq_regra_w
        FROM (SELECT coalesce(a.nr_sequencia, 0) nr_sequencia
                FROM regra_agecons_convenio a
LEFT OUTER JOIN regra_agecons_conv_grupo b ON (a.nr_sequencia = b.nr_seq_regra_agecons)
WHERE ((a.cd_convenio = cd_convenio_p) OR (coalesce(a.cd_convenio::text, '') = '')) AND ((a.cd_agenda = cd_agenda_p) OR (coalesce(a.cd_agenda::text, '') = '')) AND ((a.cd_categoria = cd_categoria_p) OR (coalesce(a.cd_categoria::text, '') = '')) AND ((a.cd_plano_convenio = cd_plano_convenio_p) OR (coalesce(a.cd_plano_convenio::text, '') = '')) AND ((a.cd_setor_atendimento = cd_setor_atendimento_p) OR (coalesce(a.cd_setor_atendimento::text, '') = '')) AND ((a.cd_medico = cd_medico_w) OR (coalesce(a.cd_medico::text, '') = '')) AND ((a.cd_especialidade = cd_especialidade_w) OR (coalesce(a.cd_especialidade::text, '') = '')) AND ((a.cd_pessoa_fisica = cd_pessoa_fisica_p) OR (coalesce(a.cd_pessoa_fisica::text, '') = '')) AND ((b.nr_seq_grupo = nr_seq_grupo_selec_p) OR (coalesce(b.nr_seq_grupo::text, '') = '')) AND coalesce(dt_inicial_vigencia::text, '') = '' AND coalesce(dt_final_vigencia::text, '') = '' AND ((a.cd_municipio_ibge = cd_municipio_ibge_w) OR (coalesce(a.cd_municipio_ibge::text, '') = '')) AND ie_permite = 'N' AND NOT EXISTS
                       (SELECT 1
                                FROM regra_agecons_convenio a
LEFT OUTER JOIN regra_agecons_conv_grupo b ON (a.nr_sequencia = b.nr_seq_regra_agecons)
WHERE ((a.cd_convenio = cd_convenio_p) OR (coalesce(a.cd_convenio::text, '') = '')) AND ((a.cd_agenda = cd_agenda_p) OR (coalesce(a.cd_agenda::text, '') = '')) AND ((a.cd_categoria = cd_categoria_p) OR (coalesce(a.cd_categoria::text, '') = '')) AND ((a.cd_plano_convenio = cd_plano_convenio_p) OR (coalesce(a.cd_plano_convenio::text, '') = '')) AND ((a.cd_setor_atendimento = cd_setor_atendimento_p) OR (coalesce(a.cd_setor_atendimento::text, '') = '')) AND ((a.cd_medico = cd_medico_w) OR (coalesce(a.cd_medico::text, '') = '')) AND ((a.cd_especialidade = cd_especialidade_w) OR (coalesce(a.cd_especialidade::text, '') = '')) AND ((a.cd_pessoa_fisica = cd_pessoa_fisica_p) OR (coalesce(a.cd_pessoa_fisica::text, '') = '')) AND ((b.nr_seq_grupo = nr_seq_grupo_selec_p) OR (coalesce(b.nr_seq_grupo::text, '') = '')) AND coalesce(dt_inicial_vigencia::text, '') = '' AND coalesce(dt_final_vigencia::text, '') = '' AND ((a.cd_municipio_ibge = cd_municipio_ibge_w) OR (coalesce(a.cd_municipio_ibge::text, '') = '')) AND ie_permite = 'S' --AND (a.ie_dia_semana IS NOT NULL OR a.hr_final IS NOT NULL OR a.hr_inicial IS NOT NULL)
 ) ORDER BY coalesce(cd_pessoa_fisica, 0) DESC,
                        coalesce(cd_convenio, 0) DESC,
                        coalesce(cd_setor_atendimento, 0) DESC,
                        coalesce(cd_plano_convenio, 0) DESC,
                        coalesce(cd_categoria, 0) DESC,
                        coalesce(cd_agenda, 0) DESC,
                        coalesce(cd_especialidade, 0) DESC,
                        coalesce(cd_medico, 0) DESC,
                        coalesce(b.nr_seq_grupo, 0) DESC) alias96 LIMIT 1;

      IF (nr_seq_regra_w > 0) THEN
        ds_erro_p := 'N';
      ELSE
        ds_erro_p := 'S';
      END IF;
    END IF;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_sugerir_html5_pck.ageint_consiste_regra_conv_pck (cd_convenio_p bigint, cd_categoria_p text, cd_agenda_p bigint, cd_setor_atendimento_p bigint, cd_plano_convenio_p text, cd_pessoa_fisica_p text, nr_seq_grupo_selec_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
