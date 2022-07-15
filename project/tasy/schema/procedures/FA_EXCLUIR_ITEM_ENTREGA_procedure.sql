-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_excluir_item_entrega (nr_seq_item_entr_p bigint) AS $body$
BEGIN

delete
from	fa_entr_medic_item_receita
where	nr_seq_item_entrega = nr_seq_item_entr_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_excluir_item_entrega (nr_seq_item_entr_p bigint) FROM PUBLIC;

