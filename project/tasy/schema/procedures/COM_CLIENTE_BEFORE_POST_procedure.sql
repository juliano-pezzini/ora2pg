-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_cliente_before_post ( nr_seq_cliente_p bigint, cd_cnpj_p text, ie_produto_p text, ie_os_pos_venda_p text, ie_os_divulgacao_p text, nm_usuario_p text, nr_ordem_servico_p INOUT bigint, dt_oficializacao_uso_p timestamp) AS $body$
DECLARE


ie_cnpj_ja_cliente_w	varchar(1);
cd_pessoa_usuario_w	varchar(10);
nm_fantasia_w		varchar(255);
ds_oficializacao_uso_w	varchar(50);
ds_razao_social_w	varchar(280);
ds_dano_w		varchar(4000);
ds_dano_breve_w		varchar(255);
nr_ordem_servico_w	bigint;
ds_cnpj_w		varchar(255);


BEGIN
if (cd_cnpj_p IS NOT NULL AND cd_cnpj_p::text <> '') then
	begin
	ie_cnpj_ja_cliente_w := com_obter_se_cnpj_ja_cliente(nr_seq_cliente_p, cd_cnpj_p, ie_produto_p);
	if (ie_cnpj_ja_cliente_w = 'S') then
		begin
		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(247107);
		end;
	end if;
	end;
end if;
if (ie_os_pos_venda_p = 'S') then
	begin	
	cd_pessoa_usuario_w 	:= obter_dados_usuario_opcao(nm_usuario_p,'C');
	ds_dano_breve_w		:= Wheb_mensagem_pck.get_texto(306148, 'CD_CNPJ=' || substr(obter_dados_pf_pj(null,cd_cnpj_p,'F'),1,65)); -- OFU - Cliente #@CD_CNPJ#@
	ds_oficializacao_uso_w	:= Wheb_mensagem_pck.get_texto(306150, 'DT_OFICI=' || to_char(clock_timestamp(),'dd/mm/yyyy')); -- Oficializacao de uso: #@DT_OFICI#@
	nm_fantasia_w		:= Wheb_mensagem_pck.get_texto(306152, 'NM_FANTASIA=' || substr(obter_dados_pf_pj(null,cd_cnpj_p,'F'),1,80)); -- Nome Fantasia: #@NM_FANTASIA#@
	ds_razao_social_w	:= Wheb_mensagem_pck.get_texto(306156, 'CD_CNPJ=' || substr(obter_dados_pf_pj(null,cd_cnpj_p,'N'),1,255)); -- Raz?o Social: #@CD_CNPJ#@
	ds_cnpj_w		:= Wheb_mensagem_pck.get_texto(306163, 'CD_CNPJ=' || cd_cnpj_p); --  CNPJ: #@CD_CNPJ#@
	ds_dano_w		:= ds_oficializacao_uso_w || chr(13) || chr(10) || nm_fantasia_w || chr(13) || chr(10) || ds_razao_social_w|| chr(13) || chr(10) || ds_cnpj_w;
	nr_ordem_servico_w	:= 0;

		begin
		nr_ordem_servico_w := man_gerar_ordem_servico(52, 1362, cd_pessoa_usuario_w, clock_timestamp(), 'M', 'N', ds_dano_breve_w, nm_usuario_p, ds_dano_w, '3', '2', 'S', 371, 11, 102, nr_ordem_servico_w);
		exception
		when others then			
			nr_ordem_servico_w := 0;
		end;

	if (coalesce(nr_ordem_servico_w,0) > 0) then
		begin
		update	man_ordem_servico
		set	nm_usuario_exec = 'vgzager' -- Victor
		where	nr_sequencia = nr_ordem_servico_w;
		end;
	 end if;	
	end;
end if;


if (ie_os_divulgacao_p = 'S') then
	begin
	nr_ordem_servico_w := 0;
	if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
		begin		
		CALL com_avisar_novo_cliente(nr_seq_cliente_p,nm_usuario_p);		
		end;
	end if;	

	cd_pessoa_usuario_w 	:= obter_dados_usuario_opcao('vgzager','C'); -- Victor 
	nm_fantasia_w		:= substr(obter_dados_pf_pj(null,cd_cnpj_p,'F'),1,80);
	ds_dano_breve_w		:= substr(Wheb_mensagem_pck.get_texto(306165, 'NM_FANTASIA=' || nm_fantasia_w),1,255);
	ds_oficializacao_uso_w	:= Wheb_mensagem_pck.get_texto(306167, null);
	nm_fantasia_w		:= Wheb_mensagem_pck.get_texto(306152, 'NM_FANTASIA=' || nm_fantasia_w);
	ds_razao_social_w	:= Wheb_mensagem_pck.get_texto(306156, 'CD_CNPJ=' || substr(obter_dados_pf_pj(null,cd_cnpj_p,'N'),1,255));
	ds_dano_w		:= ds_oficializacao_uso_w ||  chr(13) || chr(10) || nm_fantasia_w ||  chr(13) || chr(10) || ds_razao_social_w;

		begin
		man_gerar_ordem_servico(52,125,cd_pessoa_usuario_w,clock_timestamp(),'M','N',(Wheb_mensagem_pck.get_texto(306169, null) || ' ' || ds_dano_breve_w),nm_usuario_p,ds_dano_w,'3','2','S',703,11,42,nr_ordem_servico_w);
		exception
		when others then
			nr_ordem_servico_w := 0;
		end;

	if (coalesce(nr_ordem_servico_w,0) > 0) then
		begin
		update	man_ordem_servico
		set	nm_usuario_exec	= 'vgzager' --Victor
		where	nr_sequencia 	= nr_ordem_servico_w;
		end;
	end if;	
	end;
end if;


nr_ordem_servico_p	:= nr_ordem_servico_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_cliente_before_post ( nr_seq_cliente_p bigint, cd_cnpj_p text, ie_produto_p text, ie_os_pos_venda_p text, ie_os_divulgacao_p text, nm_usuario_p text, nr_ordem_servico_p INOUT bigint, dt_oficializacao_uso_p timestamp) FROM PUBLIC;
