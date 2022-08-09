-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_camara_contestacao ( ds_conteudo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



/*551*/

nr_seq_contestacao_w		bigint;
dt_geracao_w			timestamp;
cd_unimed_origem_w		smallint;
cd_unimed_destino_w		smallint;
nr_versao_transacao_w		smallint;
nr_id_questionamento_w		bigint;
nr_fatura_head_w		bigint;
dt_venc_fatura_w		timestamp;
vl_tot_fatura_w			double precision;
vl_tot_contestacao_w		double precision;
vl_tot_acordo_w			double precision;
ie_tp_arquivo_w			smallint;
vl_total_pago_w			double precision;
cd_unimed_credora_w		smallint;
nr_id_origem_w			smallint;
nr_documento_w			bigint;
dt_venc_doc_w			timestamp;
ie_status_conclusao_w		smallint;
ie_classif_cobranca_a500_w	varchar(1);
nr_nota_credito_debito_a500_w	varchar(30);
dt_vencimento_ndc_a500_w	timestamp;
vl_total_ndc_a500_w		double precision;
vl_total_contest_ndc_w		double precision;
vl_total_pago_ndc_w		double precision;
nr_documento2_w			varchar(30);
dt_venc_doc2_w			timestamp;


/*552*/

nr_seq_questionamento_w		bigint;
nr_lote_w			integer;
nr_nota_w			bigint;
cd_unimed_w			smallint;
id_benef_w			bigint;
nm_benef_w			varchar(25);
dt_atendimento_w		timestamp;
ie_tipo_tabela_w		smallint;
cd_servico_w			integer;
vl_cobrado_w			double precision;
vl_reconhecido_w		double precision;
vl_acordo_w			double precision;
dt_acordo_w			timestamp;
ie_tipo_acordo_w		varchar(10);
nr_seq_contest_w		bigint;
qt_cobrada_w			bigint;
ds_servico_w			varchar(255);
nr_seq_a500_w			bigint;
vl_cobr_co_w			double precision;
vl_reconh_co_w			double precision;
vl_acordo_co_w			double precision;
vl_cobr_filme_w			double precision;
vl_reconh_filme_w		double precision;
vl_acordo_filme_w		double precision;
vl_cobr_adic_serv_w		double precision;
vl_reconh_adic_serv_w		double precision;
vl_acordo_adic_serv_w		double precision;
vl_cobr_adic_co_w		double precision;
vl_reconh_adic_co_w		double precision;
vl_acordo_adic_co_w		double precision;
vl_cobr_adic_filme_w		double precision;
vl_reconh_adic_filme_w		double precision;
vl_acordo_adic_filme_w		double precision;
ie_pacote_w			varchar(1) := 'N';
cd_pacote_w			varchar(8);
dt_servico_w			timestamp;
hr_realiz_w			varchar(8);
qt_acordada_w			integer;
fat_mult_serv_w			real;

/*553*/

nr_seq_ptu_quest_codigo_w	double precision;
cd_motivo_quest_w		smallint;
ds_motivo_quest_w		varchar(500);


BEGIN
if (substr(ds_conteudo_p,9,3) = '551') then

	cd_unimed_destino_w	:= (substr(ds_conteudo_p,12,4))::numeric;
	cd_unimed_origem_w	:= (substr(ds_conteudo_p,16,4))::numeric;	-- Prestadora dos serviços
	dt_geracao_w		:= to_date(substr(ds_conteudo_p,26,2)||substr(ds_conteudo_p,24,2)||substr(ds_conteudo_p,20,4),'dd/mm/yyyy');
	cd_unimed_credora_w	:= (substr(ds_conteudo_p,28,4))::numeric;
	nr_id_questionamento_w	:= (substr(ds_conteudo_p,32,11))::numeric;
	nr_fatura_head_w	:= (substr(ds_conteudo_p,43,11))::numeric;
	dt_venc_fatura_w	:= to_date(substr(ds_conteudo_p,60,2)||substr(ds_conteudo_p,58,2)||substr(ds_conteudo_p,54,4),'dd/mm/yyyy');
	vl_tot_fatura_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,62,14));
	vl_tot_contestacao_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,76,14));

	begin
	vl_tot_acordo_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,90,14));
	exception
	when others then
		vl_tot_acordo_w := 0;
	end;

	begin
	ie_classif_cobranca_a500_w := substr(ds_conteudo_p,141,1);
	nr_nota_credito_debito_a500_w := substr(ds_conteudo_p,142,11);
	vl_total_ndc_a500_w := pls_format_valor_imp_ptu(substr(ds_conteudo_p,161,14));
	vl_total_contest_ndc_w := pls_format_valor_imp_ptu(substr(ds_conteudo_p,175,14));
	vl_total_pago_ndc_w := pls_format_valor_imp_ptu(substr(ds_conteudo_p,189,14));
	nr_documento2_w := substr(ds_conteudo_p,203,11);
	exception
	when others then
		ie_classif_cobranca_a500_w := null;
		nr_nota_credito_debito_a500_w := null;
		vl_total_ndc_a500_w := 0;
		vl_total_contest_ndc_w := 0;
		vl_total_pago_ndc_w := 0;
		nr_documento2_w := null;
	end;

	begin
	dt_vencimento_ndc_a500_w := to_date(substr(ds_conteudo_p,159,2)||substr(ds_conteudo_p,157,2)||substr(ds_conteudo_p,153,4),'dd/mm/yyyy');
	dt_venc_doc2_w := to_date(substr(ds_conteudo_p,220,2)||substr(ds_conteudo_p,218,2)||substr(ds_conteudo_p,214,4),'dd/mm/yyyy');
	exception
	when others then
		dt_vencimento_ndc_a500_w := null;
		dt_venc_doc2_w := null;
	end;

	ie_tp_arquivo_w		:= (substr(ds_conteudo_p,104,1))::numeric;
	nr_versao_transacao_w	:= (substr(ds_conteudo_p,105,2))::numeric;
	vl_total_pago_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,107,14));

	/*Novos campos a partir da 3.8*/

	nr_documento_w		:= (substr(ds_conteudo_p,121,11))::numeric;

	/*Diego 23/02/2011 Campo data não obrigatório*/

	begin
		dt_venc_doc_w		:= to_date(substr(ds_conteudo_p,145,2)||substr(ds_conteudo_p,143,2)||substr(ds_conteudo_p,139,4),'dd/mm/yyyy');
	exception
	when others then
		dt_venc_doc_w		:= null;
	end;
	ie_status_conclusao_w	:= (substr(ds_conteudo_p,140,1))::numeric;


	select	nextval('ptu_camara_contestacao_seq')
	into STRICT	nr_seq_contestacao_w
	;

	insert into ptu_camara_contestacao(nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, cd_unimed_destino,
		cd_unimed_origem, dt_geracao, nr_fatura,
		vl_total_fatura, nr_versao_transacao, cd_estabelecimento,
		cd_unimed_credora, dt_venc_fatura, vl_total_contestacao,
		vl_total_acordo, ie_tipo_arquivo, vl_total_pago,
		ie_operacao, nr_documento, dt_venc_doc,
		ie_conclusao,ie_classif_cobranca_a500,nr_nota_credito_debito_a500,
		dt_vencimento_ndc_a500,vl_total_ndc_a500,vl_total_contest_ndc,
		vl_total_pago_ndc,nr_documento2,dt_venc_doc2)
	values (nr_seq_contestacao_w, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, cd_unimed_destino_w,
		cd_unimed_origem_w, dt_geracao_w, nr_fatura_head_w,
		vl_tot_fatura_w, nr_versao_transacao_w, cd_estabelecimento_p,
		cd_unimed_credora_w, dt_venc_fatura_w, vl_tot_contestacao_w,
		vl_tot_acordo_w, ie_tp_arquivo_w, vl_total_pago_w,
		'R', nr_documento_w, dt_venc_doc_w,
		ie_status_conclusao_w,ie_classif_cobranca_a500_w,nr_nota_credito_debito_a500_w,
		dt_vencimento_ndc_a500_w,vl_total_ndc_a500_w,vl_total_contest_ndc_w,
		vl_total_pago_ndc_w,nr_documento2_w,dt_venc_doc2_w);

elsif (substr(ds_conteudo_p,9,3) = '552') then

	select	nextval('ptu_questionamento_seq')
	into STRICT	nr_seq_questionamento_w
	;

	/*Obter sequencia da contestacao da qual o questionamento ira ser vinculado*/

	select	max(nr_sequencia)
	into STRICT	nr_seq_contest_w
	from	ptu_camara_contestacao
	where	nm_usuario_nrec = nm_usuario_p;

	nr_lote_w		:= (substr(ds_conteudo_p,12,4))::numeric;
	nr_id_origem_w		:= (substr(ds_conteudo_p,20,4))::numeric;
	nr_nota_w		:= (substr(ds_conteudo_p,24,11))::numeric;
	cd_unimed_w		:= (substr(ds_conteudo_p,35,4))::numeric;
	id_benef_w		:= (substr(ds_conteudo_p,39,13))::numeric;
	nm_benef_w		:= to_char(substr(ds_conteudo_p,52,25));
	dt_atendimento_w	:= to_date(substr(ds_conteudo_p,85,2)||substr(ds_conteudo_p,82,2)||substr(ds_conteudo_p,77,4)||substr(ds_conteudo_p,87,8),'dd/mm/yyyy hh24:mi:ss');

	/*Se for ainda na versão 3.7*/

	if (substr(ds_conteudo_p,98,4) <> '') then
		cd_motivo_quest_w	:= pls_obter_seq_cd_quest((substr(ds_conteudo_p,98,4))::numeric );
		ds_motivo_quest_w	:= to_char(substr(ds_conteudo_p,102,120));
	end if;


	ie_tipo_tabela_w	:= (substr(ds_conteudo_p,222,1))::numeric;
	cd_servico_w		:= (substr(ds_conteudo_p,223,8))::numeric;
	vl_cobrado_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,231,14));
	vl_reconhecido_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,245,14));
	vl_acordo_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,259,14));
	dt_acordo_w		:= to_date(substr(ds_conteudo_p,279,2)||substr(ds_conteudo_p,277,2)||substr(ds_conteudo_p,273,4),'dd/mm/yyyy');
	ie_tipo_acordo_w	:= to_char(substr(ds_conteudo_p,281,2));

	/*Novos campos a partir da 3.8*/

	qt_cobrada_w		:= (substr(ds_conteudo_p,283,8))::numeric;
	ds_servico_w		:= to_char(substr(ds_conteudo_p,291,80));
	nr_seq_a500_w		:= (substr(ds_conteudo_p,371,8))::numeric;
	vl_cobr_co_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,379,14));
	vl_reconh_co_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,393,14));
	vl_acordo_co_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,407,14));
	vl_cobr_filme_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,421,14));
	vl_reconh_filme_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,435,14));
	vl_acordo_filme_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,449,14));
	vl_cobr_adic_serv_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,463,14));
	vl_reconh_adic_serv_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,477,14));
	vl_acordo_adic_serv_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,491,14));
	vl_cobr_adic_co_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,505,14));
	vl_reconh_adic_co_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,519,14));
	vl_acordo_adic_co_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,533,14));
	vl_cobr_adic_filme_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,547,14));
	vl_reconh_adic_filme_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,561,14));
	vl_acordo_adic_filme_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,575,14));

	ie_pacote_w		:= coalesce(trim(both substr(ds_conteudo_p,597,1)),'N');
	cd_pacote_w		:= to_char(substr(ds_conteudo_p,598,8));
	dt_servico_w		:= to_date(substr(ds_conteudo_p,612,2)||substr(ds_conteudo_p,610,2)||substr(ds_conteudo_p,606,4),'dd/mm/yyyy');
	hr_realiz_w		:= to_char(substr(ds_conteudo_p,614,8));

	begin
	qt_acordada_w		:= (substr(ds_conteudo_p,622,8))::numeric;
	exception
	when others then
	qt_acordada_w		:= null;
	end;

	begin
	fat_mult_serv_w		:= (substr(ds_conteudo_p,630,3))::numeric /100;
	exception
	when others then
	fat_mult_serv_w		:= 0;
	end;

	insert into ptu_questionamento(nr_sequencia, nr_nota, cd_usuario_plano,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, ie_tipo_tabela, dt_acordo,
		ie_tipo_acordo, vl_acordo, cd_unimed,
		dt_atendimento, cd_servico, vl_cobrado,
		vl_reconhecido, nm_beneficiario, nr_seq_contestacao,
		nr_lote, qt_cobrada, ds_servico, nr_seq_a500,
		vl_cobr_co, vl_reconh_co, vl_acordo_co,
		vl_cobr_filme, vl_reconh_filme, vl_acordo_filme,
		vl_cobr_adic_serv, vl_reconh_adic_serv, vl_acordo_adic_serv,
		vl_cobr_adic_co, vl_reconh_adic_co, vl_acordo_adic_co,
		vl_cobr_adic_filme, vl_reconh_adic_filme, vl_acordo_adic_filme,
		ie_pacote,cd_pacote,dt_servico,hr_realiz,
		qt_acordada, fat_mult_serv)
	values (nr_seq_questionamento_w, nr_nota_w, id_benef_w,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, ie_tipo_tabela_w, dt_acordo_w,
		ie_tipo_acordo_w, vl_acordo_w, cd_unimed_w,
		dt_atendimento_w, cd_servico_w, vl_cobrado_w,
		vl_reconhecido_w, nm_benef_w, nr_seq_contest_w,
		nr_lote_w, qt_cobrada_w, ds_servico_w, nr_seq_a500_w,
		vl_cobr_co_w, vl_reconh_co_w,	vl_acordo_co_w,
		vl_cobr_filme_w, vl_reconh_filme_w, vl_acordo_filme_w,
		vl_cobr_adic_serv_w, vl_reconh_adic_serv_w, vl_acordo_adic_serv_w,
		vl_cobr_adic_co_w, vl_reconh_adic_co_w, vl_acordo_adic_co_w,
		vl_cobr_adic_filme_w, vl_reconh_adic_filme_w, vl_acordo_adic_filme_w,
		ie_pacote_w,cd_pacote_w,dt_servico_w,hr_realiz_w,
		qt_acordada_w,fat_mult_serv_w);

		 /*Se for ainda na versão 3.7*/

		 if (coalesce(cd_motivo_quest_w,0) > 0) then

			insert into ptu_questionamento_codigo(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, ds_motivo, nm_usuario_nrec,
				nr_seq_registro, nr_seq_mot_questionamento)
			values (nextval('ptu_questionamento_codigo_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), ds_motivo_quest_w, nm_usuario_p,
				nr_seq_questionamento_w, cd_motivo_quest_w);
		 end if;

elsif (substr(ds_conteudo_p,9,3) = '553') then

	select	nextval('ptu_questionamento_codigo_seq')
	into STRICT	nr_seq_ptu_quest_codigo_w
	;

	cd_motivo_quest_w	:= pls_obter_seq_cd_quest((substr(ds_conteudo_p,12,4))::numeric );
	ds_motivo_quest_w	:= to_char(substr(ds_conteudo_p,16,500));

	select	max(nr_sequencia)
	into STRICT	nr_seq_questionamento_w
	from	ptu_questionamento
	where 	nm_usuario_nrec = nm_usuario_p;

	insert into ptu_questionamento_codigo(nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, ds_motivo, nm_usuario_nrec,
		nr_seq_registro, nr_seq_mot_questionamento )
	values (nextval('ptu_questionamento_codigo_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), ds_motivo_quest_w, cd_motivo_quest_w,
		nr_seq_questionamento_w, cd_motivo_quest_w);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_camara_contestacao ( ds_conteudo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
