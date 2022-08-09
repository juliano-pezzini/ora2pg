-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_turno_periodo_ageserv (cd_agenda_p bigint, ie_frequencia_p text, ie_dia_semana_p bigint, hr_inicial_p text, hr_final_p text, nr_min_duracao_p bigint, cd_classificacao_p text, qt_classif_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_medico_exec_p text, cd_medico_solic_p text, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, qt_idade_min_p bigint default null, qt_idade_max_p bigint default null) AS $body$
DECLARE


dt_atual_w	timestamp;
hr_final_w	timestamp;
nr_seq_turno_w	bigint;	
nr_seq_classif_w	bigint;			
				

BEGIN

begin
dt_atual_w	:= to_date('30/12/1899'|| ' ' || hr_inicial_p,'dd/mm/yyyy hh24:mi:ss');
hr_final_w	:= to_date('30/12/1899'|| ' ' || hr_final_p,'dd/mm/yyyy hh24:mi:ss');
exception
when others then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262527);
end;

if (qt_classif_p > 0) and (nr_min_duracao_p > 0) then

	while(dt_atual_w < hr_final_w) loop
		begin
		
		select	 nextval('agenda_turno_seq')
		into STRICT	nr_seq_turno_w
		;
			
		insert into agenda_turno(nr_sequencia,
					cd_agenda,
					ie_dia_semana,
					hr_inicial,             
					hr_final,               
					nr_minuto_intervalo,
					nm_usuario,     
					dt_atualizacao,
					ie_encaixe,
					ie_frequencia,
					qt_total_turno,
					dt_inicio_vigencia,
					dt_final_vigencia,
          qt_idade_min,
          qt_idade_max)
				values	(nr_seq_turno_w,
					cd_agenda_p,
					ie_dia_semana_p,
					dt_atual_w,
					dt_atual_w + (nr_min_duracao_p/1440),
					nr_min_duracao_p,
					nm_usuario_p,
					clock_timestamp(),
					'N',
					ie_frequencia_p,
					0,
					dt_inicio_vigencia_p,
					dt_final_vigencia_p,
          qt_idade_min_p,
          qt_idade_max_p);
		
		select	nextval('agenda_turno_classif_seq')
		into STRICT	nr_seq_classif_w
		;
		
		insert into agenda_turno_classif(nr_sequencia,
						 nr_seq_turno,           
						 cd_classificacao,       
						 dt_atualizacao,         
						 nm_usuario,             
						 qt_classif,
						 ie_gera_feriado,
						 cd_medico,
						 cd_medico_solic)
					values (nr_seq_classif_w,
						nr_seq_turno_w,
						cd_classificacao_p,
						clock_timestamp(),
						nm_usuario_p,
						qt_classif_p,
						'S',
						cd_medico_exec_p,
						cd_medico_solic_p);
		
		dt_atual_w	:= dt_atual_w + (nr_min_duracao_p/1440);
		
		end;
	end loop;

	commit;
end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_turno_periodo_ageserv (cd_agenda_p bigint, ie_frequencia_p text, ie_dia_semana_p bigint, hr_inicial_p text, hr_final_p text, nr_min_duracao_p bigint, cd_classificacao_p text, qt_classif_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_medico_exec_p text, cd_medico_solic_p text, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, qt_idade_min_p bigint default null, qt_idade_max_p bigint default null) FROM PUBLIC;
