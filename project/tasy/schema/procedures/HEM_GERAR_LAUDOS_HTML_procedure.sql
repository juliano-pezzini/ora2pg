-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_gerar_laudos_html ( nr_seq_proc_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_classif_w	varchar(15);


BEGIN
if (coalesce(nr_seq_proc_p,0) > 0) then

	select	max(ie_classif)
	into STRICT	ie_classif_w
	from	hem_proc
	where	nr_sequencia = nr_seq_proc_p;

	if (ie_classif_w = 'CAT') then
		CALL hem_gerar_laudo(nr_seq_proc_p, nm_usuario_p);
	elsif (ie_classif_w = 'ATC') then
		CALL hem_gerar_laudo_angioplastia(nr_seq_proc_p, nm_usuario_p);
	elsif (ie_classif_w = 'COD') then
		CALL hem_gerar_laudo_congenitas(nr_seq_proc_p, nm_usuario_p);
	elsif (ie_classif_w = 'O') then
		CALL hem_gerar_laudo_outros_proc(nr_seq_proc_p, nm_usuario_p);
	end if;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_gerar_laudos_html ( nr_seq_proc_p bigint, nm_usuario_p text) FROM PUBLIC;
