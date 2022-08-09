-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_consistir_nota_fiscal ( nr_seq_nota_cobr_p bigint, nr_seq_fatura_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_link_nfe_w			varchar(120);
nr_sequencia_w			bigint;

 
C01 CURSOR FOR 
	SELECT	ds_link_nfe, 
		nr_sequencia 
	from	ptu_nota_fiscal 
	where	nr_seq_nota_cobr	= nr_seq_nota_cobr_p;

BEGIN
/*open C01; 
loop 
fetch C01 into	 
	ds_link_nfe_w, 
	nr_sequencia_w; 
exit when C01%notfound; 
	begin 
	if	(ds_link_nfe_w is null) then 
		ptu_inserir_consist_fatura(nr_seq_fatura_p, 1, '506', 'LINK_NFe', null, null, nr_sequencia_w,nm_usuario_p); 
	end if; 
	end; 
end loop; 
close C01;*/
 
ds_link_nfe_w	:= 'A';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_consistir_nota_fiscal ( nr_seq_nota_cobr_p bigint, nr_seq_fatura_p bigint, nm_usuario_p text) FROM PUBLIC;
