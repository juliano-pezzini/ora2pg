-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alt_tab_origem_sca_benef ( nr_seq_sca_contr_p bigint, nr_seq_tabela_origem_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

				 
nr_seq_contrato_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_tabela_w			bigint;
nr_seq_vinculo_sca_w		bigint;

C01 CURSOR FOR 
	SELECT	b.nr_sequencia 
	from	pls_segurado		c, 
		pls_sca_vinculo		b, 
		pls_contrato		a 
	where	c.nr_seq_contrato	= a.nr_sequencia 
	and	b.nr_seq_segurado	= c.nr_sequencia 
	and	a.nr_sequencia		= nr_seq_contrato_w 
	and	b.nr_seq_plano		= nr_seq_plano_w 
	and	b.nr_seq_tabela_origem	= nr_seq_tabela_origem_p 
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

 

BEGIN 
 
select	nr_seq_contrato, 
	nr_seq_plano, 
	nr_seq_tabela 
into STRICT	nr_seq_contrato_w, 
	nr_seq_plano_w, 
	nr_seq_tabela_w 
from	pls_sca_regra_contrato 
where	nr_sequencia	= nr_seq_sca_contr_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_vinculo_sca_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	CALL pls_alterar_tabela_preco_sca(nr_seq_vinculo_sca_w,nr_seq_tabela_w,clock_timestamp(),cd_estabelecimento_p,nm_usuario_p);
	 
	end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alt_tab_origem_sca_benef ( nr_seq_sca_contr_p bigint, nr_seq_tabela_origem_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
