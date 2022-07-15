-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_gravar_laudo_pac_relat ( nr_seq_laudo_p bigint, nr_seq_relatorio_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
if (nr_seq_laudo_p IS NOT NULL AND nr_seq_laudo_p::text <> '') and (nr_seq_relatorio_p IS NOT NULL AND nr_seq_relatorio_p::text <> '') then 
	begin 
	 
	CALL deletar_laudo_paciente_relat(nr_seq_laudo_p);
	CALL gravar_laudo_paciente_relat(nr_seq_laudo_p,nr_seq_relatorio_p,nm_usuario_p);
	 
	end;
end if;
 
commit;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_gravar_laudo_pac_relat ( nr_seq_laudo_p bigint, nr_seq_relatorio_p bigint, nm_usuario_p text) FROM PUBLIC;

