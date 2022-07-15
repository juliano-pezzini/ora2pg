-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE administrar_horario_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_p bigint, dt_instalacao_p timestamp, nm_usuario_p text) AS $body$
DECLARE


dt_horario_w			timestamp;
dt_fim_w				timestamp;
cd_funcao_origem_w		prescr_medica.cd_funcao_origem%type;
nr_seq_item_cpoe_w		cpoe_material.nr_sequencia%type;
ie_param8_cpoe_w		varchar(50);
ie_param1562_cpoe_w		varchar(1);
dt_horario_mat_hor_onc_w	prescr_mat_hor.dt_horario%type;
nr_sequencia_mat_hor_w	prescr_mat_hor.nr_sequencia%type;
ie_oncologia_w			cpoe_material.ie_oncologia%type;

procedure atualiza_data_fim_cpoe_mat(
		dt_fim_p			cpoe_material.dt_fim%type,
		nr_seq_item_cpoe_p	cpoe_material.nr_sequencia%type) is
	
	;
BEGIN
		
		update	cpoe_material
		set 	dt_fim =  dt_fim_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_seq_item_cpoe_p
		and		ie_administracao = 'P'
		and		((cd_funcao_origem = 2314 and ie_evento_unico = 'S') or (cd_funcao_origem <> 2314));
		
		commit;
		
end;
	
begin
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (nr_etapa_p IS NOT NULL AND nr_etapa_p::text <> '') and (dt_instalacao_p IS NOT NULL AND dt_instalacao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update	prescr_mat_hor
	set		dt_fim_horario = clock_timestamp(),
			nm_usuario_adm = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
	where	nr_prescricao = nr_prescricao_p
	and		nr_seq_solucao = nr_seq_solucao_p
	and		coalesce(dt_fim_horario::text, '') = ''
	and		coalesce(dt_suspensao::text, '') = ''
	and		nr_etapa_sol = nr_etapa_p;
	
	select	max(dt_horario)
	into STRICT	dt_horario_w
	from	prescr_mat_hor
	where	nr_prescricao = nr_prescricao_p
	and		nr_seq_solucao = nr_seq_solucao_p
	and		nr_etapa_sol = nr_etapa_p;
	
	update	prescr_mat_hor a
	set		dt_fim_horario = clock_timestamp(),
			nm_usuario_adm = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario	   = nm_usuario_p
	where	nr_prescricao  = nr_prescricao_p
	and		dt_horario	   = dt_horario_w
	and		coalesce(dt_fim_horario::text, '') = ''
	and		coalesce(dt_suspensao::text, '') = ''
	and		nr_seq_superior in (	SELECT	nr_sequencia
									from	prescr_material x
									where	nr_prescricao = nr_prescricao_p
									and		nr_sequencia_solucao = nr_seq_solucao_p);
																		
	select	max(cd_funcao_origem)
	into STRICT	cd_funcao_origem_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;
	
	
	if (cd_funcao_origem_w in (2314, 281)) then
						
		select  max(a.nr_seq_mat_cpoe)
		into STRICT	nr_seq_item_cpoe_w
		from    prescr_material a,
				cpoe_material b
		where   a.nr_seq_mat_cpoe = b.nr_sequencia
		and     a.nr_prescricao = nr_prescricao_p
		and     a.nr_sequencia_solucao = nr_seq_solucao_p;
				
		if (coalesce(nr_seq_item_cpoe_w,0) > 0) then
			
			ie_param8_cpoe_w := obter_param_usuario(2314, 8, obter_perfil_ativo, nm_usuario_p, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_param8_cpoe_w);
			
			dt_fim_w :=	clock_timestamp();
			
			if (dt_fim_w < dt_horario_w) then	
				dt_fim_w :=	dt_horario_w;
			end if;
			
			if (ie_param8_cpoe_w = 'A' and cd_funcao_origem_w = 2314) then		
				atualiza_data_fim_cpoe_mat(trunc(dt_fim_w + 1/24,'hh24') - 1/1440, nr_seq_item_cpoe_w);
			else
				ie_param1562_cpoe_w := obter_param_usuario(281, 1562, obter_perfil_ativo, nm_usuario_p, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_param1562_cpoe_w);
				
				if (ie_param1562_cpoe_w = 'A' and cd_funcao_origem_w = 281)	then				
					
					select	coalesce(max(a.ie_oncologia), 'N')
					into STRICT 	ie_oncologia_w
					from 	cpoe_material a
					where 	a.nr_sequencia = nr_seq_item_cpoe_w;
					
					if (ie_oncologia_w = 'S') then
						
						select 	max(a.dt_horario) 
						into STRICT 	dt_horario_mat_hor_onc_w
						from 	prescr_mat_hor a
						where	a.nr_prescricao = nr_prescricao_p
						and		a.nr_seq_solucao = nr_seq_solucao_p				
						and 	coalesce(a.dt_suspensao::text, '') = ''
						and 	coalesce(a.ie_horario_especial,'N') = 'N'
						and		coalesce(a.ie_situacao,'A') = 'A';
						
						if (dt_horario_w = dt_horario_mat_hor_onc_w) then							
							atualiza_data_fim_cpoe_mat(trunc(dt_fim_w + 1/24,'hh24') - 1/1440, nr_seq_item_cpoe_w);
						end if;
						
					end if;
					
				end if;
				
			end if;
			
		end if;	
	
	end if;
	
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE administrar_horario_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_p bigint, dt_instalacao_p timestamp, nm_usuario_p text) FROM PUBLIC;

