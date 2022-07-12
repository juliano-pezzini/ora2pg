-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_valor_fixo (nr_seq_rat_p bigint) RETURNS bigint AS $body$
DECLARE


cd_executor_w		varchar(10);
vl_fixo_w			double precision	:= 0;


BEGIN

select	cd_executor
into STRICT	cd_executor_w
from	proj_rat
where	nr_sequencia	= nr_seq_rat_p;

select	coalesce(max(vl_fixo),0)
into STRICT	vl_fixo_w
from	proj_consultor_nivel
where	cd_consultor	= cd_executor_w
and		dt_avaliacao	= (SELECT max(dt_avaliacao) from proj_consultor_nivel where cd_consultor = cd_executor_w);


return	vl_fixo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_valor_fixo (nr_seq_rat_p bigint) FROM PUBLIC;
