-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_grid_atend_local_pa (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_w		varchar(150);
dt_data_local_w	varchar(150);


BEGIN

select  max(coalesce((coalesce(dt_saida_local,clock_timestamp()) - dt_entrada_local) * 1440,''))
into STRICT	dt_data_local_w
from   	historico_localizacao_pa a
where  	a.nr_atendimento = nr_atendimento_p
and    	a.dt_entrada_local = (SELECT max(b.dt_entrada_local) from historico_localizacao_pa b where a.nr_atendimento = b.nr_atendimento);

if (dt_data_local_w = '') then
	return	dt_data_local_w;
else
	select  max(coalesce(ds_cor,''))
	into STRICT	ds_cor_w
	from   	pa_local_cor
	where  	qt_tempo_inicial <= dt_data_local_w
	and    	qt_tempo_final > dt_data_local_w;
end if;


return	ds_cor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_grid_atend_local_pa (nr_atendimento_p bigint) FROM PUBLIC;

