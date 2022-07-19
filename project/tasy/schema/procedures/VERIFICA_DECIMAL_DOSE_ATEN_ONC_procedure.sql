-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_decimal_dose_aten_onc ( nr_seq_atendimento_p bigint, nr_seq_material_p bigint, ds_erro_p INOUT text ) AS $body$
DECLARE


nr_seq_paciente_w		paciente_atendimento.nr_seq_paciente%type;
cd_setor_atendimento_w	paciente_setor.cd_setor_atendimento%type;
cd_material_w			paciente_atend_medic.cd_material%type;
cd_unidade_medida_w		paciente_atend_medic.cd_unid_med_dose%type;
qt_dose_w				paciente_atend_medic.qt_dose%type;
nr_seq_regra_w			regra_arredond_onc.nr_sequencia%type;
nr_casas_diluicao_w		regra_arredond_onc.nr_casas_diluicao%type;


BEGIN
	ds_erro_p := null;

	select	max(nr_seq_paciente)
	into STRICT	nr_seq_paciente_w
	from	paciente_atendimento
	where	nr_seq_atendimento = nr_seq_atendimento_p;

	select	max(cd_setor_atendimento)
	into STRICT	cd_setor_atendimento_w
	from	paciente_setor
	where	nr_seq_paciente = nr_seq_paciente_w;

	select	max(cd_material),
			max(coalesce(cd_unid_med_prescr, cd_unid_med_dose)),
			max(coalesce(qt_dose_prescricao, qt_dose))
	into STRICT 	cd_material_w,
			cd_unidade_medida_w,
			qt_dose_w
	from	paciente_atend_medic
	where	nr_seq_atendimento = nr_seq_atendimento_p
	and		nr_seq_material	= nr_seq_material_p;

	select 	coalesce(max(nr_sequencia), 0)
	into STRICT 	nr_seq_regra_w
	from 	regra_arredond_onc
	where 	((cd_setor_atendimento = cd_setor_atendimento_w) or ((coalesce(cd_setor_atendimento::text, '') = '') and not exists (SELECT 1 from regra_arredond_onc x where x.cd_setor_atendimento = cd_setor_atendimento_w)))
	and 	((cd_material = cd_material_w) or ((coalesce(cd_material::text, '') = '') and not exists (select 1 from regra_arredond_onc x where x.cd_material = cd_material_w)))
	and 	((cd_unidade_medida = cd_unidade_medida_w) or ((coalesce(cd_unidade_medida::text, '') = '') and not exists (select 1 from regra_arredond_onc x where x.cd_unidade_medida = cd_unidade_medida_w)));

	if (nr_seq_regra_w > 0) then
		select 	coalesce(nr_casas_diluicao, 0)
		into STRICT	nr_casas_diluicao_w
		from 	regra_arredond_onc
		where nr_sequencia = nr_seq_regra_w;

		if (trunc(qt_dose_w, nr_casas_diluicao_w) <> qt_dose_w) then
			ds_erro_p := Obter_Desc_Expressao(640407) || '. ' || Obter_Desc_Expressao(328557) || ': ' || nr_casas_diluicao_w;
		end if;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_decimal_dose_aten_onc ( nr_seq_atendimento_p bigint, nr_seq_material_p bigint, ds_erro_p INOUT text ) FROM PUBLIC;

