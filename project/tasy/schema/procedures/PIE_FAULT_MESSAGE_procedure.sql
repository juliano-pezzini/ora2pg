-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pie_fault_message ( nr_seq_message_p pie_message.nr_sequencia%type, cd_status_p pie_message_fault.cd_status%type, cd_severity_p pie_message_fault.cd_severity%type, ds_reason_p pie_message_fault.ds_reason%type) AS $body$
DECLARE

  nr_sequencia_w 	pie_message_fault.nr_sequencia%type;

BEGIN
	if((cd_status_p IS NOT NULL AND cd_status_p::text <> '')
	and (cd_severity_p IS NOT NULL AND cd_severity_p::text <> '')
	and (ds_reason_p IS NOT NULL AND ds_reason_p::text <> '')
	and (nr_seq_message_p IS NOT NULL AND nr_seq_message_p::text <> '')) then

		select nextval('pie_message_fault_seq')
		into STRICT   nr_sequencia_w
		;

		insert into pie_message_fault(nr_sequencia,
		cd_status,
		nr_seq_message,
		cd_severity,
		ds_reason
		)
		values (nr_sequencia_w,
                 	cd_status_p,
                 	nr_seq_message_p,
                 	cd_severity_p,
                 	ds_reason_p
		);
	commit;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1088701);
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pie_fault_message ( nr_seq_message_p pie_message.nr_sequencia%type, cd_status_p pie_message_fault.cd_status%type, cd_severity_p pie_message_fault.cd_severity%type, ds_reason_p pie_message_fault.ds_reason%type) FROM PUBLIC;
