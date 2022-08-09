-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_negociacao_reg_cobr ( cd_pessoa_fisica_p text, cd_cgc_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_lista_titulo_p text) AS $body$
DECLARE

 
nr_titulo_w			bigint;
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
nr_seq_negociacao_w		bigint;
vl_juros_w			double precision;
vl_multa_w			double precision;
vl_negociado_w			double precision;
ds_lista_titulo_w		varchar(4000)	:= null;				
 
c01 CURSOR FOR 
SELECT	a.nr_titulo, 
	obter_juros_multa_titulo(a.nr_titulo,clock_timestamp(),'R','J'), 
	obter_juros_multa_titulo(a.nr_titulo,clock_timestamp(),'R','M'), 
	coalesce(vl_saldo_titulo,0) 
from	titulo_receber a 
where	' ' || ds_lista_titulo_w || ' ' like '% ' || a.nr_titulo || ' %' 
and	(ds_lista_titulo_w IS NOT NULL AND ds_lista_titulo_w::text <> '');	
		 
c02 CURSOR FOR 
SELECT	a.nr_titulo 
from	registro_cobranca_v a 
where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
and	(cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') 
and	a.vl_acobrar <> 0 

union all
 
SELECT	a.nr_titulo 
from	registro_cobranca_v a 
where	a.cd_cgc	= cd_cgc_p 
and	(cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') 
and	a.vl_acobrar <> 0;


BEGIN 
ds_lista_titulo_w := ds_lista_titulo_p;
if (coalesce(ds_lista_titulo_w::text, '') = '') then 
	open c02;
	loop 
	fetch c02 into	 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin 
		ds_lista_titulo_w := ds_lista_titulo_w || nr_titulo_w || ' ';
		end;
	end loop;
	close c02;
end if;
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') or (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') and (ds_lista_titulo_w IS NOT NULL AND ds_lista_titulo_w::text <> '')	then 
	 
	select	nextval('negociacao_cr_seq') 
	into STRICT	nr_seq_negociacao_w 
	;
		 
	insert into	negociacao_cr(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			cd_pessoa_fisica, 
			cd_cgc, 
			dt_negociacao, 
			vl_negociado, 
			ie_status, 
			vl_juros, 
			vl_multa, 
			vl_desconto, 
			tx_negociacao) 
	values (nr_seq_negociacao_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			cd_pessoa_fisica_p, 
			cd_cgc_p, 
			clock_timestamp(), 
			0, 
			'AS', 
			0, 
			0, 
			0, 
			0);
 
	open c01;
	loop 
	fetch c01 into 
		nr_titulo_w, 
		vl_juros_w,         
		vl_multa_w, 
		vl_negociado_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		insert into titulo_rec_negociado(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_negociacao, 
			nr_titulo,          	 
			vl_juros,                
			vl_multa,                 
			vl_negociado) 
		values (nextval('titulo_rec_negociado_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_negociacao_w, 
			nr_titulo_w,          	 
			vl_juros_w,                
			vl_multa_w,                 
			vl_negociado_w);	
		 
		end;
	end loop;
	close c01;
	 
	CALL atualizar_valores_neg_cr(nr_seq_negociacao_w,nm_usuario_p,'N');
 
	commit;
end if;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_negociacao_reg_cobr ( cd_pessoa_fisica_p text, cd_cgc_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_lista_titulo_p text) FROM PUBLIC;
