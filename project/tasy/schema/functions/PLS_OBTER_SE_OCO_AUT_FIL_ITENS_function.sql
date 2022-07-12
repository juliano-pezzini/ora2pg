-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_oco_aut_fil_itens ( nr_seq_ocor_filtro_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
qt_reg_proc_w			bigint  := 0;
qt_reg_mat_w			bigint  := 0;


BEGIN

select	count(1)
into STRICT	qt_reg_proc_w
from	pls_ocor_aut_filtro_proc
where	nr_seq_ocor_aut_filtro	= nr_seq_ocor_filtro_p
and	ie_situacao		= 'A';

select	count(1)
into STRICT	qt_reg_mat_w
from	pls_ocor_aut_filtro_mat
where	nr_seq_ocor_aut_filtro	= nr_seq_ocor_filtro_p
and	ie_situacao		= 'A';

if (qt_reg_proc_w > 0) or (qt_reg_mat_w > 0) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_oco_aut_fil_itens ( nr_seq_ocor_filtro_p bigint) FROM PUBLIC;

