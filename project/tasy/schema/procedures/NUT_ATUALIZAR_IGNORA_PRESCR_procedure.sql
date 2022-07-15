-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_atualizar_ignora_prescr ( nr_prescricao_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	update	prescr_medica
	set	dt_ignora_prescr_nut = clock_timestamp(),
		nm_usuario_ignora_nut = nm_usuario_p
	where	nr_prescricao = nr_prescricao_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_atualizar_ignora_prescr ( nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

