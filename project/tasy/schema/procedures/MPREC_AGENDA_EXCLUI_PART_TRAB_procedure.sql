-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprec_agenda_exclui_part_trab (nm_usuario_p text, ie_opcao_p text, nr_sequencia_p bigint default null) AS $body$
BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	if (ie_opcao_p = 'S') then

		delete	FROM MPREV_AGENDA_PARTIC_TRAB
		where	nm_usuario = nm_usuario_p;

	elsif (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

		delete	FROM MPREV_AGENDA_PARTIC_TRAB
		where 	nr_seq_participante = nr_sequencia_p
		and	nm_usuario = nm_usuario_p;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprec_agenda_exclui_part_trab (nm_usuario_p text, ie_opcao_p text, nr_sequencia_p bigint default null) FROM PUBLIC;

