-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_rep_gerar_jejum ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_funcao_origem_p funcao.cd_funcao%type, cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null) AS $body$
DECLARE

					
ds_evento_w				rep_jejum.ds_evento%type;
ds_observacao_w			rep_jejum.ds_observacao%type;
dt_evento_w				rep_jejum.dt_evento%type;
dt_fim_w				rep_jejum.dt_fim%type;
dt_inicio_w				rep_jejum.dt_inicio%type;
ie_inicio_w				rep_jejum.ie_inicio%type;
nr_seq_objetivo_w		rep_jejum.nr_seq_objetivo%type;
nr_seq_tipo_w			rep_jejum.nr_seq_tipo%type;
nr_seq_jejum_w			rep_jejum.nr_sequencia%type;
qt_hora_ant_w			rep_jejum.qt_hora_ant%type;
qt_hora_depois_w		rep_jejum.qt_hora_depois%type;
qt_min_ant_w			rep_jejum.qt_min_ant%type;
qt_min_depois_w			rep_jejum.qt_min_depois%type;

nr_sequencia_w			cpoe_dieta.nr_sequencia%type;
ie_duracao_w			cpoe_dieta.ie_duracao%type;
cd_perfil_ativo_w		rep_jejum.cd_perfil_ativo%type;

ie_retrogrado_w			prescr_medica.ie_prescr_emergencia%type;
dt_liberacao_enf_w		timestamp;
nm_usuario_lib_enf_w	prescr_medica.nm_usuario_lib_enf%type;
cd_medico_w				prescr_medica.cd_medico%type;

c01 CURSOR FOR
SELECT	ds_evento,
		ds_observacao,
		dt_evento,
		dt_fim,
		dt_inicio,
		ie_inicio,
		nr_seq_objetivo,
		nr_seq_tipo,
		nr_sequencia,
		qt_hora_ant,
		qt_hora_depois,
		qt_min_ant,
		qt_min_depois,
		cd_perfil_ativo
from	rep_jejum
where	nr_prescricao = nr_prescricao_p;


BEGIN

select 	max(coalesce(ie_prescr_emergencia,'N')),
		max(dt_liberacao),
		max(nm_usuario_lib_enf),
		max(cd_medico)
into STRICT	ie_retrogrado_w,
		dt_liberacao_enf_w,
		nm_usuario_lib_enf_w,
		cd_medico_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

open c01;
loop
fetch c01 into	ds_evento_w,
				ds_observacao_w,
				dt_evento_w,
				dt_fim_w,
				dt_inicio_w,
				ie_inicio_w,
				nr_seq_objetivo_w,
				nr_seq_tipo_w,
				nr_seq_jejum_w,
				qt_hora_ant_w,
				qt_hora_depois_w,
				qt_min_ant_w,
				qt_min_depois_w,
				cd_perfil_ativo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	ie_duracao_w := 'P';
	if (ie_inicio_w = 'C') then
		ie_duracao_w := 'R';
	end if;
	
	
	select	nextval('cpoe_dieta_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into cpoe_dieta(
				nr_sequencia,
				nr_atendimento,
				ie_tipo_dieta,
				ie_administracao,
				ie_duracao,
				ds_evento,
				ds_observacao,
				dt_evento,
				dt_liberacao,
				dt_fim,
				dt_inicio,
				dt_prox_geracao,
				ie_inicio,
				nr_seq_objetivo,
				nr_seq_tipo,
				qt_hora_ant,
				qt_hora_depois,
				qt_min_ant,
				qt_min_depois,
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_atualizacao_nrec,
				cd_perfil_ativo,
				cd_pessoa_fisica,
				cd_funcao_origem,
				cd_setor_atendimento,
				ie_retrogrado,
				dt_liberacao_enf,
				nm_usuario_lib_enf,
				cd_medico)
			values (
				nr_sequencia_w,
				nr_atendimento_p,
				'J',
				'P',
				ie_duracao_w,
				ds_evento_w,
				ds_observacao_w,
				dt_evento_w,
				dt_liberacao_p,
				coalesce(dt_fim_w,dt_validade_prescr_p),
				coalesce(dt_inicio_w,dt_inicio_prescr_p),
				dt_inicio_w +12/24,
				ie_inicio_w ,
				nr_seq_objetivo_w,
				nr_seq_tipo_w,
				qt_hora_ant_w,
				qt_hora_depois_w,
				qt_min_ant_w,
				qt_min_depois_w,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				cd_perfil_ativo_w,
				cd_pessoa_fisica_p,
				cd_funcao_origem_p,
				cd_setor_atendimento_p,
				ie_retrogrado_w,
				dt_liberacao_enf_w,
				nm_usuario_lib_enf_w,
				cd_medico_w);

	update	rep_jejum
	set		nr_seq_dieta_cpoe = nr_sequencia_w
	where	nr_sequencia = nr_seq_jejum_w
	and		nr_prescricao = nr_prescricao_p;
	
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_rep_gerar_jejum ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_inicio_prescr_p timestamp, dt_validade_prescr_p timestamp, dt_liberacao_p timestamp, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, cd_funcao_origem_p funcao.cd_funcao%type, cd_setor_atendimento_p prescr_medica.cd_setor_atendimento%type default null) FROM PUBLIC;

