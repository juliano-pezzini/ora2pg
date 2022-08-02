-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_centro_custo ( cd_centro_custo_p pls_mensalidade_seg_item.cd_centro_custo%type, nr_seq_item_p pls_mensalidade_seg_item.nr_sequencia%type) AS $body$
BEGIN
if	(cd_centro_custo_p IS NOT NULL AND cd_centro_custo_p::text <> '' AND nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then

	update pls_mensalidade_seg_item
	set cd_centro_custo = cd_centro_custo_p
	where nr_sequencia = nr_seq_item_p;

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_centro_custo ( cd_centro_custo_p pls_mensalidade_seg_item.cd_centro_custo%type, nr_seq_item_p pls_mensalidade_seg_item.nr_sequencia%type) FROM PUBLIC;

