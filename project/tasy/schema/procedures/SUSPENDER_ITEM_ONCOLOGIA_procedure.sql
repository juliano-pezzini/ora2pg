-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_item_oncologia ( nr_seq_interno_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
nr_sequencia_w		bigint;
nr_prescricao_w		bigint;		
 
C01 CURSOR FOR 
	SELECT	a.nr_prescricao, 
		a.nr_sequencia 
	from	prescr_material a 
	where	a.nr_seq_atend_medic = nr_seq_interno_p;
	

BEGIN 
 
update	paciente_atend_medic 
set	dt_cancelamento 	= clock_timestamp(), 
	nm_usuario_cancel	= nm_usuario_p, 
	ie_cancelada		= 'S' 
where	nr_seq_interno 		= nr_seq_interno_p;
 
 
open C01;
loop 
fetch C01 into	 
	nr_prescricao_w, 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	CALL Suspender_item_Prescricao(	nr_prescricao_w, 
					nr_sequencia_w, 
					'', 
					'', 
					'PRESCR_MATERIAL', 
					nm_usuario_p);
	end;
end loop;
close C01;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_item_oncologia ( nr_seq_interno_p bigint, nm_usuario_p text) FROM PUBLIC;

