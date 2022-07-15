-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_itens_deposito_iden ( nr_seq_deposito_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_titulo_w		bigint;
nr_seq_cheque_w		bigint;
nr_seq_baixa_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_titulo 
	from	deposito_ident_titulo 
	where	nr_seq_deposito	= nr_seq_deposito_p;
	
C02 CURSOR FOR 
	SELECT	nr_seq_cheque 
	from	deposito_ident_cheque 
	where	nr_seq_deposito	= nr_seq_deposito_p;


BEGIN 
open C01;
loop 
fetch C01 into	 
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	null;
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_baixa_w 
	from	titulo_receber_liq	a 
	where	a.nr_titulo		= nr_titulo_w 
	and	a.nr_seq_deposito_ident	= nr_seq_deposito_p;
	 
	CALL estornar_tit_receber_liq(nr_titulo_w,nr_seq_baixa_w,clock_timestamp(),nm_usuario_p,'N',null,null);
	end;
end loop;
close C01;
 
open C02;
loop 
fetch C02 into	 
	nr_seq_cheque_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	update	cheque_cr 
	set	dt_devolucao	 = NULL 
	where	nr_seq_cheque	= nr_seq_cheque_w;	
	end;
end loop;
close C02;
 
update	deposito_identificado 
set	nm_usuario		= nm_usuario_p, 
	ie_status		= 'AD', 
	dt_deposito		 = NULL 
where	nr_sequencia		= nr_seq_deposito_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_itens_deposito_iden ( nr_seq_deposito_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

