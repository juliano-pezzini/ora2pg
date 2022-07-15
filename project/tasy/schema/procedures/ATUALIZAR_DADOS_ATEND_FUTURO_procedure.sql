-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_atend_futuro (nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
dt_entrada_w			timestamp;
cd_setor_atendimento_w		integer;
cd_parametro_status_w		bigint;
ie_atualiza_setor_prescr_w	varchar(1);
dt_primeiro_hor_w		timestamp;
cd_setor_ant_prescr_w		integer;
cd_tipo_agenda_w		bigint;

BEGIN
cd_parametro_status_w := obter_param_usuario(10000, 7, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, cd_parametro_status_w);
ie_atualiza_setor_prescr_w := obter_param_usuario(10000, 33, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_atualiza_setor_prescr_w);

if (coalesce(nr_sequencia_p,0) > 0) and (coalesce(nr_atendimento_p,0) > 0) then
	
	cd_setor_atendimento_w := obter_setor_atendimento(nr_atendimento_p);
	
	select	dt_entrada
	into STRICT	dt_entrada_w
	from	atendimento_paciente
	where	nr_atendimento 	= nr_atendimento_p;
	
	update	atend_pac_futuro
	set	nr_atendimento 	= nr_atendimento_p
	where	nr_sequencia 	= nr_sequencia_p;
	
	if (cd_parametro_status_w <> 0) then
		update	atend_pac_futuro
		set	nr_seq_status = cd_parametro_status_w
		where	nr_sequencia  =  nr_sequencia_p;
	end if;
	
	update	sus_laudo_paciente
	set	nr_atendimento		= nr_atendimento_p
	where	nr_seq_atend_futuro 	= nr_sequencia_p;
	
	dt_primeiro_hor_w := to_date(to_char(Obter_Prim_Horario_Prescricao(nr_atendimento_p,cd_setor_atendimento_w,dt_entrada_w,nm_usuario_p,'R')
				,'dd/mm/yyyy') ||' '||to_char(obter_prim_hor_setor(cd_setor_atendimento_w),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
	
	select	max(cd_setor_atendimento)
	into STRICT	cd_setor_ant_prescr_w
	from	prescr_medica
	where	nr_seq_atend_futuro = nr_sequencia_p;
	
	update	prescr_medica
	set	nr_atendimento		= nr_atendimento_p,
		dt_prescricao		= dt_entrada_w,
		dt_primeiro_horario	= dt_primeiro_hor_w
		--cd_setor_atendimento    = decode(ie_atualiza_setor_prescr_w,'S',nvl(cd_setor_atendimento_w,cd_setor_atendimento),cd_setor_atendimento)
	where	nr_seq_atend_futuro 	= nr_sequencia_p;
	
	if (ie_atualiza_setor_prescr_w = 'S') then
		CALL Atualizar_setor_prescricao(nr_atendimento_p,cd_setor_atendimento_w,cd_setor_ant_prescr_w,nm_usuario_p);
		CALL Atualizar_turno_hor_prescr(nr_atendimento_p,cd_setor_atendimento_w,wheb_usuario_pck.get_cd_estabelecimento,nm_usuario_p);		
		CALL gerar_ajustes_ap_lote('M',nr_atendimento_p,nm_usuario_p);		
	end if;	
	
	select cd_tipo_agenda
	into STRICT cd_tipo_agenda_w
	from atend_pac_futuro
	where nr_sequencia = nr_sequencia_p;
	
	if (cd_tipo_agenda_w in (1,2)) then
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_sequencia_w
		from	agenda_paciente
		where	nr_seq_atend_futuro 	= nr_sequencia_p;
			
		if (nr_sequencia_w > 0) then
			update	agenda_paciente
			set	nr_atendimento 	= nr_atendimento_p
			where	nr_sequencia	= nr_sequencia_w;
		end if;	
	else
		select	coalesce(max(nr_seq_agenda),0)
		into STRICT	nr_sequencia_w
		from	agenda_consulta_adic
		where	nr_seq_atend_futuro 	= nr_sequencia_p;
			
		if (nr_sequencia_w > 0) then
			update	agenda_consulta
			set	nr_atendimento 	= nr_atendimento_p
			where	nr_sequencia	= nr_sequencia_w;
		end if;	

	end if;
		
end if;
commit;	
	
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_atend_futuro (nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

