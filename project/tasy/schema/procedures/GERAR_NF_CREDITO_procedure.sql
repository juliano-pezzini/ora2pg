-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nf_credito ( nr_seq_nf_orig_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
			 
ds_observacao_w		 regra_fatura_parc.ds_observacao%type;
cd_serie_nf_w		 nota_fiscal.cd_serie_nf%type;
cd_estabelecimento_w	 estabelecimento.cd_estabelecimento%type;
nr_nota_credito_w	 nota_fiscal.nr_nota_fiscal%type;
qt_existe_regra_w	 integer;
cd_operacao_nf_credito_w operacao_nota.cd_operacao_nf%type;
nr_sequencia_w		 nf_credito.nr_sequencia%type;
ie_tipo_recebimento_w	 regra_fatura_parc.ie_tipo_recebimento%type;


BEGIN 
 
ds_observacao_w := substr(wheb_mensagem_pck.get_texto(338475,'NR_SEQ_NF_ORIG_P= ' || to_char(nr_seq_nf_orig_p)),1,255);
 
select	nr_nota_fiscal, 
	cd_serie_nf, 
	ie_tipo_recebimento, 
	cd_estabelecimento 
into STRICT	nr_nota_credito_w, 
	cd_serie_nf_w, 
	ie_tipo_recebimento_w, 
	cd_estabelecimento_w 
from	nota_fiscal 
where	nr_sequencia = nr_seq_nf_orig_p;
 
select	nr_nota_fiscal, 
	cd_serie_nf 
into STRICT	nr_nota_credito_w, 
	cd_serie_nf_w 
from	nota_fiscal_item 
where	nr_sequencia = nr_seq_nf_orig_p;
 
select	nextval('nf_credito_seq') 
into STRICT	nr_sequencia_w
;
 
select	count(*) 
into STRICT	qt_existe_regra_w 
from	regra_fatura_parc 
where	ie_tipo_recebimento = ie_tipo_recebimento_w;
 
if (qt_existe_regra_w > 0) then 
	select	cd_operacao_nf_credito	 
	into STRICT	cd_operacao_nf_credito_w 
	from	regra_fatura_parc 
	where	ie_tipo_recebimento = ie_tipo_recebimento_w;
	 
else 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(338354);
 
end if;
 
insert into nf_credito(	 
	nr_sequencia, 
	nr_seq_nf_orig, 
	nr_nota_credito, 
	nm_usuario, 
	ie_situacao, 
	ie_forma_aplicacao, 
	dt_atualizacao, 
	cd_serie_nf, 
	cd_operacao_nf, 
	cd_estabelecimento, 
	nm_usuario_nrec, 
	ie_aplicacao_itens, 
	ie_acao, 
	dt_atualizacao_nrec, 
	ds_observacao) 
values (	nr_sequencia_w, 
	nr_seq_nf_orig_p, 
	nr_nota_credito_w, 
	nm_usuario_p, 
	'1', 
	'P', 
	clock_timestamp(), 
	cd_serie_nf_w, 
	cd_operacao_nf_credito_w, 
	cd_estabelecimento_w, 
	nm_usuario_p, 
	'T', 
	'D', 
	clock_timestamp(), 
	ds_observacao_w);
 
 
commit;
 
CALL gerar_nf_credito_itens(nr_sequencia_w,nm_usuario_p);
CALL liberar_nota_credito(nr_sequencia_w,cd_estabelecimento_w,nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nf_credito ( nr_seq_nf_orig_p bigint, nm_usuario_p text) FROM PUBLIC;
