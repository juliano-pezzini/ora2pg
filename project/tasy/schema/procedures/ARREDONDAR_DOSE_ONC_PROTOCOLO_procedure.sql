-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE arredondar_dose_onc_protocolo (nr_seq_paciente_p bigint) AS $body$
DECLARE


cd_material_w		integer;
ie_via_aplicacao_w	varchar(10);
qt_dose_prescr_w	double precision;
qt_registro_w		bigint;
nr_seq_material_w	bigint;
qt_dose_prescr_ww	double precision;
ie_regra_disp_w		varchar(10);
cd_unidade_medida_w	varchar(30);
cd_unidade_medida_conv_w	varchar(30);
cd_intervalo_w	varchar(30);
cd_estabelecimento_w 	bigint := wheb_usuario_pck.get_cd_estabelecimento;


C01 CURSOR FOR
	SELECT	cd_material,
		ie_via_aplicacao,
		qt_dose_prescr,
		nr_seq_material,
		CD_UNID_MED_PRESCR,
		cd_intervalo
	from	paciente_protocolo_medic
	where	nr_seq_paciente		= nr_seq_paciente_p
	and	(qt_dose_prescr IS NOT NULL AND qt_dose_prescr::text <> '');

BEGIN

select	count(*)
into STRICT	qt_registro_w
from	regra_disp_oncologia
where	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w;

select	coalesce(max(ie_regra_disp),'S')
into STRICT	ie_regra_disp_w
from	paciente_setor
where	nr_seq_paciente	= nr_seq_paciente_p;



if (qt_registro_w	> 0) and (ie_regra_disp_w	= 'S')then
	open C01;
	loop
	fetch C01 into
		cd_material_w,
		ie_via_aplicacao_w,
		qt_dose_prescr_w,
		nr_seq_material_w,
		cd_unidade_medida_w,
		cd_intervalo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		--qt_dose_prescr_ww	:= Obter_qt_dose_onco(cd_material_w,qt_dose_prescr_w,ie_via_aplicacao_w);
		qt_dose_prescr_ww	:= qt_dose_prescr_w;

		SELECT * FROM Obter_qt_dose_onco_conv(cd_material_w, qt_dose_prescr_ww, ie_via_aplicacao_w, cd_unidade_medida_w, cd_unidade_medida_conv_w, cd_intervalo_w) INTO STRICT qt_dose_prescr_ww, cd_unidade_medida_conv_w;


		if (qt_dose_prescr_ww IS NOT NULL AND qt_dose_prescr_ww::text <> '') and (qt_dose_prescr_ww	<> qt_dose_prescr_w) then
			update	paciente_protocolo_medic
			set	qt_dose_prescr		= qt_dose_prescr_ww,
				CD_UNID_MED_PRESCR	=coalesce(cd_unidade_medida_conv_w,CD_UNID_MED_PRESCR)
			where	nr_seq_paciente		= nr_seq_paciente_p
			and	nr_seq_material		= nr_seq_material_w;
		end if;

		end;
	end loop;
	close C01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE arredondar_dose_onc_protocolo (nr_seq_paciente_p bigint) FROM PUBLIC;
