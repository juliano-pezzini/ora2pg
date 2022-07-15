-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_mat_item_coleta (nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN
	if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
		CALL gerar_prescr_proc_mat_item(nr_prescricao_p, nm_usuario_p, cd_estabelecimento_p);
	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_mat_item_coleta (nr_prescricao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

