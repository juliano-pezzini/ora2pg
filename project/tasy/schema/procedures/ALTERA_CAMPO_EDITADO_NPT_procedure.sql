-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_campo_editado_npt ( nr_sequencia_p bigint, ie_valor_p text, ie_tabela_p text) AS $body$
DECLARE


/*IE_TABELA_P
A - NUT_PAC - IE_ALTERADA
S - NUT_PAC - IE_EDITADO
P - NUT_PAC_ELEM_MAT
E - NUT_PAC_ELEMENTO
*/
BEGIN

if (ie_valor_p IS NOT NULL AND ie_valor_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	if (ie_tabela_p = 'S') then
		update	nut_pac
		set		ie_editado = ie_valor_p
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_tabela_p = 'P') then
		update	nut_pac_elem_mat
		set		ie_editado = ie_valor_p
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_tabela_p = 'E') then
		update	nut_pac_elemento
		set		ie_editado = ie_valor_p
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_tabela_p = 'A') then
		update	nut_pac
		set		ie_alterada = ie_valor_p
		where	nr_sequencia = nr_sequencia_p;
	end if;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_campo_editado_npt ( nr_sequencia_p bigint, ie_valor_p text, ie_tabela_p text) FROM PUBLIC;
