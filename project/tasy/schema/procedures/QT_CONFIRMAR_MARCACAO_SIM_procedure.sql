-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_confirmar_marcacao_sim ( nr_seq_pac_sim_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_atendimento_w	bigint;
nr_seq_paciente_w	bigint;
cd_pessoa_fisica_w	varchar(10);
dt_agenda_w		timestamp;
nr_seq_local_w		bigint;
nr_duracao_w		bigint;
nr_seq_marcacao_w	bigint;
nr_seq_prof_W		bigint;
ie_tipo_agendamento_w	varchar(15);
nr_ciclo_w		smallint;
ie_gera_autorizacao_w	varchar(1);
cd_estabelecimento_w	smallint;
ds_observacao_w		varchar(255);
nr_seq_Agenda_w		bigint;
cd_medico_resp_w	varchar(10);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_agenda,
		nr_seq_local,
		nr_duracao,
		nr_seq_prof,
		ie_tipo_agendamento,
		ds_observacao
	from	agenda_quimio_marcacao
	where	nr_seq_paciente	= nr_seq_pac_sim_p
	and	ie_gerado	= 'N';

C02 CURSOR FOR
	SELECT	distinct nr_seq_paciente,
		nr_ciclo
	from	paciente_atendimento_sim
	where	nr_seq_paciente	= nr_seq_pac_sim_p;


BEGIN
select	max(a.cd_pessoa_Fisica),
	max(a.cd_estabelecimento)
into STRICT	cd_pessoa_fisica_w,
	cd_estabelecimento_w
from	paciente_setor_sim a,
	paciente_atendimento_sim b
where	b.nr_seq_paciente	= nr_seq_pac_sim_p
and	a.nr_sequencia	= b.nr_seq_paciente;

ie_gera_autorizacao_w := obter_param_usuario(865, 6, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_autorizacao_w);

open C01;
loop
fetch C01 into
	nr_seq_marcacao_w,
	dt_agenda_w,
	nr_seq_local_w,
	nr_duracao_w,
	nr_seq_prof_w,
	ie_tipo_agendamento_w,
	ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_atendimento_w
	from	paciente_atendimento_sim a,
		paciente_setor_sim b
	where	a.nr_seq_paciente	= b.nr_sequencia
	and	a.nr_seq_paciente	= nr_seq_pac_sim_p
	and	trunc(coalesce(a.dt_real, a.dt_prevista))		= trunc(dt_agenda_w);

	select	nextval('agenda_quimio_seq')
	into STRICT	nr_seq_Agenda_w
	;

	insert into agenda_quimio(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_fisica,
		nr_seq_prof,
		nr_seq_local,
		nr_seq_atend_sim,
		nr_minuto_duracao,
		dt_agenda,
		ie_tipo_pend_agenda,
		ie_status_agenda,
		ie_tipo_agendamento,
		ds_observacao,
		cd_estabelecimento,
		cd_medico_resp)
	values (nr_seq_Agenda_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica_w,
		nr_seq_prof_w,
		nr_seq_local_w,
		nr_seq_atendimento_w,
		nr_duracao_w,
		dt_agenda_w,
		'S',
		'N',
		ie_tipo_agendamento_w,
		ds_observacao_w,
		cd_estabelecimento_p,
		cd_medico_resp_w);

	update	paciente_atendimento_sim
	set	dt_real		= dt_agenda_w,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	--	nr_seq_local	= nr_seq_local_w
	where	nr_seq_paciente	= nr_seq_pac_sim_p
	and	trunc(coalesce(dt_real,dt_prevista))	= trunc(dt_agenda_w);

	update	agenda_quimio_marcacao
	set	ie_gerado	= 'S'
	where	nr_sequencia	= nr_seq_marcacao_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_confirmar_marcacao_sim ( nr_seq_pac_sim_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

