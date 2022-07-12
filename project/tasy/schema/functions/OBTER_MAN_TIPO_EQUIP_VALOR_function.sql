-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_man_tipo_equip_valor ( nr_seq_equipamento_p bigint, ie_seq_apresentacao_p bigint) RETURNS varchar AS $body$
DECLARE


cd_valor_w			varchar(40);


BEGIN

select	 max(b.cd_valor)
into STRICT	cd_valor_w
from	man_tipo_equipamento_atrib a,
	man_tipo_equipamento_valor b
where	a.nr_sequencia = b.nr_seq_tipo_equip_atrib
and	b.nr_seq_equipamento = nr_seq_equipamento_p
and	a.ie_seq_apresentacao = ie_seq_apresentacao_p;

return	cd_valor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_man_tipo_equip_valor ( nr_seq_equipamento_p bigint, ie_seq_apresentacao_p bigint) FROM PUBLIC;
