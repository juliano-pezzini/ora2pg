-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ageint_sugerir_html5_pck.obter_seq_ex_agenda_vet (nr_seq_ageint_item_p bigint, cd_estabelecimento_p bigint, qt_tempo_intervalo_p INOUT bigint, vl_retorno_p INOUT bigint, ie_regr_tempo_zero_p text DEFAULT NULL) AS $body$
DECLARE


  cd_procedimento_w      bigint;
  ie_origem_proced_w     bigint;
  cd_area_procedimento_w bigint;
  cd_especialidade_w     bigint;
  cd_grupo_proc_w        bigint;
  cd_tipo_procedimento_w procedimento.cd_tipo_procedimento%TYPE;

  c01 CURSOR FOR
    SELECT nr_sequencia,
           qt_tempo_intervalo
      FROM ageint_exames_agenda
     WHERE cd_estabelecimento = cd_estabelecimento_p
       AND coalesce(cd_area_procedimento, cd_area_procedimento_w) = cd_area_procedimento_w
       AND coalesce(cd_especialidade, cd_especialidade_w) = cd_especialidade_w
       AND coalesce(cd_grupo_proc, cd_grupo_proc_w) = cd_grupo_proc_w
       AND coalesce(cd_tipo_procedimento, cd_tipo_procedimento_w) = cd_tipo_procedimento_w
       and (coalesce(ie_regr_tempo_zero_p::text, '') = '' or coalesce(ie_agrupar_item_sugestao,'S') = 'S')
     ORDER BY coalesce(cd_area_procedimento, 0),
              coalesce(cd_especialidade, 0),
              coalesce(cd_grupo_proc, 0),
              coalesce(cd_tipo_procedimento, 0);


BEGIN

  SELECT cd_procedimento,
         ie_origem_proced
    INTO STRICT cd_procedimento_w,
         ie_origem_proced_w
    FROM agenda_integrada_item
   WHERE nr_sequencia = nr_seq_ageint_item_p;

  IF (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') AND (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') THEN
    SELECT MAX(cd_area_procedimento),
           MAX(cd_especialidade),
           MAX(cd_grupo_proc),
           coalesce(MAX(cd_tipo_procedimento), 0)
      INTO STRICT cd_area_procedimento_w,
           cd_especialidade_w,
           cd_grupo_proc_w,
           cd_tipo_procedimento_w
      FROM estrutura_procedimento_v
     WHERE cd_procedimento = cd_procedimento_w
       AND ie_origem_proced = ie_origem_proced_w;
    OPEN c01;
    LOOP
      FETCH c01
        INTO vl_retorno_p,
             qt_tempo_intervalo_p;
      EXIT WHEN NOT FOUND; /* apply on c01 */

    END LOOP;
    CLOSE c01;

  END IF;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_sugerir_html5_pck.obter_seq_ex_agenda_vet (nr_seq_ageint_item_p bigint, cd_estabelecimento_p bigint, qt_tempo_intervalo_p INOUT bigint, vl_retorno_p INOUT bigint, ie_regr_tempo_zero_p text DEFAULT NULL) FROM PUBLIC;