-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tab_custo_html (nr_seq_tabela_p bigint) RETURNS bigint AS $body$
DECLARE


cd_tabela_custo_w	bigint;
			

BEGIN

select	cd_tabela_custo	
into STRICT	cd_tabela_custo_w
from	tabela_custo
where	nr_sequencia = nr_seq_tabela_p;

return	cd_tabela_custo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tab_custo_html (nr_seq_tabela_p bigint) FROM PUBLIC;

