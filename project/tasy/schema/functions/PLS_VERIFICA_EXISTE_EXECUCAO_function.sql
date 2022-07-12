-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verifica_existe_execucao ( nr_seq_execucao_lote_p bigint) RETURNS bigint AS $body$
DECLARE


			
ds_retorno_w			bigint;
nr_seq_req_proc_w		bigint;
nr_seq_req_mat_w		bigint;	
nr_seq_requisicao_w		bigint;	
ie_status_w			varchar(2);
qt_item_zerado_w		pls_requisicao_proc.qt_procedimento%type := 0;			

	
C01 CURSOR FOR
	SELECT	b.nr_seq_req_mat,
		b.nr_seq_req_proc,
		b.nr_seq_requisicao
	from	pls_lote_execucao_req a,
		pls_itens_lote_execucao b
	where	a.nr_sequencia 		= b.nr_seq_lote_exec
	and	a.nr_sequencia		= nr_seq_execucao_lote_p
	and	b.ie_permite_execucao 	= 'S'
	and	b.ie_executar 		= 'S';				
			

BEGIN


open C01;
loop
fetch C01 into
	nr_seq_req_mat_w,
	nr_seq_req_proc_w,
	nr_seq_requisicao_w;		
EXIT WHEN NOT FOUND; /* apply on C01 */
begin
	if (nr_seq_req_proc_w IS NOT NULL AND nr_seq_req_proc_w::text <> '') then
		select 	pls_quant_itens_pendentes_exec(qt_procedimento,qt_proc_executado),
			ie_status
		into STRICT	qt_item_zerado_w,
			ie_status_w
		from 	pls_requisicao_proc
		where	nr_sequencia = nr_seq_req_proc_w;
	elsif (nr_seq_req_mat_w IS NOT NULL AND nr_seq_req_mat_w::text <> '') then
		select 	pls_quant_itens_pendentes_exec(qt_material, qt_mat_executado),
			ie_status
		into STRICT	qt_item_zerado_w,
			ie_status_w
		from 	pls_requisicao_mat
		where	nr_sequencia = nr_seq_req_mat_w;
	end if;

	if (ie_status_w = 'C') then
		ds_retorno_w := 1110929;
		exit;
	elsif (qt_item_zerado_w = 0) then
		ds_retorno_w := 199122;
		exit;
	end if;
end;
end loop;
close C01;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verifica_existe_execucao ( nr_seq_execucao_lote_p bigint) FROM PUBLIC;
