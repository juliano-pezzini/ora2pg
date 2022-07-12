-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_verifica_se_item_separar ( nr_seq_fa_entrega_p bigint) RETURNS varchar AS $body$
DECLARE

ie_separar_w	varchar(1);

BEGIN

if (nr_seq_fa_entrega_p IS NOT NULL AND nr_seq_fa_entrega_p::text <> '') then
	select	coalesce(max('S'),'N')
	into STRICT 	ie_separar_w
	from	fa_entrega_medicacao_item
	where	nr_seq_fa_entrega   = nr_seq_fa_entrega_p
	and (ie_status_medicacao = 'SM' or ie_status_medicacao = 'AC')
	and	coalesce(dt_cancelamento::text, '') = '';
end if;

return	ie_separar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_verifica_se_item_separar ( nr_seq_fa_entrega_p bigint) FROM PUBLIC;

