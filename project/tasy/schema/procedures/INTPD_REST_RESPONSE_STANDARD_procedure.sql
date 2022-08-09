-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_rest_response_standard ( nr_sequencia_p bigint, ds_message_p text, ie_status_response_p integer) AS $body$
DECLARE


ds_procedure_w		intpd_eventos_sistema.ds_procedure%type;


BEGIN


select	max(a.ds_procedure)
into STRICT	ds_procedure_w
from	intpd_eventos_sistema a,
		intpd_fila_transmissao b
where	1 = 1
and		b.NR_SEQ_EVENTO_SISTEMA = a.nr_sequencia
and		b.nr_sequencia = nr_sequencia_p;


update	intpd_fila_transmissao
set		ds_message_response = ds_message_p,
		ie_status_http = ie_status_response_p
where	nr_sequencia = nr_sequencia_p;

if (coalesce(ds_procedure_w,'NULL') <> 'NULL') then
	CALL exec_sql_dinamico('INTPDTASY', 'declare begin ' || ds_procedure_w || '(' || nr_sequencia_p || '); end;');
else

	if (substr(ie_status_response_p,1,1) not in ('1','2')) then

		CALL wheb_mensagem_pck.exibir_mensagem_abort('Response error');

	else

		update	intpd_fila_transmissao
		set		ie_status = 'S'
		where	nr_sequencia = nr_sequencia_p;

	end if;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_rest_response_standard ( nr_sequencia_p bigint, ds_message_p text, ie_status_response_p integer) FROM PUBLIC;
