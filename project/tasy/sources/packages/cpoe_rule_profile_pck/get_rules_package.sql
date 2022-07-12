-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_rule_profile_pck.get_rules ( cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, nm_usuario_p text, ie_funcao_cpoe_p text default null) RETURNS SETOF T_RULE_ROW_DATA AS $body$
DECLARE

					
					
t_rule_row_w			t_rule_row;
nr_sequencia_w			cpoe_regra_ordenacao.nr_sequencia%type;


c01 CURSOR FOR
SELECT	a.nr_seq_regra_ordem
from	cpoe_regra_ordem_lib_v a
where	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
and		coalesce(a.cd_setor_atendimento, coalesce(cd_setor_usuario_p,0)) = coalesce(cd_setor_usuario_p,0)
and		coalesce(a.nm_usuario_regra, coalesce(nm_usuario_p,'XPTO')) = coalesce(nm_usuario_p,'XPTO')
and		coalesce(a.cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
and		((coalesce(ie_funcao_cpoe_p::text, '') = '') or (a.ie_funcao_cpoe = ie_funcao_cpoe_p) or ((ie_funcao_cpoe_p IS NOT NULL AND ie_funcao_cpoe_p::text <> '') and coalesce(a.ie_funcao_cpoe, 'A') = 'A'))
and		coalesce(a.ie_situacao,'A') = 'A'
order by	coalesce(a.nm_usuario_regra,'') desc,
			coalesce(a.cd_setor_atendimento,0),
			coalesce(a.cd_perfil,0),
			coalesce(a.cd_estabelecimento,0);

					
BEGIN


select	coalesce(max(ie_oral_diet),'S'),
	coalesce(max(ie_enteral_diet),'S'),
	coalesce(max(ie_supplement),'S'),
	coalesce(max(ie_fasting),'S'),
	coalesce(max(ie_milk),'S'),
	coalesce(max(ie_medicine),'S'),
	coalesce(max(ie_exam),'S'),
	coalesce(max(ie_gas),'S'),
	coalesce(max(ie_recomendation),'S'),
	coalesce(max(ie_hemotherapy),'S'),
	coalesce(max(ie_dialysis),'S'),
	coalesce(max(ie_intervention),'S'),
	coalesce(max(ie_material),'S'),
	coalesce(max(ie_parenteral),'S'),
	coalesce(max(ie_infant_parenteral),'S'),
	coalesce(max(ie_anatomia_pat),'S')
into STRICT	t_rule_row_w.ie_oral_diet,
	t_rule_row_w.ie_enteral_diet,
	t_rule_row_w.ie_supplement,
	t_rule_row_w.ie_fasting,
	t_rule_row_w.ie_milk,
	t_rule_row_w.ie_medicine,
	t_rule_row_w.ie_exam,
	t_rule_row_w.ie_gas,
	t_rule_row_w.ie_recomendation,
	t_rule_row_w.ie_hemotherapy,
	t_rule_row_w.ie_dialysis,
	t_rule_row_w.ie_intervention,
	t_rule_row_w.ie_material,
	t_rule_row_w.ie_parenteral,
	t_rule_row_w.ie_infant_parenteral,
	t_rule_row_w.ie_anatomia_pat
from (SELECT	ie_oral_diet,
		ie_enteral_diet,
		ie_supplement,
		ie_fasting,
		ie_milk,
		ie_medicine,
		ie_exam,
		ie_gas,
		ie_recomendation,
		ie_hemotherapy,
		ie_dialysis,
		ie_intervention,
		ie_material,
		ie_parenteral,
		ie_infant_parenteral,
		ie_anatomia_pat
	from 	cpoe_presentation_rule
	where 	coalesce(cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
	and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
	order by 	cd_perfil, cd_estabelecimento) alias38 LIMIT 1;


for r_c01 in c01 loop
	begin
	nr_sequencia_w	:= r_c01.nr_seq_regra_ordem;
	end;
end loop;


t_rule_row_w.nr_seq_oral					:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'N');
t_rule_row_w.nr_seq_enteral					:= t_rule_row_w.nr_seq_oral;
t_rule_row_w.nr_seq_supplement				:= t_rule_row_w.nr_seq_oral;
t_rule_row_w.nr_seq_fasting					:= t_rule_row_w.nr_seq_oral;
t_rule_row_w.nr_seq_milk					:= t_rule_row_w.nr_seq_oral;
t_rule_row_w.nr_seq_enteral					:= t_rule_row_w.nr_seq_oral;
t_rule_row_w.nr_seq_parenteral				:= t_rule_row_w.nr_seq_oral;
t_rule_row_w.nr_seq_infant_parenteral		:= t_rule_row_w.nr_seq_oral;


t_rule_row_w.nr_seq_medicine		:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'M');
t_rule_row_w.nr_seq_exam			:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'P');
t_rule_row_w.nr_seq_gas				:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'G');
t_rule_row_w.nr_seq_recomendation	:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'R');
t_rule_row_w.nr_seq_hemotherapy		:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'H');
t_rule_row_w.nr_seq_dialysis		:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'D');
t_rule_row_w.nr_seq_intervention	:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'I');
t_rule_row_w.nr_seq_material		:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'MA');
t_rule_row_w.nr_seq_anatomia_pat	:= cpoe_rule_profile_pck.get_group_order(nr_sequencia_w,'AP');


RETURN NEXT t_rule_row_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_rule_profile_pck.get_rules ( cd_perfil_p bigint, cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, nm_usuario_p text, ie_funcao_cpoe_p text default null) FROM PUBLIC;
