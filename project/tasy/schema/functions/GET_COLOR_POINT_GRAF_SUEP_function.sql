-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_color_point_graf_suep (nr_pontuacao_p bigint, nr_seq_inf_p w_suep_item.nr_seq_inf%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_atendimento_p unidade_atendimento.nr_atendimento%type) RETURNS varchar AS $body$
DECLARE

   ds_retorno_w        varchar(200);
   qt_idade_w             bigint;
   qt_idade_dia_w         bigint;
   exec_w               varchar(300);
   ie_sexo_w              pessoa_fisica.ie_sexo%type;

   c01 CURSOR FOR
     SELECT A.NR_ALTA_MODERADA_SUEP,
      A.NR_ALTA_SEVERA_SUEP,
      A.NR_BAIXA_MODERADA_SUEP,
      A.NR_BAIXA_SEVERA_SUEP
    FROM REGRA_SEVERIDADE_PEP_INF a, 
    INFORMACAO_SUEP B
    WHERE a.NR_SEQ_PEP_INFORMACAO = B.NR_SEQ_INF 
    AND nr_seq_inf_p = B.NR_SEQUENCIA
    and (qt_idade_w  between coalesce(A.QT_IDADE_MIN,0) and coalesce(A.QT_IDADE_MAX,9999999999))
		and (qt_idade_dia_w between coalesce(A.qt_idade_min_dias,0) and coalesce(A.qt_idade_max_dias,9999999999))
		and	coalesce(A.CD_SETOR_ATENDIMENTO,Obter_Setor_Atendimento(nr_atendimento_p))	= Obter_Setor_Atendimento(nr_atendimento_p)
		and	coalesce(A.CD_ESTABELECIMENTO,Wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento
		and	coalesce(A.CD_PERFIL,wheb_usuario_pck.get_cd_perfil) = wheb_usuario_pck.get_cd_perfil
		and	coalesce(A.IE_SEXO,ie_sexo_w) = ie_sexo_w
		order by coalesce(a.cd_setor_atendimento,0), coalesce(A.CD_ESCALA_DOR,'0') desc, coalesce(A.CD_ESTABELECIMENTO,0);

BEGIN

    select obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'A'),
           obter_idade_pf(cd_pessoa_fisica_p, clock_timestamp(), 'DIA'),
           obter_sexo_pf(cd_pessoa_fisica_p, 'C'),
           SUEP_MD_PCK.GET_DEFAULT_COLOR_MD('string')
      into STRICT qt_idade_w, qt_idade_dia_w, ie_sexo_w, ds_retorno_w
;

   for r_c01 in c01 loop
        exec_w := 'CALL SUEP_MD_PCK.GET_COLOR_POINT_GRAF_MD(:1, :2, :3, :4, :5) INTO :result';
        EXECUTE exec_w
            USING IN nr_pontuacao_p, r_c01.nr_baixa_severa_suep, r_c01.NR_ALTA_SEVERA_SUEP, r_c01.nr_baixa_moderada_suep, r_c01.nr_alta_moderada_suep,  OUT ds_retorno_w;

   end loop;

   return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_color_point_graf_suep (nr_pontuacao_p bigint, nr_seq_inf_p w_suep_item.nr_seq_inf%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_atendimento_p unidade_atendimento.nr_atendimento%type) FROM PUBLIC;

