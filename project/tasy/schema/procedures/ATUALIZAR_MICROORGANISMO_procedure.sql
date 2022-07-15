-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_microorganismo ( nr_seq_resultado_p bigint, nr_seq_result_item_p bigint, cd_microorganismo_old_p bigint, cd_microorganismo_new_p bigint, qt_microorganismo_p text, ds_obs_microorganismo_p text, ie_micro_sem_antib_p text, nm_usuario_p text, nr_cultura_microorg_p bigint ) AS $body$
BEGIN

update 	exame_lab_result_antib
set    	qt_microorganismo     		=  qt_microorganismo_p,
		ds_obs_microorganismo 		=  ds_obs_microorganismo_p,
		ie_micro_sem_antib    		=  ie_micro_sem_antib_p,
		cd_microorganismo     		=  coalesce(cd_microorganismo_new_p,cd_microorganismo_old_p),
		nm_usuario	    	 		=  nm_usuario_p,
		dt_atualizacao	     		=  clock_timestamp()
where  	cd_microorganismo     		=  cd_microorganismo_old_p
and    	nr_seq_resultado      		=  nr_seq_resultado_p
and    	nr_seq_result_item    		=  nr_seq_result_item_p
and	   	coalesce(nr_cultura_microorg,0) 	= coalesce(nr_cultura_microorg_p,0);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_microorganismo ( nr_seq_resultado_p bigint, nr_seq_result_item_p bigint, cd_microorganismo_old_p bigint, cd_microorganismo_new_p bigint, qt_microorganismo_p text, ds_obs_microorganismo_p text, ie_micro_sem_antib_p text, nm_usuario_p text, nr_cultura_microorg_p bigint ) FROM PUBLIC;

