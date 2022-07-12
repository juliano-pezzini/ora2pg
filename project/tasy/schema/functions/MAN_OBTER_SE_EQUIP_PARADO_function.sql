-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_equip_parado ( nr_seq_equipamento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_parado_w			varchar(1);


BEGIN

select	coalesce(ie_parado,'N')
into STRICT	ie_parado_w
from	man_equipamento
where	nr_sequencia = nr_seq_equipamento_p;

return	ie_parado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_equip_parado ( nr_seq_equipamento_p bigint) FROM PUBLIC;
