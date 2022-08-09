-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_repasse_terc_item ( nr_repasse_terceiro_p text, nr_sequencia_item_p text, nr_sequencia_p text) AS $body$
DECLARE


nr_sequencia_item_w	repasse_terceiro_item.nr_sequencia_item%type;


BEGIN

select	coalesce(max(nr_sequencia_item),0) + 1
into STRICT	nr_sequencia_item_w
from	repasse_terceiro_item
where	nr_repasse_terceiro	= nr_repasse_terceiro_p;


update	repasse_terceiro_item
set	nr_repasse_terceiro	= nr_repasse_terceiro_p,
	nr_sequencia_item	= coalesce(nr_sequencia_item_p, nr_sequencia_item_w)
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_repasse_terc_item ( nr_repasse_terceiro_p text, nr_sequencia_item_p text, nr_sequencia_p text) FROM PUBLIC;
