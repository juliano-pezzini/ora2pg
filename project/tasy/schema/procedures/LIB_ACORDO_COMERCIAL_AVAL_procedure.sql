-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lib_acordo_comercial_aval (nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/*
L - DT_LIBERACAO
V - DT_VERIFICACAO
*/
BEGIN

if ie_opcao_p = 'L' then
	update	com_cliente_acordo_aval
	set		dt_liberacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;

end if;

if ie_opcao_p = 'V' then
	update	com_cliente_acordo_aval
	set		dt_verificacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lib_acordo_comercial_aval (nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
