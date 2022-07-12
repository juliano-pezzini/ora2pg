-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_regra_gqa (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_classif_setor_w        varchar(2);
cd_doenca_cid_w           varchar(10);
cd_escala_dor_w           varchar(5);
ds_setor_atendimento_w    varchar(255);
ie_evento_w               varchar(3);
ie_grau_ferida_w          varchar(1);
ie_informacao_w           varchar(6);
ie_regra_sepse_w          varchar(3);
nr_seq_escala_w           bigint;
nr_seq_evento_w           bigint;
nr_seq_exame_w            bigint;
nr_seq_result_w           bigint;
nr_seq_result_dor_w       bigint;
nr_seq_score_flex_w       bigint;
nr_seq_sinal_vital_w      bigint;
nr_seq_tev_resposta_w     bigint;
nr_seq_triagem_w          bigint;
nr_seq_manchester_fluxo_w bigint;
qt_idade_max_w            real;
qt_idade_min_w            real;
qt_var_confirmada_w       bigint;
qt_var_suspeita_w         bigint;
vl_maximo_w               double precision;
vl_minimo_w               double precision;
ie_tipo_pendencia_w       integer;
nr_discriminador_w        integer;
ds_regra_w                varchar(1000);
ds_label_w                varchar(255);
cd_ciap_w				  varchar(255);


/*Constante Tipos de regras */

ConstTipoDiagnostico            smallint := 1;
ConstTipoExames                 smallint := 2;
ConstTipoSinalVital             smallint := 3;
ConstTipoEscalaIndice           smallint := 4;
ConstTipoCurativo               smallint := 5;
ConstTipoProtAssist             smallint := 6;
ConstTipoEvento                 smallint := 7;
ConstClassificacaoRisco         smallint := 8;
ConstTipoCIAP         			smallint := 9;


BEGIN

  if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

       select A.NR_DISCRIMINADOR,
              A.CD_CLASSIF_SETOR,
              A.CD_DOENCA_CID,
              A.CD_ESCALA_DOR,
              substr(obter_nome_setor(A.CD_SETOR_ATENDIMENTO),1,255),
              A.IE_EVENTO,
              A.IE_GRAU_FERIDA,
              A.IE_INFORMACAO,
              A.IE_REGRA_SEPSE,
              A.NR_SEQ_ESCALA,
              A.NR_SEQ_EVENTO,
              A.NR_SEQ_EXAME,
              A.NR_SEQ_RESULT,
              A.NR_SEQ_RESULT_DOR,
              A.NR_SEQ_SCORE_FLEX,
              A.NR_SEQ_SINAL_VITAL,
              A.NR_SEQ_TEV_RESPOSTA,
              A.NR_SEQ_TRIAGEM,
              A.NR_SEQ_MANCHESTER_FLUXO,
              A.QT_IDADE_MAX,
              A.QT_IDADE_MIN,
              A.QT_VAR_CONFIRMADA,
              A.QT_VAR_SUSPEITA,
              A.VL_MAXIMO,
              A.VL_MINIMO,
              B.IE_TIPO_PENDENCIA,
			  A.CD_CIAP
       into STRICT   nr_discriminador_w,
              cd_classif_setor_w,
              cd_doenca_cid_w,
              cd_escala_dor_w,
              ds_setor_atendimento_w,
              ie_evento_w,
              ie_grau_ferida_w,
              ie_informacao_w,
              ie_regra_sepse_w,
              nr_seq_escala_w,
              nr_seq_evento_w,
              nr_seq_exame_w,
              nr_seq_result_w,
              nr_seq_result_dor_w,
              nr_seq_score_flex_w,
              nr_seq_sinal_vital_w,
              nr_seq_tev_resposta_w,
              nr_seq_triagem_w,
              nr_seq_manchester_fluxo_w,
              qt_idade_max_w,
              qt_idade_min_w,
              qt_var_confirmada_w,
              qt_var_suspeita_w,
              vl_maximo_w,
              vl_minimo_w,
              ie_tipo_pendencia_w,
			  cd_ciap_w
       from   GQA_PENDENCIA_REGRA a,
              GQA_PENDENCIA       b
       where  b.nr_sequencia = a.nr_seq_pendencia
       and    a.nr_sequencia = nr_sequencia_p;

       if (nr_seq_sinal_vital_w IS NOT NULL AND nr_seq_sinal_vital_w::text <> '') then  -- Sinal vital
          select max(ds_sinal_vital)
          into STRICT   ds_label_w
          from   sinal_vital
          where  nr_sequencia = nr_seq_sinal_vital_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := wheb_mensagem_pck.get_texto(368732) || ': ' || ds_label_w;
          end if;
       end if;

       if (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> '') then -- Diagnóstico
          select max(substr(obter_desc_cid(cd_doenca_cid_w),1,200))
          into STRICT   ds_label_w
;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := wheb_mensagem_pck.get_texto(367599) || ': ' || ds_label_w;
          end if;
       end if;

       if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then -- Exame
          select max(nm_exame)
          into STRICT   ds_label_w
          from   exame_laboratorio
          where  nr_seq_exame = nr_seq_exame_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := wheb_mensagem_pck.get_texto(368122) || ': ' || ds_label_w;
          end if;
       end if;

       if (nr_seq_escala_w IS NOT NULL AND nr_seq_escala_w::text <> '') then -- Escala
          select max(ds_informacao)
          into STRICT   ds_label_w
          from   vice_escala
          where  nr_sequencia = nr_seq_escala_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := wheb_mensagem_pck.get_texto(368124) || ': ' || ds_label_w;
          end if;
       end if;

       if (ie_evento_w IS NOT NULL AND ie_evento_w::text <> '') then -- Evento (Protocolos Assistenciais)
          select max(substr(obter_desc_expressao(cd_exp_valor_dominio, ds_valor_dominio), 1, 254))
          into STRICT   ds_label_w
          from   valor_dominio_v
          where  cd_dominio = 5359
          and    vl_dominio = ie_evento_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := wheb_mensagem_pck.get_texto(368699) || ': ' || ds_label_w;
          end if;
       end if;

       if (nr_seq_evento_w IS NOT NULL AND nr_seq_evento_w::text <> '') then -- Evento (Eventos)
          select max(ds_evento)
          into STRICT   ds_label_w
          from   qua_evento
          where nr_sequencia = nr_seq_evento_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := wheb_mensagem_pck.get_texto(368699) || ': ' || ds_label_w;
          end if;
       end if;

       if (ie_tipo_pendencia_w = ConstClassificacaoRisco) then

         if (nr_seq_triagem_w IS NOT NULL AND nr_seq_triagem_w::text <> '') then  -- Classificação
           select max(ds_classificacao)
           into STRICT   ds_label_w
           from   triagem_classif_risco
           where  nr_sequencia = nr_seq_triagem_w;

           if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
               ds_regra_w := wheb_mensagem_pck.get_texto(368724) || ': ' || ds_label_w;
           end if;

         elsif (nr_discriminador_w IS NOT NULL AND nr_discriminador_w::text <> '') then -- discriminador
            select substr(nr_sequencia ||' - '|| DS_ITEM ||' '||
                   obter_desc_expressao(707792,'Idade entre')||' ' ||coalesce(QT_IDADE_MIN,0)||' '||obter_desc_expressao(312342,'e')||' '|| coalesce(QT_IDADE_MAX,999)||' '||
                   obter_desc_expressao(620432,'anos')||' ('||obter_desc_expressao(295907,'Philips') ||')',1,255) ds
            into STRICT   ds_label_w
            from   manchester_item
            where  nr_sequencia = nr_discriminador_w;

            ds_regra_w := wheb_mensagem_pck.get_texto(326003) || ': ' || ds_label_w;

         elsif (nr_seq_manchester_fluxo_w IS NOT NULL AND nr_seq_manchester_fluxo_w::text <> '') then -- fluxograma
           select substr(nr_sequencia ||' - '|| substr(obter_desc_expressao(CD_EXP_DESC_ITEM),1,254) ||' '||
                  obter_desc_expressao(707792,'Idade entre')||' ' ||coalesce(QT_IDADE_MIN,0)||' '||obter_desc_expressao(312342,'e')||' '|| coalesce(QT_IDADE_MAX,999)||' '||
                  obter_desc_expressao(620432,'anos')||' ('||obter_desc_expressao(295907,'Philips') ||')',1,255) ds
           into STRICT   ds_label_w
           from   manchester_fluxograma
           where  nr_sequencia = nr_seq_manchester_fluxo_w;

            ds_regra_w := wheb_mensagem_pck.get_texto(326003) || ': ' || ds_label_w;

         end if;

       end if;

       if (ds_setor_atendimento_w IS NOT NULL AND ds_setor_atendimento_w::text <> '') then  -- Setor paciente
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(367654) || ': ' || ds_setor_atendimento_w;
       end if;

       if (cd_escala_dor_w IS NOT NULL AND cd_escala_dor_w::text <> '') then -- Escala dor
          select max(substr(obter_desc_expressao(cd_exp_valor_dominio, ds_valor_dominio), 1, 254))
          into STRICT   ds_label_w
          from   valor_dominio_v
          where  cd_dominio = 1298 -- Escalas de dor
          and    vl_dominio = cd_escala_dor_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(367656) || ': ' || ds_label_w;
          end if;
       end if;

       if (nr_seq_result_dor_w IS NOT NULL AND nr_seq_result_dor_w::text <> '') then -- Dor
          select max(ds_escala)
          into STRICT   ds_label_w
          from   escala_dor_regra
          where  nr_sequencia = nr_seq_result_dor_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(367664) || ': ' || ds_label_w;
          end if;
       end if;

       if (nr_seq_score_flex_w IS NOT NULL AND nr_seq_score_flex_w::text <> '') then -- Score flex
          select max(ds_escala)
          into STRICT   ds_label_w
          from   eif_escala
          where  nr_sequencia = nr_seq_score_flex_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368126) || ': ' || ds_label_w;
          end if;
       end if;

       if (nr_seq_result_w IS NOT NULL AND nr_seq_result_w::text <> '') then -- Resultado
          select max(ds_resultado)
          into STRICT   ds_label_w
          from   eif_escala_result
          where  nr_sequencia = nr_seq_result_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368149) || ': ' || ds_label_w;
          end if;
       end if;

       if (qt_var_suspeita_w IS NOT NULL AND qt_var_suspeita_w::text <> '') then -- Deflagrador de risco de sepsis
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368152) || ': ' || qt_var_suspeita_w;
       end if;

       if (qt_var_confirmada_w IS NOT NULL AND qt_var_confirmada_w::text <> '') then -- Deflagrador de sepsis grave
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368153) || ': ' || qt_var_confirmada_w;
       end if;

       if (ie_regra_sepse_w IS NOT NULL AND ie_regra_sepse_w::text <> '') then -- Status Sepsis
          select max(substr(obter_desc_expressao(cd_exp_valor_dominio, ds_valor_dominio), 1, 254))
          into STRICT   ds_label_w
          from   valor_dominio_v
          where  cd_dominio = 7056
          and    vl_dominio = ie_regra_sepse_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368154) || ': ' || ds_label_w;
          end if;
       end if;

       if (cd_classif_setor_w IS NOT NULL AND cd_classif_setor_w::text <> '') then -- Classif setor
          select max(substr(obter_desc_expressao(cd_exp_valor_dominio, ds_valor_dominio), 1, 254))
          into STRICT   ds_label_w
          from   valor_dominio_v
          where  cd_dominio = 1
          and    vl_dominio = cd_classif_setor_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368730) || ': ' || ds_label_w;
          end if;
       end if;

       if (vl_minimo_w IS NOT NULL AND vl_minimo_w::text <> '') then -- Valor mín
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(367665) || ': ' || vl_minimo_w;
       end if;

       if (vl_maximo_w IS NOT NULL AND vl_maximo_w::text <> '') then -- Valor máx
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(367666) || ': ' || vl_maximo_w;
       end if;

       if (qt_idade_min_w IS NOT NULL AND qt_idade_min_w::text <> '') then -- Idade mín(anos)
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368118) || ': ' || qt_idade_min_w;
       end if;

       if (qt_idade_max_w IS NOT NULL AND qt_idade_max_w::text <> '') then -- Idade máx(anos)
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368119) || ': ' || qt_idade_max_w;
       end if;

       if (ie_informacao_w IS NOT NULL AND ie_informacao_w::text <> '') then -- Informação
          ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368155) || ': ' || ie_informacao_w;
       end if;

       if (nr_seq_tev_resposta_w IS NOT NULL AND nr_seq_tev_resposta_w::text <> '') then -- Respostas TEV
          select max(substr(ds_titulo,1,255))
          into STRICT   ds_label_w
          from	  tev_resposta
          where  nr_sequencia = nr_seq_tev_resposta_w;

          if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
             ds_regra_w := ds_regra_w || ' - ' || wheb_mensagem_pck.get_texto(368156) || ': ' || ds_label_w;
          end if;
       end if;

       if (ie_tipo_pendencia_w = ConstTipoCurativo) then

         if (ie_grau_ferida_w IS NOT NULL AND ie_grau_ferida_w::text <> '') then -- Grau
           select max(substr(obter_desc_expressao(cd_exp_valor_dominio, ds_valor_dominio), 1, 254))
           into STRICT   ds_label_w
           from   valor_dominio_v
           where  cd_dominio = 3959
           and    vl_dominio = ie_grau_ferida_w;

           if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
               ds_regra_w := wheb_mensagem_pck.get_texto(302667) || ' - ' || wheb_mensagem_pck.get_texto(368698) || ': ' || ds_label_w || ds_regra_w;
           end if;

         else

            ds_regra_w := wheb_mensagem_pck.get_texto(302667) ||  ': ' || substr(ds_regra_w, 3, 255);

         end if;

       end if;

	   if (ie_tipo_pendencia_w = ConstTipoCIAP) then

		   if (cd_ciap_w IS NOT NULL AND cd_ciap_w::text <> '') then -- CIAP
			  select max(substr(obter_desc_ciap(cd_ciap_w),1,255))
			  into STRICT   ds_label_w
			;

			  if (ds_label_w IS NOT NULL AND ds_label_w::text <> '') then
				 ds_regra_w := wheb_mensagem_pck.get_texto(1060535) || ': ' || ds_label_w;
			  end if;
		   end if;


       end if;

   end if;

   return ds_regra_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_regra_gqa (nr_sequencia_p bigint) FROM PUBLIC;

