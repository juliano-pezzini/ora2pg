-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE integracao_dispensario_pck.cubixx_admissao_paciente ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint) AS $body$
BEGIN

	PERFORM set_config('integracao_dispensario_pck.nr_atendimento_w', nr_atendimento_p, false);

	if (current_setting('integracao_dispensario_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%coalesce(type::text, '') = '') then
		select	max(nr_atendimento)
		into STRICT	current_setting('integracao_dispensario_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%type
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_p;
	end if;
	
	if (integracao_dispensario_pck.get_integracao_cubixx(cd_estabelecimento_p) = 'S') and (integracao_dispensario_pck.get_se_setor_integracao(cd_setor_atendimento_p) = 'S') then
		select	count(1)
		into STRICT	current_setting('integracao_dispensario_pck.qt_existe_w')::bigint
		from    prescr_mat_hor a,
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
		and 	exists (  SELECT	1
						from 	paciente_atendimento x,
							paciente_atend_medic y
						where 	y.nr_seq_atendimento = x.nr_seq_atendimento
						and 	y.cd_material = a.cd_material
						and 	x.nr_prescricao = a.nr_prescricao);

		if (current_setting('integracao_dispensario_pck.qt_existe_w')::bigint > 0) then
			PERFORM set_config('integracao_dispensario_pck.ds_param_integ_cubixx_w', 'nr_atendimento=' || current_setting('integracao_dispensario_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%type || obter_separador_bv, false);
			CALL gravar_agend_integracao(809, current_setting('integracao_dispensario_pck.ds_param_integ_cubixx_w')::varchar(2000), cd_setor_atendimento_p);
		end if;
	end if;
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integracao_dispensario_pck.cubixx_admissao_paciente ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;
