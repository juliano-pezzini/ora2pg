-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_ret_agenda_consulta ( nr_seq_agenda_cons_p bigint, nr_atendimento_p bigint, ie_classif_agenda_p text, ie_status_agenda_p text, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_seq_agenda_cons_p,0) > 0) then

	update	agenda_consulta
	set	ie_classif_agenda	= coalesce(ie_classif_agenda_p, ie_classif_agenda),
		nr_atendimento		= coalesce(nr_atendimento_p, nr_atendimento),
		ie_status_agenda	= coalesce(ie_status_agenda_p, ie_status_agenda)
	where	nr_sequencia		= nr_seq_agenda_cons_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ret_agenda_consulta ( nr_seq_agenda_cons_p bigint, nr_atendimento_p bigint, ie_classif_agenda_p text, ie_status_agenda_p text, nm_usuario_p text) FROM PUBLIC;
