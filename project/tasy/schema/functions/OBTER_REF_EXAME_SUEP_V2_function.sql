-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ref_exame_suep_v2 (cd_pessoa_fisica_p text, nr_seq_exame_p bigint, nr_seq_suep_p item_suep.nr_seq_suep%type, nr_atendimento_p bigint, ie_card_type_p text) RETURNS varchar AS $body$
DECLARE

   ds_retorno_w           varchar(255);
   qt_idade_w             bigint;
   ie_sexo_w              varchar(1);
   exec_w                 varchar(300);

   c01 CURSOR FOR
      SELECT
        SUEP_MD_PCK.DECODE_THIRD_CELL_MD(ie_tipo_valor) color, 
        qt_minima, qt_maxima, qt_idade_min, qt_idade_max, ie_sexo
      from exame_lab_padrao 
      where nr_seq_exame = nr_seq_exame_p 
      and ie_tipo_valor in (0,1,2);
  r01 c01%rowtype;

  c02 CURSOR FOR
    SELECT qt_resultado nr_pontuacao
    from ( SELECT e.qt_resultado,
                  d.dt_liberacao
      from exame_lab_resultado d,
            exame_lab_result_item e
      where d.nr_seq_resultado = e.nr_seq_resultado
        and obter_se_lib_nivel_atencao(d.ie_nivel_atencao, 'T', d.nm_usuario, d.nr_prescricao) = 'S'
        and (coalesce(d.ie_nivel_atencao, 'T') = 'P' or coalesce(d.ie_nivel_atencao, 'T') = 'S' or coalesce(d.ie_nivel_atencao, 'T') = 'T')
        and d.nr_atendimento = nr_atendimento_p
        and e.nr_seq_exame = nr_seq_exame_p
        and (e.qt_resultado IS NOT NULL AND e.qt_resultado::text <> '')
        and (d.dt_liberacao IS NOT NULL AND d.dt_liberacao::text <> '')
      order by d.dt_liberacao desc, 
              e.qt_resultado) alias7 ORDER by dt_liberacao desc LIMIT 1;

 r02 c02%rowtype;


BEGIN
     
    select obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'A'),
           obter_sexo_pf(cd_pessoa_fisica_p, 'C'),
           SUEP_MD_PCK.GET_DEFAULT_COLOR_MD('thirdCell')
      into STRICT qt_idade_w, ie_sexo_w,  ds_retorno_w
;

   open c01;
   loop
     fetch c01 into r01;
     EXIT WHEN NOT FOUND; /* apply on c01 */
   end loop;
   close c01;

   open c02;
   loop
     fetch c02 into r02;
     EXIT WHEN NOT FOUND; /* apply on c02 */

    exec_w := 'CALL SUEP_MD_PCK.OBTER_REF_EXAME_SUEP_V2_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10) INTO :result';
        EXECUTE exec_w
            USING IN
              r02.nr_pontuacao, 
              r01.qt_maxima, 
              r01.qt_minima,
              r01.qt_idade_min, 
              r01.qt_idade_max, 
              qt_idade_w, 
              ie_sexo_w, 
              r01.ie_sexo, 
              r01.color, 
              ds_retorno_w,
            OUT ds_retorno_w;

   end loop;
   close c02;

   return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ref_exame_suep_v2 (cd_pessoa_fisica_p text, nr_seq_exame_p bigint, nr_seq_suep_p item_suep.nr_seq_suep%type, nr_atendimento_p bigint, ie_card_type_p text) FROM PUBLIC;
