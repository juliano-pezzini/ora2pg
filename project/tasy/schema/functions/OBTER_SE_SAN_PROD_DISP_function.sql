-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_san_prod_disp (nr_seq_producao_w bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_trans_w		bigint;
nr_seq_inutil_w		bigint;
nr_seq_emp_sai_w	bigint;

ds_retorno_w		varchar(1);


BEGIN

select	nr_seq_transfusao,
	nr_seq_inutil,
	nr_seq_emp_saida
into STRICT	nr_seq_trans_w,
	nr_seq_inutil_w,
	nr_seq_emp_sai_w
from san_producao
where nr_sequencia = nr_seq_producao_w;

if (nr_seq_trans_w IS NOT NULL AND nr_seq_trans_w::text <> '') or (nr_seq_inutil_w IS NOT NULL AND nr_seq_inutil_w::text <> '') or (nr_seq_emp_sai_w IS NOT NULL AND nr_seq_emp_sai_w::text <> '') then
	ds_retorno_w := 'N';
else
	select CASE WHEN count(*)=0 THEN 'S'  ELSE 'R' END
	into STRICT ds_retorno_w
	from san_reserva_prod
	where 	nr_seq_producao = nr_seq_producao_w
	and	ie_status <> 'N';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_san_prod_disp (nr_seq_producao_w bigint) FROM PUBLIC;
