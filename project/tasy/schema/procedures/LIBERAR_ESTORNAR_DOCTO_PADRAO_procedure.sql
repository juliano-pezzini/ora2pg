-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_estornar_docto_padrao (nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE


/* IE_OPCAO_P
L	- Liberar;
E	- Estornar;
*/
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	if (ie_opcao_p	= 'L') then
		update	reg_lic_doc_padrao
		set	dt_liberacao 	= clock_timestamp(),
			nm_usuario_lib	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_sequencia_p;
	elsif (ie_opcao_p	= 'E') then
		update	reg_lic_doc_padrao
		set	dt_liberacao 	 = NULL,
			nm_usuario_lib	 = NULL,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_sequencia_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_estornar_docto_padrao (nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

