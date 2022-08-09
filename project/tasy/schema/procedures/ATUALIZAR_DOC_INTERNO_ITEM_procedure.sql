-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_doc_interno_item ( nm_usuario_p text, nr_sequencia_p bigint, nr_doc_interno_p bigint, ie_procmat_p bigint) AS $body$
BEGIN

if (ie_procmat_p = 2) then
	update 	procedimento_paciente
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		nr_doc_interno = nr_doc_interno_p
	where	nr_sequencia = nr_sequencia_p;
elsif (ie_procmat_p = 3) then
	update	material_atend_paciente
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		nr_doc_interno = nr_doc_interno_p
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_doc_interno_item ( nm_usuario_p text, nr_sequencia_p bigint, nr_doc_interno_p bigint, ie_procmat_p bigint) FROM PUBLIC;
