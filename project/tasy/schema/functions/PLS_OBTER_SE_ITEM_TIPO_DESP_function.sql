-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_item_tipo_desp ( nr_seq_item_p bigint, nr_seq_grupo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_despesa_w		varchar(10);
ie_retorno_w			varchar(1)	:= 'S';
ie_tipo_item_w			varchar(1);
ie_permite_w			varchar(1)	:= 'S';
nr_seq_item_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_partic_proc_w		bigint;
nr_seq_analise_w		bigint;
nr_seq_ocorrencia_w		bigint;
qt_grupos_w			bigint;
nr_seq_ocorr_grupo_w		bigint;
nr_seq_ocorr_benef_w		bigint;

C01 CURSOR FOR
	SELECT	distinct a.nr_seq_ocorrencia
	from	pls_analise_conta_item_v a
	where	a.nr_seq_analise	= nr_seq_analise_w
	and	((a.nr_seq_conta_proc = nr_seq_conta_proc_w) or (a.nr_seq_conta_mat = nr_seq_conta_mat_w) or (a.nr_seq_proc_partic = nr_seq_partic_proc_w));
	
C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_ocorrencia_grupo	a
	where	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_w
	and	a.nr_seq_grupo		= nr_seq_grupo_p
	and	a.ie_situacao		= 'A';


BEGIN
select	max(a.nr_seq_conta_mat),
	max(a.nr_seq_conta_proc),
	max(a.nr_seq_partic_proc),
	max(a.nr_seq_analise),
	max(a.ie_tipo_despesa),
	max(a.ie_tipo_item)
into STRICT	nr_seq_conta_mat_w,
	nr_seq_conta_proc_w,
	nr_seq_partic_proc_w,
	nr_seq_analise_w,
	ie_tipo_despesa_w,
	ie_tipo_item_w
from	w_pls_resumo_conta	a
where	nr_sequencia	= nr_seq_item_p;

open C01;
loop
fetch C01 into	
	nr_seq_ocorr_benef_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(a.nr_seq_ocorrencia)
	into STRICT	nr_seq_ocorrencia_w
	from	pls_ocorrencia_benef	a
	where	a.nr_sequencia	= nr_seq_ocorr_benef_w;
	
	open C02;
	loop
	fetch C02 into	
		nr_seq_ocorr_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ie_permite_w	:= pls_obter_se_grupo_tipo_desp(nr_seq_ocorr_grupo_w,ie_tipo_despesa_w,ie_tipo_item_w);
		
		if (ie_permite_w = 'N') then
			ie_retorno_w	:= ie_permite_w;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_item_tipo_desp ( nr_seq_item_p bigint, nr_seq_grupo_p bigint) FROM PUBLIC;
