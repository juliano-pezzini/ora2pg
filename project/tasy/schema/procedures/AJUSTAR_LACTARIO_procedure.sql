-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_lactario ( nr_seq_leite_deriv_p bigint, nm_usuario_p text, cd_perfil_p bigint) AS $body$
DECLARE

 
nr_prescricao_w		bigint;
nr_sequencia_w		integer;
qt_volume_total_w	double precision;
cd_intervalo_w		varchar(7);
ie_se_necessario_w	varchar(1);
	
c01 CURSOR FOR 
SELECT	nr_sequencia 
from	prescr_material 
where	nr_prescricao		= nr_prescricao_w 
and	nr_seq_leite_deriv	= nr_seq_leite_deriv_p 
and	ie_agrupador		= 16;
	

BEGIN 
 
select	max(nr_prescricao), 
	max(qt_volume_total), 
	max(cd_intervalo), 
	max(ie_se_necessario) 
into STRICT	nr_prescricao_w, 
	qt_volume_total_w, 
	cd_intervalo_w, 
	ie_se_necessario_w 
from	prescr_leite_deriv 
where	nr_sequencia	= nr_seq_leite_deriv_p;
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	update	prescr_material 
	set	qt_dose			= qt_volume_total_w, 
		cd_intervalo		= cd_intervalo_w, 
		ie_se_necessario	= ie_se_necessario_w 
	where	nr_prescricao		= nr_prescricao_w 
	and	nr_sequencia		= nr_sequencia_w;
 
	CALL Gerar_prescr_mat_sem_dt_lib(nr_prescricao_w,	nr_sequencia_w,	cd_perfil_p, 'N', nm_usuario_p, null);
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_lactario ( nr_seq_leite_deriv_p bigint, nm_usuario_p text, cd_perfil_p bigint) FROM PUBLIC;
