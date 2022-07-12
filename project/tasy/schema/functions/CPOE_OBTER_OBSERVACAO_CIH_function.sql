-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_observacao_cih (nr_seq_cpoe_p bigint, nr_seq_cpoe_anterior_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


cd_material_w	cpoe_material.cd_material%type;
qt_dias_liberado_text_w	cpoe_material.qt_dias_liberado%type;
qt_dias_solicitado_text_w	cpoe_material.qt_dias_solicitado%type;
nr_dia_util_w	cpoe_material.nr_dia_util%type;
qt_dias_solicitado_w	cpoe_material.qt_dias_solicitado%type;

ie_dose_w	atb_change_rule.ie_dose%type;
ie_via_aplicacao_w	atb_change_rule.ie_via_aplicacao%type;
ie_intervalo_w	atb_change_rule.ie_intervalo%type;
ie_diluicao_w	atb_change_rule.ie_diluicao%type;
ie_rediluicao_w	atb_change_rule.ie_rediluicao%type;
ie_justificativa_w	atb_change_rule.ie_justificativa%type;
ie_observacao_w	atb_change_rule.ie_observacao%type;

ds_dose_w	varchar(4000);
ds_via_aplicacao_w	varchar(4000);
ds_intervalo_w	varchar(4000);
ds_diluicao_w	varchar(4000);
ds_rediluicao_w	varchar(4000);
ds_justificativa_w	varchar(4000);
ds_observacao_w	varchar(4000);
ds_observacao_ccih_w varchar(4000);

c01 CURSOR FOR
SELECT	a.qt_dose qt_dose, b.qt_dose qt_dose_ant, a.cd_unidade_medida cd_unidade_medida, b.cd_unidade_medida cd_unidade_medida_ant,
	a.ie_via_aplicacao ie_via_aplicacao, b.ie_via_aplicacao ie_via_aplicacao_ant, a.cd_intervalo cd_intervalo, b.cd_intervalo cd_intervalo_ant,
	a.cd_mat_dil cd_mat_dil, b.cd_mat_dil cd_mat_dil_ant, a.cd_mat_red cd_mat_red, b.cd_mat_red cd_mat_red_ant,
	a.ds_justificativa ds_justificativa, b.ds_justificativa ds_justificativa_ant, a.ds_observacao ds_observacao, b.ds_observacao ds_observacao_ant
from	cpoe_material a,
	cpoe_material b
where a.nr_sequencia  = nr_seq_cpoe_p
and	  b.nr_sequencia  = nr_seq_cpoe_anterior_p;


function obter_desc_w(cd_expressao_p	bigint,
				ds_value1_p	text,
				ds_value2_p	text)
				return text is;
BEGIN
	return obter_desc_expressao(cd_expressao_p) ||' '|| obter_desc_expressao(310214) || ' ' || ds_value1_p || ' ' || obter_desc_expressao(618484) || ' ' || ds_value2_p || chr(13);
end;

function obter_se_mostra_mensagem_n(ie_condicao_p	varchar2,
				ds_value1_p	number,
				ds_value2_p	number)
				return varchar2 is
begin
	if ((coalesce(ie_condicao_p, 'N') = 'S') and (coalesce(ds_value1_p,0) <> coalesce(ds_value2_p,0))) then
		return 'S';
	end if;

	return 'N';
end;

function obter_se_mostra_mensagem_v(ie_condicao_p	varchar2,
				ds_value1_p	varchar2,
				ds_value2_p	varchar2) return varchar2 is
begin
	if ((coalesce(ie_condicao_p, 'N') = 'S') and (coalesce(ds_value1_p,'XPT') <> coalesce(ds_value2_p, 'XPT'))) then
		return 'S';
	end if;

	return 'N';
end;

begin

select	max(cd_material),
	max(nr_dia_util),
	max(qt_dias_solicitado)
into STRICT	cd_material_w,
	nr_dia_util_w,
	qt_dias_solicitado_w
from	cpoe_material
where	nr_sequencia = nr_seq_cpoe_p;

select	coalesce(max(qt_dias_liberado), 0),
	coalesce(max(qt_dias_solicitado), 0)
into STRICT	qt_dias_liberado_text_w,
	qt_dias_solicitado_text_w
from	cpoe_material
where	nr_sequencia = nr_seq_cpoe_anterior_p;

if (qt_dias_liberado_text_w > 0) then
	ds_observacao_ccih_w := wheb_mensagem_pck.get_texto(1063301,'QT_DIAS_LIBERADOS='||qt_dias_liberado_text_w||';QT_DIA_UTIL='||nr_dia_util_w) || chr(13);
end if;

if (qt_dias_solicitado_text_w <> qt_dias_solicitado_w) then
	ds_observacao_ccih_w :=  ds_observacao_ccih_w || wheb_mensagem_pck.get_texto(1063302,'QT_DIAS_SOLICITADOS='||qt_dias_solicitado_w||';QT_DIAS_SUBSTITUIDOS='||qt_dias_solicitado_text_w) || chr(13);
end if;

cpoe_atb_change_rule(cd_estabelecimento_p, cd_setor_atendimento_p,
						cd_perfil_p , cd_material_w,
						ie_dose_w, ie_via_aplicacao_w, ie_intervalo_w, ie_diluicao_w,
						ie_rediluicao_w, ie_justificativa_w, ie_observacao_w);

for r_c01_w in C01
loop
	if (obter_se_mostra_mensagem_n(ie_dose_w, r_c01_w.qt_dose, r_c01_w.qt_dose_ant) = 'S') then
		ds_dose_w := substr(obter_desc_w(288220, r_c01_w.qt_dose_ant || ' ' || r_c01_w.cd_unidade_medida_ant, r_c01_w.qt_dose || ' ' || r_c01_w.cd_unidade_medida), 1,4000);
	end if;
	
	if (obter_se_mostra_mensagem_v(ie_via_aplicacao_w, r_c01_w.ie_via_aplicacao, r_c01_w.ie_via_aplicacao_ant) = 'S') then
		ds_via_aplicacao_w := substr(obter_desc_w(301673, obter_desc_via(r_c01_w.ie_via_aplicacao_ant), obter_desc_via(r_c01_w.ie_via_aplicacao)), 1,4000);
	end if;

	if (obter_se_mostra_mensagem_v(ie_intervalo_w, r_c01_w.cd_intervalo, r_c01_w.cd_intervalo_ant) = 'S') then
		ds_intervalo_w := substr(obter_desc_w(325804, obter_desc_intervalo(r_c01_w.cd_intervalo_ant), obter_desc_intervalo(r_c01_w.cd_intervalo)), 1,4000);
	end if;

	if (obter_se_mostra_mensagem_v(ie_diluicao_w, r_c01_w.cd_mat_dil, r_c01_w.cd_mat_dil_ant) = 'S') then
		ds_diluicao_w := substr(obter_desc_w(287942, obter_desc_material(r_c01_w.cd_mat_dil_ant), obter_desc_material(r_c01_w.cd_mat_dil)), 1,4000);
	end if;

	if (obter_se_mostra_mensagem_v(ie_rediluicao_w, r_c01_w.cd_mat_red, r_c01_w.cd_mat_red_ant) = 'S') then
		ds_rediluicao_w := substr(obter_desc_w(315216, obter_desc_material(r_c01_w.cd_mat_red_ant), obter_desc_material(r_c01_w.cd_mat_red)), 1,4000);
	end if;
	
	if (obter_se_mostra_mensagem_v(ie_justificativa_w, r_c01_w.ds_justificativa, r_c01_w.ds_justificativa_ant) = 'S') then
		ds_justificativa_w := substr(obter_desc_w(292337, r_c01_w.ds_justificativa_ant, r_c01_w.ds_justificativa), 1,4000);
	end if;
	
	if (obter_se_mostra_mensagem_v(ie_observacao_w, r_c01_w.ds_observacao, r_c01_w.ds_observacao_ant) = 'S') then
		ds_observacao_w := substr(obter_desc_w(1068298, r_c01_w.ds_observacao_ant, r_c01_w.ds_observacao), 1,4000);
	end if;

	if ((ds_dose_w IS NOT NULL AND ds_dose_w::text <> '') or (ds_via_aplicacao_w IS NOT NULL AND ds_via_aplicacao_w::text <> '') or 	(ds_intervalo_w IS NOT NULL AND ds_intervalo_w::text <> '') or (ds_diluicao_w IS NOT NULL AND ds_diluicao_w::text <> '') or
		(ds_rediluicao_w IS NOT NULL AND ds_rediluicao_w::text <> '') or	(ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') or (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '')) then
		ds_observacao_ccih_w :=  substr((ds_observacao_ccih_w || wheb_mensagem_pck.get_texto(1063310,'DS_ALTERACOES='||ds_dose_w||ds_via_aplicacao_w||ds_intervalo_w||ds_diluicao_w||ds_rediluicao_w||ds_justificativa_w||ds_observacao_w)), 1, 4000);
	end if;
end loop;

return substr(ds_observacao_ccih_w, 1, 4000);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_observacao_cih (nr_seq_cpoe_p bigint, nr_seq_cpoe_anterior_p bigint, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint) FROM PUBLIC;
