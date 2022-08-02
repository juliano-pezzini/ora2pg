-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_subst_texto_envio_corresp ( nr_seq_item_p bigint, ds_texto_padrao_p text) AS $body$
BEGIN

update	san_envio_corresp_item
set	ds_texto_padrao	= ds_texto_padrao_p
where	nr_sequencia	= nr_seq_item_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_subst_texto_envio_corresp ( nr_seq_item_p bigint, ds_texto_padrao_p text) FROM PUBLIC;

