-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION search_panorama_content.get_titles_body_system_organs (nr_atendimento_w bigint) RETURNS varchar AS $body$
DECLARE

c_algoritmo_icon CURSOR(p_cd_setor_atendimento bigint) FOR
    SELECT
        apc.ie_escala_acuidade
    FROM
        pan_configuracao_setor      t,
        acuidade_panorama_clinico   apc
    WHERE
        t.nr_sequencia = apc.nr_seq_pan_config_setor
        AND t.cd_setor_atendimento = p_cd_setor_atendimento
        AND t.ie_situacao = 'A';

cd_setor_atendimento_w	integer;
ds_return_w             varchar(255);
nr_expressao_w          integer;

BEGIN
  if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then

      cd_setor_atendimento_w := obter_setor_atendimento(nr_atendimento_w);

      select max(cd_setor_atendimento)
      into STRICT cd_setor_atendimento_w
      from unidade_atendimento
      where nr_atendimento = nr_atendimento_w;

      select search_panorama_content.get_titles_bso_by_sector(cd_setor_atendimento_w)
      into STRICT ds_return_w
;

  end if;
return ds_return_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION search_panorama_content.get_titles_body_system_organs (nr_atendimento_w bigint) FROM PUBLIC;
