-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_ie_gerou_kit_js ( nr_prescricao_p bigint, ie_gerou_kit_p text, nm_usuario_p text) AS $body$
BEGIN

	update	prescr_medica
	set	ie_gerou_kit = ie_gerou_kit_p,
		dt_atualizacao = clock_timestamp()
	where	nr_prescricao = nr_prescricao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ie_gerou_kit_js ( nr_prescricao_p bigint, ie_gerou_kit_p text, nm_usuario_p text) FROM PUBLIC;

