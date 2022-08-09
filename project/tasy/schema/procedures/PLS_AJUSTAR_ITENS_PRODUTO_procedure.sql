-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_itens_produto () AS $body$
BEGIN

delete	from pls_plano_item_operacao
where	nr_seq_plano_item in (	SELECT	nr_sequencia
				from	pls_plano_item
				where	coalesce(cd_estabelecimento,1) <> 1);

delete	from pls_plano_item
where	coalesce(cd_estabelecimento,1) <> 1;

update	pls_plano_item
set	cd_estabelecimento  = NULL
where	cd_estabelecimento = 1;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_itens_produto () FROM PUBLIC;
