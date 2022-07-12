-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mdc_obter_se_pend_task_list (nr_seq_episodio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);			

BEGIN

begin
select	'S'
into STRICT	ds_retorno_w
from	wl_worklist a
where	a.nr_atendimento in (SELECT	x.nr_atendimento
	from	atendimento_paciente x
	where	x.nr_seq_episodio	= nr_seq_episodio_p
	and	coalesce(x.dt_cancelamento::text, '') = '')
and 	coalesce(ie_cancelado, 'N') = 'N'
and	coalesce(a.dt_final_real::text, '') = ''  LIMIT 1;
exception
when others then
	ds_retorno_w := 'N';
end;


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mdc_obter_se_pend_task_list (nr_seq_episodio_p bigint) FROM PUBLIC;

