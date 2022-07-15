-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ca_desfazer_liberacao (nr_sequencia_p bigint, ie_tipo_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	if (ie_tipo_p = '1') then
		update   ca_dados_reservatorio
		set      dt_liberacao  = NULL,
			 nm_usuario_liberacao  = NULL
		where    nr_sequencia = nr_sequencia_p;
	elsif (ie_tipo_p = '2') then
		update   ca_osmose_manutencao
		set      dt_liberacao  = NULL,
			 nm_usuario_lib  = NULL
		where    nr_sequencia = nr_sequencia_p;
	elsif (ie_tipo_p = '3') then
		update	ca_controle_ozonio
		set     dt_liberacao  = NULL,
			nm_usuario_lib  = NULL
		where   nr_sequencia = nr_sequencia_p;
	end if;
end if;
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ca_desfazer_liberacao (nr_sequencia_p bigint, ie_tipo_p text) FROM PUBLIC;

