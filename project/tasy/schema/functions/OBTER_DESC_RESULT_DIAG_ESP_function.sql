-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_result_diag_esp (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255) := '';


BEGIN


select 	max(c.ds_result_esperado)
into STRICT	ds_retorno_w
from   	pe_prescr_diag_res_esp a,
	pe_resultado_esperado c
where  	a.nr_seq_diag_result = c.nr_sequencia
and    	a.nr_sequencia = nr_sequencia_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_result_diag_esp (nr_sequencia_p bigint) FROM PUBLIC;

