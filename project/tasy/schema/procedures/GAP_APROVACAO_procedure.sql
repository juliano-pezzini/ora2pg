-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gap_aprovacao ( nr_seq_gap_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/*
A - Aprovação.
D - Desfazer Aprovação.
*/
BEGIN

if (ie_opcao_p = 'A') then
	update	latam_gap
	set	dt_aprovacao			= clock_timestamp(),
		nm_usuario_aprovacao		= nm_usuario_p
		where	nr_sequencia 		= nr_seq_gap_p;
	else if (ie_opcao_p = 'D') then
		update	latam_gap
		set	dt_aprovacao		 = NULL,
			nm_usuario_aprovacao	 = NULL
		where	nr_sequencia 		= nr_seq_gap_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gap_aprovacao ( nr_seq_gap_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
