-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplica_agenda_horario (cd_agenda_p bigint, dt_dia_semana_p bigint, nm_usuario_p text, ie_preferencias_horario_p text default 'N', ie_classif_liberadas_p text default 'N', ie_regras_convenio_turno_p text default 'N', ie_regra_turno_usuario_p text default 'N') AS $body$
DECLARE



nr_seq_turno_origem_w	agenda_horario.nr_sequencia%type;
nr_seq_turno_destino_w	agenda_horario.nr_sequencia%type;


C01 CURSOR FOR
SELECT	nr_sequencia
from	agenda_horario
where	cd_agenda = cd_agenda_p
  and	dt_dia_semana = dt_dia_semana_p
  and	not exists (SELECT dt_dia_semana
		 from agenda_horario
		 where cd_agenda      = cd_agenda_p
		   and dt_dia_semana  = CASE WHEN dt_dia_semana=7 THEN  1  ELSE DT_DIA_SEMANA + 1 END );



BEGIN

open C01;
loop
fetch C01 into
	nr_seq_turno_origem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

begin

	select	nextval('agenda_horario_seq')
	into STRICT	nr_seq_turno_destino_w
	from	agenda_horario LIMIT 1;

	insert into agenda_horario(cd_agenda,
			dt_dia_semana,
			hr_inicial,
			hr_final,
			nr_minuto_intervalo,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			hr_inicial_intervalo,
			hr_final_intervalo,
			ds_observacao,
			dt_final_vigencia,
			cd_medico,
			nr_seq_medico_exec,
			nr_seq_sala,
			dt_inicio_vigencia,
			nr_sequencia,
			ie_frequencia,
			nr_prioridade,
			nr_seq_classif_agenda,
			nr_seq_proc_interno,
			cd_procedencia,
			cd_convenio,
			cd_categoria,
			nr_seq_transporte,
			ie_forma_agendamento,
			ie_lado,
			ie_tipo_atendimento,
			qt_idade_min,
			qt_idade_max,
			qt_encaixe,
			ie_feriado,
			ie_semana,
			ds_observacao_adic,
			ie_turno_agendamento_grupo)
	(SELECT cd_agenda_p,
			CASE WHEN dt_dia_semana=7 THEN  1 WHEN dt_dia_semana=9 THEN  dt_dia_semana  ELSE dt_dia_semana + 1 END ,
			hr_inicial,
			hr_final,
			nr_minuto_intervalo,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			hr_inicial_intervalo,
			hr_final_intervalo,
			ds_observacao,
			dt_final_vigencia,
			cd_medico,
			nr_seq_medico_exec,
			nr_seq_sala,
			dt_inicio_vigencia,
			nr_seq_turno_destino_w,
			ie_frequencia,
			nr_prioridade,
			nr_seq_classif_agenda,
			nr_seq_proc_interno,
			cd_procedencia,
			cd_convenio,
			cd_categoria,
			nr_seq_transporte,
			ie_forma_agendamento,
			ie_lado,
			ie_tipo_atendimento,
			qt_idade_min,
			qt_idade_max,
			qt_encaixe,
			ie_feriado,
			ie_semana,
			ds_observacao_adic,
			ie_turno_agendamento_grupo
	from 	agenda_horario
	where	nr_sequencia = nr_seq_turno_origem_w);


	if (ie_preferencias_horario_p = 'S') then

		insert into agenda_horario_pref(cd_perfil,
				dt_atualizacao,
				dt_atualizacao_nrec,
				dt_final_vigencia,
				dt_inicio_vigencia,
				hr_final,
				hr_inicial,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_horario,
				nr_seq_preferencia,
				nr_seq_turno,
				nr_sequencia)
		(SELECT	cd_perfil,
				clock_timestamp(),
				clock_timestamp(),
				dt_final_vigencia,
				dt_inicio_vigencia,
				hr_final,
				hr_inicial,
				nm_usuario_p,
				nm_usuario_p,
				nr_seq_turno_destino_w,
				nr_seq_preferencia,
				nr_seq_turno,
				nextval('agenda_horario_pref_seq')
		from	agenda_horario_pref
		where	nr_seq_horario = nr_seq_turno_origem_w);

	end if;

	if (ie_classif_liberadas_p = 'S') then

		insert into agenda_turno_classif_lib(dt_atualizacao,
				dt_atualizacao_nrec,
				ie_classif_agenda,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_classif_agenda,
				nr_seq_hor_esp,
				nr_seq_horario,
				nr_seq_turno,
				nr_seq_turno_esp,
				nr_sequencia)
		(SELECT	clock_timestamp(),
				clock_timestamp(),
				ie_classif_agenda,
				nm_usuario_p,
				nm_usuario_p,
				nr_seq_classif_agenda,
				nr_seq_hor_esp,
				nr_seq_turno_destino_w,
				nr_seq_turno,
				nr_seq_turno_esp,
				nextval('agenda_turno_classif_lib_seq')
		from	agenda_turno_classif_lib
		where	nr_seq_horario = nr_seq_turno_origem_w);

	end if;

	if (ie_regras_convenio_turno_p = 'S') then

		insert into agenda_regra(cd_agenda,
				cd_area_proc,
				cd_categoria,
				cd_convenio,
				cd_empresa_ref,
				cd_especialidade,
				cd_estabelecimento,
				cd_grupo_proc,
				cd_medico,
				cd_municipio_ibge,
				cd_perfil,
				cd_plano_convenio,
				cd_procedimento,
				ds_mensagem,
				dt_atualizacao,
				dt_atualizacao_nrec,
				dt_fim_agenda,
				dt_fim_vigencia,
				dt_inicio_agenda,
				dt_inicio_vigencia,
				hr_fim,
				hr_inicio,
				ie_agenda,
				ie_consiste_final,
				ie_consiste_qtd_hora,
				ie_convenio_qtd,
				ie_estrutura_qtd,
				ie_forma_consistencia,
				ie_medico,
				ie_permite,
				ie_situacao,
				ie_somente_anestesia,
				ie_somente_mesmo_grupo,
				ie_tipo_convenio,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_proc_interno,
				nr_seq_turno,
				nr_sequencia,
				qt_idade_max,
				qt_idade_min,
				qt_regra)
		(SELECT cd_agenda,
				cd_area_proc,
				cd_categoria,
				cd_convenio,
				cd_empresa_ref,
				cd_especialidade,
				cd_estabelecimento,
				cd_grupo_proc,
				cd_medico,
				cd_municipio_ibge,
				cd_perfil,
				cd_plano_convenio,
				cd_procedimento,
				ds_mensagem,
				clock_timestamp(),
				clock_timestamp(),
				dt_fim_agenda,
				dt_fim_vigencia,
				dt_inicio_agenda,
				dt_inicio_vigencia,
				hr_fim,
				hr_inicio,
				ie_agenda,
				ie_consiste_final,
				ie_consiste_qtd_hora,
				ie_convenio_qtd,
				ie_estrutura_qtd,
				ie_forma_consistencia,
				ie_medico,
				ie_permite,
				ie_situacao,
				ie_somente_anestesia,
				ie_somente_mesmo_grupo,
				ie_tipo_convenio,
				nm_usuario_p,
				nm_usuario_p,
				nr_seq_proc_interno,
				nr_seq_turno_destino_w,
				nextval('agenda_regra_seq'),
				qt_idade_max,
				qt_idade_min,
				qt_regra
		from	agenda_regra
		where	nr_seq_turno = nr_seq_turno_origem_w);

	end if;

	if (ie_regra_turno_usuario_p = 'S') then

		insert into agenda_horario_permissao(cd_agenda,
				cd_pessoa_fisica,
				dt_atualizacao,
				dt_atualizacao_nrec,
				ie_situacao,
				nm_usuario,
				nm_usuario_nrec,
				nr_seq_horario,
				nr_sequencia)
		(SELECT	cd_agenda,
				cd_pessoa_fisica,
				clock_timestamp(),
				clock_timestamp(),
				ie_situacao,
				nm_usuario_p,
				nm_usuario_p,
				nr_seq_turno_destino_w,
				nextval('agenda_horario_permissao_seq')
		from	agenda_horario_permissao
		where	nr_seq_horario = nr_seq_turno_origem_w);

	end if;

end;
end loop;
close C01;

commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplica_agenda_horario (cd_agenda_p bigint, dt_dia_semana_p bigint, nm_usuario_p text, ie_preferencias_horario_p text default 'N', ie_classif_liberadas_p text default 'N', ie_regras_convenio_turno_p text default 'N', ie_regra_turno_usuario_p text default 'N') FROM PUBLIC;
