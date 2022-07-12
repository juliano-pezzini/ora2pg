-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_se_perm_prescr_item (nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p usuario.nm_usuario%type, ie_motivo_prescr_p regra_prescr_medic.ie_motivo_prescr%type, ie_tipo_item_p text, cd_protocolo_p protocolo_medic_material.cd_protocolo%type, nr_sequencia_p protocolo_medic_material.nr_sequencia%type, nr_seq_item_p protocolo_medic_material.nr_seq_material%type, nr_prescricao_p prescr_medica.nr_prescricao%type default null, cd_material_p cpoe_material.cd_material%type default null, cd_mat_comp1_p cpoe_material.cd_mat_comp1%type default null, cd_mat_comp2_p cpoe_material.cd_mat_comp2%type default null, cd_mat_comp3_p cpoe_material.cd_mat_comp3%type default null, cd_mat_comp4_p cpoe_material.cd_mat_comp4%type default null, cd_mat_comp5_p cpoe_material.cd_mat_comp5%type default null, cd_mat_comp6_p cpoe_material.cd_mat_comp6%type default null, cd_mat_comp7_p cpoe_material.cd_mat_comp7%type default null) RETURNS varchar AS $body$
DECLARE


ie_perm_prescr_w		varchar(1);
nr_agrupamento_w		protocolo_medic_material.nr_agrupamento%type;

/*
ie_tipo_item_p = [M]edicamento e [S]olucao.

Passar os parametros de acordo com o tipo da prescricao.

Protocolo ou Rotina: nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p, ie_tipo_item_p, cd_protocolo_p, nr_sequencia_p e nr_seq_item_p.

Favoritos: nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p, cd_material_p, cd_mat_comp1_p, cd_mat_comp2_p, cd_mat_comp3_p, cd_mat_comp4_p, cd_mat_comp5_p, cd_mat_comp6_p e cd_mat_comp7_p.

Prescricoes anteriores: nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p, ie_tipo_item_p, nr_seq_item_p e nr_prescricao_p.
*/
BEGIN

	if (coalesce(cd_material_p::text, '') = '' and coalesce(nr_prescricao_p::text, '') = '') then

		if (ie_tipo_item_p = 'M') then

			select	coalesce(max(a.nr_agrupamento),0)
			into STRICT	nr_agrupamento_w
			from	protocolo_medic_material a
			where	a.cd_protocolo = cd_protocolo_p
			and		a.nr_sequencia = nr_sequencia_p
			and		a.nr_seq_material = nr_seq_item_p;

			select	coalesce(max('N'),'S')
			into STRICT	ie_perm_prescr_w
			from	protocolo_medic_material a
			where	a.cd_protocolo = cd_protocolo_p
			and		a.nr_sequencia = nr_sequencia_p
			and		a.nr_agrupamento = nr_agrupamento_w
			and		coalesce(a.nr_seq_solucao::text, '') = ''
			and		coalesce(a.nr_seq_diluicao::text, '') = ''
			and		cpoe_regra_se_permite_presc(a.cd_material, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'N';

		elsif (ie_tipo_item_p = 'S') then

			select	coalesce(max('N'),'S')
			into STRICT	ie_perm_prescr_w
			from	protocolo_medic_material a
			where	a.cd_protocolo = cd_protocolo_p
			and		a.nr_sequencia = nr_sequencia_p
			and		a.nr_seq_solucao = nr_seq_item_p
			and		coalesce(a.ie_diluente,'N') = 'N'
			and		cpoe_regra_se_permite_presc(a.cd_material, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'N';

		else

			ie_perm_prescr_w := 'S';

		end if;

	elsif (coalesce(cd_material_p::text, '') = '' and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '')) then

		if (ie_tipo_item_p = 'M') then

			select	coalesce(max(a.nr_agrupamento),0)
			into STRICT	nr_agrupamento_w
			from	prescr_material a
			where	a.nr_prescricao = nr_prescricao_p
			and		a.nr_sequencia = nr_seq_item_p;

			select	coalesce(max('N'),'S')
			into STRICT	ie_perm_prescr_w
			from	prescr_material a
			where	a.nr_prescricao = nr_prescricao_p
			and		a.nr_agrupamento = nr_agrupamento_w
			and 	coalesce(a.nr_sequencia_solucao::text, '') = ''
			and		coalesce(a.nr_sequencia_diluicao::text, '') = ''
			and		a.ie_agrupador not in (3,7,9)
			and		cpoe_regra_se_permite_presc(a.cd_material, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'N';

		elsif (ie_tipo_item_p = 'S') then

			select	coalesce(max('N'),'S')
			into STRICT	ie_perm_prescr_w
			from	prescr_material a
			where	a.nr_prescricao = nr_prescricao_p
			and		a.nr_sequencia_solucao = nr_seq_item_p
			and		coalesce(a.nr_sequencia_diluicao::text, '') = ''
			and		a.ie_agrupador not in (3,7,9)
			and		cpoe_regra_se_permite_presc(a.cd_material, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'N';

		end if;

	else

		if ((coalesce(cd_material_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_material_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')
		and (coalesce(cd_mat_comp1_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_mat_comp1_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')
		and (coalesce(cd_mat_comp2_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_mat_comp2_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')
		and (coalesce(cd_mat_comp3_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_mat_comp3_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')
		and (coalesce(cd_mat_comp4_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_mat_comp4_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')
		and (coalesce(cd_mat_comp5_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_mat_comp5_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')
		and (coalesce(cd_mat_comp6_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_mat_comp6_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')
		and (coalesce(cd_mat_comp7_p::text, '') = '' or cpoe_regra_se_permite_presc(cd_mat_comp7_p, nr_atendimento_p, nm_usuario_p, ie_motivo_prescr_p) = 'S')) then

			ie_perm_prescr_w := 'S';

		else

			ie_perm_prescr_w := 'N';

		end if;

	end if;

	return coalesce(ie_perm_prescr_w, 'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_se_perm_prescr_item (nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p usuario.nm_usuario%type, ie_motivo_prescr_p regra_prescr_medic.ie_motivo_prescr%type, ie_tipo_item_p text, cd_protocolo_p protocolo_medic_material.cd_protocolo%type, nr_sequencia_p protocolo_medic_material.nr_sequencia%type, nr_seq_item_p protocolo_medic_material.nr_seq_material%type, nr_prescricao_p prescr_medica.nr_prescricao%type default null, cd_material_p cpoe_material.cd_material%type default null, cd_mat_comp1_p cpoe_material.cd_mat_comp1%type default null, cd_mat_comp2_p cpoe_material.cd_mat_comp2%type default null, cd_mat_comp3_p cpoe_material.cd_mat_comp3%type default null, cd_mat_comp4_p cpoe_material.cd_mat_comp4%type default null, cd_mat_comp5_p cpoe_material.cd_mat_comp5%type default null, cd_mat_comp6_p cpoe_material.cd_mat_comp6%type default null, cd_mat_comp7_p cpoe_material.cd_mat_comp7%type default null) FROM PUBLIC;
