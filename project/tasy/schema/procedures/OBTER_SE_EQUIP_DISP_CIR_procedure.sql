-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_equip_disp_cir ( nr_seq_agenda_p bigint, cd_equipamento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_agenda_ant_p bigint, ie_novo_registro_p text) AS $body$
DECLARE


qt_equip_man_w		        bigint;
qt_equipamento_w	        bigint;
qt_equip_agenda_w	        bigint;
nr_seq_agenda_w		        bigint;
qt_novo_registro_w			integer;
cd_classif_equip_w			bigint;
qt_tempo_esterilizacao_w	bigint;
qt_equip_agenda_exec_w		bigint;
nr_minuto_duracao_w			bigint;
ie_contador_w				bigint	:= 0;
tam_lista_w					bigint;
ie_pos_virgula_w			smallint;
nr_sequencia_w				agenda_paciente.nr_sequencia%type;
qt_equip_reserv_med_w		bigint;
nr_seq_equipe_w				bigint;
qt_equip_reservado_w		bigint;
qt_horas_w					double precision;
cd_agenda_w					bigint;
ds_equipamento_w	        varchar(80);
ds_agenda_w			        varchar(50);
nm_paciente_w		        varchar(60);
nm_medico_w			        varchar(50);
ie_consiste_w				varchar(15);
ds_erro_w					varchar(255)	:= null;
hr_duracao_w				varchar(255);
ie_primeiro_registro_w		varchar(1);
ds_lista_agenda_w			varchar(255)	:= null;
cd_pessoa_fisica_w			varchar(10);
cd_medico_w					varchar(10);
ie_dia_da_semana_w			varchar(100);
dt_inicial_w				timestamp;
dt_final_w			        timestamp;
dt_agenda_w			        timestamp;
hr_inicio_atual_w			timestamp;
hr_fim_atual_w				timestamp;
hr_inicio_anterior_w 		timestamp;
hr_fim_anterior_w			timestamp;

C02 CURSOR FOR
	SELECT	/*+ INDEX(A AGEPACI_UK) */		b.hr_inicio,
		b.hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400),
		b.nr_sequencia
	from	agenda c,
		agenda_pac_equip a,
		agenda_paciente b
	where	b.nr_sequencia	= a.nr_seq_agenda
	and	((hr_inicio between dt_inicial_w and dt_final_w) or
		(hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
		((hr_inicio < dt_inicial_w) and (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400) > dt_final_w)))
	and	a.cd_equipamento = cd_equipamento_p
	--and	((dt_inicio_vigencia is null) or (dt_inicio_vigencia <= trunc(hr_inicio)))

	--and	((dt_final_vigencia is null) or (dt_final_vigencia >= trunc(hr_inicio)))
	and 	b.cd_agenda = c.cd_agenda
	and 	c.cd_tipo_agenda = 1
	and	ie_status_agenda = 'E'
	and	ie_origem_inf = 'I'
	and	b.nr_sequencia <> nr_seq_agenda_p;

C03 CURSOR FOR
	SELECT	/*+ INDEX(A AGEPACI_UK) */		b.hr_inicio,
		b.hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400),
		b.nr_sequencia
	from	agenda c,
		agenda_pac_equip a,
		agenda_paciente b
	where	b.nr_sequencia	= a.nr_seq_agenda
	and	((hr_inicio between dt_inicial_w and dt_final_w) or
		(hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) between dt_inicial_w and dt_final_w) or
		((hr_inicio < dt_inicial_w) and (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400) > dt_final_w)))
	and	a.cd_equipamento = cd_equipamento_p
	and 	b.cd_agenda = c.cd_agenda
	and 	c.cd_tipo_agenda = 1
	and	ie_status_agenda not in ('C','E')
	and	ie_origem_inf = 'I'
	and	b.nr_sequencia <> nr_seq_agenda_p
	order by 1,2;


BEGIN

if (coalesce(cd_equipamento_p,0) > 0) then
	ie_consiste_w := Obter_Param_Usuario(871, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_w);
	qt_novo_registro_w	:= 0;
	
	if (ie_novo_registro_p = 'S') then
		qt_novo_registro_w := 1;
	end if;

	select	max(hr_inicio),
		max(cd_medico),
		max(cd_agenda)
	into STRICT	dt_inicial_w,
		cd_medico_w,
		cd_agenda_w
	from	agenda_paciente
	where	nr_sequencia	= nr_seq_agenda_p;

	qt_equip_man_w	:= obter_qt_equip_manutencao(null, cd_equipamento_p,dt_inicial_w);

	select	coalesce(sum(coalesce(qt_compartilhamento,qt_equipamento)) - qt_equip_man_w, 1),
		coalesce(max(cd_classificacao),0)
	into STRICT	qt_equipamento_w,
		cd_classif_equip_w
	from	equipamento
	where	cd_equipamento	= cd_equipamento_p
	and	ie_situacao	= 'A';

	qt_tempo_esterilizacao_w	:= 0;

	/* Obter o tempo de esterilizacao da classificacao do equipamento */

	if (cd_classif_equip_w <> 0) then
		select	coalesce(max(qt_tempo_esterelizacao),0)
		into STRICT	qt_tempo_esterilizacao_w
		from	classif_equipamento
		where	nr_sequencia = cd_classif_equip_w;
	end if;

	select	hr_inicio,
		CASE WHEN ie_status_agenda='E' THEN  (hr_inicio + (qt_tempo_esterilizacao_w / 1440) - (1/86400))  ELSE (hr_inicio + ((nr_minuto_duracao + coalesce(qt_tempo_esterilizacao_w,0)) / 1440) - (1/86400)) END
	into STRICT	dt_inicial_w,
		dt_final_w
	from	agenda_paciente
	where	nr_sequencia	= nr_seq_agenda_p;

	/* Obter qtde de agendamentos que foram executadas no periodo - neste so eh contado o tempo de esterilizacao e nao considera mais o tempo de duracao pois o mesmo ja foi realizado */

	ie_primeiro_registro_w 	:= 'S';

	open C02;
	loop
	fetch C02 into
		hr_inicio_atual_w,
		hr_fim_atual_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		if (ie_primeiro_registro_w = 'S') then
			hr_inicio_anterior_w 	:= hr_inicio_atual_w;
			hr_fim_anterior_w		:= hr_fim_atual_w;
			qt_equip_agenda_exec_w	:= 1;
			ie_primeiro_registro_w 	:= 'N';
			ds_lista_agenda_w		:= ds_lista_agenda_w || nr_sequencia_w;
		else
			if (hr_inicio_atual_w < hr_fim_anterior_w) then
				qt_equip_agenda_exec_w 	:= qt_equip_agenda_exec_w + 1;
				ds_lista_agenda_w		:= ds_lista_agenda_w || ',' || nr_sequencia_w;
			end if;
		end if;
	end loop;
	close C02;

	ie_primeiro_registro_w 	:= 'S';

	open C03;
	loop
	fetch C03 into
		hr_inicio_atual_w,
		hr_fim_atual_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		if (ie_primeiro_registro_w = 'S') then
			hr_inicio_anterior_w 	:= hr_inicio_atual_w;
			hr_fim_anterior_w	:= hr_fim_atual_w;
			qt_equip_agenda_w	:= 1;
			ie_primeiro_registro_w 	:= 'N';
			if (coalesce(ds_lista_agenda_w::text, '') = '') then
				ds_lista_agenda_w	:= ds_lista_agenda_w || nr_sequencia_w;
			else
				ds_lista_agenda_w	:= ds_lista_agenda_w || ',' ||nr_sequencia_w;
			end if;
		else
			if (hr_inicio_atual_w < hr_fim_anterior_w) then
				qt_equip_agenda_w := qt_equip_agenda_w + 1;
				ds_lista_agenda_w := ds_lista_agenda_w || ',' ||nr_sequencia_w;
			end if;
		end if;
	end loop;
	close C03;

	qt_equip_agenda_w	:= coalesce(qt_equip_agenda_exec_w,0) + coalesce(qt_equip_agenda_w,0) + qt_novo_registro_w;

	if (ds_lista_agenda_w IS NOT NULL AND ds_lista_agenda_w::text <> '') then
		ds_lista_agenda_w := ds_lista_agenda_w || ',';
	end if;

	if (qt_equipamento_w < qt_equip_agenda_w) then
		if (ds_lista_agenda_w IS NOT NULL AND ds_lista_agenda_w::text <> '') then
			while	(ds_lista_agenda_w IS NOT NULL AND ds_lista_agenda_w::text <> '') or
				ie_contador_w > 200 loop
				begin

				tam_lista_w		:= length(ds_lista_agenda_w);
				ie_pos_virgula_w	:= position(',' in ds_lista_agenda_w);

				if (ie_pos_virgula_w <> 0) then
					begin
					nr_seq_agenda_w	:= substr(ds_lista_agenda_w,1,(ie_pos_virgula_w - 1));
					select	substr(Obter_Desc_Equipamento(cd_equipamento_p),1,80),
						hr_inicio,
						substr(obter_nome_agenda(cd_agenda),1,50),
						nm_paciente,
						substr(obter_nome_pf(cd_medico),1,50),
						nr_minuto_duracao,
						obter_horario_formatado(nr_minuto_duracao/60)
					into STRICT	ds_equipamento_w,
						dt_agenda_w,
						ds_agenda_w,
						nm_paciente_w,
						nm_medico_w,
						nr_minuto_duracao_w,
						hr_duracao_w
					from	agenda_paciente
					where	nr_sequencia	= nr_seq_agenda_w;

					if (qt_equip_man_w > 0) then
						ds_erro_w	:= substr(wheb_mensagem_pck.get_texto(300669, 'DS_EQUIPAMENTO_P=' || obter_desc_equipamento(cd_equipamento_p)), 1, 255);
						
						insert into	consistencia_agenda_cir(
												nr_sequencia,
												dt_atualizacao,
												nm_usuario,
												nr_seq_agenda,
												ie_tipo_consistencia,
												ds_consistencia,
												cd_equipamento,
												nm_paciente)
										values (	nextval('consistencia_agenda_cir_seq'),
												clock_timestamp(),
												nm_usuario_p,
												nr_seq_agenda_p,
												'E',
												ds_erro_w,
												cd_equipamento_p,
												nm_paciente_w);
						commit;
					else
						ds_erro_w := wheb_mensagem_pck.get_texto(300672, 'DT_AGENDA_W=' || to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi') || ' ' || ds_agenda_w ||
										';NM_MEDICO_W=' || nm_medico_w || ';NR_MIN_W=' || to_char(nr_minuto_duracao_w) || ';HR_DURACAO_W=' || hr_duracao_w);

						insert into	consistencia_agenda_cir(	nr_sequencia,
												dt_atualizacao,
												nm_usuario,
												nr_seq_agenda,
												ie_tipo_consistencia,
												ds_consistencia,
												cd_equipamento,
												nm_paciente)
										values (		nextval('consistencia_agenda_cir_seq'),
												clock_timestamp(),
												nm_usuario_p,
												nr_seq_agenda_p,
												'E',
												ds_erro_w,
												cd_equipamento_p,
												nm_paciente_w);
						commit;
					end if;

					if (ie_consiste_w <> 'N') then
						insert into agenda_pac_hist(
							nr_sequencia,
							nr_seq_agenda,
							ds_historico,
							dt_atualizacao,
							nm_usuario,
							dt_historico,
							cd_pessoa_fisica,
							dt_atualizacao_nrec,
							nm_usuario_nrec)
						values (
							nextval('agenda_pac_hist_seq'),
							nr_seq_agenda_p,
							wheb_mensagem_pck.get_texto(300681, 'CD_EQUIPAMENTO_P=' || substr(Obter_Desc_Equipamento(cd_equipamento_p), 1, 80)) || ds_erro_w,
							clock_timestamp(),
							'Tasy',
							clock_timestamp(),
							Obter_Dados_Usuario_Opcao(nm_usuario_p,'C'),
							clock_timestamp(),
							'Tasy');
						commit;
					end if;
					ds_lista_agenda_w	:= substr(ds_lista_agenda_w,(ie_pos_virgula_w + 1),tam_lista_w);
					end;
				end if;
				ie_contador_w	:= ie_contador_w + 1;
				end;
			end loop;
		elsif (qt_equip_man_w > 0) and (ie_novo_registro_p = 'S') then

			ds_erro_w	:= substr(wheb_mensagem_pck.get_texto(300669, 'DS_EQUIPAMENTO_P=' || obter_desc_equipamento(cd_equipamento_p)), 1, 255);

			insert into	consistencia_agenda_cir(
									nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									nr_seq_agenda,
									ie_tipo_consistencia,
									ds_consistencia,
									cd_equipamento)
							values (	nextval('consistencia_agenda_cir_seq'),
									clock_timestamp(),
									nm_usuario_p,
									nr_seq_agenda_p,
									'E',
									ds_erro_w,
									cd_equipamento_p);
			commit;

			if (ie_consiste_w <> 'N') then
				insert into agenda_pac_hist(
					nr_sequencia,
					nr_seq_agenda,
					ds_historico,
					dt_atualizacao,
					nm_usuario,
					dt_historico,
					cd_pessoa_fisica,
					dt_atualizacao_nrec,
					nm_usuario_nrec)
				values (
					nextval('agenda_pac_hist_seq'),
					nr_seq_agenda_p,
					wheb_mensagem_pck.get_texto(300681, 'CD_EQUIPAMENTO_P=' || substr(Obter_Desc_Equipamento(cd_equipamento_p), 1, 80)) || ds_erro_w,
					clock_timestamp(),
					'Tasy',
					clock_timestamp(),
					Obter_Dados_Usuario_Opcao(nm_usuario_p,'C'),
					clock_timestamp(),
					'Tasy');
				commit;
			end if;
		end if;
	end if;

	if (coalesce(ds_erro_w::text, '') = '') then
		ie_dia_da_semana_w := Obter_Cod_Dia_Semana(dt_inicial_w);
		qt_horas_w := (dt_inicial_w - clock_timestamp()) * 24;
		-- Busca a quantidade de reservas do equipamento naquele horario
		if (cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') then
			select 	count(*)
			into STRICT	qt_equip_reservado_w
			from   	regra_reserva_equipamento
			where  	cd_equipamento = cd_equipamento_p
			and		coalesce(cd_Agenda, cd_agenda_w)	= cd_agenda_w
			and 	coalesce(ie_dia_semana,coalesce(ie_dia_da_semana_w,'X')) = coalesce(ie_dia_da_semana_w,'X')
			and (dt_inicial_w between 	to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' ' || to_char(hr_inicio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and
							to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' ' || to_char(hr_fim,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
			and	((coalesce(qt_horas_ant_agenda,0) = 0) or (qt_horas_w > coalesce(qt_horas_ant_agenda,0)))
			and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= trunc(dt_inicial_w)))
			and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_inicial_w)));
			-- Se possui equipamento reservado naquele horario, consiste disponibilidade do mesmo
			if (qt_equip_reservado_w > 0) then
				-- Verfica se o equipamento esta reservado para o medico
				select 	count(*)
				into STRICT	qt_equip_reserv_med_w
				from   	regra_reserva_equipamento
				where  	cd_equipamento = cd_equipamento_p
				and		coalesce(cd_Agenda, cd_agenda_w)	= cd_agenda_w
				and 	coalesce(ie_dia_semana,coalesce(ie_dia_da_semana_w,'X')) = coalesce(ie_dia_da_semana_w,'X')
				and (dt_inicial_w between 	to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' ' || to_char(hr_inicio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and
								to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' ' || to_char(hr_fim,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
				and	((cd_pessoa_fisica = cd_medico_w) or (obter_se_medico_equipe(nr_seq_equipe,cd_medico_w) = 'S'))
				and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= trunc(dt_inicial_w)))
				and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_inicial_w)));

				-- Se nao esta reservado, consiste disponibilidade de quantidade de equipamento disponivel
				if (qt_equip_reserv_med_w = 0) then
					qt_equip_agenda_w	:= qt_equip_agenda_w - qt_equip_reservado_w;

					if (qt_equip_agenda_w = 0) and (ie_consiste_w <> 'N') then
						select 	max(cd_pessoa_fisica),
							max(nr_seq_equipe)
						into STRICT	cd_pessoa_fisica_w,
							nr_seq_equipe_w
						from   	regra_reserva_equipamento
						where	nr_sequencia = (SELECT 	max(nr_sequencia)
									from	regra_reserva_equipamento
									where  	cd_equipamento = cd_equipamento_p
									and		coalesce(cd_Agenda, cd_agenda_w)	= cd_agenda_w
									and 	coalesce(ie_dia_semana,coalesce(ie_dia_da_semana_w,'X')) = coalesce(ie_dia_da_semana_w,'X')
									and (dt_inicial_w between 	to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' ' || to_char(hr_inicio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and
													to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' ' || to_char(hr_fim,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
									and	((coalesce(dt_inicio_vigencia::text, '') = '') or (dt_inicio_vigencia <= trunc(dt_inicial_w)))
									and	((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_inicial_w))));
						if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
							ds_erro_w	:= wheb_mensagem_pck.get_texto(300682, 'DS_EQUIPAMENTO_P=' || substr(Obter_Desc_Equipamento(cd_equipamento_p), 1, 80) ||
												';CD_PESSOA_FISICA_P=' || substr(obter_nome_pf(cd_pessoa_fisica_w), 1, 50));
						else
							ds_erro_w	:= wheb_mensagem_pck.get_texto(300684, 'DS_EQUIPAMENTO_P=' || substr(Obter_Desc_Equipamento(cd_equipamento_p), 1, 80) ||
												';NR_SEQ_EQUIPE_P=' || substr(Obter_Desc_PF_Equipe(nr_seq_equipe_w), 1, 50));
						end if;

						insert into consistencia_agenda_cir(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								nr_seq_agenda,
								ie_tipo_consistencia,
								ds_consistencia,
								cd_equipamento)
						values (	nextval('consistencia_agenda_cir_seq'),
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_agenda_p,
								'E',
								ds_erro_w,
								cd_equipamento_p);
						commit;	
						
						insert into agenda_pac_hist(
							nr_sequencia,
							nr_seq_agenda,          
							ds_historico,           
							dt_atualizacao,         
							nm_usuario,             
							dt_historico,           
							cd_pessoa_fisica,       
							dt_atualizacao_nrec,    
							nm_usuario_nrec)
						values (
							nextval('agenda_pac_hist_seq'),
							nr_seq_agenda_p,
							wheb_mensagem_pck.get_texto(300681, 'CD_EQUIPAMENTO_P=' || substr(Obter_Desc_Equipamento(cd_equipamento_p), 1, 80)) || ds_erro_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							Obter_Dados_Usuario_Opcao(nm_usuario_p,'C'),
							clock_timestamp(),
							nm_usuario_p);
							commit;
					end if;	
				end if;	
			end if;	
		end if;
	end if;
end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_equip_disp_cir ( nr_seq_agenda_p bigint, cd_equipamento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_agenda_ant_p bigint, ie_novo_registro_p text) FROM PUBLIC;

