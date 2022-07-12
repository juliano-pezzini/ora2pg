-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE integracao_dispensario_pck.cubixx_enviar_prescricao ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint) AS $body$
DECLARE

	
	c01 CURSOR FOR
		SELECT	distinct
			c.cd_material,
			a.nr_atendimento,
			a.nr_seq_lote,
			c.nr_sequencia
		from    
			prescr_mat_hor a,
			prescr_medica b,
			prescr_material c,
			estrutura_material_v s,
			material e
		where	(a.nr_seq_lote IS NOT NULL AND a.nr_seq_lote::text <> '')
		and		a.cd_material 		= s.cd_material
		and		a.nr_prescricao	 	= b.nr_prescricao
		and		c.nr_prescricao 	= b.nr_prescricao
		and		a.nr_seq_material	= c.nr_sequencia
		and		a.nr_prescricao 	= nr_prescricao_p
		and		a.cd_material 		= e.cd_material
		and		c.ie_suspenso 		<> 'S'
		and		coalesce(a.dt_suspensao::text, '') = ''
		and		exists (	SELECT	1
						from	
							ap_lote x,
							classif_lote_disp_far y
						where	x.nr_sequencia 				= a.nr_seq_lote
						and		coalesce(x.ie_integracao, 'N') 	<> 'P'
						and		y.nr_sequencia 				= x.nr_seq_classif
						and		y.ie_classif_urgente 		= 'A'
						and		coalesce(x.dt_atend_farmacia::text, '') = '')
		and		exists(	select  1
						from 	regra_local_dispensacao x
						where 	x.cd_estabelecimento  					= b.cd_estabelecimento
						and		x.cd_setor_atendimento  				= b.cd_setor_atendimento
						and		x.nr_sequencia 							= coalesce(a.nr_regra_local_disp, c.nr_seq_regra_local)
						and 	coalesce(x.nr_seq_classif,a.nr_seq_classif) 	= a.nr_seq_classif
						and 	((x.cd_material   						= s.cd_material) 
									or (x.cd_grupo_material  				= s.cd_grupo_material) 
									or (x.cd_subgrupo_material 			= s.cd_subgrupo_material) 
									or (x.cd_classe_material  				= s.cd_classe_material) 
									or ((x.nr_seq_estrut_int IS NOT NULL AND x.nr_seq_estrut_int::text <> '') 
										and	consistir_se_mat_contr_estrut(x.nr_seq_estrut_int, s.cd_material) 	= 'S')))
		and 	exists (  select	1
						from 	paciente_atendimento x,
							paciente_atend_medic y
						where 	y.nr_seq_atendimento = x.nr_seq_atendimento
						and 	y.cd_material = a.cd_material
						and 	x.nr_prescricao = a.nr_prescricao);
	
	
BEGIN
	
	PERFORM set_config('integracao_dispensario_pck.nr_atendimento_w', nr_atendimento_p, false);
	
	if (current_setting('integracao_dispensario_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%coalesce(type::text, '') = '') then
		select	max(nr_atendimento)
		into STRICT	current_setting('integracao_dispensario_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%type
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_p;
	end if;

	if (integracao_dispensario_pck.get_integracao_cubixx(cd_estabelecimento_p) = 'S') and (integracao_dispensario_pck.get_se_setor_integracao(cd_setor_atendimento_p) = 'S') then
		open C01;
		loop
		fetch C01 into	
			current_setting('integracao_dispensario_pck.cd_material_w')::material.cd_material%type,
			current_setting('integracao_dispensario_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%type,
			current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type,
			current_setting('integracao_dispensario_pck.nr_seq_material_w')::prescr_material.nr_sequencia%type;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			PERFORM set_config('integracao_dispensario_pck.ds_param_integ_cubixx_w', 'nr_atendimento=' 		|| current_setting('integracao_dispensario_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%type 		|| obter_separador_bv 	||
										'nr_prescricao=' 		|| nr_prescricao_p 				|| obter_separador_bv 	||
										'nr_seq_lote=' 			|| current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type 		|| obter_separador_bv 	||
										'cd_material_presc=' 	|| current_setting('integracao_dispensario_pck.cd_material_w')::material.cd_material%type 		|| obter_separador_bv 	||
										'nr_seq_material=' 		|| current_setting('integracao_dispensario_pck.nr_seq_material_w')::prescr_material.nr_sequencia%type 	|| obter_separador_bv	||
										'cd_setor_atendimento=' || cd_setor_atendimento_p 		|| obter_separador_bv, false);
			CALL gravar_agend_integracao(810, current_setting('integracao_dispensario_pck.ds_param_integ_cubixx_w')::varchar(2000), cd_setor_atendimento_p);
			end;
		end loop;
		close C01;
	end if;
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integracao_dispensario_pck.cubixx_enviar_prescricao ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;