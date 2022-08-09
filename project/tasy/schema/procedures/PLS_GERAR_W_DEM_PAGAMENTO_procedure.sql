-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_dem_pagamento ( nr_seq_protocolo_p bigint, nr_seq_prestador_p bigint, nr_seq_lote_p bigint, ie_deletar_reg_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_protocolo_w	bigint;
cd_ans_w		varchar(50);
ds_operadora_w		varchar(255);
cd_cgc_operadora_w	varchar(20);
nr_demonstrativo_w	varchar(50);
cd_prestador_w		varchar(50);
cd_cgc_prestador_w	varchar(20);	
nr_cpf_prestador_w	varchar(50);
ds_prestador_w		varchar(255);
cd_cnes_prestador_w	varchar(50);
nr_fatura_w		varchar(50);
nr_lote_w		varchar(50);
dt_envio_lote_w		timestamp;
nr_protocolo_w		varchar(50);
vl_fatura_w		double precision;
vl_lib_fatura_w		double precision;
vl_glosa_fatura_w	double precision;
dt_pagamento_w		timestamp;
ie_forma_pagto_w	varchar(5);
cd_banco_w		varchar(20);		
cd_agencia_w		varchar(20);
nr_conta_w		varchar(50);
nr_seq_lote_pgto_w	bigint;
dt_mes_competencia_w	timestamp;

c01 CURSOR FOR 
SELECT	b.cd_ans, 
	b.nm_fantasia, 
	b.cd_cgc_outorgante, 
	a.nr_sequencia, 
	c.nr_sequencia, 
	c.cd_cgc, 
	obter_cpf_pessoa_fisica(c.cd_pessoa_fisica), 
	substr(obter_nome_pf_pj(c.cd_pessoa_fisica, c.cd_cgc),1,254), 
	CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN  substr(obter_dados_pf_pj(null,c.cd_cgc, 'CNES'),1,20)  ELSE substr(obter_dados_pf(c.cd_pessoa_fisica,'CNES'),1,20) END , 
	a.nr_sequencia, 
	a.nr_protocolo_prestador, 
	a.dt_protocolo, 
	a.nr_sequencia, 
	d.vl_cobrado, 
	d.vl_total_liberado, 
	d.vl_glosa, 
	d.dt_pagamento, 
	d.ie_forma_pagto, 
	d.cd_banco, 
	d.cd_agencia, 
	d.nr_conta, 
	d.nr_seq_lote 
from	pls_protocolo_conta a, 
	pls_outorgante b, 
	pls_prestador c, 
	pls_prot_conta_titulo d 
where	a.nr_seq_outorgante	= b.nr_sequencia				 
and 	a.nr_seq_prestador	= c.nr_sequencia 
and	a.nr_sequencia		= nr_seq_protocolo 
and	a.nr_sequencia		= nr_seq_protocolo_p;


BEGIN 
 
/*Diego 259134 - MOdificação realizada para que possa ser utilizado esta procedure dentro da pls_gerar_w_dem_pagamento_lote*/
 
if (coalesce(ie_deletar_reg_p,'S') = 'S') then 
	delete	from 	w_pls_protocolo 
	where	nm_usuario	= nm_usuario_p;
end if;
 
if (coalesce(nr_seq_protocolo_p,0)	> 0) then 
	open c01;
	loop 
	fetch c01 into 
		cd_ans_w, 
		ds_operadora_w, 
		cd_cgc_operadora_w, 
		nr_demonstrativo_w, 
		cd_prestador_w, 
		cd_cgc_prestador_w, 
		nr_cpf_prestador_w, 
		ds_prestador_w, 
		cd_cnes_prestador_w, 
		nr_fatura_w, 
		nr_lote_w, 
		dt_envio_lote_w, 
		nr_protocolo_w, 
		vl_fatura_w, 
		vl_lib_fatura_w, 
		vl_glosa_fatura_w, 
		dt_pagamento_w, 
		ie_forma_pagto_w, 
		cd_banco_w, 
		cd_agencia_w, 
		nr_conta_w, 
		nr_seq_lote_pgto_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		select	nextval('w_pls_protocolo_seq') 
		into STRICT	nr_seq_protocolo_w 
		;
 
		insert	into w_pls_protocolo(	 
			nr_sequencia,      
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_ans, 
			ds_operadora, 
			cd_cgc_operadora, 
			nr_demonstrativo,    
			dt_emissao, 
			cd_prestador, 
			cd_cgc_prestador, 
			nr_cpf_prestador, 
			ds_prestador, 
			cd_cnes_prestador, 
			nr_fatura, 
			nr_lote, 
			dt_envio_lote, 
			nr_protocolo, 
			vl_fatura, 
			vl_lib_fatura, 
			vl_glosa_fatura, 
			nr_seq_protocolo, 
			dt_pagamento, 
			ie_forma_pagto, 
			cd_banco, 
			cd_agencia, 
			nr_conta, 
			nr_seq_lote_pgto) 
		values (nr_seq_protocolo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_ans_w, 
			ds_operadora_w, 
			cd_cgc_operadora_w, 
			nr_demonstrativo_w, 
			clock_timestamp(), 
			cd_prestador_w, 
			cd_cgc_prestador_w, 
			nr_cpf_prestador_w, 
			ds_prestador_w, 
			cd_cnes_prestador_w, 
			nr_fatura_w, 
			nr_lote_w, 
			dt_pagamento_w, 
			nr_protocolo_w, 
			vl_fatura_w, 
			vl_lib_fatura_w, 
			vl_glosa_fatura_w, 
			nr_seq_protocolo_p, 
			dt_pagamento_w, 
			ie_forma_pagto_w, 
			cd_banco_w, 
			cd_agencia_w, 
			nr_conta_w, 
			nr_seq_lote_pgto_w);
 
	end loop;
	close c01;
elsif (coalesce(nr_seq_prestador_p,0)	> 0) and (coalesce(nr_seq_lote_p,0)	> 0) then 
	select	a.nr_sequencia, 
		trunc(a.dt_geracao_titulos), 
		a.dt_mes_competencia, 
		b.vl_pagamento, 
		b.nr_seq_prestador, 
		c.cd_cgc, 
		obter_cpf_pessoa_fisica(c.cd_pessoa_fisica), 
		substr(obter_nome_pf_pj(c.cd_pessoa_fisica, c.cd_cgc),1,254), 
		CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN  substr(obter_dados_pf_pj(null,c.cd_cgc, 'CNES'),1,20)  ELSE substr(obter_dados_pf(c.cd_pessoa_fisica,'CNES'),1,20) END , 
		d.cd_ans, 
		d.nm_fantasia, 
		d.cd_cgc_outorgante, 
		e.cd_agencia_bancaria, 
		e.cd_banco, 
		e.cd_conta 
	into STRICT	nr_lote_w, 
		dt_mes_competencia_w, 
		dt_pagamento_w, 
		vl_fatura_w, 
		cd_prestador_w, 
		cd_cgc_prestador_w, 
		nr_cpf_prestador_w, 
		ds_prestador_w, 
		cd_cnes_prestador_w, 
		cd_ans_w, 
		ds_operadora_w, 
		cd_cgc_operadora_w, 
		cd_agencia_w, 
		cd_banco_w, 
		nr_conta_w 
	FROM pls_outorgante d, pls_prestador c, pls_lote_pagamento a, pls_pagamento_prestador b
LEFT OUTER JOIN banco_estabelecimento e ON (b.nr_seq_conta_banco = e.nr_sequencia)
WHERE b.nr_seq_prestador	= nr_seq_prestador_p and b.nr_seq_lote		= nr_seq_lote_p and b.nr_seq_prestador	= c.nr_sequencia and b.nr_seq_lote		= a.nr_sequencia and c.cd_estabelecimento	= d.cd_estabelecimento;
 
	select	nextval('w_pls_protocolo_seq') 
	into STRICT	nr_seq_protocolo_w 
	;
	 
	insert	into w_pls_protocolo(	 
			nr_sequencia,      
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_ans, 
			ds_operadora, 
			cd_cgc_operadora, 
			nr_demonstrativo,    
			dt_emissao, 
			cd_prestador, 
			cd_cgc_prestador, 
			nr_cpf_prestador, 
			ds_prestador, 
			cd_cnes_prestador, 
			nr_fatura, 
			nr_lote, 
			dt_envio_lote, 
			nr_protocolo, 
			vl_fatura, 
			vl_lib_fatura, 
			vl_glosa_fatura, 
			nr_seq_protocolo, 
			dt_pagamento, 
			ie_forma_pagto, 
			cd_banco, 
			cd_agencia, 
			nr_conta, 
			nr_seq_lote_pgto) 
		values (nr_seq_protocolo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_ans_w, 
			ds_operadora_w, 
			cd_cgc_operadora_w, 
			nr_seq_protocolo_w, 
			clock_timestamp(), 
			cd_prestador_w, 
			cd_cgc_prestador_w, 
			nr_cpf_prestador_w, 
			ds_prestador_w, 
			cd_cnes_prestador_w, 
			nr_lote_w, 
			nr_lote_w, 
			dt_mes_competencia_w, 
			nr_protocolo_w, 
			vl_fatura_w, 
			vl_fatura_w, 
			null, 
			null, 
			dt_pagamento_w, 
			ie_forma_pagto_w, 
			cd_banco_w, 
			cd_agencia_w, 
			nr_conta_w, 
			nr_lote_w);
end if;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_dem_pagamento ( nr_seq_protocolo_p bigint, nr_seq_prestador_p bigint, nr_seq_lote_p bigint, ie_deletar_reg_p text, nm_usuario_p text) FROM PUBLIC;
