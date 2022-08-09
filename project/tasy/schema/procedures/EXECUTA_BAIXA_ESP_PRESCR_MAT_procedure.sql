-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executa_baixa_esp_prescr_mat ( cd_motivo_baixa_p bigint, nr_prescricao_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (cd_motivo_baixa_p IS NOT NULL AND cd_motivo_baixa_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update 	prescr_material
	set 	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		cd_motivo_baixa = cd_motivo_baixa_p
	where 	nr_prescricao = nr_prescricao_p
	and 	cd_motivo_baixa = 0;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executa_baixa_esp_prescr_mat ( cd_motivo_baixa_p bigint, nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
