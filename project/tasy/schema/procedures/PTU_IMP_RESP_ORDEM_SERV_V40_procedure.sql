-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_resp_ordem_serv_v40 ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Importar resposta ordem serv_v40

Rotina utilizada nas transações ptu via scs homologadas com a unimed brasil.
quando for alterar, favor verificar com o análista responsável para a realização de testes.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Performance
---------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_transacao_w			varchar(5);
ie_tipo_cliente_w		varchar(15);
cd_unimed_exec_w		smallint;
cd_unimed_benef_w		smallint;
nr_seq_execucao_w		bigint;
nr_seq_origem_w			bigint;
cd_unimed_w			smallint;
cd_usuario_plano_w		bigint;
nm_prestador_w			varchar(25);
nr_seq_guia_w			bigint;
nr_seq_requisicao_w		bigint;
nr_seq_resposta_w		bigint;
ds_observacao_w			varchar(255);
ie_tipo_tabela_w		varchar(2);
cd_servico_w			integer;
qt_autorizada_w			smallint;
ie_status_req_w			smallint;
cd_mens_erro_1			smallint;
cd_mens_erro_2			smallint;
cd_mens_erro_3			smallint;
cd_mens_erro_4			smallint;
cd_mens_erro_5			smallint;
ie_status_w			varchar(2);
nr_seq_transacao_w		bigint;
ie_tipo_transacao_w		varchar(2);
qt_registro_w			smallint;
qt_registro_ww			smallint;
nr_seq_importacao_w		bigint;
ds_conteudo_w			varchar(4000);
nr_seq_material_w		bigint;
nr_seq_procedimento_w		bigint;
cd_servico_consersao_w		bigint;

c01 CURSOR FOR
	SELECT	nr_seq_importacao,
		ds_valores
	from	w_scs_importacao
	where	nm_usuario	= nm_usuario_p
	order by nr_seq_importacao;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_plano_proc
	where	cd_procedimento 	= cd_servico_w
	and	nr_seq_guia		= nr_seq_guia_w
	
union

	SELECT	nr_sequencia
	from	pls_requisicao_proc
	where	cd_procedimento 	= coalesce(cd_servico_consersao_w,cd_servico_w)
	and	nr_seq_requisicao	= nr_seq_requisicao_w;

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_plano_mat
	where	pls_obter_seq_codigo_material(nr_seq_material,'') 	= cd_servico_w
	and	nr_seq_guia		= nr_seq_guia_w
	
union

	SELECT	nr_sequencia
	from	pls_requisicao_mat
	where (pls_obter_seq_codigo_material(nr_seq_material,'') 	= cd_servico_w
	or	pls_obter_seq_codigo_material(nr_seq_material,'')	= cd_servico_consersao_w)
	and	nr_seq_requisicao	= nr_seq_requisicao_w;


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
			cd_transacao_w		:= substr(ds_conteudo_w,1,5);
			ie_tipo_cliente_w	:= trim(both substr(ds_conteudo_w,6,15));
			cd_unimed_benef_w	:= (substr(ds_conteudo_w,21,4))::numeric;
			cd_unimed_exec_w	:= (substr(ds_conteudo_w,25,4))::numeric;
			nr_seq_origem_w		:= (substr(ds_conteudo_w,29,10))::numeric;
			nr_seq_execucao_w	:= (substr(ds_conteudo_w,39,10))::numeric;
			cd_unimed_w		:= (substr(ds_conteudo_w,49,4))::numeric;
			cd_usuario_plano_w	:= trim(both substr(ds_conteudo_w,53,13));
			nm_prestador_w		:= trim(both substr(ds_conteudo_w,66,25));

			begin
				select	nr_seq_guia,
					nr_seq_requisicao
				into STRICT	nr_seq_guia_w,
					nr_seq_requisicao_w
				from	ptu_requisicao_ordem_serv
				where	nr_seq_origem	= nr_seq_origem_w;
			exception
			when others then
				nr_seq_guia_w		:= 0;
				nr_seq_requisicao_w	:= 0;
			end;

			if (cd_transacao_w	= '00607') then
				select	nextval('ptu_resposta_req_ord_serv_seq')
				into STRICT	nr_seq_resposta_w
				;

				if (ie_tipo_cliente_w	= 'UNIMED') then
					ie_tipo_cliente_w	:= 'U';
				elsif (ie_tipo_cliente_w	= 'PORTAL') then
					ie_tipo_cliente_w	:= 'P';
				elsif (ie_tipo_cliente_w	= 'PRESTADOR') then
					ie_tipo_cliente_w	:= 'R';
				end if;

				insert	into ptu_resposta_req_ord_serv(nr_sequencia, cd_transacao, ie_tipo_cliente,
					 cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao,
					 cd_unimed, cd_usuario_plano, nr_seq_origem,
					 nm_prest_alto_custo, nr_seq_requisicao, nr_seq_guia,
					 nm_usuario, dt_atualizacao, ds_arquivo_pedido,
					 nm_usuario_nrec, dt_atualizacao_nrec)
				values (nr_seq_resposta_w, cd_transacao_w, ie_tipo_cliente_w,
					 cd_unimed_exec_w, cd_unimed_benef_w, nr_seq_execucao_w,
					 cd_unimed_w, cd_usuario_plano_w, nr_seq_origem_w,
					 nm_prestador_w, nr_seq_requisicao_w, nr_seq_guia_w,
					 nm_usuario_p, clock_timestamp(), ds_arquivo_p,
					 nm_usuario_p, clock_timestamp());
			end if;
		elsif (nr_seq_importacao_w	= 2) then
			select	trim(both substr(ds_conteudo_w,1,255))
				into STRICT	ds_observacao_w
				;

				update	ptu_requisicao_ordem_serv
				set	ds_observacao	= ds_observacao_w
				where	nr_sequencia	= nr_seq_resposta_w;
		elsif (substr(ds_conteudo_w,1,1) in ('0','1','2','3', '4'))  then
			ie_tipo_tabela_w	:= substr(ds_conteudo_w,1,1);
			cd_servico_w		:= (substr(ds_conteudo_w,2,8))::numeric;
			qt_autorizada_w		:= (substr(ds_conteudo_w,10,8))::numeric;
			ie_status_req_w		:= (substr(ds_conteudo_w,18,1))::numeric;
			cd_mens_erro_1		:= (substr(ds_conteudo_w,19,1))::numeric;
			cd_mens_erro_2		:= (substr(ds_conteudo_w,23,1))::numeric;
			cd_mens_erro_3		:= (substr(ds_conteudo_w,27,1))::numeric;
			cd_mens_erro_4		:= (substr(ds_conteudo_w,31,1))::numeric;
			cd_mens_erro_5		:= (substr(ds_conteudo_w,35,1))::numeric;

			insert	into ptu_resposta_req_servico(nr_sequencia, nr_seq_resp_req_ord, cd_servico,
				 qt_servico_aut, ie_status_requisicao, ie_tipo_tabela,
				 nm_usuario, dt_atualizacao, nm_usuario_nrec,
				 dt_atualizacao_nrec)
			values (nextval('ptu_resposta_req_servico_seq'), nr_seq_resposta_w, cd_servico_w,
				 qt_autorizada_w, ie_status_req_w, ie_tipo_tabela_w,
				 nm_usuario_p, clock_timestamp(), nm_usuario_p,
				 clock_timestamp());

			if (ie_status_req_w	= 1) then
				ie_status_w	:= 'N';
			elsif (ie_status_req_w	= 2) then
				ie_status_w	:= 'S';
			end if;

			if (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '')then
				nr_seq_transacao_w 	:= nr_seq_guia_w;
				ie_tipo_transacao_w	:= 'G';
				if (ie_tipo_tabela_w	in ('0','1','4')) then
					cd_servico_consersao_w	:= ptu_obter_servico_conversao(cd_servico_w, nr_seq_origem_w, null, 'OS');
					open C02;
					loop
					fetch C02 into
						nr_seq_procedimento_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
						begin

						update	pls_guia_plano_proc
						set	qt_autorizada	= qt_autorizada_w,
							ie_status	= ie_status_w
						where	nr_sequencia	= nr_seq_procedimento_w;

						if (cd_mens_erro_1	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_1,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_2	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_2,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_3	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_3,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_4	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_4,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_5	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_5,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;

						end;
					end loop;
					close C02;
				elsif (ie_tipo_tabela_w	in ('2','3')) then
					cd_servico_consersao_w	:= ptu_obter_servico_conversao(cd_servico_w, nr_seq_origem_w, null, 'OS');
					open C03;
					loop
					fetch C03 into
						nr_seq_material_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
						begin

						update	pls_guia_plano_mat
						set	qt_autorizada	= qt_autorizada_w,
							ie_status	= ie_status_w
						where	nr_sequencia	= nr_seq_material_w;

						if (cd_mens_erro_1	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_1,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_2	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_2,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_3	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_3,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_4	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_4,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;

						if (cd_mens_erro_5	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_5,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;

						end;
					end loop;
					close C03;
				end if;

				select	count(*)
				into STRICT	qt_registro_w
				from	pls_guia_plano_proc
				where	ie_status	= 'N'
				and	nr_seq_guia	= nr_seq_guia_w;

				select	count(*)
				into STRICT	qt_registro_ww
				from	pls_guia_plano_mat
				where	ie_status	= 'N'
				and	nr_seq_guia	= nr_seq_guia_w;

				if	((qt_registro_w	> 0) or (qt_registro_ww	> 0)) then
					update	pls_guia_plano
					set	ie_estagio	= 4
					where	nr_sequencia	= nr_seq_guia_w;
				else
					update	pls_guia_plano
					set	ie_estagio	= 6
					where	nr_sequencia	= nr_seq_guia_w;
				end if;
			else
				nr_seq_transacao_w	:= nr_seq_requisicao_w;
				ie_tipo_transacao_w	:= 'R';
				if (ie_tipo_tabela_w	in ('0','1','4')) then
					cd_servico_consersao_w	:= ptu_obter_servico_conversao(cd_servico_w, nr_seq_origem_w, null, 'OS');
					open C02;
					loop
					fetch C02 into
						nr_seq_procedimento_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
						begin

						update	pls_requisicao_proc
						set	qt_procedimento		= qt_autorizada_w,
							ie_status		= ie_status_w
						where	nr_sequencia		= nr_seq_procedimento_w;

						if (cd_mens_erro_1	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_1,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_2	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_2,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_3	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_3,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_4	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_4,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_5	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_5,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, nr_seq_procedimento_w, null, null, nm_usuario_p);
						end if;

						end;
					end loop;
					close C02;
				elsif (ie_tipo_tabela_w	in ('2','3')) then
					cd_servico_consersao_w	:= ptu_obter_servico_conversao(cd_servico_w, nr_seq_origem_w, null, 'OS');
					open C03;
					loop
					fetch C03 into
						nr_seq_material_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
						begin

						update	pls_requisicao_mat
						set	qt_material		= qt_autorizada_w,
							ie_status		= ie_status_w
						where	nr_sequencia		= nr_seq_material_w;

						if (cd_mens_erro_1	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_1,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_2	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_2,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_3	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_3,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_4	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_4,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;
						if (cd_mens_erro_5	<> 0) then
							CALL ptu_inserir_inconsistencia(	null, null, cd_mens_erro_5,'',cd_estabelecimento_p, nr_seq_transacao_w, ie_tipo_transacao_w,
											cd_transacao_w, null, nr_seq_material_w, null, nm_usuario_p);
						end if;

						end;
					end loop;
					close C03;
				end if;

				select	count(1)
				into STRICT	qt_registro_w
				from	pls_requisicao_proc
				where	ie_status	= 'N'
				and	nr_seq_requisicao	= nr_seq_requisicao_w;

				select	count(1)
				into STRICT	qt_registro_ww
				from	pls_requisicao_mat
				where	ie_status	= 'N'
				and	nr_seq_requisicao	= nr_seq_requisicao_w;

				if	((qt_registro_w	> 0) or (qt_registro_ww	> 0)) then
					update	pls_requisicao
					set	ie_estagio	= 7
					where	nr_sequencia	= nr_seq_requisicao_w;
				else
					update	pls_requisicao
					set	ie_estagio	= 2
					where	nr_sequencia	= nr_seq_requisicao_w;
				end if;
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
-- REVOKE ALL ON PROCEDURE ptu_imp_resp_ordem_serv_v40 ( ds_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

