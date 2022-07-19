-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sae_atualizar_item_result ( nr_seq_topografia_p bigint, nr_sequencia_p bigint, ie_lado_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	update	pe_prescr_item_result
	set	nr_seq_topografia = nr_seq_topografia_p,
		ie_lado		= ie_lado_p,
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_sequencia_p;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sae_atualizar_item_result ( nr_seq_topografia_p bigint, nr_sequencia_p bigint, ie_lado_p text, nm_usuario_p text) FROM PUBLIC;

