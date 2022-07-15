-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_excluir_lote_item ( nr_seq_medic_item_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_medic_item_p IS NOT NULL AND nr_seq_medic_item_p::text <> '') then

	delete 	from fa_entrega_medic_item_lote
	where	nr_seq_medic_item = nr_seq_medic_item_p
	and	(nr_seq_lote IS NOT NULL AND nr_seq_lote::text <> '');

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_excluir_lote_item ( nr_seq_medic_item_p bigint, nm_usuario_p text) FROM PUBLIC;

