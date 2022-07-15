-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_gerar_w_nutricao ( dt_referencia_p timestamp, dt_referencia_fim_p timestamp, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_tipo_evolucao_p text, nr_seq_tipo_aval_p bigint, ds_filtros_me_p text, ie_prescricao_nutricao_p text, ie_prescricao_definida_p text, ie_prescricao_hora_especial_p text, ie_mostrar_atend_com_dt_alta_p text, ie_status_gestao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_setores_internacao_w			varchar(1);

dt_referencia_w				timestamp;
dt_referencia_fim_w			timestamp;

ie_inserir_w				boolean := false;
ds_comando_w				varchar(32767);
ds_sql_where_w				varchar(32767);
C01					integer;
retorno_w				bigint;

ie_term_jejum_w				varchar(1);
dt_nascimento_w				timestamp;
ds_filtros_me_w				varchar(32767);

cd_setor_atendimento_w			integer;
ds_setor_atendimento_w			varchar(100);
nr_atendimento_w			bigint;
cd_pessoa_fisica_w			varchar(10);
cd_unidade_basica_w			varchar(10);
cd_unidade_compl_w			varchar(10);
cd_unidade_w				varchar(30);
nm_paciente_w				varchar(60);
nm_medico_resp_w			varchar(60);
cd_medico_w				varchar(10);
ie_sexo_w				varchar(1);
dt_entrada_w				timestamp;
dt_previsto_alta_w			timestamp;
dt_entrada_unidade_w			timestamp;
dt_alta_w				timestamp;
ds_idade_w				varchar(100);
cd_nutricionista_w			varchar(10);
nm_nutricionista_w			varchar(100);
ds_diagnostico_w			varchar(240);
qt_altura_w				double precision;
qt_ultimo_peso_w			double precision;
qt_ultimo_imc_w				double precision;
qt_pri_altura_w				double precision;
qt_pri_peso_w				double precision;
qt_pri_imc_w				double precision;
ds_cirurgia_w				varchar(1000);
ds_dia_hora_inter_w			varchar(35);
ie_status_nut_w				varchar(30);
dt_pri_evol_w				timestamp;
nm_prof_pri_evol_w			varchar(255);
dt_ult_evol_w				timestamp;
nm_prof_ult_evol_w			varchar(255);
nm_avaliador_w				varchar(255);
dt_avaliacao_w				timestamp;
dt_liberacao_w				timestamp;
ie_existe_prescr_pend_w			varchar(1);
ie_alerta_w				varchar(1);
ds_convenio_w				varchar(255);
nr_seq_classif_w			bigint;
ds_classif_w				varchar(255);
ds_lista_classif_w			varchar(2000);
ie_precaucao_w				varchar(1);
ie_aniversariante_w			varchar(1);
ie_dieta_acomp_w			varchar(1);
ie_jejum_w				varchar(1);
dt_serv_bloq_adep_w			timestamp;
ds_motivo_bloqueio_adep_w		varchar(4000);
nm_usuario_bloq_adep_w			varchar(15);
ds_nivel_assistencial_w			varchar(255);
ds_classif_pac_w			varchar(255);
qt_evolucoes_w				bigint;
ie_primeira_prescr_w			varchar(1);
cd_unidade_number_w			bigint;


BEGIN

CALL exec_sql_dinamico(nm_usuario_p,'truncate table w_nutricao');

dt_referencia_w		:= trunc(dt_referencia_p);
dt_referencia_fim_w	:= trunc(dt_referencia_fim_p) + 86399/86400;
ds_filtros_me_w		:= ds_filtros_me_p;

/*Parametros*/

ie_setores_internacao_w := coalesce(obter_valor_param_usuario(1003, 51, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p),'N');
/*--------------*/

if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') and (dt_referencia_fim_p IS NOT NULL AND dt_referencia_fim_p::text <> '') then


	/*Filtros*/

	if (coalesce(cd_setor_atendimento_p,0) > 0) then
		ds_sql_where_w	:= ds_sql_where_w ||chr(10)||' and c.cd_setor_atendimento = :cd_setor_atendimento';
	end if;

	if (coalesce(nr_Atendimento_p,0) > 0) then
		ds_sql_where_w	:= ds_sql_where_w ||chr(10)||' and b.nr_atendimento = :nr_atendimento';
	end if;
	
	if (ie_prescricao_nutricao_p = 'S') then
		ds_sql_where_w 	:= ds_sql_where_w ||chr(10)||' and	EXISTS (	SELECT  1
											FROM	nut_atend_serv_dia_rep a,
												nut_atend_serv_dia c
											WHERE	a.nr_seq_serv_dia  = c.nr_sequencia
											AND	dt_servico BETWEEN :dt_referencia AND :dt_referencia_fim
											AND	c.nr_atendimento = b.nr_atendimento
											AND    	((EXISTS (SELECT 1 FROM prescr_dieta y WHERE y.nr_prescricao = a.nr_prescr_oral and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM rep_jejum z WHERE z.nr_prescricao = a.nr_prescr_jejum and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM prescr_material d WHERE d.nr_prescricao IN (a.NR_PRESCR_COMPL, a.NR_PRESCR_ENTERAl, a.NR_PRESCR_NPT_ADULTA) AND d.ie_agrupador IN (8,12) and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM nut_pac e WHERE e.nr_prescricao= a.NR_PRESCR_NPT_NEO and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM prescr_leite_deriv e where e.nr_prescricao = a.nr_prescr_leite_deriv)))
											AND     (EXISTS (SELECT 1
													FROM   	prescr_medica x,
														usuario	y
													WHERE  	x.cd_prescritor = y.cd_pessoa_fisica
													AND	y.IE_TIPO_EVOLUCAO  = 4
													AND	x.nr_prescricao IN (NR_PRESCR_ORAL,NR_PRESCR_JEJUM,NR_PRESCR_COMPL, NR_PRESCR_ENTERAL,NR_PRESCR_NPT_ADULTA, NR_PRESCR_NPT_NEO, NR_PRESCR_LEITE_DERIV) and rownum = 1))
											and	rownum = 1)';
	end if;

	if (ie_prescricao_nutricao_p = 'N' and ie_prescricao_definida_p = 'S') then
		ds_sql_where_w 	:= ds_sql_where_w ||chr(10)||' and	EXISTS (	SELECT  1
											FROM	nut_atend_serv_dia_rep a,
												nut_atend_serv_dia c
											WHERE	a.nr_seq_serv_dia  = c.nr_sequencia
											AND	dt_servico BETWEEN :dt_referencia AND :dt_referencia_fim
											AND	c.nr_atendimento = b.nr_atendimento
											AND    	((EXISTS (SELECT 1 FROM prescr_dieta y WHERE y.nr_prescricao = a.nr_prescr_oral and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM rep_jejum z WHERE z.nr_prescricao = a.nr_prescr_jejum and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM prescr_material d WHERE d.nr_prescricao IN (a.NR_PRESCR_COMPL, a.NR_PRESCR_ENTERAl, a.NR_PRESCR_NPT_ADULTA) AND d.ie_agrupador IN (8,12) and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM nut_pac e WHERE e.nr_prescricao= a.NR_PRESCR_NPT_NEO and rownum = 1))
											OR	 (EXISTS (SELECT 1 FROM prescr_leite_deriv e where e.nr_prescricao = a.nr_prescr_leite_deriv)))
											and	rownum = 1)';
	end if;

	if (ie_prescricao_hora_especial_p = 'S') then
		ds_sql_where_w 	:= ds_sql_where_w ||chr(10)||' and	exists (select	1
										from	nut_atend_serv_dia c
										where	c.nr_atendimento = b.nr_atendimento
										ANd	dt_servico BETWEEN :dt_referencia AND :dt_referencia_fim
										and	exists (select	1
												from	prescr_medica b
												where	b.nr_atendimento = c.nr_atendimento
												and	nvl(b.dt_liberacao,b.dt_liberacao_medico) is not null
												and	((c.dt_servico between b.dt_inicio_prescr and b.dt_validade_prescr) or (b.dt_validade_prescr is null))
												and  	exists (select 1
														from	prescr_dieta d
														where 	d.nr_prescricao = b.nr_prescricao
														and 	nvl(d.ie_dose_espec_agora,'||chr(39)||'N'||chr(39)||') = '||chr(39)||'S'||chr(39)||')))';
	end if;
	--Fim dos filtros
	if (coalesce(nr_Atendimento_p,0) = 0) then
		--Comando SQL
		ds_comando_w :=
			'SELECT c.ds_setor_atendimento,
				c.cd_setor_atendimento,
				b.nr_atendimento,
				b.cd_pessoa_fisica,
				a.cd_unidade_basica,
				a.cd_unidade_compl,
				a.cd_unidade_basica ||'||chr(39)||' '||chr(39)||'||a.cd_unidade_compl cd_unidade,
				substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_paciente,
				substr(obter_nome_pf(e.cd_pessoa_fisica),1,255) nm_medico_resp,
				b.cd_medico_resp cd_medico,
				d.ie_sexo,
				b.dt_entrada,
				b.dt_previsto_alta,
				a.dt_entrada_unidade,
				b.dt_alta,
				d.dt_nascimento
			FROM   	atendimento_paciente b,
				unidade_atendimento a,
				setor_atendimento c,
				pessoa_fisica d,
				pessoa_fisica e
			WHERE  	a.nr_atendimento = b.nr_atendimento
			and	a.cd_setor_Atendimento = c.cd_setor_atendimento
			and	b.cd_pessoa_fisica = d.cd_pessoa_fisica
			and	b.cd_medico_resp = e.cd_pessoa_fisica
			AND     b.dt_cancelamento is null
			AND	b.cd_estabelecimento = :cd_estabelecimento
			AND	a.ie_status_unidade IN ('||chr(39)||'R'||chr(39)||','||chr(39)||'L'||chr(39)||','||chr(39)||'H'||chr(39)||','||chr(39)||'G'||chr(39)||','||chr(39)||'A'||chr(39)||','||chr(39)||'O'||chr(39)||','||chr(39)||'E'||chr(39)||','||chr(39)||'C'||chr(39)||','||chr(39)||'P'||chr(39)||','||chr(39)||'M'||chr(39)||','||chr(39)||'I'||chr(39)||','||chr(39)||'S'||chr(39)||')
			';

		ds_comando_w := ds_comando_w ||chr(10)||ds_sql_where_w||chr(10)||ds_filtros_me_w;

		if (ie_setores_internacao_w = 'S')  then


			ds_comando_w	:= ds_comando_w ||chr(10)||
			'union
			SELECT	c.ds_setor_atendimento,
				c.cd_setor_atendimento,
				b.nr_atendimento,
				b.cd_pessoa_fisica,
				'||chr(39)||' '||chr(39)||' cd_unidade_basica,
				'||chr(39)||' '||chr(39)||' cd_unidade_compl,
				f.cd_unidade_basica ||'||chr(39)||' '||chr(39)||'|| f.cd_unidade_compl cd_unidade,
				substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_paciente,
				substr(obter_nome_pf(e.cd_pessoa_fisica),1,255) nm_medico_resp,
				b.cd_medico_resp cd_medico,
				d.ie_sexo,
				b.dt_entrada,
				b.dt_previsto_alta,
				sysdate dt_entrada_unidade,
				b.dt_alta,
				d.dt_nascimento
			FROM	atendimento_paciente b,
				pessoa_fisica d,
				pessoa_fisica e,
				setor_atendimento c,
				atend_paciente_unidade f
			WHERE	d.cd_pessoa_fisica = b.cd_pessoa_fisica
			AND	e.cd_pessoa_fisica     = b.cd_medico_resp
			and	b.cd_estabelecimento   = :cd_estabelecimento
			AND   	b.dt_alta IS NULL
			AND     b.dt_cancelamento is null
			and	c.CD_CLASSIF_SETOR <> 3
			and 	f.nr_atendimento = b.nr_atendimento
			and 	f.cd_setor_atendimento = c.cd_setor_atendimento
			AND	c.cd_setor_atendimento = (	select	max(x.cd_setor_atendimento)
								from	atend_paciente_unidade x
								where	x.nr_atendimento = b.nr_atendimento
								and	x.nr_seq_interno = ( 	select	nvl(max(y.nr_seq_interno),0)
												from 	atend_paciente_unidade y
												where	y.nr_atendimento = x.nr_atendimento
												and 	nvl(y.dt_saida_unidade, y.dt_entrada_unidade + 9999) = (select	max(nvl(z.dt_saida_unidade, z.dt_entrada_unidade + 9999))
																				from   	atend_paciente_unidade z
																				where  	z.nr_atendimento = y.nr_atendimento)))
			AND	NVL(c.ie_mostra_gestao_nutricao, '||chr(39)||'S'||chr(39)||') = '||chr(39)||'S'||chr(39)||'
			AND	NOT EXISTS (	SELECT  1
						FROM 	unidade_atendimento c
						WHERE	c.nr_atendimento     = b.nr_atendimento
						AND	c.ie_status_unidade IN ('||chr(39)||'R'||chr(39)||','||chr(39)||'L'||chr(39)||','||chr(39)||'H'||chr(39)||','||chr(39)||'G'||chr(39)||','||chr(39)||'A'||chr(39)||','||chr(39)||'O'||chr(39)||','||chr(39)||'E'||chr(39)||','||chr(39)||'C'||chr(39)||','||chr(39)||'P'||chr(39)||','||chr(39)||'M'||chr(39)||','||chr(39)||'I'||chr(39)||','||chr(39)||'S'||chr(39)||')
						and	rownum = 1)
						';


			ds_comando_w := ds_comando_w ||chr(10)||ds_sql_where_w||chr(10)||ds_filtros_me_w;

		end if;

		if (ie_mostrar_atend_com_dt_alta_p = 'S') then

			ds_comando_w	:= ds_comando_w ||chr(10)||
			'union
			SELECT	c.ds_setor_atendimento,
				c.cd_setor_atendimento,
				b.nr_atendimento,
				b.cd_pessoa_fisica,
				'||chr(39)||' '||chr(39)||' cd_unidade_basica,
				'||chr(39)||' '||chr(39)||' cd_unidade_compl,
				'||chr(39)||' '||chr(39)||' cd_unidade,
				substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_paciente,
				substr(obter_nome_pf(e.cd_pessoa_fisica),1,255) nm_medico_resp,
				b.cd_medico_resp cd_medico,
				d.ie_sexo,
				b.dt_entrada,
				b.dt_previsto_alta,
				sysdate dt_entrada_unidade,
				b.dt_alta,
				d.dt_nascimento
			FROM   	atendimento_paciente b,
				pessoa_fisica d,
				pessoa_fisica e,
				setor_atendimento c
			where	b.cd_pessoa_fisica	= d.cd_pessoa_fisica
			and	b.cd_medico_resp	= e.cd_pessoa_fisica
			AND	b.cd_estabelecimento	= '|| cd_estabelecimento_p ||'
			and	b.dt_alta is not null
			AND     b.dt_cancelamento is null
			AND	c.cd_setor_atendimento = (	select	max(x.cd_setor_atendimento)
								from	atend_paciente_unidade x
								where	x.nr_atendimento = b.nr_atendimento
								and	x.nr_seq_interno = ( 	select	nvl(max(y.nr_seq_interno),0)
												from 	atend_paciente_unidade y
												where	y.nr_atendimento = x.nr_atendimento
												and	y.ie_passagem_setor <> ''S''
												and 	nvl(y.dt_saida_unidade, y.dt_entrada_unidade + 9999) = (select	max(nvl(z.dt_saida_unidade, z.dt_entrada_unidade + 9999))
																	from   	atend_paciente_unidade z
																	where  	z.nr_atendimento = y.nr_atendimento
																	and	z.ie_passagem_setor <> ''S'')))
			and	b.dt_alta >= inicio_dia(to_date(''' || to_char(dt_referencia_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy''))
			and 	exists (select	1
					from	atend_paciente_unidade x
					where	x.nr_atendimento = b.nr_atendimento
					and    ((inicio_dia(to_date(''' || to_char(dt_referencia_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy'')) between x.dt_entrada_unidade and x.dt_saida_unidade) or
						(x.dt_entrada_unidade between inicio_dia(to_date(''' || to_char(dt_referencia_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy'')) and fim_dia(to_date(''' || to_char(dt_referencia_fim_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy''))) or
						(x.dt_entrada_unidade < fim_dia(to_date(''' || to_char(dt_referencia_fim_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy'')) and x.dt_saida_unidade is null))
			and 	x.cd_setor_atendimento = ' || cd_setor_atendimento_p || '
			and	x.dt_saida_unidade is not null)
			';
			ds_comando_w := ds_comando_w ||chr(10)||ds_sql_where_w||chr(10)||ds_filtros_me_w;

		end if;
	else
		ds_comando_w :=	'SELECT	c.ds_setor_atendimento,
					c.cd_setor_atendimento,
					b.nr_atendimento,
					b.cd_pessoa_fisica,
					f.cd_unidade_basica cd_unidade_basica,
					f.cd_unidade_compl cd_unidade_compl,
					f.cd_unidade_basica ||'||chr(39)||' '||chr(39)||'||f.cd_unidade_compl cd_unidade,
					substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_paciente,
					substr(obter_nome_pf(e.cd_pessoa_fisica),1,255) nm_medico_resp,	
					b.cd_medico_resp cd_medico,
					d.ie_sexo,
					b.dt_entrada,
					b.dt_previsto_alta,
					f.dt_entrada_unidade dt_entrada_unidade,
					b.dt_alta,
					d.dt_nascimento
				FROM	atendimento_paciente b,
					pessoa_fisica d,
					pessoa_fisica e,
					setor_atendimento c,
					unidade_atendimento f
				WHERE	d.cd_pessoa_fisica 	= b.cd_pessoa_fisica
				AND	e.cd_pessoa_fisica      = b.cd_medico_resp
				and	b.cd_estabelecimento    = :cd_estabelecimento
				and	b.nr_atendimento 	= f.nr_atendimento
				and	c.cd_setor_atendimento  = f.cd_setor_atendimento
				AND     b.dt_cancelamento is null
				AND	c.cd_setor_atendimento  = (	select	max(x.cd_setor_atendimento)
									from	atend_paciente_unidade x
									where	x.nr_atendimento = b.nr_atendimento
									and	x.nr_seq_interno = ( 	select	nvl(max(nr_seq_interno),0)
													from 	atend_paciente_unidade y
													where	y.nr_atendimento = x.nr_atendimento
													and 	nvl(y.dt_saida_unidade, y.dt_entrada_unidade + 9999) = (select	max(nvl(z.dt_saida_unidade, z.dt_entrada_unidade + 9999))
																					from   	atend_paciente_unidade z
																					where  	z.nr_atendimento = y.nr_atendimento
and exists(select 1 from setor_atendimento st
	where st.cd_setor_atendimento = z.cd_setor_atendimento
	and NVL(st.ie_mostra_gestao_nutricao,''S'') = ''S''))))
																					';
		ds_comando_w := ds_comando_w ||chr(10)||ds_sql_where_w||chr(10)||ds_filtros_me_w;

		if (ie_setores_internacao_w = 'S')  then
			ds_comando_w	:= ds_comando_w ||chr(10)||
			'union
			SELECT	c.ds_setor_atendimento,
				c.cd_setor_atendimento,
				b.nr_atendimento,
				b.cd_pessoa_fisica,
				'||chr(39)||' '||chr(39)||' cd_unidade_basica,
				'||chr(39)||' '||chr(39)||' cd_unidade_compl,
				f.cd_unidade_basica ||'||chr(39)||' '||chr(39)||'|| f.cd_unidade_compl cd_unidade,
				substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_paciente,
				substr(obter_nome_pf(e.cd_pessoa_fisica),1,255) nm_medico_resp,	
				b.cd_medico_resp cd_medico,
				d.ie_sexo,
				b.dt_entrada,
				b.dt_previsto_alta,
				sysdate dt_entrada_unidade,
				b.dt_alta,
				d.dt_nascimento
			FROM	atendimento_paciente b,
				pessoa_fisica d,
				pessoa_fisica e,
				setor_atendimento c,
				atend_paciente_unidade f
			WHERE	d.cd_pessoa_fisica = b.cd_pessoa_fisica
			AND	e.cd_pessoa_fisica     = b.cd_medico_resp
			and	b.cd_estabelecimento   = :cd_estabelecimento
			AND   	b.dt_alta IS NULL
			AND     b.dt_cancelamento is null
			and	c.CD_CLASSIF_SETOR <> 3
			and 	f.nr_atendimento = b.nr_atendimento
			and 	f.cd_setor_atendimento = c.cd_setor_atendimento
			AND	c.cd_setor_atendimento = (	select	max(x.cd_setor_atendimento)
								from	atend_paciente_unidade x
								where	x.nr_atendimento = b.nr_atendimento
								and	x.nr_seq_interno = ( 	select	nvl(max(y.nr_seq_interno),0)
												from 	atend_paciente_unidade y
												where	y.nr_atendimento = x.nr_atendimento
												and 	nvl(y.dt_saida_unidade, y.dt_entrada_unidade + 9999) = (select	max(nvl(z.dt_saida_unidade, z.dt_entrada_unidade + 9999))
																				from   	atend_paciente_unidade z
																				where  	z.nr_atendimento = y.nr_atendimento)))
			AND	NVL(c.ie_mostra_gestao_nutricao, '||chr(39)||'S'||chr(39)||') = '||chr(39)||'S'||chr(39)||'
			AND	NOT EXISTS (	SELECT  1
						FROM 	unidade_atendimento c
						WHERE	c.nr_atendimento     = b.nr_atendimento
						AND	c.ie_status_unidade IN ('||chr(39)||'R'||chr(39)||','||chr(39)||'L'||chr(39)||','||chr(39)||'H'||chr(39)||','||chr(39)||'G'||chr(39)||','||chr(39)||'A'||chr(39)||','||chr(39)||'O'||chr(39)||','||chr(39)||'E'||chr(39)||','||chr(39)||'C'||chr(39)||','||chr(39)||'P'||chr(39)||','||chr(39)||'M'||chr(39)||','||chr(39)||'I'||chr(39)||','||chr(39)||'S'||chr(39)||')
						and	rownum = 1)
						';
			ds_comando_w := ds_comando_w ||chr(10)||ds_sql_where_w||chr(10)||ds_filtros_me_w;
		end if;

		if (ie_mostrar_atend_com_dt_alta_p = 'S') then

			ds_comando_w	:= ds_comando_w ||chr(10)||
			'union
			SELECT	c.ds_setor_atendimento,
				c.cd_setor_atendimento,
				b.nr_atendimento,
				b.cd_pessoa_fisica,
				'||chr(39)||' '||chr(39)||' cd_unidade_basica,
				'||chr(39)||' '||chr(39)||' cd_unidade_compl,
				'||chr(39)||' '||chr(39)||' cd_unidade,
				substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_paciente,
				substr(obter_nome_pf(e.cd_pessoa_fisica),1,255) nm_medico_resp,	
				b.cd_medico_resp cd_medico,
				d.ie_sexo,
				b.dt_entrada,
				b.dt_previsto_alta,
				sysdate dt_entrada_unidade,
				b.dt_alta,
				d.dt_nascimento
			FROM   	atendimento_paciente b,
				pessoa_fisica d,
				pessoa_fisica e,
				setor_atendimento c
			where	b.cd_pessoa_fisica	= d.cd_pessoa_fisica
			and	b.cd_medico_resp	= e.cd_pessoa_fisica
			AND	b.cd_estabelecimento	= '|| cd_estabelecimento_p ||'
			and	b.dt_alta is not null
			AND        b.dt_cancelamento is null
			AND	c.cd_setor_atendimento = (	select	max(x.cd_setor_atendimento)
								from	atend_paciente_unidade x
								where	x.nr_atendimento = b.nr_atendimento
								and	x.nr_seq_interno = ( 	select	nvl(max(y.nr_seq_interno),0)
												from 	atend_paciente_unidade y
												where	y.nr_atendimento = x.nr_atendimento
												and	y.ie_passagem_setor <> ''S''
												and 	nvl(y.dt_saida_unidade, y.dt_entrada_unidade + 9999) = (select	max(nvl(z.dt_saida_unidade, z.dt_entrada_unidade + 9999))
																	from   	atend_paciente_unidade z
																	where  	z.nr_atendimento = y.nr_atendimento
																	and	z.ie_passagem_setor <> ''S'')))
			and	b.dt_alta >= inicio_dia(to_date(''' || to_char(dt_referencia_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy''))
			and 	exists (select	1
					from	atend_paciente_unidade x
					where	x.nr_atendimento = b.nr_atendimento
					and    ((inicio_dia(to_date(''' || to_char(dt_referencia_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy'')) between x.dt_entrada_unidade and x.dt_saida_unidade) or
						(x.dt_entrada_unidade between inicio_dia(to_date(''' || to_char(dt_referencia_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy'')) and fim_dia(to_date(''' || to_char(dt_referencia_fim_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy''))) or
						(x.dt_entrada_unidade < fim_dia(to_date(''' || to_char(dt_referencia_fim_p,'dd/mm/yyyy') || ''',''dd/mm/yyyy'')) and x.dt_saida_unidade is null))
			and 	((x.cd_setor_atendimento = ' || coalesce(cd_setor_atendimento_p,0) || ') or (b.nr_atendimento = ' || nr_atendimento_p || '))
			and	x.dt_saida_unidade is not null)
			';
			ds_comando_w := ds_comando_w ||chr(10)||ds_sql_where_w||chr(10)||ds_filtros_me_w;

		end if;
	end if;
	
	C01 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C01, ds_comando_w, dbms_sql.Native);
	DBMS_SQL.DEFINE_COLUMN(C01, 1,  ds_setor_atendimento_w, 100);
	DBMS_SQL.DEFINE_COLUMN(C01, 2,  cd_setor_atendimento_w);
	DBMS_SQL.DEFINE_COLUMN(C01, 3,  nr_atendimento_w);
	DBMS_SQL.DEFINE_COLUMN(C01, 4,  cd_pessoa_fisica_w,10);
	DBMS_SQL.DEFINE_COLUMN(C01, 5,  cd_unidade_basica_w,10);
	DBMS_SQL.DEFINE_COLUMN(C01, 6,  cd_unidade_compl_w,10);
	DBMS_SQL.DEFINE_COLUMN(C01, 7,  cd_unidade_w,30);
	DBMS_SQL.DEFINE_COLUMN(C01, 8,  nm_paciente_w, 60);
	DBMS_SQL.DEFINE_COLUMN(C01, 9,  nm_medico_resp_w, 60);
	DBMS_SQL.DEFINE_COLUMN(C01, 10, cd_medico_w,10);
	DBMS_SQL.DEFINE_COLUMN(C01, 11, ie_sexo_w,1);
	DBMS_SQL.DEFINE_COLUMN(C01, 12, dt_entrada_w);
	DBMS_SQL.DEFINE_COLUMN(C01, 13, dt_previsto_alta_w);
	DBMS_SQL.DEFINE_COLUMN(C01, 14, dt_entrada_unidade_w);
	DBMS_SQL.DEFINE_COLUMN(C01, 15, dt_alta_w);
	DBMS_SQL.DEFINE_COLUMN(C01, 16, dt_nascimento_w);

	DBMS_SQL.BIND_VARIABLE(C01,'CD_ESTABELECIMENTO', cd_estabelecimento_p);

	if (coalesce(cd_setor_atendimento_p,0) > 0) then
		DBMS_SQL.BIND_VARIABLE(C01,'CD_SETOR_ATENDIMENTO', cd_setor_Atendimento_p);
	end if;

	if (coalesce(nr_atendimento_p,0) > 0) then
		DBMS_SQL.BIND_VARIABLE(C01,'NR_ATENDIMENTO', nr_atendimento_p);
	end if;

	if (ie_prescricao_nutricao_p = 'S') then
		DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA', dt_referencia_w);
		DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA_FIM', dt_referencia_fim_w);
	end if;

	if (ie_prescricao_nutricao_p = 'N' and ie_prescricao_definida_p = 'S') then
		DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA', dt_referencia_w);
		DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA_FIM', dt_referencia_fim_w);
	end if;

	if (ie_prescricao_hora_especial_p = 'S') then
		DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA', dt_referencia_w);
		DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA_FIM', dt_referencia_fim_w);
	end if;

	if (position(':DT_REFERENCIA' in upper(ds_comando_w)) > 0) then
		DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA', dt_referencia_w);
	end if;

	retorno_w := DBMS_SQL.execute(C01);

	while( DBMS_SQL.FETCH_ROWS(C01) > 0 ) loop
		begin

		ds_setor_atendimento_w	:= null;
		cd_setor_atendimento_w	:= null;
		nr_atendimento_w	:= null;
		cd_pessoa_fisica_w	:= null;
		cd_unidade_basica_w	:= null;
		cd_unidade_compl_w	:= null;
		cd_unidade_w		:= null;
		nm_paciente_w		:= null;
		nm_medico_resp_w	:= null;
		cd_medico_w		:= null;
		ie_sexo_w		:= null;
		dt_entrada_w		:= null;
		dt_previsto_alta_w	:= null;
		dt_entrada_unidade_w	:= null;
		dt_alta_w		:= null;
		dt_nascimento_w		:= null;


		DBMS_SQL.COLUMN_VALUE(C01, 1,  ds_setor_atendimento_w);
		DBMS_SQL.COLUMN_VALUE(C01, 2,  cd_setor_atendimento_w);
		DBMS_SQL.COLUMN_VALUE(C01, 3,  nr_atendimento_w);
		DBMS_SQL.COLUMN_VALUE(C01, 4,  cd_pessoa_fisica_w);
		DBMS_SQL.COLUMN_VALUE(C01, 5,  cd_unidade_basica_w);
		DBMS_SQL.COLUMN_VALUE(C01, 6,  cd_unidade_compl_w);
		DBMS_SQL.COLUMN_VALUE(C01, 7,  cd_unidade_w);
		DBMS_SQL.COLUMN_VALUE(C01, 8,  nm_paciente_w);
		DBMS_SQL.COLUMN_VALUE(C01, 9,  nm_medico_resp_w);
		DBMS_SQL.COLUMN_VALUE(C01, 10, cd_medico_w);
		DBMS_SQL.COLUMN_VALUE(C01, 11, ie_sexo_w);
		DBMS_SQL.COLUMN_VALUE(C01, 12, dt_entrada_w);
		DBMS_SQL.COLUMN_VALUE(C01, 13, dt_previsto_alta_w);
		DBMS_SQL.COLUMN_VALUE(C01, 14, dt_entrada_unidade_w);
		DBMS_SQL.COLUMN_VALUE(C01, 15, dt_alta_w);
		DBMS_SQL.COLUMN_VALUE(C01, 16, dt_nascimento_w);


		ie_inserir_w	:= (
				(ie_status_gestao_p = 0) or
				((ie_status_gestao_p = 1) and (substr(Nut_Obter_Status_Atend(nr_atendimento_w, cd_setor_atendimento_w, dt_referencia_w, dt_referencia_fim_p),1,30) = 'SP')) or
				((ie_status_gestao_p = 2) and (substr(Nut_Obter_Status_Atend(nr_atendimento_w, cd_setor_atendimento_w, dt_referencia_w, dt_referencia_fim_p),1,30) = 'P')) or
				((ie_status_gestao_p = 3) and (substr(nut_obter_Se_prescr_avaliar(dt_referencia_w, dt_referencia_fim_w, nr_atendimento_w, cd_setor_atendimento_p),1,1) = 'S')) or
				((ie_status_gestao_p = 4) and (substr(Nut_Obter_Status_Atend(nr_atendimento_w, cd_setor_atendimento_w, dt_referencia_w, dt_referencia_fim_p),1,30) = 'S')) or
				((ie_status_gestao_p = 5) and (substr(nut_obter_se_atend_bloq_Adep(dt_referencia_w, dt_referencia_fim_w, cd_setor_atendimento_w, nr_atendimento_w, 'D'),1,30) is not null)) or
				((ie_status_gestao_p = 6) and (substr(nut_obter_se_prim_prescricao(nr_atendimento_w,dt_referencia_w, dt_referencia_fim_w, cd_setor_atendimento_w),1,1) = 'S')) or
				((ie_status_gestao_p = 8) and (SUBSTR(Obter_se_prescr_pend_Data(nr_atendimento_w,dt_referencia_w,dt_referencia_fim_w),1,1) = 'S'))
				);

		if (ie_status_gestao_p = 7) then
			begin
			select	'S'
			into STRICT	ie_term_jejum_w
			from	nut_Atend_serv_dia x
			where	x.dt_servico between dt_referencia_w AND dt_referencia_fim_w
			and	x.nr_atendimento = nr_atendimento_w
			and	x.cd_setor_atendimento = cd_setor_atendimento_w
			and	substr(nut_obter_se_saida_jejum(x.dt_servico,x.cd_setor_atendimento,x.nr_atendimento,x.nr_seq_servico),1,1) = 'S'  LIMIT 1;
			exception
			when others then
				ie_term_jejum_w := 'N';
			end;
			ie_inserir_w := (ie_term_jejum_w = 'S');
		end if;

		if (ie_inserir_w) then

			ds_idade_w			:= SUBSTR(obter_idade(dt_nascimento_w, clock_timestamp(), 'S'),1,100);
			cd_nutricionista_w		:= obter_profissional_resp(nr_atendimento_w, 'N');
			nm_nutricionista_w		:= SUBSTR(obter_nome_pf(obter_profissional_resp(nr_atendimento_w, 'N')),1,100);
			ds_diagnostico_w		:= SUBSTR(obter_diagnostico_atendimento(nr_atendimento_w),1,200);
			qt_altura_w			:= coalesce(obter_sinal_vital(nr_atendimento_w, 'Altura'),0);
			qt_ultimo_peso_w		:= coalesce(obter_sinal_vital(nr_atendimento_w, 'Peso'),0);
			qt_ultimo_imc_w			:= coalesce(obter_sinal_vital(nr_atendimento_w, 'IMC'),0);
			qt_pri_altura_w			:= coalesce(obter_primeiro_sinal_vital(nr_atendimento_w, obter_desc_expressao(283402)),0);
			qt_pri_peso_w			:= coalesce(obter_primeiro_sinal_vital(nr_atendimento_w, obter_desc_expressao(295698)),0);
			qt_pri_imc_w			:= coalesce(obter_primeiro_sinal_vital(nr_atendimento_w, 'IMC'),0);
			ds_cirurgia_w			:= SUBSTR(obter_cirurgia_paciente(nr_atendimento_w, 'AA'),1,200);
			ds_dia_hora_inter_w		:= SUBSTR(obter_dias_horas_internacao(nr_atendimento_w),1,200);
			ie_status_nut_w			:= SUBSTR(Nut_Obter_Status_Atend(nr_atendimento_w, cd_setor_atendimento_w, dt_referencia_w, dt_referencia_fim_p),1,30);
			dt_pri_evol_w			:= to_date(SUBSTR(obter_dados_tipo_evolucao(nr_atendimento_w,ie_tipo_evolucao_p, 'DPA'),1,255),'dd/mm/yyyy hh24:mi:ss');
			nm_prof_pri_evol_w		:= SUBSTR(obter_dados_tipo_evolucao(nr_atendimento_w,ie_tipo_evolucao_p, 'PPA'),1,255);
			dt_ult_evol_w			:= to_date(SUBSTR(obter_dados_tipo_evolucao(nr_atendimento_w,ie_tipo_evolucao_p, 'DUA'),1,255),'dd/mm/yyyy hh24:mi:ss');
			nm_prof_ult_evol_w		:= SUBSTR(obter_dados_tipo_evolucao(nr_atendimento_w,ie_tipo_evolucao_p, 'PUA'),1,255);
			nm_avaliador_w			:= SUBSTR(obter_dados_aval_atend(nr_seq_tipo_aval_p, nr_atendimento_w, 'AV'),1,255);
			dt_avaliacao_w			:= to_date(SUBSTR(obter_dados_aval_atend(nr_seq_tipo_aval_p, nr_atendimento_w, 'DA'),1,255),'dd/mm/yyyy hh24:mi:ss');
			dt_liberacao_w			:= to_date(SUBSTR(obter_dados_aval_atend(nr_seq_tipo_aval_p, nr_atendimento_w, 'DL'),1,255),'dd/mm/yyyy hh24:mi:ss');
			ie_existe_prescr_pend_w		:= SUBSTR(Obter_se_prescr_pend_Data(nr_atendimento_w,dt_referencia_w,dt_referencia_fim_w),1,1);
			ie_alerta_w			:= SUBSTR(obter_se_pac_alerta_alergia(cd_pessoa_fisica_w),1,1);
			ds_convenio_w			:= SUBSTR(OBTER_NOME_CONVENIO(obter_convenio_atendimento(nr_atendimento_w)),1,200);
			nr_seq_classif_w		:= SUBSTR(obter_classif_servico(dt_referencia_w,dt_referencia_fim_w,nr_atendimento_w, cd_setor_atendimento_w, 'C'),1,150);
			ds_classif_w			:= SUBSTR(obter_classif_servico(dt_referencia_w,dt_referencia_fim_w,nr_atendimento_w, cd_setor_atendimento_w, 'D'),1,150);
			ds_lista_classif_w		:= SUBSTR(obter_lista_dados_classif(cd_pessoa_fisica_w, 'D'),1,255);
			ie_precaucao_w			:= SUBSTR(obter_Se_precaucao_cih(nr_atendimento_w),1,1);
			ie_aniversariante_w		:= SUBSTR(obter_se_aniversario_pessoa(cd_pessoa_fisica_w,0),1,1);
			ie_dieta_acomp_w		:= SUBSTR(obter_se_dieta_acomp(nr_atendimento_w, dt_referencia_fim_w),1,1);
			ie_jejum_w			:= SUBSTR(nut_obter_se_jejum(nr_atendimento_w, cd_setor_atendimento_w, dt_referencia_w, dt_referencia_fim_w),1,1);
			dt_serv_bloq_adep_w		:= to_date(SUBSTR(nut_obter_se_atend_bloq_Adep(dt_referencia_w, dt_referencia_fim_w, cd_setor_atendimento_w, nr_atendimento_w, 'D'),1,30),'dd/mm/yyyy hh24:mi:ss');
			ds_motivo_bloqueio_adep_w	:= SUBSTR(nut_obter_se_atend_bloq_Adep(dt_referencia_w, dt_referencia_fim_w, cd_setor_atendimento_w, nr_atendimento_w, 'M'),1,255);
			nm_usuario_bloq_adep_w		:= SUBSTR(nut_obter_se_atend_bloq_Adep(dt_referencia_w, dt_referencia_fim_w, cd_setor_atendimento_w, nr_atendimento_w, 'U'),1,255);
			ds_nivel_assistencial_w		:= SUBSTR(nut_obter_nivel_assistencial(nr_atendimento_w, 'D'),1,255);
			ds_classif_pac_w		:= SUBSTR(nut_obter_classif_pac(nr_atendimento_w, 'D'),1,255);
			qt_evolucoes_w			:= SUBSTR(nut_obter_qtd_evolucao(nr_atendimento_w),1,10);
			ie_primeira_prescr_w		:= SUBSTR(nut_obter_se_prim_prescricao(nr_atendimento_w, dt_referencia_w, dt_referencia_fim_w, cd_setor_atendimento_w),1,1);
			cd_unidade_number_w		:= somente_numero(cd_unidade_basica_w);

			insert	 into w_nutricao(nr_sequencia,
						ds_setor_atendimento,
						cd_setor_atendimento,
						nr_atendimento,
						cd_pessoa_fisica,
						cd_unidade_basica,
						cd_unidade_compl,
						cd_unidade,
						nm_paciente,
						nm_medico_resp,
						cd_medico,
						ds_idade,
						ie_sexo,
						cd_nutricionista,
						nm_nutricionista,
						dt_entrada,
						dt_previsto_alta,
						ds_diagnostico,
						qt_altura,
						qt_ultimo_peso,
						qt_ultimo_imc,
						qt_pri_altura,
						qt_pri_peso,
						qt_pri_imc,
						ds_cirurgia,
						ds_dia_hora_inter,
						dt_entrada_unidade,
						ie_status_nut,
						dt_pri_evol,
						nm_prof_pri_evol,
						dt_ult_evol,
						nm_prof_ult_evol,
						nm_avaliador,
						dt_avaliacao,
						dt_liberacao,
						ie_existe_prescr_pend,
						ie_alerta,
						ds_convenio,
						nr_seq_classif,
						ds_classif,
						ds_lista_classif,
						dt_alta,
						ie_precaucao,
						ie_aniversariante,
						ie_dieta_acomp,
						ie_jejum,
						dt_serv_bloq_adep,
						ds_motivo_bloqueio_adep,
						nm_usuario_bloq_adep,
						ds_nivel_assistencial,
						ds_classif_pac,
						qt_evolucoes,
						ie_primeira_prescr,
						nm_usuario,
						cd_unidade_number)
				values (nextval('w_nutricao_seq'),
						ds_setor_atendimento_w,
						cd_setor_atendimento_w,
						nr_atendimento_w,
						cd_pessoa_fisica_w,
						cd_unidade_basica_w,
						cd_unidade_compl_w,
						cd_unidade_w,
						nm_paciente_w,
						nm_medico_resp_w,
						cd_medico_w,
						ds_idade_w,
						ie_sexo_w,
						cd_nutricionista_w,
						nm_nutricionista_w,
						dt_entrada_w,
						dt_previsto_alta_w,
						ds_diagnostico_w,
						qt_altura_w,
						qt_ultimo_peso_w,
						qt_ultimo_imc_w,
						qt_pri_altura_w,
						qt_pri_peso_w,
						qt_pri_imc_w,
						ds_cirurgia_w,
						ds_dia_hora_inter_w,
						dt_entrada_unidade_w,
						ie_status_nut_w,
						dt_pri_evol_w,
						nm_prof_pri_evol_w,
						dt_ult_evol_w,
						nm_prof_ult_evol_w,
						nm_avaliador_w,
						dt_avaliacao_w,
						dt_liberacao_w,
						ie_existe_prescr_pend_w,
						ie_alerta_w,
						ds_convenio_w,
						nr_seq_classif_w,
						ds_classif_w,
						ds_lista_classif_w,
						dt_alta_w,
						ie_precaucao_w,
						ie_aniversariante_w,
						ie_dieta_acomp_w,
						ie_jejum_w,
						dt_serv_bloq_adep_w,
						ds_motivo_bloqueio_adep_w,
						nm_usuario_bloq_adep_w,
						ds_nivel_assistencial_w,
						ds_classif_pac_w,
						qt_evolucoes_w,
						ie_primeira_prescr_w,
						nm_usuario_p,
						cd_unidade_number_w);
		end if;

		end;
	end loop;

DBMS_SQL.CLOSE_CURSOR(C01);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_gerar_w_nutricao ( dt_referencia_p timestamp, dt_referencia_fim_p timestamp, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_tipo_evolucao_p text, nr_seq_tipo_aval_p bigint, ds_filtros_me_p text, ie_prescricao_nutricao_p text, ie_prescricao_definida_p text, ie_prescricao_hora_especial_p text, ie_mostrar_atend_com_dt_alta_p text, ie_status_gestao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

