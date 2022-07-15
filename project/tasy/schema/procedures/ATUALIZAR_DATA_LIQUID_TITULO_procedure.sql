-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_data_liquid_titulo ( nr_titulo_p bigint, dt_cancelamento_titulo_p timestamp, nm_usuario_p text) AS $body$
BEGIN

	if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (dt_cancelamento_titulo_p IS NOT NULL AND dt_cancelamento_titulo_p::text <> '') then

		update	titulo_receber
		set	dt_liquidacao	= trunc(dt_cancelamento_titulo_p),
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_titulo	= nr_titulo_p;

		commit;

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_data_liquid_titulo ( nr_titulo_p bigint, dt_cancelamento_titulo_p timestamp, nm_usuario_p text) FROM PUBLIC;

