-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_rotina_gas (nr_seq_rotina_p bigint) RETURNS varchar AS $body$
DECLARE


ds_item_w	varchar(2000);


BEGIN

select	max(substr(coalesce(nm_rotina, obter_descricao_padrao('GAS', 'DS_GAS', nr_seq_gas)),1,80))
into STRICT	ds_item_w
from	protocolo_medic_gas
where	nr_sequencia	= nr_seq_rotina_p;

return	ds_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_rotina_gas (nr_seq_rotina_p bigint) FROM PUBLIC;

