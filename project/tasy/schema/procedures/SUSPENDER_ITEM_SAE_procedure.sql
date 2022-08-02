-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_item_sae ( nr_seq_pe_proc_p bigint, cd_motivo_p bigint, ds_motivo_p text, nm_usuario_p text) AS $body$
DECLARE

 
				 
nr_sequencia_w		bigint;
nr_prescricao_w		bigint;	
nr_seq_cpoe_interv_w		pe_prescr_proc.nr_seq_cpoe_interv%type;
				
				 
				 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_prescricao 
	from	prescr_material 
	where	nr_seq_pe_proc	= nr_seq_pe_proc_p;
				

BEGIN 
 
update	pe_prescr_proc 
set	dt_suspensao	= clock_timestamp(), 
	nm_usuario_susp	= nm_usuario_p, 
	IE_SUSPENSO	= 'S' 
where	nr_sequencia	= nr_seq_pe_proc_p;
 
select	coalesce(nr_seq_cpoe_interv,0) 
into STRICT	nr_seq_cpoe_interv_w 
from	pe_prescr_proc 
where	nr_sequencia	= nr_seq_pe_proc_p;
 
if (nr_seq_cpoe_interv_w <> 0) then 
	update	cpoe_intervencao 
	set		dt_suspensao	= clock_timestamp(), 
			dt_lib_suspensao	= clock_timestamp(), 
			dt_fim	= clock_timestamp(), 
			nm_usuario_susp	= nm_usuario_p 
	where	nr_sequencia	= nr_seq_cpoe_interv_w;
end if;
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w, 
	nr_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL Suspender_item_Prescricao(	nr_prescricao_w, 
					nr_sequencia_w, 
					cd_motivo_p, 
					ds_motivo_p, 
					'PRESCR_MATERIAL', 
					nm_usuario_p, 
					924);
	end;
end loop;
close C01;
 
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_item_sae ( nr_seq_pe_proc_p bigint, cd_motivo_p bigint, ds_motivo_p text, nm_usuario_p text) FROM PUBLIC;

