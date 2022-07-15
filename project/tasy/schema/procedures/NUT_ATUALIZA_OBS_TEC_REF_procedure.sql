-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_atualiza_obs_tec_ref (ds_observacao_tec_p text, nr_atendimento_p bigint, dt_dieta_p timestamp, cd_refeicao_p text, ie_destino_dieta_p text default 'P') AS $body$
BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (dt_dieta_p IS NOT NULL AND dt_dieta_p::text <> '') and (cd_refeicao_p IS NOT NULL AND cd_refeicao_p::text <> '') then

	update	mapa_dieta
	set	ds_observacao_tec = ds_observacao_tec_p
	where	nr_atendimento = nr_atendimento_p
	and	dt_dieta = dt_dieta_p
	and	cd_refeicao = cd_refeicao_p
	and	ie_destino_dieta = ie_destino_dieta_p;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_atualiza_obs_tec_ref (ds_observacao_tec_p text, nr_atendimento_p bigint, dt_dieta_p timestamp, cd_refeicao_p text, ie_destino_dieta_p text default 'P') FROM PUBLIC;

