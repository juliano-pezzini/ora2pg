-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_diag_proc_relevante ( nr_seq_diag_proc_p bigint, ie_commit_p text default 'S') AS $body$
BEGIN

	delete	FROM cirurgia_descr_relevante
	where	nr_sequencia = nr_seq_diag_proc_p;

if (coalesce(ie_commit_p,'N') = 'S') and (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_diag_proc_relevante ( nr_seq_diag_proc_p bigint, ie_commit_p text default 'S') FROM PUBLIC;

