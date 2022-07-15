-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_servico_nutricao ( ds_lista_servico_p text, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_status_gestao_p text, dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, nr_prescricao_p bigint) AS $body$
DECLARE

					
nr_atendimento_w			bigint;	
cd_setor_Atendimento_w			integer;
ds_lista_servico_w			varchar(4000);	
ie_pos_virgula_w			smallint;
tam_lista_w				bigint;		
nr_seq_servico_w			bigint;	
nr_seq_serv_dia_w			bigint;
dt_servico_w				timestamp;
qt_servicos_w				bigint;
ds_observacao_w				varchar(4000);
ds_observacao_tec_w			varchar(255);
dt_referencia_w				timestamp;
ds_horarios_w				varchar(5);
nm_pessoa_fisica_w			varchar(255);
nr_Seq_acompanhante_w			bigint;
qt_dieta_acomp_w			bigint;
ie_gera_acomp_w				varchar(1);
ds_consistencia_w			varchar(4000);
cd_acompanhante_w			varchar(10);
nm_acompanhante_w			varchar(80);
nr_seq_atend_acompanhante_w		bigint;
nr_seq_atend_acomp_novo_w		bigint;
cd_dieta_w				bigint;
ie_servico_hora_inf_w			varchar(1);
C01					integer;
ds_comando_w				varchar(32767);
retorno_w				bigint;
i					bigint;

/*Parametros*/

ie_gera_servico_Acompanhante_w	        varchar(1);
ie_acompanhante_dia_anterior_w		varchar(1);
ie_preencher_auto_obs_w			varchar(1);
ie_gerar_auto_conduta_dieta_w		varchar(1);
qtd_w					bigint;

c03 CURSOR FOR
	SELECT	nr_sequencia
	from	nut_atend_serv_dia
	where	nr_atendimento 		= nr_atendimento_w
	and	cd_setor_atendimento 	= cd_setor_atendimento_w
	and	nr_Seq_servico 		= nr_seq_servico_w
	and	coalesce(dt_liberacao::text, '') = ''
	and     dt_servico between inicio_dia(dt_referencia_w) and  fim_dia(dt_referencia_w);

c04 CURSOR FOR
	SELECT	b.cd_pessoa_fisica,
		substr(coalesce(obter_nome_pf(b.cd_pessoa_fisica), b.nm_pessoa_fisica),1,80),
		b.ds_observacao,
		b.nr_sequencia
	from  	nut_atend_serv_dia a,
		nut_atend_acompanhante b
	where	a.nr_sequencia = b.nr_seq_atend_serv_dia
	and	((b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '') or (b.nm_pessoa_fisica IS NOT NULL AND b.nm_pessoa_fisica::text <> ''))
	and	a.nr_seq_servico = nr_seq_servico_w
	and	dt_servico between inicio_dia(dt_referencia_w-1) and  fim_dia(dt_referencia_w-1)
	and	a.nr_atendimento = nr_atendimento_w;

c05 CURSOR FOR
	SELECT cd_dieta
	from   nut_atend_acomp_dieta a
	where  a.nr_seq_atend_acomp = nr_seq_atend_acompanhante_w;


BEGIN

ie_gera_servico_Acompanhante_w	:= Obter_Valor_Param_Usuario(1003, 50, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);
ie_acompanhante_dia_anterior_w	:= coalesce(Obter_Valor_Param_Usuario(1003, 59, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'N');
ie_servico_hora_inf_w		:= obter_valor_param_usuario(1003,37,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ie_preencher_auto_obs_w		:= obter_valor_param_usuario(1003,16,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);
ie_gerar_auto_conduta_dieta_w	:= obter_valor_param_usuario(1003,36,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);

dt_referencia_w := dt_referencia_p;

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	ds_comando_w := 'SELECT	b.nr_atendimento,
				a.cd_setor_atendimento
			FROM    atendimento_paciente b,
					nutricao_ocupacao_unidade_v a,
					setor_atendimento s
			WHERE   a.cd_setor_atendimento = s.cd_setor_atendimento
			AND	a.nr_atendimento = b.nr_atendimento
			AND     a.nr_atendimento IS NOT NULL
			AND   	b.cd_estabelecimento = ' || cd_estabelecimento_p || ' ';

			if (ie_status_gestao_p <> 'T') then
				ds_comando_w := ds_comando_w || '   and	(substr(nut_obter_status_atend(a.nr_atendimento, a.cd_setor_atendimento, :dt_referencia_p),1,30) = :ie_status_gestao_p) ';
			end if;

			if (cd_setor_atendimento_p	> 0) then
				ds_comando_w	:= ds_comando_w || ' and (a.cd_setor_atendimento = :cd_setor_atendimento_p) ';
			end if;

			if (nr_atendimento_p	> 0) then
				ds_comando_w	:= ds_comando_w || ' and (a.nr_atendimento = :nr_atendimento_p) ';
			end if;

			ds_comando_w	:= ds_comando_w || '	AND	s.cd_classif_setor IN ('||chr(39)||'3'||chr(39)||','||chr(39)||'4'||chr(39)||')
			UNION
			SELECT	b.nr_atendimento,
					s.cd_setor_atendimento
			FROM    atendimento_paciente b,
					setor_atendimento s
			WHERE	s.cd_setor_atendimento = obter_setor_atendimento(b.nr_atendimento)
			and	b.dt_alta_interno = to_date(''30/12/2999'',''dd/mm/yyyy'') 
			and   	b.cd_estabelecimento = ' || cd_estabelecimento_p || ' ';

			if (ie_status_gestao_p <> 'T') then
				ds_comando_w	:= ds_comando_w || '  AND 	(substr(nut_obter_status_atend(b.nr_atendimento,s.cd_setor_atendimento, :dt_referencia_p),1,30) = :ie_status_gestao_p) ';
			end if;

			if (nr_atendimento_p	> 0) then
				ds_comando_w	:= ds_comando_w || ' and (b.nr_atendimento = :nr_atendimento_p) ';
			end if;

			ds_comando_w	:= ds_comando_w || '	AND	 s.cd_classif_setor NOT IN ('||chr(39)||'3'||chr(39)||','||chr(39)||'4'||chr(39)||','||chr(39)||'2'||chr(39)||')';

else

	ds_comando_w := 'select	nr_atendimento,
				cd_setor_atendimento
			from	w_nutricao   
			where	1=1 ';
			if (nr_atendimento_p	> 0) then
				ds_comando_w	:= ds_comando_w || ' and (nr_atendimento = :nr_atendimento_p) ';
			end if;

			if (cd_setor_atendimento_p	> 0) then
				ds_comando_w	:= ds_comando_w || ' and (cd_setor_atendimento = :cd_setor_atendimento_p) ';
			end if;
			if (ie_status_gestao_p <> 'T') then
				ds_comando_w	:= ds_comando_w ||' and	(SUBSTR(Nut_Obter_Status_Atend(nr_atendimento, cd_setor_atendimento, :dt_referencia_p),1,30) = :ie_status_gestao_p)  ';	
			end if;

end if;

C01 := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(C01, ds_comando_w, dbms_sql.Native);
DBMS_SQL.DEFINE_COLUMN(C01, 1,  nr_atendimento_w);
DBMS_SQL.DEFINE_COLUMN(C01, 2,  cd_setor_atendimento_w);

if (ie_status_gestao_p <> 'T') then
	DBMS_SQL.BIND_VARIABLE(C01,'DT_REFERENCIA_P', dt_referencia_p);
	DBMS_SQL.BIND_VARIABLE(C01,'IE_STATUS_GESTAO_P', ie_status_gestao_p);
end if;

if (cd_setor_atendimento_p	> 0) then
	DBMS_SQL.BIND_VARIABLE(C01,'CD_SETOR_ATENDIMENTO_P', cd_setor_atendimento_p);
end if;

if (nr_atendimento_p	> 0) then
	DBMS_SQL.BIND_VARIABLE(C01,'NR_ATENDIMENTO_P', nr_atendimento_p);
end if;

retorno_w := DBMS_SQL.execute(C01);

while(DBMS_SQL.FETCH_ROWS(C01) > 0) loop
	begin

	nr_atendimento_w	:= null;
	cd_setor_atendimento_w	:= null;

	DBMS_SQL.COLUMN_VALUE(C01, 1,  nr_atendimento_w);
	DBMS_SQL.COLUMN_VALUE(C01, 2,  cd_setor_atendimento_w);

	if (ds_lista_servico_p IS NOT NULL AND ds_lista_servico_p::text <> '') then
		ds_lista_servico_w := ds_lista_servico_p;
		qtd_w := 1;
		while(ds_lista_servico_w IS NOT NULL AND ds_lista_servico_w::text <> '') and (qtd_w < 1000)loop
			begin
			qtd_w		:= qtd_w + 1;
			tam_lista_w	:= length(ds_lista_servico_w);
			ie_pos_virgula_w	:= position(',' in ds_lista_servico_w);

			if (ie_pos_virgula_w <> 0) then
				nr_seq_servico_w	:= substr(ds_lista_servico_w,1,(ie_pos_virgula_w - 1));
			else
				nr_seq_servico_w	:= ds_lista_servico_w;
			end if;

			ds_lista_servico_w	:= substr(ds_lista_servico_w,(ie_pos_virgula_w + 1),tam_lista_w);

			if (ie_servico_hora_inf_w = 'S') then
				ds_horarios_w := obter_horario_servico(nr_seq_servico_w, cd_setor_atendimento_w);

				if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') and (to_date(to_char(dt_referencia_p,'dd/mm/yyyy')||' '||ds_horarios_w, 'dd/mm/yyyy hh24:mi') <
				    to_date(to_char(clock_timestamp(),'dd/mm/yyyy')||' '||to_char(dt_referencia_p,'hh24:mi'), 'dd/mm/yyyy hh24:mi')) then
					dt_referencia_w := dt_referencia_p +1;
				else
					dt_referencia_w := dt_referencia_p;
				end if;
			end if;

			select	count(*)	
			into STRICT	qt_servicos_w
			from	nut_atend_serv_dia
			where	nr_atendimento 		= nr_atendimento_w
			and		cd_setor_atendimento 	= cd_setor_atendimento_w
			and		nr_Seq_servico 		= nr_seq_servico_w
			and		dt_servico between inicio_dia(dt_referencia_w) and fim_dia(dt_referencia_w)
			and		Nut_Obter_Se_Conduta_Suspensa(nr_sequencia) = 'N';

			if (qt_servicos_w = 0) then

				select 	nextval('nut_atend_serv_dia_seq')
				into STRICT	nr_seq_serv_dia_w
				;

				select	trunc(ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_referencia_w, coalesce(obter_horario_servico(nr_seq_servico_w, cd_setor_atendimento_w),'00:00')), 'mi')
				into STRICT	dt_servico_w
				;

				if (ie_preencher_auto_obs_w = 'S') then
					ds_observacao_w := obter_obs_anterior_servico(dt_referencia_w,nr_Atendimento_w,nr_Seq_Servico_w, 'O');
					ds_observacao_tec_w := obter_obs_anterior_servico(dt_referencia_w,nr_Atendimento_w,nr_Seq_Servico_w,'T');
				end if;


				insert into nut_atend_serv_dia(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_Seq_servico,
					dt_servico,
					cd_setor_atendimento,
					nr_atendimento,
					ie_status,
					ds_observacao,
					ds_observacao_tec
					)
				values (nr_seq_serv_dia_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_servico_w,
					dt_servico_w,
					cd_setor_atendimento_w,
					nr_atendimento_w,
					'A',
					ds_observacao_w,
					ds_observacao_tec_w);

				CALL inserir_serv_prescr_aval(nr_prescricao_p,nr_seq_serv_dia_w,nm_usuario_p);
				if (ie_gerar_auto_conduta_dieta_w = 'S') then
					CALL Gerar_Dietas_Servico(nr_seq_serv_dia_w,nm_usuario_p);
				end if;

				if (ie_acompanhante_dia_anterior_w = 'S') then

					open c04;
					loop
					fetch c04 into 	cd_acompanhante_w,
							nm_acompanhante_w,
							ds_observacao_w,
							nr_seq_atend_acompanhante_w;
						EXIT WHEN NOT FOUND; /* apply on c04 */
							begin

							select	nextval('nut_atend_acompanhante_seq')
							into STRICT	nr_seq_atend_acomp_novo_w
							;

							insert into nut_atend_acompanhante(	nr_sequencia,
												nr_seq_atend_serv_dia,
												cd_pessoa_fisica,
												nm_pessoa_fisica, 
												ds_observacao, 
												dt_atualizacao,
												dt_atualizacao_nrec, 
												nm_usuario, 
												nm_usuario_nrec)
										values (	nr_seq_atend_acomp_novo_w,
												nr_seq_serv_dia_w,
												cd_acompanhante_w,
												nm_acompanhante_w,
												ds_observacao_w,
												clock_timestamp(),
												clock_timestamp(),
												nm_usuario_p,
												nm_usuario_p);

							open c05;
							loop
							fetch c05 into cd_dieta_w;
							EXIT WHEN NOT FOUND; /* apply on c05 */
								begin

								insert into nut_atend_acomp_dieta(	nr_sequencia,
													nr_seq_atend_acomp, 
													cd_dieta,
													dt_atualizacao,
													dt_atualizacao_nrec, 
													nm_usuario, 
													nm_usuario_nrec)
											values (nextval('nut_atend_acomp_dieta_seq'),
													nr_seq_atend_acomp_novo_w,
													cd_dieta_w,
													clock_timestamp(),
													clock_timestamp(),
													nm_usuario_p,
													nm_usuario_p);

								end;
							end loop;
							close c05;

							end;
					end loop;
					close c04;

				end if;

				ds_consistencia_w := Consiste_acomp_dieta_categoria(nr_seq_serv_dia_w, nm_usuario_p, cd_estabelecimento_p, ds_consistencia_w);

				if (ie_gera_servico_Acompanhante_w = 'S') and (coalesce(ds_consistencia_w::text, '') = '') then

					select	coalesce(max(b.qt_dieta_acomp),0),
						max(substr(obter_nome_pf(c.cd_pessoa_fisica),1,255))
					into STRICT	qt_dieta_acomp_w,
						nm_pessoa_fisica_w
					from	atendimento_paciente a,
						atend_categoria_convenio b,
						pessoa_fisica c
					where	a.nr_Atendimento = b.nr_Atendimento
					and	b.nr_seq_interno = (	SELECT 	max(d.nr_seq_interno)
									from	atend_categoria_convenio d
									where	d.nr_atendimento = a.nr_atendimento
									/*and	nvl(d.dt_final_vigencia,dt_servico_w) >= dt_servico_w
									and	dt_servico_w >= nvl(d.dt_inicio_vigencia,dt_servico_w)*/
									)
					and	a.cd_pessoa_Fisica = c.cd_pessoa_fisica
					and	a.nr_atendimento = nr_atendimento_w;

					i := 0;

					for i in 1..qt_dieta_acomp_w loop
						begin

						 := inserir_acompanhante_nutricao(	nr_seq_servico_w, dt_servico_w, nr_atendimento_w, cd_setor_atendimento_w, null, OBTER_DESC_EXPRESSAO(330453) || ' '||nm_pessoa_fisica_w,				-- 330453: 'Acompanhante de'
										nm_usuario_p, nr_Seq_acompanhante_w);
						end;
					end loop;

				end if;

			else
				open c03;
				loop
				fetch c03 into nr_seq_Serv_dia_w;
				EXIT WHEN NOT FOUND; /* apply on c03 */
					begin
					CALL inserir_serv_prescr_aval(nr_prescricao_p,nr_seq_serv_dia_w,nm_usuario_p);
					end;				
				end loop;
				close c03;
			end if;				

			end;
			end loop;

	end if;	
	end;
end loop;

DBMS_SQL.CLOSE_CURSOR(C01);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_servico_nutricao ( ds_lista_servico_p text, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, ie_status_gestao_p text, dt_referencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, nr_prescricao_p bigint) FROM PUBLIC;

