-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_item_checklist ( nr_seq_check_proc_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_seq_checklist_w 	varchar(255);


BEGIN

if (nr_seq_check_proc_item_p IS NOT NULL AND nr_seq_check_proc_item_p::text <> '') then
	select	max(nm_item_checklist)
	into STRICT	ds_seq_checklist_w
	from	checklist_processo_item
	where	nr_sequencia = nr_seq_check_proc_item_p;
end if;

return ds_seq_checklist_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_item_checklist ( nr_seq_check_proc_item_p bigint) FROM PUBLIC;

