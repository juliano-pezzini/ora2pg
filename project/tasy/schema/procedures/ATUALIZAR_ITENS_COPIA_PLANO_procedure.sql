-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_itens_copia_plano ( ie_manter_p text, ie_suspender_p text, ie_estender_p text, nr_seq_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_p <> 0) then

	update	w_copia_plano
	set    	ie_check_manter    = ie_manter_p,
		ie_check_suspender = ie_suspender_p,
		ie_check_estender  = ie_estender_p
	where	nr_sequencia       = nr_seq_p;

	commit;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_itens_copia_plano ( ie_manter_p text, ie_suspender_p text, ie_estender_p text, nr_seq_p bigint, nm_usuario_p text) FROM PUBLIC;

