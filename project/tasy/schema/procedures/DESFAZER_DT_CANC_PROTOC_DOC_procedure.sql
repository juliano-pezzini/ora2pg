-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_dt_canc_protoc_doc ( nr_sequencia_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update	protocolo_documento
	set 	dt_cancelamento    	 = NULL,
		nm_usuario_canc    	 = NULL
	where 	nr_sequencia		= nr_sequencia_p;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_dt_canc_protoc_doc ( nr_sequencia_p bigint) FROM PUBLIC;

