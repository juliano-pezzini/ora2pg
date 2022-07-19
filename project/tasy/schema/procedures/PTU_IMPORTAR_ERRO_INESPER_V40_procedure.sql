-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_importar_erro_inesper_v40 ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina utilizada nas transações ptu via SCS homologadas com a unimed brasil.
Quando for alterar, favor verificar com o análista responsável para a realização de testes.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_transacao_w			varchar(10);
ie_tipo_cliente_w		varchar(15);
cd_unimed_executora_w		smallint;
cd_unimed_beneficiario_w	smallint;
nr_seq_execucao_w		bigint;
nr_seq_origem_w			bigint;
cd_mens_excecao_w		smallint;
nr_seq_guia_w			bigint;
nr_seq_requisicao_w		bigint;
ds_conteudo_w			varchar(4000);
nr_seq_importacao_w		bigint;
nr_seq_erro_w			bigint;
nr_seq_pedido_compl_w		bigint;
nr_seq_pedido_aut_w		bigint;

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
	nr_seq_importacao_w,
	ds_conteudo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (substr(ds_conteudo_w,1,4)	<> 'FIM$') then
		if (nr_seq_importacao_w	= 1) then
			select  substr(ds_conteudo_w,1,5),
				trim(both substr(ds_conteudo_w,6,15)),
				CASE WHEN (substr(ds_conteudo_w,21,4))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,21,4))::numeric  END ,
				CASE WHEN (substr(ds_conteudo_w,25,4))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,25,4))::numeric  END ,
				CASE WHEN (substr(ds_conteudo_w,29,10))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,29,10))::numeric  END ,
				CASE WHEN (substr(ds_conteudo_w,39,10))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,39,10))::numeric  END ,
				CASE WHEN (substr(ds_conteudo_w,49,4))::numeric =0 THEN ''  ELSE (substr(ds_conteudo_w,49,4))::numeric  END
			into STRICT	cd_transacao_w,
				ie_tipo_cliente_w,
				cd_unimed_executora_w,
				cd_unimed_beneficiario_w,
				nr_seq_execucao_w,
				nr_seq_origem_w,
				cd_mens_excecao_w
			;

			if (coalesce(nr_seq_execucao_w::text, '') = '') then
				select	ptu_obter_erro_inesperado(ds_arquivo_p)
				into STRICT	nr_seq_execucao_w
				;
			end if;

			begin
				select	nr_seq_pedido_compl,
					nr_seq_pedido_aut
				into STRICT	nr_seq_pedido_compl_w,
					nr_seq_pedido_aut_w
				from	ptu_controle_execucao
				where	nr_sequencia	= nr_seq_execucao_w;
			exception
			when others then
				nr_seq_pedido_compl_w	:= 0;
				nr_seq_pedido_aut_w	:= 0;
			end;

			if (nr_seq_pedido_compl_w	<> 0) then
				select	nr_seq_guia,
					nr_seq_requisicao
				into STRICT	nr_seq_guia_w,
					nr_seq_requisicao_w
				from	ptu_pedido_compl_aut
				where	nr_sequencia	= nr_seq_pedido_compl_w;
			elsif (nr_seq_pedido_aut_w	<> 0) then
				select	nr_seq_guia,
					nr_seq_requisicao
				into STRICT	nr_seq_guia_w,
					nr_seq_requisicao_w
				from	ptu_pedido_autorizacao
				where	nr_sequencia	= nr_seq_pedido_aut_w;
			end if;

			if (ie_tipo_cliente_w	= 'UNIMED') then
				ie_tipo_cliente_w	:= 'U';
			elsif (ie_tipo_cliente_w	= 'PORTAL') then
				ie_tipo_cliente_w	:= 'P';
			elsif (ie_tipo_cliente_w	= 'PRESTADOR') then
				ie_tipo_cliente_w	:= 'R';
			end if;

			if (cd_transacao_w	= '00310') then
				select	nextval('ptu_erro_inesperado_seq')
				into STRICT	nr_seq_erro_w
				;

				insert	into ptu_erro_inesperado(nr_sequencia, cd_transacao, ie_tipo_cliente,
					 cd_unimed_executora, cd_unimed_beneficiario, dt_atualizacao,
					 nm_usuario, nr_seq_execucao, nr_seq_origem,
					 nr_seq_requisicao, nr_seq_guia, ds_arquivo_pedido,
					 nm_usuario_nrec, dt_atualizacao_nrec)
				values (nr_seq_erro_w, cd_transacao_w, ie_tipo_cliente_w,
					 cd_unimed_executora_w, cd_unimed_beneficiario_w, clock_timestamp(),
					 nm_usuario_p, nr_seq_execucao_w, nr_seq_origem_w,
					 nr_seq_requisicao_w, nr_seq_guia_w, ds_arquivo_p,
					 nm_usuario_p, clock_timestamp());

				CALL ptu_inserir_inconsistencia(	null, null, cd_mens_excecao_w,'',cd_estabelecimento_p, nr_seq_erro_w, 'EI',
								'00310', null, null, null, nm_usuario_p);

				CALL ptu_gravar_log_erro_inesperado(nr_seq_guia_w, nr_seq_requisicao_w, cd_mens_excecao_w, '00310', nm_usuario_p);
			end if;
		end if;
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_importar_erro_inesper_v40 ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

