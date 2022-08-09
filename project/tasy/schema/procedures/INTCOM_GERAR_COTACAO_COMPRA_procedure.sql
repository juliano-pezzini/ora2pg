-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intcom_gerar_cotacao_compra ( nr_pdc_p text, nr_solic_compra_p bigint, cd_comprador_p text, ds_xml_p text, ds_diretorio_p text, nm_usuario_p text, nr_cot_compra_p INOUT bigint) AS $body$
DECLARE

 
cd_estabelecimento_w			smallint;			
qt_existe_w				bigint;
nr_cot_compra_w				bigint;
cd_comprador_padrao_w			varchar(10);
cd_comprador_padrao_ww			varchar(10);
cd_pessoa_solicitante_w			varchar(10);
ie_tipo_interface_compras_w			varchar(15);
qt_erro_w				bigint := 0;
ds_erro_w				varchar(2000) := '';
nr_seq_registro_w			bigint;
ds_login_w				varchar(255);
ds_senha_w				varchar(255);


BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from	solic_compra 
where	nr_solic_compra = nr_solic_compra_p;
 
if (qt_existe_w > 0) then 
	begin 
	 
	select	obter_conversao_interna('','COMPRADOR','CD_PESSOA_FISICA',cd_comprador_p) 
	into STRICT	cd_comprador_padrao_w 
	;
	 
	select	max(a.cd_estabelecimento), 
		max(a.cd_pessoa_solicitante), 
		max(ie_tipo_interface_compras), 
		max(cd_comprador_padrao) 
	into STRICT	cd_estabelecimento_w, 
		cd_pessoa_solicitante_w, 
		ie_tipo_interface_compras_w, 
		cd_comprador_padrao_ww 
	from	solic_compra a, 
		parametro_compras b 
	where	a.cd_estabelecimento = b.cd_estabelecimento 
	and	a.nr_solic_compra = nr_solic_compra_p;
	 
	if (coalesce(cd_comprador_padrao_w::text, '') = '') then	 
		cd_comprador_padrao_w := cd_comprador_padrao_ww;
	end if;
	 
	select	nextval('cot_compra_seq') 
	into STRICT	nr_cot_compra_w 
	;
	 
	begin 
	insert into cot_compra( 
		nr_cot_compra, 
		dt_cot_compra, 
		dt_atualizacao, 
		cd_comprador, 
		nm_usuario, 
		ds_observacao, 
		cd_pessoa_solicitante, 
		cd_estabelecimento, 
		dt_retorno_prev, 
		nr_documento_externo, 
		ie_tipo_integracao_envio, 
		ie_tipo_integracao_receb, 
		ds_titulo, 
		ie_finalidade_cotacao) 
	values (	nr_cot_compra_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		cd_comprador_padrao_w, 
		nm_usuario_p, 
		Wheb_mensagem_pck.get_Texto(303122), /*'Gerado na importação da ordem de compra da integração do compras',*/
 
		cd_pessoa_solicitante_w, 
		cd_estabelecimento_w, 
		clock_timestamp(), 
		nr_pdc_p, 
		ie_tipo_interface_compras_w, 
		ie_tipo_interface_compras_w, 
		obter_titulo_cotacao(nr_cot_compra_w, cd_estabelecimento_w, nm_usuario_p), 
		'F');
	exception 
	when others then 
		qt_erro_w	:= 1;
		ds_erro_w	:= substr(Wheb_mensagem_pck.get_Texto(303123, 'DS_ERRO_W='|| sqlerrm ),1,2000);
	end;
	 
	if (ds_xml_p IS NOT NULL AND ds_xml_p::text <> '') and (qt_erro_w = 0) then 
		 
		begin 
		insert into cot_compra_arq( 
			nr_sequencia, 
			nr_cot_compra, 
			dt_atualizacao, 
			nm_usuario,				 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			ds_arquivo, 
			ds_conteudo, 
			ie_envio_retorno) 
		values (	nextval('cot_compra_arq_seq'), 
			nr_cot_compra_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(),				 
			nm_usuario_p, 
			coalesce(ds_diretorio_p,Wheb_mensagem_pck.get_Texto(303125)), 
			ds_xml_p, 
			'R');
		exception 
		when others then 
			qt_erro_w	:= 1;
			ds_erro_w	:= substr(Wheb_mensagem_pck.get_Texto(303126, 'DS_ERRO_W='|| sqlerrm ),1,2000);
			 
		end;
		 
	end if;		
	end;	
end if;
 
if (qt_erro_w > 0) then 
	 
	rollback;
	select	nextval('registro_integr_compras_seq') 
	into STRICT	nr_seq_registro_w 
	;
 
	select	a.ds_login_integr_compras_ws, 
		a.ds_senha_integr_compras_ws 
	into STRICT	ds_login_w, 
		ds_senha_w 
	from	parametro_compras a 
	where	a.cd_estabelecimento	= coalesce(cd_estabelecimento_w,1);
 
	insert into registro_integr_compras( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_tipo_operacao, 
		nr_solic_compra) 
	values (	nr_seq_registro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p,	 
		'WDG',	 
		nr_solic_compra_p);
 
	insert into registro_integr_com_xml( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_registro, 
		ie_status, 
		ie_operacao, 
		ie_sistema_origem, 
		ds_erro, 
		ds_retorno, 
		ie_tipo_operacao, 
		ds_login, 
		ds_senha, 
		id_pdc) 
	values (	nextval('registro_integr_com_xml_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_registro_w, 
		'E', 
		'R', 
		'TASY', 
		ds_erro_w, 
		null, 
		'WDG', 
		ds_login_w, 
		ds_senha_w, 
		nr_pdc_p);
	commit;
	 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182482,'DS_ERRO_P='||DS_ERRO_W);
end if;
 
nr_cot_compra_p := nr_cot_compra_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intcom_gerar_cotacao_compra ( nr_pdc_p text, nr_solic_compra_p bigint, cd_comprador_p text, ds_xml_p text, ds_diretorio_p text, nm_usuario_p text, nr_cot_compra_p INOUT bigint) FROM PUBLIC;
