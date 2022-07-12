-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_restr_pop_alvo ( ie_subs_bind_p text, nr_seq_populacao_alvo_p bigint, nm_pessoa_p text, qt_idade_inicial_p bigint, qt_idade_final_p bigint, ie_sexo_p text, ie_grupo_controle_p text, ie_partic_programa_p text, ie_preco_p text, qt_dias_plano_p bigint, ie_situacao_contrato_p text, ie_situacao_atend_p text, vl_custo_minimo_p bigint, vl_custo_maximo_p bigint, ie_periodo_custo_p text, pr_sinist_minimo_p bigint, pr_sinist_maximo_p bigint, ie_periodo_sinist_p text, qt_atendimento_p bigint, dt_inicio_atend_p timestamp, dt_fim_atend_p timestamp, nr_seq_tipo_atendimento_p bigint, ie_tipo_guia_p text, ie_carater_internacao_p text, cd_procedimento_p bigint default null, qt_procedimento_p bigint default 1, cd_municipio_ibge_p bigint default null, cd_material_p text default null, cd_doenca_p text default null, dt_diagnostico_inicio_p timestamp default null, dt_diagnostico_fim_p timestamp default null, cd_ciap_p text default null, cd_doenca_lista_p text default null, dt_problema_inicio_p timestamp default null, dt_problema_fim_p timestamp default null, dt_entrada_inicio_p timestamp default null, dt_entrada_fim_p timestamp default null, dt_alta_inicio_p timestamp default null, dt_alta_fim_p timestamp default null, TIPO_ATENDIMENTO_P bigint default null, ie_tipo_segurado_p text default null, sg_estado_p text default null) RETURNS varchar AS $body$
DECLARE

					
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Montar as restricoes da claususa where tanto da consulta no java quanto do update na procedure mprev_selec_pessoa_pop_alvo
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: MedPrev - Pesquisa de Populacao Alvo.
[  ]  Objetos do dicionario [x ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros: Procedure mprev_selec_pessoa_pop_alvo
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: Esta function deve estar compativel com a action 'AtivarPessoasCaptacaoWCPAction' do Tasy Java.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_sql_w 		varchar(4000) := '';
aspas_w 		varchar(1) := chr(39);
enter_w			varchar(2) := chr(13) || chr(10);
dt_inicio_format_w	varchar(50);
dt_fim_format_w		varchar(50);


BEGIN

if (nr_seq_populacao_alvo_p IS NOT NULL AND nr_seq_populacao_alvo_p::text <> '') then
	/* Dados da pessoa */

	if ('S' = ie_subs_bind_p) then
		ds_sql_w := ' and	nr_seq_populacao_alvo = :nr_seq_populacao_alvo ';
	else
		ds_sql_w := ' and	nr_seq_populacao_alvo = ' || nr_seq_populacao_alvo_p;
	end if;

	if (nm_pessoa_p IS NOT NULL AND nm_pessoa_p::text <> '') then
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and 	nm_pessoa_pesquisa like elimina_acentuacao(upper('||aspas_w||'% :nm_pessoa %'||aspas_w||'))';
		else
			ds_sql_w := ds_sql_w || ' and 	nm_pessoa_pesquisa like elimina_acentuacao(upper('||aspas_w||'%'|| nm_pessoa_p ||'%'||aspas_w||'))';
		end if;
	end if;

 	if (cd_municipio_ibge_p IS NOT NULL AND cd_municipio_ibge_p::text <> '') then
      if ('S' = ie_subs_bind_p) then
      			ds_sql_w := ds_sql_w || ' and    CD_MUNICIPIO_IBGE = :CD_MUNICIPIO_IBGE ';
    		else
      			ds_sql_w := ds_sql_w || ' and    CD_MUNICIPIO_IBGE = '||to_char(CD_MUNICIPIO_IBGE_P);
   		end if;
  end if;

  if (sg_estado_p IS NOT NULL AND sg_estado_p::text <> '') then
      ds_sql_w := ds_sql_w || ' and sg_estado = ' || aspas_w || sg_estado_p || aspas_w;
  end if;

  /*Dados do atendimento*/

  if ((TIPO_ATENDIMENTO_P IS NOT NULL AND TIPO_ATENDIMENTO_P::text <> '') or (DT_ENTRADA_INICIO_P IS NOT NULL AND DT_ENTRADA_INICIO_P::text <> '') or (DT_ENTRADA_FIM_P IS NOT NULL AND DT_ENTRADA_FIM_P::text <> '') or (DT_ALTA_INICIO_P IS NOT NULL AND DT_ALTA_INICIO_P::text <> '') or (DT_ALTA_FIM_P IS NOT NULL AND DT_ALTA_FIM_P::text <> '')) then
      ds_sql_w := ds_sql_w ||	' and exists (select 1 ' || enter_w ||
      'from hdm_pop_alvo_atend hdm_atend ' || enter_w ||
      'where hdm_atend.nr_seq_populacao_alvo = a.nr_seq_populacao_alvo ' || enter_w ||
      'and hdm_atend.cd_pessoa_fisica = a.cd_pessoa_fisica ';
      if (TIPO_ATENDIMENTO_P IS NOT NULL AND TIPO_ATENDIMENTO_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_atend.ie_tipo_atendimento = ' || aspas_w || TIPO_ATENDIMENTO_P || aspas_w;
      end if;
      if (DT_ENTRADA_INICIO_P IS NOT NULL AND DT_ENTRADA_INICIO_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_atend.DT_ENTRADA > ' || aspas_w || DT_ENTRADA_INICIO_P || aspas_w;
      end if;
      if (DT_ENTRADA_FIM_P IS NOT NULL AND DT_ENTRADA_FIM_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_atend.DT_ENTRADA < ' || aspas_w || DT_ENTRADA_FIM_P || aspas_w;
      end if;
      if (DT_ALTA_INICIO_P IS NOT NULL AND DT_ALTA_INICIO_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_atend.DT_ALTA > ' || aspas_w || DT_ALTA_INICIO_P || aspas_w;
      end if;
      if (DT_ALTA_FIM_P IS NOT NULL AND DT_ALTA_FIM_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_atend.DT_ALTA < ' || aspas_w || DT_ALTA_FIM_P || aspas_w;
      end if;
      ds_sql_w := ds_sql_w ||	' ) ';
    end if;


  
  /*Dados lista de problemas*/

  if ((CD_CIAP_P IS NOT NULL AND CD_CIAP_P::text <> '') or (CD_DOENCA_LISTA_P IS NOT NULL AND CD_DOENCA_LISTA_P::text <> '') or (DT_PROBLEMA_INICIO_P IS NOT NULL AND DT_PROBLEMA_INICIO_P::text <> '') or (DT_PROBLEMA_FIM_P IS NOT NULL AND DT_PROBLEMA_FIM_P::text <> '')) then
      ds_sql_w := ds_sql_w ||	' and exists (select 1 ' || enter_w ||
      'from hdm_pop_alvo_problema hdm_problema ' || enter_w ||
      'where hdm_problema.nr_seq_populacao_alvo = a.nr_seq_populacao_alvo ' || enter_w ||
      'and hdm_problema.cd_pessoa_fisica = a.cd_pessoa_fisica ';
      if (cd_doenca_lista_p IS NOT NULL AND cd_doenca_lista_p::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_problema.cd_doenca = ' || aspas_w || cd_doenca_lista_p || aspas_w;
      end if;
      if (CD_CIAP_P IS NOT NULL AND CD_CIAP_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_problema.cd_ciap = ' || aspas_w || cd_ciap_p || aspas_w;
      end if;	
      if (dt_problema_inicio_p IS NOT NULL AND dt_problema_inicio_p::text <> '') then
          ds_sql_w := ds_sql_w ||	' and dt_inicio > ' || aspas_w || dt_problema_inicio_p || aspas_w;
      end if;
      if (DT_PROBLEMA_FIM_P IS NOT NULL AND DT_PROBLEMA_FIM_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and dt_inicio < '  || aspas_w || DT_PROBLEMA_FIM_P || aspas_w;
      end if;
      ds_sql_w := ds_sql_w ||	' ) ';
    end if;

  /*Dados do diagnostico*/

  if ((cd_doenca_p IS NOT NULL AND cd_doenca_p::text <> '') or (dt_diagnostico_inicio_p IS NOT NULL AND dt_diagnostico_inicio_p::text <> '') or (DT_DIAGNOSTICO_FIM_P IS NOT NULL AND DT_DIAGNOSTICO_FIM_P::text <> '')) then
      ds_sql_w := ds_sql_w ||	' and exists (select 1 ' || enter_w ||
      'from hdm_pop_alvo_diagnostico hdm_diagnostico  ' || enter_w ||
      'where hdm_diagnostico .nr_seq_populacao_alvo = a.nr_seq_populacao_alvo  ' || enter_w ||
      'and hdm_diagnostico .cd_pessoa_fisica = a.cd_pessoa_fisica  ';
      if (cd_doenca_p IS NOT NULL AND cd_doenca_p::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_diagnostico.cd_doenca = ' || aspas_w || cd_doenca_p || aspas_w;
      end if;
      if (dt_diagnostico_inicio_p IS NOT NULL AND dt_diagnostico_inicio_p::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_diagnostico.dt_inicio > ' || aspas_w || dt_diagnostico_inicio_p || aspas_w;
      end if;
      if (DT_DIAGNOSTICO_FIM_P IS NOT NULL AND DT_DIAGNOSTICO_FIM_P::text <> '') then
          ds_sql_w := ds_sql_w ||	' and hdm_diagnostico.dt_fim < ' || aspas_w || DT_DIAGNOSTICO_FIM_P || aspas_w;
      end if;
      ds_sql_w := ds_sql_w ||	' ) ';
  end if;

  /*Dados do medicamento*/

  if (CD_MATERIAL_P IS NOT NULL AND CD_MATERIAL_P::text <> '') then
      ds_sql_w := ds_sql_w ||	' and exists (select 1 ' || enter_w ||
      'from hdm_pop_alvo_medic hdm_medic ' || enter_w ||
      'where hdm_medic.nr_seq_populacao_alvo = a.nr_seq_populacao_alvo ' || enter_w ||
      'and hdm_medic.cd_pessoa_fisica = a.cd_pessoa_fisica ' || enter_w ||
      'and hdm_medic.cd_material = ' || aspas_w || cd_material_p || aspas_w || ') ';
  end if;


	if (qt_idade_inicial_p IS NOT NULL AND qt_idade_inicial_p::text <> '') then
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and    qt_idade_anos >= :qt_idade_inicial ';
		else
			ds_sql_w := ds_sql_w || ' and    qt_idade_anos >= '||to_char(qt_idade_inicial_p);
		end if;
	end if;
	if (qt_idade_final_p IS NOT NULL AND qt_idade_final_p::text <> '') then
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and    qt_idade_anos <= :qt_idade_final ';
		else
			ds_sql_w := ds_sql_w || ' and    qt_idade_anos <= '||to_char(qt_idade_final_p);
		end if;
	end if;
	if ((ie_sexo_p IS NOT NULL AND ie_sexo_p::text <> '')  and 'A' <>  ie_sexo_p) then
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and    ie_sexo = :ie_sexo ';
		else
			ds_sql_w := ds_sql_w || ' and    ie_sexo = ' || aspas_w || ie_sexo_p || aspas_w;
		end if;
	end if;
	if ((ie_grupo_controle_p IS NOT NULL AND ie_grupo_controle_p::text <> '') and 'A' <> ie_grupo_controle_p) then
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and    ie_grupo_controle = :ie_grupo_controle ';
		else
			ds_sql_w := ds_sql_w || ' and    ie_grupo_controle = ' || aspas_w || ie_grupo_controle_p || aspas_w;
		end if;
	end if;
	if ((ie_partic_programa_p IS NOT NULL AND ie_partic_programa_p::text <> '') and 'A' <> ie_partic_programa_p) then
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and    ie_partic_programa = :ie_grupo_controle ';
		else
			ds_sql_w := ds_sql_w || ' and    ie_partic_programa = '|| aspas_w || ie_partic_programa_p || aspas_w;
		end if;
	end if;
	/* Dados do beneficiario */

	if (ie_preco_p IS NOT NULL AND ie_preco_p::text <> '') or (qt_dias_plano_p IS NOT NULL AND qt_dias_plano_p::text <> '') or (coalesce(ie_situacao_contrato_p,'T') <> 'T') or (coalesce(ie_situacao_atend_p,'T') <> 'T')
		or (ie_tipo_segurado_p IS NOT NULL AND ie_tipo_segurado_p::text <> '') then

		if (ie_tipo_segurado_p IS NOT NULL AND ie_tipo_segurado_p::text <> '') then
			ds_sql_w	:= ds_sql_w ||	' and	exists	(select	1' || enter_w ||
						'		from	mprev_pop_alvo_benef benef, ' || enter_w ||
						'			pls_segurado seg ' || enter_w ||
						'		where	benef.nr_seq_pop_alvo_pessoa = a.nr_sequencia ' || enter_w ||
						'		and	benef.nr_seq_segurado = seg.nr_sequencia ' || enter_w ||
						'		and	seg.ie_tipo_segurado = :ie_tipo_segurado' || enter_w;
		else
			ds_sql_w	:= ds_sql_w ||	' and	exists	(select	1' || enter_w ||
						'		from	mprev_pop_alvo_benef benef ' || enter_w ||
						'		where	benef.nr_seq_pop_alvo_pessoa = a.nr_sequencia ' || enter_w;
		end if;

		if (ie_preco_p IS NOT NULL AND ie_preco_p::text <> '') then
			if ('S' = ie_subs_bind_p) then
				ds_sql_w	:= ds_sql_w || ' and	benef.ie_preco_plano = :ie_preco ';
			else
				ds_sql_w	:= ds_sql_w || ' and	benef.ie_preco_plano = ' || aspas_w || ie_preco_p || aspas_w;
			end if;
		end if;
		if (qt_dias_plano_p IS NOT NULL AND qt_dias_plano_p::text <> '') then
			if ('S' = ie_subs_bind_p) then
				ds_sql_w	:= ds_sql_w || ' and	benef.dt_inclusao_plano >= sysdate - :qt_dias_plano';
			else
				ds_sql_w	:= ds_sql_w || ' and	benef.dt_inclusao_plano >= sysdate - ' || qt_dias_plano_p;
			end if;
		end if;
		if (coalesce(ie_situacao_contrato_p,'T') = 'A') then
			ds_sql_w := ds_sql_w || ' and    benef.ie_situacao_contrato = ' || aspas_w || '2' || aspas_w;
		elsif (coalesce(ie_situacao_contrato_p,'T') = 'I') then
			ds_sql_w := ds_sql_w || ' and    benef.ie_situacao_contrato <> ' || aspas_w || '2' || aspas_w;
		end if;
		if (coalesce(ie_situacao_atend_p,'T') = 'A') then
			ds_sql_w := ds_sql_w || ' and    benef.ie_situacao_atend = ' || aspas_w || 'A' || aspas_w;
		elsif (coalesce(ie_situacao_atend_p,'T') = 'I') then
			ds_sql_w := ds_sql_w || ' and    (benef.ie_situacao_atend is null or ' ||
								'benef.ie_situacao_atend <> ' || aspas_w || 'A' || aspas_w || ')';
		end if;
		ds_sql_w	:= ds_sql_w || ')';
	end if;
	/* Dados custo */

	if (vl_custo_minimo_p IS NOT NULL AND vl_custo_minimo_p::text <> '') or (vl_custo_maximo_p IS NOT NULL AND vl_custo_maximo_p::text <> '') then
		ds_sql_w	:= ds_sql_w ||	' and	(select	nvl(sum(custo.vl_custo),0) ' || enter_w ||
						'	from	mprev_pop_alvo_data dt, ' || enter_w ||
						'		mprev_pop_alvo_benef benef, ' || enter_w ||
						'		mprev_pop_pes_custo custo ' || enter_w ||
						'	where	custo.nr_seq_pop_alvo_benef = benef.nr_sequencia ' || enter_w ||
						'	and	custo.nr_seq_pop_alvo_data = dt.nr_sequencia ' || enter_w ||
						'	and	benef.nr_seq_pop_alvo_pessoa = a.nr_sequencia ' || enter_w;
		if (ie_periodo_custo_p IS NOT NULL AND ie_periodo_custo_p::text <> '') then
			if (ie_periodo_custo_p = 'UT') then
				ds_sql_w	:= ds_sql_w || ' and	dt.dt_mes >= pkg_date_utils.add_month(pkg_date_utils.end_of(sysdate,' || aspas_w || 'MONTH' || aspas_w || ', 0),-3, 0) ';
			elsif (ie_periodo_custo_p = 'US') then
				ds_sql_w	:= ds_sql_w || ' and	dt.dt_mes >= pkg_date_utils.add_month(pkg_date_utils.end_of(sysdate,' || aspas_w || 'MONTH' || aspas_w || ', 0),-6, 0) ';
			elsif (ie_periodo_custo_p = 'UA') then
				ds_sql_w	:= ds_sql_w || ' and	dt.dt_mes >= pkg_date_utils.add_month(pkg_date_utils.end_of(sysdate,' || aspas_w || 'MONTH' || aspas_w || ', 0),-12, 0) ';
			end if;
		end if;
		ds_sql_w	:= ds_sql_w || ') ';
		if ('S' = ie_subs_bind_p) then
			ds_sql_w	:= ds_sql_w || ' between nvl(:vl_custo_minimo,-999999999) and :vl_custo_maximo ';
		else
			ds_sql_w	:= ds_sql_w || ' between replace(' || aspas_w || coalesce(vl_custo_minimo_p,-999999999) || aspas_w || ',to_char(0,' || aspas_w || 'fmd' || aspas_w || ')) and '  ||
									' replace(' || aspas_w || coalesce(vl_custo_maximo_p,999999999) || aspas_w || ',to_char(0,' || aspas_w || 'fmd' || aspas_w || '))';
		end if;
	end if;
	/* Dados sinistralidade */

	if (pr_sinist_minimo_p IS NOT NULL AND pr_sinist_minimo_p::text <> '') or (pr_sinist_maximo_p IS NOT NULL AND pr_sinist_maximo_p::text <> '') then
		ds_sql_w	:= ds_sql_w ||	' and	(select	nvl(avg(custo.pr_sinistralidade),0) ' || enter_w ||
						'	from	mprev_pop_alvo_data dt, ' || enter_w ||
						'		mprev_pop_alvo_benef benef, ' || enter_w ||
						'		mprev_pop_pes_custo custo ' || enter_w ||
						'	where	custo.nr_seq_pop_alvo_benef = benef.nr_sequencia ' || enter_w ||
						'	and	custo.nr_seq_pop_alvo_data = dt.nr_sequencia ' || enter_w ||
						'	and	benef.nr_seq_pop_alvo_pessoa = a.nr_sequencia ' || enter_w;
		if (ie_periodo_sinist_p IS NOT NULL AND ie_periodo_sinist_p::text <> '') then
			if (ie_periodo_sinist_p = 'UT') then
				ds_sql_w	:= ds_sql_w || ' and	dt.dt_mes >= pkg_date_utils.add_month(pkg_date_utils.end_of(sysdate,' || aspas_w || 'month' || aspas_w || ', 0),-3, 0) ';
			elsif (ie_periodo_sinist_p = 'US') then
				ds_sql_w	:= ds_sql_w || ' and	dt.dt_mes >= pkg_date_utils.add_month(pkg_date_utils.end_of(sysdate,' || aspas_w || 'MONTH' || aspas_w || ', 0),-6, 0) ';
			elsif (ie_periodo_sinist_p = 'UA') then
				ds_sql_w	:= ds_sql_w || ' and	dt.dt_mes >= pkg_date_utils.add_month(pkg_date_utils.end_of(sysdate,' || aspas_w || 'MONTH' || aspas_w || ', 0),-12, 0) ';
			end if;
		end if;
		ds_sql_w	:= ds_sql_w || ') ';
		if ('S' = ie_subs_bind_p) then
			ds_sql_w	:= ds_sql_w || ' between nvl(:pr_sinist_minimo,-999999999) and :pr_sinist_maximo ';
		else
			ds_sql_w	:= ds_sql_w || ' between replace(' || aspas_w || coalesce(pr_sinist_minimo_p,-999999999) || aspas_w || ',to_char(0,' || aspas_w || 'fmd' || aspas_w || ')) and '  ||
									' replace(' || aspas_w || coalesce(pr_sinist_maximo_p,999999999) || aspas_w || ',to_char(0,' || aspas_w || 'fmd' || aspas_w || '))';
		end if;
	end if;
	/* Dados atendimento OPS */

	if (qt_atendimento_p IS NOT NULL AND qt_atendimento_p::text <> '') then
		ds_sql_w	:= ds_sql_w ||	' and	(select	count(1) ' || enter_w ||
						'	from	mprev_pop_alvo_data dt, ' || enter_w ||
						'		mprev_pop_alvo_benef benef, ' || enter_w ||
						'		mprev_pop_pes_atend atend ' || enter_w ||
						'	where	atend.nr_seq_pop_alvo_benef = benef.nr_sequencia ' || enter_w ||
						'	and	atend.nr_seq_pop_alvo_data = dt.nr_sequencia ' || enter_w ||
						'	and	benef.nr_seq_pop_alvo_pessoa = a.nr_sequencia ' || enter_w;
		if (dt_inicio_atend_p IS NOT NULL AND dt_inicio_atend_p::text <> '') then
			if ('S' = ie_subs_bind_p) then
				ds_sql_w	:= ds_sql_w || ' and dt.dt_mes >= pkg_date_utils.end_of(:dt_inicio_atend,' || aspas_w || 'MONTH' || aspas_w || ', 0)';
			else
				dt_inicio_format_w	:= 'to_date(' || aspas_w || to_char(dt_inicio_atend_p,'dd/mm/yyyy') || aspas_w
								|| ',' || aspas_w || 'dd/mm/yyyy' || aspas_w || ')';
				ds_sql_w	:= ds_sql_w || ' and dt.dt_mes >= pkg_date_utils.end_of(' || dt_inicio_format_w || ',' || aspas_w || 'MONTH' || aspas_w || ', 0)';
			end if;
		end if;
		if (dt_fim_atend_p IS NOT NULL AND dt_fim_atend_p::text <> '') then
			if ('S' = ie_subs_bind_p) then
				ds_sql_w	:= ds_sql_w || ' and dt.dt_mes <= pkg_date_utils.end_of(:dt_fim_atend,' || aspas_w || 'MONTH' || aspas_w || ', 0)';
			else
				dt_fim_format_w	:= 'to_date(' || aspas_w || to_char(dt_fim_atend_p,'dd/mm/yyyy') || aspas_w
								|| ',' || aspas_w || 'dd/mm/yyyy' || aspas_w || ')';
				ds_sql_w	:= ds_sql_w || ' and dt.dt_mes <= pkg_date_utils.end_of(' || dt_fim_format_w || ',' || aspas_w || 'MONTH' || aspas_w || ', 0)';
			end if;
		end if;
		if (nr_seq_tipo_atendimento_p IS NOT NULL AND nr_seq_tipo_atendimento_p::text <> '') then
			if ('S' = ie_subs_bind_p) then
				ds_sql_w	:= ds_sql_w || ' and atend.nr_seq_tipo_atendimento = :nr_seq_tipo_atendimento ';
			else
				ds_sql_w	:= ds_sql_w || ' and atend.nr_seq_tipo_atendimento = ' || nr_seq_tipo_atendimento_p;
			end if;
		end if;
		if (ie_tipo_guia_p IS NOT NULL AND ie_tipo_guia_p::text <> '') then
			if ('S' = ie_subs_bind_p) then
				ds_sql_w	:= ds_sql_w || ' and atend.ie_tipo_guia = :ie_tipo_guia ';
			else
				ds_sql_w	:= ds_sql_w || ' and atend.ie_tipo_guia = ' || aspas_w ||ie_tipo_guia_p || aspas_w;
			end if;
		end if;
		if (ie_carater_internacao_p IS NOT NULL AND ie_carater_internacao_p::text <> '') then
			if ('S' = ie_subs_bind_p) then
				ds_sql_w	:= ds_sql_w || ' and atend.ie_carater_internacao = :ie_carater_internacao ';
			else
			ds_sql_w	:= ds_sql_w || ' and atend.ie_carater_internacao = ' || aspas_w || ie_carater_internacao_p || aspas_w;
			end if;
		end if;
		ds_sql_w	:= ds_sql_w || ') ';
		if ('S' = ie_subs_bind_p) then
			ds_sql_w	:= ds_sql_w || ' >= :qt_atendimento ';
		else
			ds_sql_w	:= ds_sql_w || ' >= ' || qt_atendimento_p;
		end if;
	end if;

  
/* Dados procedimento */

	if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
		ds_sql_w := ds_sql_w ||	' and	((select	count(1) ' || enter_w ||
						'	from	mprev_pop_alvo_data dt, ' || enter_w ||
						'		mprev_pop_alvo_benef benef, ' || enter_w ||
						'		mprev_pop_pes_atend_proc proc ' || enter_w ||
						'	where	proc.nr_seq_pop_alvo_benef = benef.nr_sequencia ' || enter_w ||
						'	and	proc.nr_seq_pop_alvo_data = dt.nr_sequencia ' || enter_w ||
						'	and	benef.nr_seq_pop_alvo_pessoa = a.nr_sequencia ' || enter_w;
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and proc.cd_procedimento = :cd_procedimento ';
		else
			ds_sql_w := ds_sql_w || ' and proc.cd_procedimento = ' || cd_procedimento_p;
		end if;

		ds_sql_w := ds_sql_w || ' ) ';
		
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' >=  :qt_procedimento ' || enter_w;
		else
			ds_sql_w := ds_sql_w || ' >= ' || coalesce(qt_procedimento_p,1) || enter_w;
		end if;
		
    ds_sql_w := ds_sql_w || ' or	(SELECT count(1)  ' || enter_w ||
		'FROM	hdm_pop_alvo_proced hdm_proced ' || enter_w ||
		'WHERE hdm_proced.nr_seq_populacao_alvo = a.nr_seq_populacao_alvo ' || enter_w ||
		'and hdm_proced.cd_pessoa_fisica = a.cd_pessoa_fisica ' || enter_w;
		
		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' and hdm_proced.CD_PROCEDIMENTO = :cd_procedimento_p) ';
		else
			ds_sql_w := ds_sql_w || ' and hdm_proced.CD_PROCEDIMENTO = ' || cd_procedimento_p || ' ) ';
		end if;
    		if ('S' = ie_subs_bind_p) then
			ds_sql_w := ds_sql_w || ' >=  :qt_procedimento ' || enter_w;
		else
			ds_sql_w := ds_sql_w || ' >= ' || coalesce(qt_procedimento_p,1) || enter_w;
		end if;
		ds_sql_w := ds_sql_w || ' ) ';
	end if;
end if;


return	ds_sql_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_restr_pop_alvo ( ie_subs_bind_p text, nr_seq_populacao_alvo_p bigint, nm_pessoa_p text, qt_idade_inicial_p bigint, qt_idade_final_p bigint, ie_sexo_p text, ie_grupo_controle_p text, ie_partic_programa_p text, ie_preco_p text, qt_dias_plano_p bigint, ie_situacao_contrato_p text, ie_situacao_atend_p text, vl_custo_minimo_p bigint, vl_custo_maximo_p bigint, ie_periodo_custo_p text, pr_sinist_minimo_p bigint, pr_sinist_maximo_p bigint, ie_periodo_sinist_p text, qt_atendimento_p bigint, dt_inicio_atend_p timestamp, dt_fim_atend_p timestamp, nr_seq_tipo_atendimento_p bigint, ie_tipo_guia_p text, ie_carater_internacao_p text, cd_procedimento_p bigint default null, qt_procedimento_p bigint default 1, cd_municipio_ibge_p bigint default null, cd_material_p text default null, cd_doenca_p text default null, dt_diagnostico_inicio_p timestamp default null, dt_diagnostico_fim_p timestamp default null, cd_ciap_p text default null, cd_doenca_lista_p text default null, dt_problema_inicio_p timestamp default null, dt_problema_fim_p timestamp default null, dt_entrada_inicio_p timestamp default null, dt_entrada_fim_p timestamp default null, dt_alta_inicio_p timestamp default null, dt_alta_fim_p timestamp default null, TIPO_ATENDIMENTO_P bigint default null, ie_tipo_segurado_p text default null, sg_estado_p text default null) FROM PUBLIC;

