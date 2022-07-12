-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estag_alt (nr_seq_proj_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2);
nr_seq_estagio_w	bigint;
qt_regra_w			bigint;

BEGIN

ds_retorno_w	:=	'S';

select  max(nr_seq_estagio)
into STRICT	nr_seq_estagio_w
from	gpi_projeto
where	nr_sequencia = nr_seq_proj_p;


select  count(*)
into STRICT	qt_regra_w
from	gpi_estagio
where	ie_altera_percent_etapa = 'S'
and	nr_sequencia = nr_seq_estagio_w;

if (qt_regra_w > 0) then

	select  coalesce(max(ie_altera_percent_etapa),'N')
	into STRICT   	ds_retorno_w
	from	gpi_estagio
	where	nr_sequencia = nr_seq_estagio_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estag_alt (nr_seq_proj_p bigint) FROM PUBLIC;
