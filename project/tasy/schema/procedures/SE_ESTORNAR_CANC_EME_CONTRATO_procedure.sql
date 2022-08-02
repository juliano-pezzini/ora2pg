-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE se_estornar_canc_eme_contrato ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	update	eme_contrato
	set	dt_cancelamento 	 = NULL,
		ds_motivo_cancelamento 	 = NULL,
		nm_usuario		= nm_usuario_p
	where	nr_sequencia 		= nr_sequencia_p;

	end;
	end if;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE se_estornar_canc_eme_contrato ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

