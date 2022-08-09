-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hfp_finalizar_programa ( nr_sequencia_p bigint, nr_tipo_finalizacao_p bigint, nm_usuario_p text) AS $body$
BEGIN

if ((coalesce(nr_sequencia_p,0) > 0) and (coalesce(nr_tipo_finalizacao_p,0) > 0)) then
	begin
	update	hfp_paciente
	set	dt_fim			= clock_timestamp(),
		nm_usuario_fim		= nm_usuario_p,
		ie_status 		= 'F',
		nr_seq_motivo_fim 	= nr_tipo_finalizacao_p
	where	nr_sequencia 		= nr_sequencia_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hfp_finalizar_programa ( nr_sequencia_p bigint, nr_tipo_finalizacao_p bigint, nm_usuario_p text) FROM PUBLIC;
