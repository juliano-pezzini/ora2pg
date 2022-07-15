-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_consulta_horarios ( cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, ie_forma_apres_p text, ie_tipo_agendamento_p text, cd_setor_exclusivo_p bigint, cd_estabelecimento_p bigint, nr_seq_area_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_especialidade_p bigint) AS $body$
DECLARE


ds_sep_bv_w		varchar(50);
ds_comando_w		varchar(255);
nr_dias_mes_w		bigint;
dt_atual_w		timestamp;


cd_agenda_w		bigint;
cd_medico_exec_w		varchar(10);
cd_paciente_w		varchar(10);
nm_paciente_w		varchar(60);
ie_status_agenda_w	varchar(3);
nr_minuto_duracao_w	bigint;
dt_agenda_w		timestamp;
ie_turno_medico_w		varchar(1);
nr_seq_agenda_w		ageint_consulta_horarios.nr_seq_agenda%type;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_proc_interno_w	bigint;
cd_setor_atendimento_w	bigint;
nr_seq_status_pac_w	bigint;
	
cd_tipo_agenda_w		bigint;
ie_tipo_agendamento_w	varchar(1);

nr_seq_agenda_int_w	bigint;
ds_observacao_final_w	varchar(2000);
nr_atendimento_w		bigint;
cd_convenio_w		integer;
ie_apres_hr_medico_w	varchar(1);
qt_marc_medico_w		bigint;
cd_turno_w		varchar(1);
ie_encaixe_w		varchar(1);
nr_seq_obs_final_w	bigint;
ie_permite_w		varchar(1) := 'S';
ie_anestesia_w		varchar(1);
ie_carater_cirurgia_w		agenda_integrada_item.ie_carater_cirurgia%type;
cd_especialidade_w			bigint;
ie_classif_agenda_w		agenda_consulta.ie_classif_agenda%type;
ds_motivo_w			varchar(255);
ie_regra_w      agenda_integrada_item.ie_regra%type;
ie_glosa_w      agenda_integrada_item.ie_glosa%type;

ie_manter_livres_w	varchar(1);

C01 CURSOR FOR
	SELECT	cd_agenda,
			cd_medico_exec,
			cd_paciente,
			nm_paciente,
			ie_status_agenda,
			nr_minuto_duracao,
			dt_agenda,
			Ageint_Obter_Se_Turno_Medico(cd_pessoa_fisica_p, dt_agenda, cd_agenda, nm_usuario_p, ageint_obter_regra_medico(cd_agenda_w,cd_pessoa_fisica_p), cd_estabelecimento_p),
			nr_seq_agenda,
			cd_procedimento,
			ie_origem_proced,
			nr_seq_proc_interno,
			nr_seq_status_pac,
			nr_atendimento,
			cd_convenio,
			cd_turno,
			ie_encaixe,
			cd_especialidade,
			ie_classif_agenda,
			ds_motivo
	from	ageint_consulta_horarios
	where	dt_agenda between pkg_date_utils.start_of(dt_agenda_p, 'DD', 0) and pkg_date_utils.end_of(dt_agenda_p, 'DAY', 0)
	and		nm_usuario = nm_usuario_p;	


C02 CURSOR FOR
	SELECT	cd_agenda,
			cd_medico_exec,
			cd_paciente,
			nm_paciente,
			ie_status_agenda,
			nr_minuto_duracao,
			dt_agenda,
			Ageint_Obter_Se_Turno_Medico(cd_pessoa_fisica_p, dt_agenda, cd_agenda, nm_usuario_p, ageint_obter_regra_medico(cd_agenda_w,cd_pessoa_fisica_p), cd_estabelecimento_p),
			nr_seq_agenda,
			nr_atendimento,
			cd_convenio,
			cd_turno,
			ie_encaixe,
			cd_especialidade,
			ie_classif_agenda
	from	ageint_consulta_horarios
	where	dt_agenda between pkg_date_utils.start_of(dt_atual_w, 'DD', 0) and pkg_date_utils.end_of(dt_atual_w, 'DAY', 0)
	and		nm_usuario = nm_usuario_p;
	
C03 CURSOR FOR
	SELECT	a.cd_agenda
	FROM agenda a, agenda_paciente b
LEFT OUTER JOIN agenda_integrada_item c ON (b.nr_sequencia = c.nr_seq_agenda_exame)
WHERE a.cd_agenda						= b.cd_agenda  and a.ie_situacao 					= 'A' and coalesce(a.ie_agenda_integrada,'N') 	= 'S' and (a.cd_tipo_agenda = 2 and ie_tipo_agendamento_p = 'E') and a.cd_estabelecimento 	= cd_estabelecimento_p and ((a.cd_setor_exclusivo 	= cd_setor_exclusivo_p) or (c.nr_seq_grupo_selec = nr_seq_grupo_p))
	
union

	SELECT	a.cd_agenda
	FROM agenda a, agenda_consulta b
LEFT OUTER JOIN agenda_integrada_item c ON (b.nr_sequencia = c.nr_seq_agenda_cons)
WHERE a.cd_agenda						= b.cd_agenda  and a.ie_situacao = 'A' and coalesce(a.ie_agenda_integrada,'N') = 'S' and (a.cd_tipo_agenda = 3 and ie_tipo_agendamento_p = 'C') and a.cd_estabelecimento = cd_estabelecimento_p and ((a.cd_setor_exclusivo 	= cd_setor_exclusivo_p) or (c.nr_seq_grupo_selec = nr_seq_grupo_p))
	 
union

	select	a.cd_agenda
	FROM agenda a, agenda_consulta b
LEFT OUTER JOIN agenda_integrada_item c ON (b.nr_sequencia = c.nr_seq_agenda_cons)
WHERE a.cd_agenda						= b.cd_agenda  and a.ie_situacao = 'A' and coalesce(a.ie_agenda_integrada,'N') = 'S' and (a.cd_tipo_agenda = 5 and ie_tipo_agendamento_p = 'S') and a.cd_estabelecimento = cd_estabelecimento_p and ((a.cd_setor_exclusivo 	= cd_setor_exclusivo_p) or (c.nr_seq_grupo_selec = nr_seq_grupo_p));
	

BEGIN

ie_tipo_agendamento_w	:= ie_tipo_agendamento_p;
ie_apres_hr_medico_w := Obter_Param_Usuario(869, 157, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_apres_hr_medico_w);

/*
ie_forma_apres_p
	M	Mensal
	D	Diario
*/
delete	FROM ageint_consulta_horarios
where	nm_usuario	= nm_usuario_p;

if ((coalesce(cd_especialidade_p::text, '') = '') or (cd_especialidade_p = 0)) then
	delete	FROM ageint_consulta_hor_usu
	where	nm_usuario	= nm_usuario_p;
end if;

ds_sep_bv_w	:= obter_separador_bv;


if (coalesce(ie_tipo_agendamento_p::text, '') = '') then
	select	max(cd_tipo_agenda)
	into STRICT	cd_tipo_agenda_w
	from	agenda
	where	cd_agenda = cd_agenda_p;
	
	if (cd_tipo_agenda_w = 2) then
		ie_tipo_agendamento_w	:= 'E';
	elsif (cd_tipo_agenda_w = 3) then
		ie_tipo_agendamento_w	:= 'C';
	elsif (cd_tipo_agenda_w = 5) then
		ie_tipo_agendamento_w	:= 'S';
	end if;	
end if;

if (ie_tipo_agendamento_w	= 'E') then
	select	coalesce(max(ie_forma_excluir_exame),'N')
	into STRICT	ie_manter_livres_w
	from	parametro_agenda
	where	cd_estabelecimento	= cd_estabelecimento_p;
elsif (ie_tipo_agendamento_w	= 'C') then
	select	coalesce(max(ie_forma_excluir_consulta),'N')
	into STRICT	ie_manter_livres_w
	from	parametro_agenda
	where	cd_estabelecimento	= cd_estabelecimento_p;
elsif (ie_tipo_agendamento_w	= 'S') then
	select	coalesce(max(ie_forma_excluir_servico),'N')
	into STRICT	ie_manter_livres_w
	from	parametro_agenda
	where	cd_estabelecimento	= cd_estabelecimento_p;
end if;

if (ie_manter_livres_w = 'S') then
	if (ie_tipo_agendamento_w	= 'E') then
		ds_comando_w	:= (' begin ageint_gerar_consulta_ageexam2(:cd_estabelecimento, :cd_agenda, :dt_agenda, :nm_usuario); end; ');
	elsif (ie_tipo_agendamento_w	= 'C') then
		ds_comando_w	:= (' begin ageint_gerar_consulta_agecons2(:cd_estabelecimento, :cd_agenda, :dt_agenda, :nm_usuario); end; ');
	elsif (ie_tipo_agendamento_w	= 'S') then
		ds_comando_w	:= (' begin ageint_gerar_consulta_ageserv2(:cd_estabelecimento, :cd_agenda, :dt_agenda, :nm_usuario); end; ');
	end if;
else
	if (ie_tipo_agendamento_w	= 'E') then
		ds_comando_w	:= (' begin ageint_gerar_consulta_ageexam(:cd_estabelecimento, :cd_agenda, :dt_agenda, :nm_usuario); end; ');
	elsif (ie_tipo_agendamento_w	= 'C') then
		ds_comando_w	:= (' begin ageint_gerar_consulta_agecons(:cd_estabelecimento, :cd_agenda, :dt_agenda, :nm_usuario); end; ');
	elsif (ie_tipo_agendamento_w	= 'S') then
		ds_comando_w	:= (' begin ageint_gerar_consulta_ageserv(:cd_estabelecimento, :cd_agenda, :dt_agenda, :nm_usuario); end; ');
	end if;
end if;
if (ds_comando_w IS NOT NULL AND ds_comando_w::text <> '') then
	if (ie_forma_apres_p	= 'D') then
		if	((coalesce(cd_setor_exclusivo_p::text, '') = '') and (coalesce(nr_seq_grupo_p::text, '') = '')) then
			CALL exec_sql_dinamico_bv('AGEINT',ds_comando_w, 'cd_estabelecimento='|| cd_estabelecimento_p || ds_sep_bv_w ||
									'cd_agenda='|| cd_agenda_p || ds_sep_bv_w ||
									'dt_agenda='|| to_char(dt_agenda_p, 'dd/mm/yyyy') || ds_sep_bv_w ||
									'nm_usuario='|| nm_usuario_p || ds_sep_bv_w);
		else
			open C03;
			loop
			fetch C03 into	
				cd_agenda_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				CALL exec_sql_dinamico_bv('AGEINT',ds_comando_w, 'cd_estabelecimento='|| cd_estabelecimento_p || ds_sep_bv_w ||
									'cd_agenda='|| cd_agenda_w || ds_sep_bv_w ||
									'dt_agenda='|| to_char(dt_agenda_p, 'dd/mm/yyyy') || ds_sep_bv_w ||
									'nm_usuario='|| nm_usuario_p || ds_sep_bv_w);
				end;
			end loop;
			close C03;
		end if;
	else
		nr_dias_mes_w	:= pkg_date_utils.start_of(fim_mes(dt_agenda_p), 'DD', 0) - pkg_date_utils.start_of(dt_Agenda_p, 'MONTH', 0);
		dt_atual_w	:= pkg_date_utils.start_of(dt_Agenda_p, 'MONTH',0);
		
		while(dt_atual_w <= fim_mes(dt_agenda_p))loop
			begin
	
			CALL exec_sql_dinamico_bv('AGEINT',ds_comando_w, 'cd_estabelecimento='|| cd_estabelecimento_p || ds_sep_bv_w ||
							'cd_agenda='|| cd_agenda_p || ds_sep_bv_w ||
							'dt_agenda='|| to_char(dt_atual_w, 'dd/mm/yyyy') || ds_sep_bv_w ||
							'nm_usuario='|| nm_usuario_p|| ds_sep_bv_w);
			dt_atual_w	:= dt_atual_w + 1;
	
			end;
	
		end loop;
	end if;
end if;
if (ie_forma_apres_p = 'D') then
		
	open C01;
	loop
	fetch C01 into	
		cd_agenda_w,
		cd_medico_exec_w,                 
		cd_paciente_w,                    
		nm_paciente_w,                    
		ie_status_agenda_w,               
		nr_minuto_duracao_w,              
		dt_agenda_w,
		ie_turno_medico_w,
		nr_seq_agenda_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_seq_proc_interno_w,
		nr_seq_status_pac_w,
		nr_atendimento_w,
		cd_convenio_w,
		cd_turno_w,
		ie_encaixe_w,
		cd_especialidade_w,
		ie_classif_agenda_w,
		ds_motivo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		if (ie_tipo_agendamento_w	= 'E') then
			select	max(nr_seq_agenda_int),
					coalesce(max(ie_anestesia), 'N'),
					max(ie_carater_cirurgia),
          max(ie_regra),
          max(ie_glosa)
			into STRICT	nr_seq_agenda_int_w,
					ie_anestesia_w,
					ie_carater_cirurgia_w,
          ie_regra_w,
          ie_glosa_w
			from	agenda_integrada_item
			where	nr_seq_agenda_exame = nr_seq_agenda_w;
		else	
			select	max(nr_seq_agenda_int),
					coalesce(max(ie_anestesia), 'N'),
          max(ie_regra),
          max(ie_glosa)
			into STRICT	nr_seq_agenda_int_w,
					ie_anestesia_w,
          ie_regra_w,
          ie_glosa_w
			from	agenda_integrada_item
			where	nr_seq_agenda_cons  = nr_seq_agenda_w;
		end if;
		
		ie_permite_w	:= 'S';
		
		if (ie_tipo_agendamento_w	= 'E') then
			if	((nr_seq_area_p IS NOT NULL AND nr_seq_area_p::text <> '') or (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '')) then
				if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then					
					select	CASE WHEN coalesce(max(nr_seq_grupo_selec), 0)=0 THEN  'N'  ELSE 'S' END
					into STRICT	ie_permite_w
					from	agenda_integrada_item
					where	nr_seq_agenda_exame = nr_seq_agenda_w
					and		nr_seq_grupo_selec 	= nr_seq_grupo_p;
				else
					select	CASE WHEN coalesce(max(a.nr_seq_grupo_selec), 0)=0 THEN  'N'  ELSE 'S' END
					into STRICT	ie_permite_w
					from	agenda_integrada_item a,
							agenda_int_area b,
							agenda_int_grupo c
					where	a.nr_seq_grupo_selec 	= c.nr_sequencia
					and		c.nr_seq_area 			= b.nr_sequencia
					and		a.nr_seq_agenda_exame 	= nr_seq_agenda_w
					and		b.nr_sequencia 			= nr_seq_area_p;
					
				end if;
			end if;
		elsif	((nr_seq_area_p IS NOT NULL AND nr_seq_area_p::text <> '') or (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '')) then
			if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then
				select	CASE WHEN coalesce(max(nr_seq_grupo_selec), 0)=0 THEN  'N'  ELSE 'S' END
				into STRICT	ie_permite_w
				from	agenda_integrada_item
				where	nr_seq_agenda_cons 	= nr_seq_agenda_w
				and		nr_seq_grupo_selec 	= nr_seq_grupo_p;
			else				
				select	CASE WHEN coalesce(max(a.nr_seq_grupo_selec), 0)=0 THEN  'N'  ELSE 'S' END
				into STRICT	ie_permite_w
				from	agenda_integrada_item a,
						agenda_int_area b,
						agenda_int_grupo c
				where	a.nr_seq_grupo_selec 	= c.nr_sequencia
				and		c.nr_seq_area 			= b.nr_sequencia
				and		nr_seq_agenda_cons 		= nr_seq_agenda_w
				and		b.nr_sequencia 			= nr_seq_area_p;
			end if;
		end if;
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_obs_final_w
		from	ageint_observacao_final
		where	nr_seq_ageint = nr_seq_agenda_int_w;
		
		select	max(ds_observacao)
		into STRICT	ds_observacao_final_w
		from	ageint_observacao_final
		where	nr_sequencia = nr_seq_obs_final_w;
		
		select	max(cd_setor_exclusivo)
		into STRICT	cd_setor_atendimento_w
		from	agenda
		where	cd_agenda = cd_agenda_w;
		
		if (ie_apres_hr_medico_w = 'N') and (cd_medico_exec_w IS NOT NULL AND cd_medico_exec_w::text <> '') and (ie_status_agenda_w = 'L') then
			
			SELECT	coalesce(COUNT(*), 0)
			INTO STRICT	qt_marc_medico_w
			FROM	ageint_marcacao_usuario
			WHERE	cd_pessoa_fisica	= coalesce(cd_medico_exec_w, cd_pessoa_fisica_p)
			and		hr_agenda 			between pkg_date_utils.start_of(dt_agenda_w, 'DD', 0) and pkg_date_utils.end_of(dt_agenda_w, 'DAY', 0)
			AND		(dt_agenda_w 		+ nr_minuto_duracao_w / 1440 between (dt_agenda_w  + (1 / 1440)) and (hr_agenda + (nr_minuto_duracao - 1) /1440)
			or		(dt_agenda_w		between hr_agenda and (hr_Agenda + (nr_minuto_duracao - 1) /1440)))
			and		cd_agenda			<> cd_agenda_w;
			
			if (qt_marc_medico_w = 0)then
				SELECT	coalesce(COUNT(*), 0)
				INTO STRICT	qt_marc_medico_w
				FROM	agenda_paciente
				WHERE	cd_medico_exec		= coalesce(cd_medico_exec_w, cd_pessoa_fisica_p)
				and		hr_inicio 			between pkg_date_utils.start_of(dt_agenda_w, 'DD', 0) and pkg_date_utils.end_of(dt_agenda_w, 'DAY', 0)
				AND		(dt_agenda_w 		+ nr_minuto_duracao_w / 1440 between (dt_agenda_w  + (1 / 1440)) and (hr_inicio + (nr_minuto_duracao - 1) /1440)
				or		(dt_agenda_w		between hr_inicio and (hr_inicio + (nr_minuto_duracao - 1) /1440)))
				and		cd_agenda			<> cd_agenda_w
				and		ie_status_agenda	not in ('C', 'L', 'F', 'I', 'II', 'R', 'B');			
			end if;
			
		else
			qt_marc_medico_w	:= 0;				
		end if;
		
		if	((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '' AND ie_turno_medico_w = 'S') or (coalesce(cd_pessoa_fisica_p,'0') = '0')) and (qt_marc_medico_w = 0) and
			((cd_medico_exec_w = cd_pessoa_fisica_p) or (cd_pessoa_fisica_p = '0')) and (ie_permite_w = 'S')	then
			
			insert into ageint_consulta_hor_usu(
								dt_atualizacao,
								nm_usuario,
								cd_agenda,
								cd_medico_exec,
								cd_paciente,
								nm_paciente,
								ie_status_agenda,
								nr_minuto_duracao,
								dt_agenda,
								nr_seq_agenda,
								cd_procedimento,
								nr_seq_proc_interno,
								ie_origem_proced,
								cd_setor_atendimento,
								nr_seq_status_pac,
								ds_observacao_final,
								nr_atendimento,
								cd_convenio,
								cd_turno,
								ie_encaixe,
								nr_seq_ageint,
								ie_anestesia,
								ie_carater_cirurgia,
								cd_especialidade,
								ie_classif_agenda,
								ds_motivo,
                ie_regra,
                ie_glosa)
							values (clock_timestamp(),
								nm_usuario_p,
								cd_agenda_w,
								cd_medico_exec_w,
								cd_paciente_w,
								nm_paciente_w,
								ie_status_agenda_w,
								nr_minuto_duracao_w,
								dt_agenda_w,
								nr_seq_agenda_w,
								cd_procedimento_w,
								nr_seq_proc_interno_w,
								ie_origem_proced_w,
								cd_setor_atendimento_w,
								nr_seq_status_pac_w,
								ds_observacao_final_w,
								nr_atendimento_w,
								cd_convenio_w,
								cd_turno_w,
								ie_encaixe_w,
								nr_seq_agenda_int_w,
								ie_anestesia_w,
								ie_carater_cirurgia_w,
								cd_especialidade_w,
								ie_classif_agenda_w,
								ds_motivo_w,
                ie_regra_w,
                ie_glosa_w);
		end if;		
		end;
	end loop;
	close C01;

elsif (ie_forma_apres_p = 'M') then

	dt_atual_w	:= pkg_date_utils.start_of(dt_agenda_p, 'MONTH', 0);

	while(dt_atual_w <= fim_mes(dt_agenda_p))loop
		begin

		open C02;
		loop
		fetch C02 into	
			cd_agenda_w,
			cd_medico_exec_w,
			cd_paciente_w, 
			nm_paciente_w,
			ie_status_agenda_w,
			nr_minuto_duracao_w,
			dt_agenda_w,
			ie_turno_medico_w,
			nr_seq_agenda_w,
			nr_atendimento_w,
			cd_convenio_w,
			cd_turno_w,
			ie_encaixe_w,
			cd_especialidade_w,
			ie_classif_agenda_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			if	((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '' AND ie_turno_medico_w = 'S') or (coalesce(cd_pessoa_fisica_p,'0') = '0')) then

        select	max(ie_regra),
            max(ie_glosa)
        into STRICT  ie_regra_w,
            ie_glosa_w
        from	agenda_integrada_item
        where	nr_seq_agenda_cons  = nr_seq_agenda_w;

			insert into ageint_consulta_hor_usu(	dt_atualizacao,
								nm_usuario,
								cd_agenda,
								cd_medico_exec,
								cd_paciente,
								nm_paciente,
								ie_status_agenda,
								nr_minuto_duracao,
								dt_agenda,
								nr_seq_agenda,
								nr_atendimento,
								cd_convenio,
								cd_turno,
								ie_encaixe,
								nr_seq_ageint,
								cd_especialidade,
								ie_classif_agenda,
                ie_regra,
                ie_glosa)
							values (clock_timestamp(),
								nm_usuario_p,
								cd_agenda_w,
								cd_medico_exec_w,
								cd_paciente_w,
								nm_paciente_w,
								ie_status_agenda_w,
								nr_minuto_duracao_w,
								dt_agenda_w,
								nr_seq_agenda_w,
								nr_atendimento_w,
								cd_convenio_w,
								cd_turno_w,
								ie_encaixe_w,
								nr_seq_agenda_int_w,
								cd_especialidade_w,
								ie_classif_agenda_w,
                ie_regra_w,
                ie_glosa_w);
			end if;

			end;
		end loop;
		close C02;

		dt_atual_w	:= dt_atual_w + 1;
		end;
	end loop;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_consulta_horarios ( cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_agenda_p timestamp, ie_forma_apres_p text, ie_tipo_agendamento_p text, cd_setor_exclusivo_p bigint, cd_estabelecimento_p bigint, nr_seq_area_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_especialidade_p bigint) FROM PUBLIC;

