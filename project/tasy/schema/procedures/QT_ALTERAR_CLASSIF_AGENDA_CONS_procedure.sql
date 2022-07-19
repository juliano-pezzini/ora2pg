-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_alterar_classif_agenda_cons (nr_seq_pend_agenda_p text, ie_classif_agenda_p text, nr_seq_atendimento_p bigint) AS $body$
BEGIN
if (coalesce(nr_seq_pend_agenda_p,0) > 0) and (ie_classif_agenda_p IS NOT NULL AND ie_classif_agenda_p::text <> '') then

	update	w_gerar_consulta_quimio
	set		ie_classif_agenda = ie_classif_agenda_p
	where	nr_seq_pend_agenda = nr_seq_pend_agenda_p
	and		nr_seq_atendimento = nr_seq_atendimento_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_alterar_classif_agenda_cons (nr_seq_pend_agenda_p text, ie_classif_agenda_p text, nr_seq_atendimento_p bigint) FROM PUBLIC;

