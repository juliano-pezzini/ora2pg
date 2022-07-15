-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_dias_solic_dias_fut ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/*Procedure utilizada no AtePac_e8 para liberar os dias solicitados nos itens de "prescrições futuras"*/
 
 
qt_total_dias_lib_w	integer;
cd_material_w		integer;
qt_dose_w			double precision;
cd_unidade_medida_dose_w	varchar(30);
nr_prescr_orig_fut_w	bigint;
nr_prescricao_w		bigint;
cd_intervalo_w		varchar(7);
ie_via_aplicacao_w	varchar(5);
ds_erro_w		varchar(255);
nr_seq_material_w	bigint;
nr_atendimento_w	bigint;
nr_dia_util_w		bigint;

C01 CURSOR FOR 
	SELECT	a.nr_prescricao, 
		b.nr_sequencia 
	from	prescr_medica a, 
		prescr_material b 
	where	a.nr_prescricao			= b.nr_prescricao 
	and 	a.nr_atendimento		= nr_atendimento_w 
	--and 	nr_prescr_orig_fut		= nr_prescr_orig_fut_w 
	and	b.nr_dia_util			> nr_dia_util_w 
	and	a.dt_prescricao between clock_timestamp() - interval '15 days' and clock_timestamp() + interval '15 days' 
	and	coalesce(b.qt_total_dias_lib,0) 	= 0 
	and	b.ie_agrupador			= 1 
	and	b.cd_material			= cd_material_w 
	and	b.qt_dose			= qt_dose_w 
	and	b.ie_via_aplicacao		= ie_via_aplicacao_w 
	and	b.cd_unidade_medida_dose	= cd_unidade_medida_dose_w 
	and 	b.cd_intervalo			= cd_intervalo_w;

BEGIN
 
Select	max(nr_prescr_orig_fut), 
	max(nr_atendimento) 
into STRICT	nr_prescr_orig_fut_w, 
	nr_atendimento_w 
from	prescr_medica 
where 	nr_prescricao	= nr_prescricao_p;
 
--if	(nr_prescr_orig_fut_w is not null) then 
	 
Select	max(qt_total_dias_lib), 
	max(cd_material), 
	max(qt_dose), 
	max(cd_unidade_medida_dose), 
	max(cd_intervalo), 
	max(ie_via_aplicacao), 
	max(nr_dia_util) 
into STRICT	qt_total_dias_lib_w, 
	cd_material_w, 
	qt_dose_w, 
	cd_unidade_medida_dose_w, 
	cd_intervalo_w, 
	ie_via_aplicacao_w, 
	nr_dia_util_w 
from	prescr_material 
where	nr_prescricao	= nr_prescricao_p 
and 	nr_sequencia	= nr_seq_material_p;
 
open C01;
loop 
fetch C01 into	 
	nr_prescricao_w, 
	nr_seq_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	update	prescr_material 
	set		qt_total_dias_lib	= qt_total_dias_lib_w, 
			dt_aprovacao_cih	= clock_timestamp() 
	where	nr_prescricao		= nr_prescricao_w 
	and 		nr_sequencia		= nr_seq_material_w;
	 
	ds_erro_w  := consistir_prescr_material(nr_prescricao_w, nr_seq_material_w, nm_usuario_p, cd_perfil_p, ds_erro_w );
	 
	end;
end loop;
close C01;
	 
--end if; 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_dias_solic_dias_fut ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

