-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_regra_agenda_cirurgica ( nr_sequencia_p bigint, lista_agenda_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

					
lista_agenda_w		varchar(2000);	
cd_agenda_w		bigint;
ie_contador_w		bigint:= 0;
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
ie_rastrear_origem_w	varchar(1);
				
				

BEGIN

ie_rastrear_origem_w := Obter_Param_Usuario(871, 541, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_rastrear_origem_w);

lista_agenda_w	:= lista_agenda_p;

while	(lista_agenda_w IS NOT NULL AND lista_agenda_w::text <> '') or
	ie_contador_w > 200 loop
	begin
	tam_lista_w		:= length(lista_agenda_w);
	ie_pos_virgula_w	:= position(',' in lista_agenda_w);
	
	if (ie_pos_virgula_w <> 0) then
		cd_agenda_w 	:= substr(lista_agenda_w,1,(ie_pos_virgula_w - 1));
		lista_agenda_w	:= substr(lista_agenda_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;
	
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_agenda_w IS NOT NULL AND cd_agenda_w::text <> '') then
		insert	into	agenda_regra(nr_sequencia,
			cd_estabelecimento,
			cd_agenda,
			dt_atualizacao,
			nm_usuario,
			ie_permite,
			cd_convenio,
			cd_area_proc,
			cd_especialidade,
			cd_grupo_proc,
			cd_procedimento,
			ie_origem_proced,
			cd_medico,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_proc_interno,
			nr_seq_regra,
			cd_municipio_ibge,
			qt_regra,
			nr_seq_grupo,
			nr_seq_forma_org,
			nr_seq_subgrupo,
			nr_seq_classif_agenda,
			cd_categoria,
			ie_forma_consistencia,
			ie_medico,
			cd_perfil,
			cd_plano_convenio,
			nr_seq_turno,
			dt_inicio_agenda,
			dt_fim_agenda,
			ie_dia_semana,
			ie_turno,
			qt_horas_ant_agenda,
			nr_seq_equipe,
			nm_regra,
			nr_seq_agenda_regra,
			ds_mensagem,
			hr_inicio,
			hr_fim,
			ie_validar_dias_semana,
			ie_agenda)
			SELECT	nextval('agenda_regra_seq'),
				cd_estabelecimento,
				cd_agenda_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_permite,
				cd_convenio,
				cd_area_proc,
				cd_especialidade,
				cd_grupo_proc,
				cd_procedimento,
				ie_origem_proced,
				cd_medico,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_interno,
				nr_seq_regra,
				cd_municipio_ibge,
				qt_regra,
				nr_seq_grupo,
				nr_seq_forma_org,
				nr_seq_subgrupo,
				nr_seq_classif_agenda,
				cd_categoria,
				ie_forma_consistencia,
				ie_medico,
				cd_perfil,
				cd_plano_convenio,
				nr_seq_turno,
				dt_inicio_agenda,
				dt_fim_agenda,
				ie_dia_semana,
				ie_turno,
				qt_horas_ant_agenda,
				nr_seq_equipe,
				nm_regra,
				CASE WHEN ie_rastrear_origem_w='S' THEN nr_sequencia_p  ELSE null END ,
				ds_mensagem,
				hr_inicio,
				hr_fim,
				ie_validar_dias_semana,
				ie_agenda
			from 	agenda_regra
			where	nr_sequencia = 	nr_sequencia_p;
	commit;			
	end if;	
	ie_contador_w	:= ie_contador_w + 1;
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_regra_agenda_cirurgica ( nr_sequencia_p bigint, lista_agenda_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

