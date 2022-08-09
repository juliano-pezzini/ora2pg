-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_gravar_texto_receita ( nr_sequencia_p bigint, ds_texto_p text, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE


/*
ie_opcao_p
F - Receita da farmácia
R - Medicamento de rotina
*/
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	if (ie_opcao_p = 'R') then
		update	fa_medicamento_rotina
		set	ds_texto_receita = ds_texto_p
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_opcao_p = 'F') then
		update	fa_receita_farmacia_item
		set	ds_texto_receita = ds_texto_p
		where	nr_sequencia = nr_sequencia_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_gravar_texto_receita ( nr_sequencia_p bigint, ds_texto_p text, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;
