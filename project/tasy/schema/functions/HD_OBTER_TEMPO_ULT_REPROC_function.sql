-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_tempo_ult_reproc (nr_seq_dialisador_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

nr_seq_reproc_w		bigint;
dt_referencia_w		timestamp;
qt_horas_w		varchar(10);
ds_retorno_w		varchar(255);
dt_priming_w		timestamp;


BEGIN

select 	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_reproc_w
from	hd_dialisador_reproc
where 	nr_seq_dialisador = nr_seq_dialisador_p
and	(dt_fim IS NOT NULL AND dt_fim::text <> '');

select	max(dt_priming)
into STRICT	dt_priming_w
from	hd_dializador
where	nr_Sequencia = nr_seq_dialisador_p;

qt_horas_w	:= '0';

dt_referencia_w	:= dt_priming_w;

if (nr_seq_reproc_w > 0) then

	select 	coalesce(dt_fim,dt_inicio)
	into STRICT	dt_referencia_w
	from	hd_dialisador_reproc
	where	nr_sequencia = nr_seq_reproc_w;

end if;

qt_horas_w	:= trunc((clock_timestamp() - dt_referencia_w) * 24);

if (ie_opcao_p = 'H') then

	ds_retorno_w	:= qt_horas_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_tempo_ult_reproc (nr_seq_dialisador_p bigint, ie_opcao_p text) FROM PUBLIC;

