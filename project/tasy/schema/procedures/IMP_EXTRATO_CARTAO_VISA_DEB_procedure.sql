-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE imp_extrato_cartao_visa_deb (nr_seq_extrato_p bigint, nm_usuario_p text, ds_arquivo_p text) AS $body$
DECLARE

dt_processamento_w	timestamp;
dt_inicial_w		timestamp;
dt_final_w		timestamp;
nr_extrato_w		integer;
nr_resumo_w		varchar(20);
cd_banco_w		smallint;
cd_agencia_w		varchar(8);
cd_conta_w		varchar(15);
nr_seq_conta_banco_w	bigint;
qt_cv_aceito_w		bigint;
qt_cv_rejeitado_w	bigint;
vl_bruto_w		double precision;
vl_comissao_w		double precision;
vl_desconto_w		double precision;
vl_liquido_w		double precision;
cd_estabelecimento_w	smallint;
vl_parcela_w		double precision;
dt_compra_w		timestamp;
qt_parcelas_w		bigint;
nr_cartao_w		varchar(20);		
nr_autorizacao_w	varchar(40);
ds_comprovante_w	varchar(100);
ds_rejeicao_w		varchar(255);
nr_parcela_w		bigint;
nr_seq_extrato_res_w	bigint;
ie_tipo_registro_w	varchar(2);
nr_sequencia_w		bigint;
dt_min_parcela_w	timestamp;
dt_max_parcela_w	timestamp;
nr_seq_grupo_w		bigint;
ie_status_w		varchar(2);
ie_debito_w		varchar(1);
ie_resumo_debito_w	varchar(1);
nr_seq_extrato_arq_w	bigint;
nr_comprovante_venda_w	varchar(255);
dt_comprovante_venda_w	timestamp;

/* Cursor Resumos */
 
c01 CURSOR FOR 
SELECT	nr_sequencia, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,1,','),1,200) ie_tipo_registro, 
	to_date(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,3,','),1,200),'ddmmyyyy') dt_compra, 
	(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,7,','),1,13) || ',' || SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,7,','),14,2))::numeric  vl_bruto, 
	(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,9,','),1,13) || ',' || SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,9,','),14,2))::numeric  vl_liquido, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,11,','),1,200) cd_banco, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,12,','),1,200) cd_agencia, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,13,','),1,200) cd_conta, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,5,','),1,200) nr_resumo, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,6,','),1,200) qt_cv_aceito, 
	to_char(null) nr_comprovante_venda, 
	to_char(null) nr_cartao, 
	to_char(null) dt_comprovante_venda 
from	w_extrato_cartao_cr 
where	nr_seq_extrato			= nr_seq_extrato_p 
and	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,1,','),1,200) = '01' -- Resumo 
union all
 
SELECT	nr_sequencia, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,1,','),1,200) ie_tipo_registro, 
	to_date(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,11,','),1,200),'ddmmyyyy') dt_compra, 
	(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,5,','),1,13) || ',' || SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,7,','),14,2))::numeric  vl_bruto, 
	(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,7,','),1,13) || ',' || SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,9,','),14,2))::numeric  vl_liquido, 
	to_char(null) cd_banco, 
	to_char(null) cd_agencia, 
	to_char(null) cd_conta, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,3,','),1,200) nr_resumo, 
	to_char(null) qt_cv_aceito, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,10,','),1,200) nr_comprovante_venda, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,8,','),1,200) nr_cartao, 
	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,4,','),1,200) dt_comprovante_venda 
from	w_extrato_cartao_cr 
where	nr_seq_extrato			= nr_seq_extrato_p 
and	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,1,','),1,200) = '05' --Detalhe 
order by nr_sequencia;


BEGIN 
 
select 	nextval('extrato_cartao_cr_arq_seq') 
into STRICT	nr_seq_extrato_arq_w
;
 
insert into EXTRATO_CARTAO_CR_ARQ(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_extrato, 
				ie_tipo_arquivo, 
				ds_arquivo) 
			values (nr_seq_extrato_arq_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_extrato_p, 
				'D', 
				ds_arquivo_p);
				 
commit;
 
select	cd_estabelecimento, 
	nr_seq_grupo 
into STRICT	cd_estabelecimento_w, 
	nr_seq_grupo_w 
from	extrato_cartao_cr 
where	nr_sequencia	= nr_seq_extrato_p;
 
/* Header */
 
select	somente_numero(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,8,','),1,200)) nr_extrato, 
	to_date(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,3,','),1,200),'ddmmyyyy') dt_processamento, 
	to_date(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,3,','),1,200),'ddmmyyyy') dt_inicial, 
	to_date(SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,4,','),1,200),'ddmmyyyy') dt_final 
into STRICT	nr_extrato_w, 
	dt_processamento_w, 
	dt_inicial_w, 
	dt_final_w 
from	w_extrato_cartao_cr 
where	nr_seq_extrato	= nr_seq_extrato_p 
and	SUBSTR(OBTER_VALOR_CAMPO_SEPARADOR(ds_conteudo,1,','),1,200) = '00';
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	ie_tipo_registro_w, 
	dt_compra_w, 
	vl_bruto_w, 
	vl_liquido_w, 
	cd_banco_w, 
	cd_agencia_w, 
	cd_conta_w, 
	nr_resumo_w, 
	qt_cv_aceito_w, 
	nr_comprovante_venda_w, 
	nr_cartao_w, 
	dt_comprovante_venda_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	if (ie_tipo_registro_w = '01') then 
 
		select	max(nr_seq_conta_banco) 
		into STRICT	nr_seq_conta_banco_w 
		from	grupo_bandeira_cr 
		where	nr_sequencia	= nr_seq_grupo_w;
 
		if (coalesce(nr_seq_conta_banco_w::text, '') = '') then 
			--r.aise_application_error(-20011,'Não foi encontrada a conta bancária de referência no cadastro do grupo de bandeiras do extrato!'); 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267412);
		end if;
 
		select	nextval('extrato_cartao_cr_res_seq') 
		into STRICT	nr_seq_extrato_res_w 
		;
 
		insert	into	extrato_cartao_cr_res(nr_sequencia, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_extrato, 
			nr_resumo, 
			nr_seq_conta_banco, 
			qt_cv_aceito, 
			vl_bruto, 
			vl_liquido, 
			dt_prev_pagto, 
			nr_seq_extrato_arq) 
		values (nr_seq_extrato_res_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_extrato_p, 
			nr_resumo_w, 
			nr_seq_conta_banco_w, 
			qt_cv_aceito_w, 
			vl_bruto_w, 
			vl_liquido_w, 
			dt_compra_w, 
			nr_seq_extrato_arq_w);
			 
	elsif (ie_tipo_registro_w = '05') then 
 
		insert	into	extrato_cartao_cr_movto(nr_sequencia, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_extrato, 
			nr_seq_extrato_res, 
			vl_parcela, 
			vl_liquido, 
			nr_cartao, 
			dt_compra, 
			ie_pagto_indevido, 
			nr_seq_extrato_arq) 
		values (nextval('extrato_cartao_cr_movto_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_extrato_p, 
			nr_seq_extrato_res_w, 
			vl_bruto_w, 
			vl_liquido_w, 
			nr_cartao_w, 
			dt_compra_w, 
			'N', 
			nr_seq_extrato_arq_w);
	end if;	
end loop;
close c01;
 
select	min(dt_compra), 
	max(dt_compra) 
into STRICT	dt_min_parcela_w, 
	dt_max_parcela_w 
from	extrato_cartao_cr_movto 
where	nr_seq_extrato	=	nr_seq_extrato_p;
 
update	extrato_cartao_cr 
set	nr_extrato		= nr_extrato_w, 
	dt_importacao		= clock_timestamp(), 
	dt_processamento	= dt_processamento_w, 
	dt_inicial		= dt_min_parcela_w, 
	dt_final		= dt_max_parcela_w 
where	nr_sequencia		= nr_seq_extrato_p;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE imp_extrato_cartao_visa_deb (nr_seq_extrato_p bigint, nm_usuario_p text, ds_arquivo_p text) FROM PUBLIC;
