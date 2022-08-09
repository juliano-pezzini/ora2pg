-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dt_revisao_contrato ( dt_revisao_p timestamp, nm_usuario_p text, nr_sequencia_p bigint) AS $body$
BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (dt_revisao_p IS NOT NULL AND dt_revisao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update	CONTRATO
	set	dt_revisao = dt_revisao_p,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dt_revisao_contrato ( dt_revisao_p timestamp, nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;
