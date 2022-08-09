-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_obs_medica ( ds_obs_medica_p text, nm_usuario_p text, nr_sequencia_p bigint) AS $body$
BEGIN

	if (ds_obs_medica_p IS NOT NULL AND ds_obs_medica_p::text <> '') then

		UPDATE SAN_TRANS_REACAO
		SET ds_obs_medico = DS_OBS_MEDICA_P,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		WHERE nr_sequencia = nr_sequencia_p;

		commit;

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_obs_medica ( ds_obs_medica_p text, nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;
