-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_mat_prescr_prot ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_protocolo_p bigint, nr_seq_protocolo_p bigint, nr_seq_mat_prot_p bigint) AS $body$
DECLARE

 
qt_dose_w			double precision;
cd_unidade_medida_w		varchar(30);
cd_unidade_medida_consumo_w	varchar(30);
qt_conversao_dose_w		double precision;
cd_material_w			integer;
qt_unitaria_w			double precision;
cd_intervalo_w			varchar(7);
ie_via_aplicacao_w		varchar(5);
nr_ocorrencia_w			double precision;
ie_origem_inf_w			varchar(1) := 'P';
qt_material_w  		double precision;
qt_dispensar_w			double precision;
ds_erro_w			varchar(255);
ds_observacao_w			varchar(255);
cd_unidade_medida_dose_w	varchar(30);
ie_regra_disp_w			varchar(1);/* Rafael em 15/3/8 OS86206 */
ie_se_necessario_w		varchar(1);
ie_acm_w			varchar(1);


BEGIN 
 
begin 
select	a.qt_dose, 
	a.cd_unidade_medida, 
	b.cd_unidade_medida_consumo, 
	a.cd_material, 
	a.ds_recomendacao 
into STRICT	qt_dose_w, 
	cd_unidade_medida_w, 
	cd_unidade_medida_consumo_w, 
	cd_material_w, 
	ds_observacao_w 
from	material b, 
	protocolo_medic_material a 
where	a.cd_material	= b.cd_material 
and	a.cd_protocolo	= cd_protocolo_p 
and	a.nr_sequencia	= nr_seq_protocolo_p 
and	a.nr_seq_material = nr_seq_mat_prot_p;
exception when others then	 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(236810);
end;
	 
if (cd_unidade_medida_consumo_w = cd_unidade_medida_w) then 
	qt_conversao_dose_w	:= 1;
else 
	begin 
	select	coalesce(max(qt_conversao),1) 
	into STRICT	qt_conversao_dose_w 
	from	material_conversao_unidade 
	where	cd_material		= cd_material_w 
	and	cd_unidade_medida	= cd_unidade_medida_w;
	exception 
		when others then 
			qt_conversao_dose_w	:= 1;
	end;
end if;
 
select	cd_intervalo, 
	ie_via_aplicacao, 
	nr_ocorrencia, 
	ie_origem_inf, 
	cd_unidade_medida_dose, 
	qt_material, 
	coalesce(ie_se_necessario,'N'), 
	coalesce(ie_acm_w,'N') 
into STRICT	cd_intervalo_w, 
	ie_via_aplicacao_w, 
	nr_ocorrencia_w, 
	ie_origem_inf_w, 
	cd_unidade_medida_dose_w, 
	qt_material_w, 
	ie_se_necessario_w, 
	ie_acm_w 
from	prescr_material 
where	nr_prescricao	= nr_prescricao_p 
and	nr_sequencia	= nr_sequencia_p;
	 
 
qt_unitaria_w := (trunc(qt_dose_w * 1000 / qt_conversao_dose_w)/ 1000);	
 
SELECT * FROM Obter_Quant_Dispensar(1, cd_material_w, nr_prescricao_p, nr_sequencia_p, cd_intervalo_w, ie_via_aplicacao_w, qt_unitaria_w, 0, nr_ocorrencia_w, '', ie_origem_inf_w, cd_unidade_medida_dose_w, 1, qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_se_necessario_w, ie_acm_w) INTO STRICT qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w;
				 
if	((coalesce(qt_material_w::text, '') = '') or (qt_material_w = 0)) then 
	qt_material_w := 1;
end if;
		 
update	prescr_material 
set	cd_material		= cd_material_w, 
	qt_unitaria		= qt_unitaria_w, 
	nr_ocorrencia		= nr_ocorrencia_w, 
	qt_material		= qt_material_w, 
	qt_total_dispensar	= qt_dispensar_w, 
	qt_dose			= qt_dose_w,	 
	cd_unidade_medida 	= cd_unidade_medida_consumo_w, 
	cd_unidade_medida_dose	= cd_unidade_medida_w, 
	qt_conversao_dose	= qt_conversao_dose_w, 
	ds_observacao		= ds_observacao_w, 
	--ie_regra_disp		= ie_regra_disp_w 
	ie_regra_disp		= CASE WHEN coalesce(ie_regra_disp,'X')='D' THEN  ie_regra_disp  ELSE ie_regra_disp_w END  
where	nr_prescricao		= nr_prescricao_p 
and	nr_sequencia		= nr_sequencia_p;
	 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_mat_prescr_prot ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_protocolo_p bigint, nr_seq_protocolo_p bigint, nr_seq_mat_prot_p bigint) FROM PUBLIC;
