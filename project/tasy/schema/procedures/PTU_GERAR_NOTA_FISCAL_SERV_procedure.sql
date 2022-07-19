-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_nota_fiscal_serv ( nr_seq_cobranca_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_nota_fiscal_w		varchar(20);
nr_seq_servico_w		bigint;

c01 CURSOR FOR 
	SELECT	c.nr_nota_fiscal 
	from	pls_conta		a, 
		pls_protocolo_conta	b, 
		pls_lote_protocolo	c 
	where	b.nr_seq_lote		= c.nr_sequencia 
	and	a.nr_seq_protocolo	= b.nr_sequencia 
	and	a.nr_seq_serv_pre_pagto	= nr_seq_servico_w;

 

BEGIN 
 
select	nr_seq_serv_pre_pagto 
into STRICT	nr_seq_servico_w 
from	ptu_nota_cobranca 
where	nr_sequencia	= nr_seq_cobranca_p;
 
open c01;
loop 
fetch c01 into 
	nr_nota_fiscal_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	insert into ptu_nota_fiscal(nr_sequencia, nr_seq_nota_cobr, ds_link_nfe, 
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec, 
		nm_usuario_nrec, nr_nota_fiscal) 
	values (nextval('ptu_nota_fiscal_seq'), nr_seq_cobranca_p, 'link nota fiscal eletronica', 
		clock_timestamp(), nm_usuario_p, clock_timestamp(), 
		nm_usuario_p, nr_nota_fiscal_w);
 
	end;
end loop;
close C01;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_nota_fiscal_serv ( nr_seq_cobranca_p bigint, nm_usuario_p text) FROM PUBLIC;

