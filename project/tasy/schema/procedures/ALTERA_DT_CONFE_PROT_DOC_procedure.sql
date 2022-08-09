-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_dt_confe_prot_doc ( nr_documento_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nm_usuario_conf_p text) AS $body$
BEGIN

if (nr_documento_p IS NOT NULL AND nr_documento_p::text <> '')
	and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update	protocolo_doc_item
	set    	dt_conferencia = clock_timestamp(),
		nm_usuario_conf = nm_usuario_conf_p
	where  	nr_documento = nr_documento_p
	and    	nr_sequencia = nr_sequencia_p;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_dt_confe_prot_doc ( nr_documento_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nm_usuario_conf_p text) FROM PUBLIC;
