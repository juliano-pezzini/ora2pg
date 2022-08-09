-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_importar_cancelamento ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_origem_p INOUT bigint) AS $body$
DECLARE

 
cd_transacao_w			varchar(5);
ie_tipo_cliente_w		varchar(15);
cd_unimed_executora_w		smallint;
cd_unimed_beneficiario_w	smallint;
nr_seq_execucao_w		bigint;
nr_seq_guia_w			bigint;
ds_conteudo_w			varchar(4000);
qt_reg_mat_w			smallint;
qt_reg_proc_w			smallint;
nr_seq_import_w			smallint;
nr_seq_pedido_compl_w		bigint;
nr_seq_pedido_aut_w		bigint;
nr_seq_pedido_ant_w		bigint;
ie_insere_w			varchar(2);
nr_seq_requisicao_w		bigint;

c01 CURSOR FOR 
	SELECT	nr_seq_importacao, 
		ds_valores 
	from	w_scs_importacao 
	where	nm_usuario	= nm_usuario_p 
	order by nr_seq_importacao;

BEGIN
 
open c01;
loop 
fetch c01 into 
	nr_seq_import_w, 
	ds_conteudo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	if (substr(ds_conteudo_w,1,4)	<> 'FIM$') then 
		if (nr_seq_import_w	= 1) then 
			select substr(ds_conteudo_w,1,5), 
				trim(both substr(ds_conteudo_w,6,15)), 
				CASE WHEN (substr(ds_conteudo_w,21,4))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,21,4))::numeric  END , 
				CASE WHEN (substr(ds_conteudo_w,25,4))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,25,4))::numeric  END , 
				CASE WHEN (substr(ds_conteudo_w,29,10))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,29,10))::numeric  END , 
				CASE WHEN (substr(ds_conteudo_w,39,10))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,39,10))::numeric  END  
			into STRICT	cd_transacao_w, 
				ie_tipo_cliente_w, 
				cd_unimed_executora_w, 
				cd_unimed_beneficiario_w, 
				nr_seq_execucao_w, 
				nr_seq_origem_p 
			;
			 
			begin 
			select	nr_sequencia 
			into STRICT	nr_seq_pedido_ant_w 
			from	ptu_cancelamento 
			where	nr_seq_origem	= nr_seq_origem_p;
			exception 
			when others then 
				nr_seq_pedido_ant_w	:= 0;
			end;
			 
			if (nr_seq_pedido_ant_w	<> 0) then 
				goto final;
			end if;
			 
			select	coalesce(nr_seq_pedido_compl,0), 
				coalesce(nr_seq_pedido_aut,0) 
			into STRICT	nr_seq_pedido_compl_w, 
				nr_seq_pedido_aut_w 
			from	ptu_controle_execucao 
			where	nr_sequencia	= nr_seq_origem_p;
						 
			if (nr_seq_pedido_compl_w	<> 0) then 
				begin 
					select	nr_seq_guia, 
						nr_seq_requisicao 
					into STRICT	nr_seq_guia_w, 
						nr_seq_requisicao_w 
					from	ptu_pedido_compl_aut 
					where	nr_sequencia	= nr_seq_pedido_compl_w;
				exception 
				when others then 
					nr_seq_guia_w		:= 0;
					nr_seq_requisicao_w	:= 0;
				end;
				 
				if (coalesce(nr_seq_guia_w,0)	<> 0) then 
					CALL pls_cancelar_autorizacao(nr_seq_guia_w,2,nm_usuario_p,null);
					CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Recebido e processado o pedido de cancelamento da Unimed '||cd_unimed_executora_w,'',nm_usuario_p);
				elsif (coalesce(nr_seq_requisicao_w,0)	<> 0) then 
					CALL pls_cancelar_requisicao(nr_seq_requisicao_w, null, '', nm_usuario_p, cd_estabelecimento_p);
					CALL pls_cancelar_guia_execut_scs(nr_seq_requisicao_w, nm_usuario_p);
					CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Recebido e processado o pedido de cancelamento da Unimed '||cd_unimed_executora_w,null,nm_usuario_p);
				end if;
			elsif (nr_seq_pedido_aut_w	<> 0) then 
				begin 
					select	nr_seq_guia, 
						nr_seq_requisicao 
					into STRICT	nr_seq_guia_w, 
						nr_seq_requisicao_w 
					from	ptu_pedido_autorizacao 
					where	nr_sequencia	= nr_seq_pedido_aut_w;
				exception 
				when others then 
					nr_seq_guia_w		:= 0;
					nr_seq_requisicao_w	:= 0;
				end;
				 
				if (coalesce(nr_seq_guia_w,0)	<> 0) then 
					CALL pls_cancelar_autorizacao(nr_seq_guia_w,2,nm_usuario_p,null);
					CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Recebido e processado o pedido de cancelamento da Unimed '||cd_unimed_executora_w,'',nm_usuario_p);
				elsif (coalesce(nr_seq_requisicao_w,0)	<> 0) then 
					CALL pls_cancelar_requisicao(nr_seq_requisicao_w, null, '', nm_usuario_p, cd_estabelecimento_p);
					CALL pls_cancelar_guia_execut_scs(nr_seq_requisicao_w, nm_usuario_p);
					CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Recebido e processado o pedido de cancelamento da Unimed '||cd_unimed_executora_w,null,nm_usuario_p);
				end if;
			end if;
			 
			if (ie_tipo_cliente_w	= 'UNIMED') then 
				ie_tipo_cliente_w	:= 'U';
			elsif (ie_tipo_cliente_w	= 'PORTAL') then 
				ie_tipo_cliente_w	:= 'P';
			elsif (ie_tipo_cliente_w	= 'PRESTADOR') then 
				ie_tipo_cliente_w	:= 'R';
			end if;
 
			insert	into ptu_cancelamento(nr_sequencia, cd_transacao, ie_tipo_cliente, 
				 cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, 
				 dt_atualizacao, nm_usuario, nr_seq_origem, 
				 nr_seq_guia, nr_seq_requisicao, ds_arquivo_pedido) 
			values (nextval('ptu_cancelamento_seq'), cd_transacao_w, ie_tipo_cliente_w, 
				 cd_unimed_executora_w, cd_unimed_beneficiario_w, nr_seq_execucao_w, 
				 clock_timestamp(), nm_usuario_p, nr_seq_origem_p, 
				 nr_seq_guia_w, nr_seq_requisicao_w, ds_arquivo_p);
		end if;
	end if;
 
	end;
end loop;
close c01;
 
CALL ptu_gerar_confirmacao(nr_seq_origem_p,cd_estabelecimento_p,'C',nm_usuario_p);
 
<<final>> 
ie_insere_w	:= 'N';
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_importar_cancelamento ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_origem_p INOUT bigint) FROM PUBLIC;
