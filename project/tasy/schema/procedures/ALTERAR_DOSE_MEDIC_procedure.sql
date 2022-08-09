-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_dose_medic ( nr_prescricao_p bigint, nr_seq_item_p bigint, qt_dose_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_intervalo_w			varchar(30);
cd_material_w			bigint;
cd_unid_medida_medic_w	varchar(30);
ds_dose_dif_w			varchar(255);
ds_erro_w				varchar(2000);
ie_origem_inf_w			varchar(5);
ie_regra_disp_w			varchar(5);
ie_via_aplicacao_w		varchar(30);
nr_ocorrencias_w		bigint;
qt_dispensar_w			double precision;
qt_dose_especial_w		double precision;
qt_material_w			double precision;
qt_unitaria_w			double precision;
ie_se_necessario_w		varchar(1);
ie_acm_w				varchar(1);
cd_funcao_origem_w		prescr_medica.cd_funcao_origem%type;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (qt_dose_p IS NOT NULL AND qt_dose_p::text <> '') then
	begin

	select 	max(cd_funcao_origem)
	into STRICT	cd_funcao_origem_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	select	cd_material,
			cd_intervalo,
			ie_via_aplicacao,
			cd_unidade_medida_dose,
			qt_dose_especial,
			nr_ocorrencia,
			ds_dose_diferenciada,
			ie_origem_inf,
			coalesce(ie_se_necessario,'N'),
			coalesce(ie_acm,'N')
	into STRICT	cd_material_w,
			cd_intervalo_w,
			ie_via_aplicacao_w,
			cd_unid_medida_medic_w,
			qt_dose_especial_w,
			nr_ocorrencias_w,
			ds_dose_dif_w,
			ie_origem_inf_w,
			ie_se_necessario_w,
			ie_acm_w
	from	prescr_material
	where	nr_prescricao = nr_prescricao_p
	and 	nr_sequencia  = nr_seq_item_p;

	exception
		when no_data_found then
			if (cd_funcao_origem_w <> 2314)	then
				--Não foi possível localizar o item '||nr_seq_item_p||' na prescrição '||nr_prescricao_p||' #@#@');
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(236809,	'NR_SEQ_ITEM_P='||nr_seq_item_p||
																';NR_PRESCRICAO_P='||nr_prescricao_p);
			end if;
	end;

	qt_unitaria_w :=  obter_conversao_unid_med_cons(cd_material_w,cd_unid_medida_medic_w, qt_dose_p);

	SELECT * FROM Obter_Quant_Dispensar(	cd_estabelecimento_p, cd_material_w, nr_prescricao_p, nr_seq_item_p, cd_intervalo_w, ie_via_aplicacao_w, qt_unitaria_w, qt_dose_especial_w, nr_ocorrencias_w, ds_dose_dif_w, ie_origem_inf_w, cd_unid_medida_medic_w, 1, qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_se_necessario_w, ie_acm_w) INTO STRICT qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w;

	update	prescr_material
	set		qt_dose		= qt_dose_p,
			qt_unitaria	= qt_unitaria_w,
			qt_material	= qt_dispensar_w,
			qt_total_dispensar	= qt_dispensar_w,
			ie_regra_disp	= CASE WHEN ie_regra_disp='D' THEN  ie_regra_disp  ELSE ie_regra_disp_w END
	where	nr_prescricao = nr_prescricao_p
	and 	nr_sequencia  = nr_seq_item_p;
end if;

CALL ajustar_prescr_material(nr_prescricao_p, nr_seq_item_p);
ds_erro_w := consistir_prescr_material(nr_prescricao_p, nr_seq_item_p, nm_usuario_p, cd_perfil_p, ds_erro_w);
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_dose_medic ( nr_prescricao_p bigint, nr_seq_item_p bigint, qt_dose_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
