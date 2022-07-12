-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE integracao_titulo_pagar_pck.gerar_titulo_pagar ( cd_estabelecimento_p text, cd_fornecedor_p text, nr_titulo_p text, cd_empresa_p text, ie_situacao_p text, cd_cgc_p text, cd_pessoa_fisica_p text, ie_tipo_titulo_p text, nr_docto_origem_tit_p text, dt_emissao_p timestamp, dt_vencimento_p timestamp, vl_titulo_p bigint, vl_saldo_titulo_p bigint, ds_observacao_p text, cd_grupo_conta_p text, dt_entrada_p timestamp, nr_nosso_numero_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

		 
	ds_erro_w			varchar(255);
	
	cd_tipo_taxa_juro_w		bigint;
	cd_tipo_taxa_multa_w		bigint;
	ie_tipo_titulo_w			smallint;
	cd_fornecedor_w			varchar(10);
	cd_pessoa_fisica_w		varchar(10);
	dt_vencimento_w			timestamp;
	nr_sequencia_w			bigint;
	nr_titulo_w			bigint;
	qt_registro_w			bigint;
	vl_titulo_w			double precision;
	cd_estab_financeiro_w		smallint;
	
	
BEGIN 
	 
	 
	 
	begin 
	ie_tipo_titulo_w	:= (coalesce(substr(ie_tipo_titulo_p,1,2),'1'))::numeric;
	exception when others then 
		ie_tipo_titulo_w	:= 1;	
	end;
	 
	select	count(*), 
		max(cd_estab_financeiro) 
	into STRICT	qt_registro_w, 
		cd_estab_financeiro_w 
	from	estabelecimento 
	where	cd_estabelecimento	= cd_estabelecimento_p;
	 
	if (qt_registro_w	= 0) then 
		ds_erro_w	:= substr(ds_erro_w || ' ' || Wheb_mensagem_pck.get_texto(303548,'CD_ESTABELECIMENTO_P=' || cd_estabelecimento_p),1,255);
	end if;
	 
	 
	select	coalesce(max(nr_titulo),0) 
	into STRICT	nr_titulo_w 
	from	titulo_pagar 
	where	nr_titulo_externo	= nr_titulo_p 
	and	nm_usuario_orig		= Wheb_mensagem_pck.get_texto(303543) 
	and	ie_situacao		<> 'C';
	 
	select	coalesce(max(cd_tipo_taxa_juro),0), 
		coalesce(max(cd_tipo_taxa_multa),0) 
	into STRICT	cd_tipo_taxa_juro_w, 
		cd_tipo_taxa_multa_w 
	from	parametros_contas_pagar 
	where	cd_estabelecimento	= cd_estabelecimento_p;
		 
	cd_fornecedor_w	:= coalesce(coalesce(cd_pessoa_fisica_p,cd_fornecedor_p),'0');
	 
	if (cd_fornecedor_w <> '0') then 
		select	coalesce(max(cd_pessoa_fisica),'') 
		into STRICT	cd_pessoa_fisica_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;/*cd_sistema_ant	= cd_fornecedor_w*/
 
		--and	nm_usuario_nrec	= 'IntegrSenior'; retirada essa consistencia através da os 501584 - alfernandes 11/2012 
		
		if (coalesce(cd_pessoa_fisica_w,'X') = 'X') then 
			ds_erro_w	:= substr(ds_erro_w || Wheb_mensagem_pck.get_texto(303547) || ' ' || cd_fornecedor_w,1,255);
		end if;
	end if;
		 
	if (coalesce(cd_cgc_p,'X') <> 'X') then 
		 
		select	count(*) 
		into STRICT	qt_registro_w 
		from	pessoa_juridica 
		where	cd_cgc	= cd_cgc_p;
		 
		if (qt_registro_w = 0) then 
			ds_erro_w	:= substr(Wheb_mensagem_pck.get_texto(303546) || ' ' || cd_cgc_p,1,255);
		end if;
	end if;
		 
	if (nr_titulo_w = 0) and (coalesce(ds_erro_w,'X') = 'X') then 
		begin 
		 
		select	nextval('titulo_pagar_seq')	 
		into STRICT	nr_titulo_w 
		;
	 
		insert	into titulo_pagar( 
			cd_pessoa_fisica, 
			cd_cgc, 
			nr_titulo, 
			cd_estabelecimento,   
			dt_atualizacao,     
			nm_usuario,       
			dt_emissao,       
			dt_vencimento_original, 
			dt_vencimento_atual,  	 
			vl_titulo,        
			vl_saldo_titulo,     
			vl_saldo_juros,     
			vl_saldo_multa, 
			cd_moeda,        
			tx_juros,        
			tx_multa,        
			cd_tipo_taxa_juro,    
			cd_tipo_taxa_multa,   
			tx_desc_antecipacao,   
			ie_situacao,       
			ie_origem_titulo, 
			ie_tipo_titulo, 
			ie_pls, 
			nr_titulo_externo, 
			nr_documento, 
			nr_seq_trans_fin_baixa, 
			nm_usuario_orig, 
			cd_estab_financeiro, 
			ie_status) 
		values (	cd_pessoa_fisica_w, 
			cd_cgc_p, 
			nr_titulo_w, 
			cd_estabelecimento_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			dt_emissao_p, 
			dt_vencimento_p, 
			dt_vencimento_p, 
			vl_titulo_p, 
			vl_saldo_titulo_p, 
			0, 
			0, 
			1, 
			0, 
			0, 
			cd_tipo_taxa_juro_w, 
			cd_tipo_taxa_multa_w, 
			null, 
			'A', 
			1, 
			ie_tipo_titulo_w, 
			'N', 
			nr_titulo_p, 
			substr(nr_titulo_p,1,20), 
			null, 
			Wheb_mensagem_pck.get_texto(303543), 
			cd_estab_financeiro_w, 
			'D');
			 
		exception when others then 
			ds_erro_w	:= substr(Wheb_mensagem_pck.get_texto(303544) || ' ' || sqlerrm(SQLSTATE),1,255);
		end;
	elsif (nr_titulo_w > 0) then 
	 
		select	coalesce(vl_titulo,0), 
			dt_vencimento_atual 
		into STRICT	vl_titulo_w, 
			dt_vencimento_w 
		from	titulo_pagar 
		where	nr_titulo	= nr_titulo_w;
		 
		if (vl_titulo_w <> vl_titulo_p) then 
			/* alt valor */
 
			select	coalesce(max(nr_sequencia),0) 
			into STRICT	nr_sequencia_w 
			from	titulo_pagar_alt_valor 
			where	nr_titulo	= nr_titulo_w;
			 
			nr_sequencia_w	:= nr_sequencia_w + 1;
			 
			begin 
			insert into titulo_pagar_alt_valor( 
				nr_titulo, nr_sequencia, dt_alteracao, 
				vl_anterior, vl_alteracao, cd_moeda, 
				dt_atualizacao, nm_usuario, nr_lote_contabil, 
				ds_observacao, nr_seq_trans_fin, nr_externo, 
				nr_seq_motivo )	 
			values (	nr_titulo_w, 
				nr_sequencia_w, clock_timestamp(), 
				vl_titulo_w, 
				vl_titulo_p, 
				1, 
				clock_timestamp(), 
				nm_usuario_p, 
				0, 
				Wheb_mensagem_pck.get_texto(303542), 
				null, 
				null, 
				null);
			exception when others then 
				ds_erro_w	:= substr(Wheb_mensagem_pck.get_texto(303545,'NR_TITULO_W=' || nr_titulo_w) || ' ' || sqlerrm(SQLSTATE),1,255);
			end;
		end if;
		 
		if (dt_vencimento_w <> dt_vencimento_p) then 
		 
			select	coalesce(max(nr_sequencia),0) 
			into STRICT	nr_sequencia_w 
			from	titulo_pagar_alt_venc 
			where	nr_titulo	= nr_titulo_w;
			 
			nr_sequencia_w	:= nr_sequencia_w + 1;
			 
			insert into titulo_pagar_alt_venc( 
				nr_titulo, 
				nr_sequencia, 
				dt_anterior, 
				dt_vencimento, 
				dt_atualizacao, 
				nm_usuario, 
				dt_alteracao, 
				ds_observacao, 
				vl_saldo_multa, 
				vl_saldo_juros, 
				tx_juros, 
				tx_multa, 
				nr_externo) 
			values (	nr_titulo_w, 
				nr_sequencia_w, 
				clock_timestamp(), 
				dt_vencimento_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				Wheb_mensagem_pck.get_texto(303542), 
				0, 
				0, 
				0, 
				0, 
				null);
		end if;
		 
	end if;
	 
	ds_erro_p	:= ds_erro_w;
	 
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integracao_titulo_pagar_pck.gerar_titulo_pagar ( cd_estabelecimento_p text, cd_fornecedor_p text, nr_titulo_p text, cd_empresa_p text, ie_situacao_p text, cd_cgc_p text, cd_pessoa_fisica_p text, ie_tipo_titulo_p text, nr_docto_origem_tit_p text, dt_emissao_p timestamp, dt_vencimento_p timestamp, vl_titulo_p bigint, vl_saldo_titulo_p bigint, ds_observacao_p text, cd_grupo_conta_p text, dt_entrada_p timestamp, nr_nosso_numero_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;