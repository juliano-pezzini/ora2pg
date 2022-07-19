-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_update_motivo_cancelamento ( ie_motivo_cancelamento_p text, nr_sequencia_p bigint, nm_usuario_p text, dt_obito_p timestamp, ds_motivo_obito_p text) AS $body$
BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then

	update	regulacao_atendimento
	set	ie_motivo_cancelamento = ie_motivo_cancelamento_p,
	        	dt_obito = dt_obito_p,
		ds_motivo_obito = ds_motivo_obito_p
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_update_motivo_cancelamento ( ie_motivo_cancelamento_p text, nr_sequencia_p bigint, nm_usuario_p text, dt_obito_p timestamp, ds_motivo_obito_p text) FROM PUBLIC;

