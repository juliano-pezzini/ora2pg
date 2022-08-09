-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_amostra_exame ( nr_prescricao_p bigint, nr_seq_material_p bigint, nr_sequencia_p bigint, cd_material_exame_p text, nm_usuario_p text) AS $body$
BEGIN

update 	prescr_procedimento
set 	ie_amostra = 'S',
	ie_status_atend = 20,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where  	nr_prescricao = nr_prescricao_p
and    	cd_material_exame = cd_material_exame_p;

update 	prescr_proc_material
set 	ie_amostra = 'S',
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where  	nr_prescricao = nr_prescricao_p
and    	nr_seq_material = nr_seq_material_p
and    	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_amostra_exame ( nr_prescricao_p bigint, nr_seq_material_p bigint, nr_sequencia_p bigint, cd_material_exame_p text, nm_usuario_p text) FROM PUBLIC;
