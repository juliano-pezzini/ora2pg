-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_protocolo_sae_cirurgia ( nr_seq_protocolo_p bigint, nr_seq_subtipo_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_cirurgia_p bigint, cd_prescritor_p text, nr_horas_validade_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

					
ie_prim_hor_sae_w	varchar(15);
ie_estender_w		varchar(15);
cd_setor_atendimento_w	integer;
nr_seq_subtipo_w	bigint;
nr_sequencia_w		bigint;
nr_seq_proc_w		bigint;
ie_prox_hor_setor_w	varchar(15);
dt_primeiro_horario_w	timestamp;
dt_prescricao_w		timestamp;
dt_inicio_prescr_w	timestamp;
dt_validade_prescr_w	timestamp;
nr_horas_validade_w	bigint;
nr_seq_prot_proc_w	bigint;

					
c01 CURSOR FOR
	SELECT	nr_sequencia
	from	pe_protocolo_subtipo
	where	coalesce(ie_situacao,'A') = 'A'
	and	nr_seq_protocolo 	 = nr_seq_protocolo_p
	and	nr_sequencia 		 = coalesce(nr_seq_subtipo_p,nr_sequencia);
	
c02 CURSOR FOR	
	SELECT	nr_sequencia,
		nr_seq_proc
	from	pe_protocolo_proc
	where  	nr_seq_subtipo		 = nr_seq_subtipo_w;
	
	

BEGIN

ie_prim_hor_sae_w := obter_param_usuario(871, 397, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_prim_hor_sae_w);
ie_estender_w := obter_param_usuario(871, 398, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_estender_w);
ie_prox_hor_setor_w := obter_param_usuario(871, 399, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_prox_hor_setor_w);


if (coalesce(nr_seq_protocolo_p,0) > 0) then

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	pe_prescricao
	where	nr_cirurgia = nr_cirurgia_p;

	dt_prescricao_w	:= clock_timestamp();

	if (nr_sequencia_w = 0) then
		select	nextval('pe_prescricao_seq')
		into STRICT	nr_sequencia_w
		;
		
		cd_setor_atendimento_w	:= obter_setor_Atendimento(nr_atendimento_p);
		
		if (ie_prim_hor_sae_w = '1') and (coalesce(cd_setor_atendimento_w,0) > 0) then
			select 	ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prescricao_w, hr_inicio_prescricao_sae)
			into STRICT	dt_primeiro_horario_w
			from 	setor_Atendimento
			where 	cd_setor_atendimento =	cd_setor_atendimento_w;
			if (ie_prox_hor_setor_w = 'S') and (dt_primeiro_horario_w < clock_timestamp()) then
				dt_primeiro_horario_w := to_date(to_char((dt_prescricao_w + 1/24),'dd/mm/yyyy') || ' ' || to_char(trunc(dt_prescricao_w,'hh') + 1/24,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
			end if;
		elsif (ie_prim_hor_sae_w = '2') then
			dt_primeiro_horario_w := to_date(to_char((dt_prescricao_w + 1/24),'dd/mm/yyyy') || ' ' || to_char(trunc(dt_prescricao_w,'hh') + 1/24,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
		end if;	
		
		dt_inicio_prescr_w	:= Obter_Inicio_Prescr_Sae(cd_setor_atendimento_w,dt_prescricao_w,dt_primeiro_horario_w);
		
		if (nr_horas_validade_p > 0) then
			nr_horas_validade_w := nr_horas_validade_p;
		else
			nr_horas_validade_w := obter_horas_validade_SAE(dt_primeiro_horario_w,nr_atendimento_p,ie_estender_w,'A',dt_prescricao_w,nr_sequencia_w);
		end if;	
		
		if (dt_inicio_prescr_w IS NOT NULL AND dt_inicio_prescr_w::text <> '') then
			dt_validade_prescr_w	:= dt_inicio_prescr_w + (nr_horas_validade_w / 24 - 1/86400);
		end if;		
		
		
		insert	into pe_prescricao(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_prescricao,
						cd_prescritor,
						nr_atendimento,
						cd_pessoa_fisica,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						dt_inicio_prescr,
						dt_validade_prescr,
						nr_prescricao,
						nr_cirurgia,
						ie_situacao,
						cd_perfil_ativo,
						cd_setor_atendimento,
						ie_rn,
						qt_horas_validade,
						dt_primeiro_horario)
		values (nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						dt_prescricao_w,
						cd_prescritor_p,
						nr_atendimento_p,
						cd_pessoa_fisica_p,
						clock_timestamp(),
						nm_usuario_p,
						dt_inicio_prescr_w,
						dt_validade_prescr_w,
						null,
						nr_cirurgia_p,
						'A',
						obter_perfil_ativo,
						cd_setor_atendimento_w,
						'N',
						nr_horas_validade_w,
						dt_primeiro_horario_w);
		commit;
	end if;	
	open c01;
	loop
	fetch c01 into
		nr_seq_subtipo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		open c02;
		loop
		fetch c02 into
			nr_seq_prot_proc_w,
			nr_seq_proc_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			CALL Gerar_Intervencao_Protocolo(nr_sequencia_w,nr_seq_proc_w,nr_seq_prot_proc_w,nm_usuario_p);
		end loop;
		close c02;
	end loop;
	close c01;
end if;	
		
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_protocolo_sae_cirurgia ( nr_seq_protocolo_p bigint, nr_seq_subtipo_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_cirurgia_p bigint, cd_prescritor_p text, nr_horas_validade_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
