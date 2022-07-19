-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_confirmacao_v60 ( ie_tipo_cliente_p ptu_confirmacao.ie_tipo_cliente%type, cd_unimed_executora_p ptu_confirmacao.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_confirmacao.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_confirmacao.nr_seq_execucao%type, nr_seq_origem_p ptu_confirmacao.nr_seq_origem%type, ie_identificador_p ptu_confirmacao.ie_tipo_identificador%type, cd_transacao_p ptu_confirmacao.cd_transacao%type, nr_versao_p ptu_confirmacao.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_confirmacao_p INOUT ptu_confirmacao.nr_sequencia%type, ie_possui_registro_p INOUT text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Realizar a importação do arquivo de 00309-Confirmação 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ x] Tasy (Delphi/Java) [ x] Portal [ ] Relatórios [ x] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
ie_tipo_cliente_w		ptu_confirmacao.ie_tipo_cliente%type;
nr_seq_confirmacao_w		ptu_confirmacao.nr_sequencia%type;
nr_seq_confirmacao_existe_w	ptu_confirmacao.nr_sequencia%type;
nr_seq_pedido_aut_w		ptu_controle_execucao.nr_seq_pedido_aut%type;
nr_seq_pedido_compl_w		ptu_controle_execucao.nr_seq_pedido_compl%type;
nr_seq_origem_w			ptu_resposta_autorizacao.nr_seq_origem%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;
nr_seq_import_w			integer;
qt_reg_canelamento_w		integer;
qt_reg_insistencia_w		integer;
qt_reg_confir_cancel_w		integer;
qt_reg_confir_insist_w		integer;
qt_reg_resp_aud_w		integer;
qt_reg_confir_aud_w		integer;
qt_reg_decurso_w		integer;
qt_reg_confir_decurso_w		integer;
qt_registros_aud_w		integer;
qt_proc_aut_w			integer;
qt_proc_neg_w			integer;
qt_reg_autoriz_os_w		integer;
qt_reg_confir_autoriz_os_w	integer;
nr_seq_res_ord_serv_w		ptu_resposta_req_ord_serv.nr_sequencia%type;
cd_unimed_solicitante_w		ptu_resposta_req_ord_serv.cd_unimed_solicitante%type;
nr_seq_solic_w			ptu_resposta_req_ord_serv.nr_seq_origem%type;
nr_seq_segurado_w		pls_guia_plano.nr_seq_segurado%type;
dt_solicitacao_w		pls_guia_plano.dt_solicitacao%type;
ie_tipo_guia_w			varchar(2);
ie_tipo_resposta_w		varchar(2);
dt_valid_senha_w		timestamp;
cd_senha_w			varchar(20);
dt_solicitacao_varchar_w	varchar(20);
nr_seq_cancel_wsd_w		bigint;
ie_gerar_senha_interna_w	varchar(1);


BEGIN 
-- Verificar o parâmetro na função OPS - Gestão de Operadoras / Parâmetros OPS / Intercâmbio / Intercâmbio SCS 
begin 
	select	ie_gerar_senha_interna 
	into STRICT	ie_gerar_senha_interna_w 
	from	pls_param_intercambio_scs;
exception 
when others then 
	ie_gerar_senha_interna_w	:= null;
end;
 
/*select	max(nr_sequencia) 
into	nr_seq_confirmacao_existe_w 
from	ptu_confirmacao 
where	nr_seq_origem		= nr_seq_origem_p 
and	cd_unimed_beneficiario	= cd_unimed_beneficiario_p 
and	ie_identificador	= ie_identificador_p; 
*/
 
ie_possui_registro_p := 'N';
 
--Verificar se já existe um pedido de cancelamento em aberto, caso exista a rotina retorna a sequência do pedido existente 
/*if	( nr_seq_confirmacao_existe_w is not null ) then 
	ie_possui_registro_p 	:= 'S'; 
	nr_seq_confirmacao_w 	:= nr_seq_confirmacao_existe_w; 
else*/
 
	begin 
		select	a.nr_sequencia 
		into STRICT	nr_seq_pedido_compl_w 
		from	ptu_pedido_compl_aut a, 
			ptu_controle_execucao b 
		where	b.nr_sequencia		= nr_seq_execucao_p 
		and	a.nr_sequencia		= b.nr_seq_pedido_compl 
		and	a.cd_unimed_executora	= cd_unimed_executora_p;
	exception 
	when others then 
		begin 
			select	a.nr_sequencia 
			into STRICT	nr_seq_pedido_aut_w 
			from	ptu_pedido_autorizacao a, 
				ptu_controle_execucao b 
			where	b.nr_sequencia		= nr_seq_execucao_p 
			and	a.nr_sequencia		= b.nr_seq_pedido_aut 
			and	a.cd_unimed_executora	= cd_unimed_executora_p;
		exception 
		when others then 
			begin 
				select	coalesce(nr_seq_pedido_compl,0), 
					coalesce(nr_seq_pedido_aut,0) 
				into STRICT	nr_seq_pedido_compl_w, 
					nr_seq_pedido_aut_w 
				from	ptu_controle_execucao 
				where	nr_sequencia	= nr_seq_origem_p;
			exception 
			when others then 
				begin 
					select 	coalesce(nr_seq_origem,0) 
					into STRICT	nr_seq_origem_w 
					from  ptu_resposta_autorizacao 
					where  nr_seq_execucao 	= nr_seq_execucao_p 
					and	cd_unimed_executora	= cd_unimed_executora_p;
 
					select	coalesce(nr_seq_pedido_compl,0), 
						coalesce(nr_seq_pedido_aut,0) 
					into STRICT	nr_seq_pedido_compl_w, 
						nr_seq_pedido_aut_w 
					from	ptu_controle_execucao 
					where	nr_sequencia	= nr_seq_origem_w;				
				exception 
				when others then 
					nr_seq_pedido_compl_w	:= 0;
					nr_seq_pedido_aut_w	:= 0;
				end;
			end;
		end;
	end;
 
	if (nr_seq_pedido_aut_w	<> 0) then 
		select	max(nr_seq_guia), 
			max(nr_seq_requisicao) 
		into STRICT	nr_seq_guia_w, 
			nr_seq_requisicao_w 
		from	ptu_pedido_autorizacao 
		where	nr_sequencia	= nr_seq_pedido_aut_w;
	elsif (nr_seq_pedido_compl_w	<> 0) then 
		select	max(nr_seq_guia), 
			max(nr_seq_requisicao) 
		into STRICT	nr_seq_guia_w, 
			nr_seq_requisicao_w 
		from	ptu_pedido_compl_aut 
		where	nr_sequencia	= nr_seq_pedido_compl_w;
	end if;
 
	ie_tipo_cliente_w := ptu_converter_tipo_cliente(ie_tipo_cliente_p);
 
	select	count(1) 
	into STRICT	qt_reg_decurso_w 
	from	ptu_decurso_prazo	a 
	where	a.nr_seq_execucao	= nr_seq_execucao_p;
 
	select 	count(1) 
	into STRICT	qt_reg_confir_decurso_w 
	from	ptu_confirmacao	x 
	where	x.nr_seq_execucao	= nr_seq_execucao_p 
	and	x.ie_tipo_resposta	= 'DP';
 
	if (qt_reg_decurso_w	<> qt_reg_confir_decurso_w) then 
		ie_tipo_resposta_w	:= 'DP';
	end if;
 
	select	count(1) 
	into STRICT	qt_reg_autoriz_os_w 
	from	ptu_autorizacao_ordem_serv	a 
	where	a.nr_seq_execucao		= nr_seq_execucao_p;
 
	select 	count(1) 
	into STRICT	qt_reg_confir_autoriz_os_w 
	from	ptu_confirmacao	x 
	where	x.nr_seq_execucao	= nr_seq_execucao_p 
	and	x.ie_tipo_resposta	= 'AO';
 
	if (qt_reg_autoriz_os_w	<> qt_reg_confir_autoriz_os_w) then 
		ie_tipo_resposta_w	:= 'AO';
	end if;
 
	select	count(1) 
	into STRICT	qt_reg_canelamento_w 
	from	ptu_cancelamento	a 
	where	a.nr_seq_execucao	= nr_seq_execucao_p;
 
	if (qt_reg_canelamento_w	= 0) and (nr_seq_execucao_p	= nr_seq_origem_p) then 
		select	count(1) 
		into STRICT	qt_reg_canelamento_w 
		from	ptu_cancelamento		a 
		where	a.nr_seq_origem			= nr_seq_origem_p 
		and	a.cd_unimed_beneficiario	= cd_unimed_beneficiario_p;
	end if;
 
	select	count(1) 
	into STRICT	qt_reg_confir_cancel_w 
	from	ptu_confirmacao	x 
	where	x.nr_seq_execucao	= nr_seq_execucao_p 
	and	x.ie_tipo_resposta	= 'C';
 
	if (qt_reg_confir_cancel_w	= 0) and (nr_seq_execucao_p	= nr_seq_origem_p) then 
		select	count(1) 
		into STRICT	qt_reg_confir_cancel_w 
		from	ptu_confirmacao	x 
		where	x.nr_seq_origem			= nr_seq_origem_p 
		and	x.cd_unimed_beneficiario	= cd_unimed_beneficiario_p 
		and	x.ie_tipo_resposta		= 'C';
	end if;
 
	if (qt_reg_canelamento_w	<> qt_reg_confir_cancel_w ) then 
		ie_tipo_resposta_w	:= 'C';
	end if;
 
	select	count(1) 
	into STRICT	qt_reg_insistencia_w 
	from	ptu_pedido_insistencia	a 
	where	a.nr_seq_execucao	= nr_seq_execucao_p;
 
	select 	count(1) 
	into STRICT	qt_reg_confir_insist_w 
	from	ptu_confirmacao	x 
	where	x.nr_seq_execucao	= nr_seq_execucao_p 
	and	x.ie_tipo_resposta	= 'PI';
 
	if (qt_reg_insistencia_w	<> qt_reg_confir_insist_w ) then 
		ie_tipo_resposta_w	:= 'PI';
	end if;
 
	select	count(1) 
	into STRICT	qt_reg_resp_aud_w 
	from	ptu_resposta_auditoria	a 
	where	a.nr_seq_execucao	= nr_seq_execucao_p;
 
	select	count(1) 
	into STRICT	qt_reg_confir_aud_w 
	from	ptu_confirmacao	x 
	where	x.nr_seq_execucao	= nr_seq_execucao_p 
	and	x.ie_tipo_resposta	= 'RA';
 
	if (qt_reg_resp_aud_w	<> qt_reg_confir_aud_w ) then 
		ie_tipo_resposta_w	:= 'RA';
	end if;
 
	if (ie_tipo_resposta_w	= 'C') and (ie_identificador_p = 1) then 
		select	max(nr_sequencia) 
		into STRICT 	nr_seq_cancel_wsd_w 
		from 	pls_guia_motivo_cancel 
		where 	ie_motivo_cancel_wsd = 'EC' 
		and	ie_situacao = 'A';
 
		if (coalesce(nr_seq_cancel_wsd_w::text, '') = '') then 
			select	max(nr_sequencia) 
			into STRICT 	nr_seq_cancel_wsd_w 
			from 	pls_guia_motivo_cancel;
		end if;
 
		if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then 
			CALL pls_cancelar_requisicao(nr_seq_requisicao_w, nr_seq_cancel_wsd_w, '', nm_usuario_p, cd_estabelecimento_p);
 
		elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
			CALL pls_cancelar_autorizacao(nr_seq_guia_w, nr_seq_cancel_wsd_w, nm_usuario_p,null);
		end if;
 
	elsif (ie_tipo_resposta_w	= 'PI') and (ie_identificador_p = 1) then 
		if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then 
			update	pls_requisicao_proc 
			set	ie_status		= 'A', 
				ie_estagio		= 'AA', 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_requisicao	= nr_seq_requisicao_w;
 
			update	pls_requisicao_mat 
			set	ie_status		= 'A', 
				ie_estagio		= 'AA', 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_requisicao	= nr_seq_requisicao_w;
 
			update	pls_requisicao 
			set	ie_estagio	= 5, 
				ie_status	= 'P', 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario	= nm_usuario_p 
			where	nr_sequencia	= nr_seq_requisicao_w;
 
			CALL pls_gerar_auditoria_requisicao(nr_seq_requisicao_w, nm_usuario_p,'AE');
			CALL ptu_gerar_grupo_aud_padrao(null,nr_seq_requisicao_w,'GC',nm_usuario_p);
		elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
			update	pls_guia_plano_proc 
			set	ie_status	= 'A', 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario	= nm_usuario_p 
			where	nr_seq_guia	= nr_seq_guia_w;
 
			update	pls_guia_plano_mat 
			set	ie_status	= 'A', 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario	= nm_usuario_p 
			where	nr_seq_guia	= nr_seq_guia_w;
 
			update	pls_guia_plano 
			set	ie_estagio	= 11, 
				ie_status	= '2', 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario	= nm_usuario_p 
			where	nr_sequencia	= nr_seq_guia_w;
 
			CALL pls_gerar_auditoria_guia(nr_seq_guia_w, nm_usuario_p);
			CALL ptu_gerar_grupo_aud_padrao(nr_seq_guia_w,null,'GC',nm_usuario_p);
		end if;
	elsif	((ie_tipo_resposta_w	= 'DP') and ((ie_identificador_p = 1) or (ie_identificador_p = 4))) then 
 
		if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then 
			update	pls_requisicao_proc 
			set	ie_status		= 'S', 
				qt_procedimento		= qt_solicitado, 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_requisicao	= nr_seq_requisicao_w 
			and	ie_status		= 'A';
 
			update	pls_requisicao_mat 
			set	ie_status		= 'S', 
				qt_material		= qt_solicitado, 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_requisicao	= nr_seq_requisicao_w 
			and	ie_status		= 'A';
 
			select	nr_seq_segurado, 
				dt_requisicao, 
				ie_tipo_guia 
			into STRICT	nr_seq_segurado_w, 
				dt_solicitacao_w, 
				ie_tipo_guia_w 
			from	pls_requisicao 
			where	nr_sequencia = nr_seq_requisicao_w;
 
			CALL pls_gerar_validade_senha_req(	nr_seq_requisicao_w, 
							nr_seq_segurado_w, 
							dt_solicitacao_w, 
							ie_tipo_guia_w, 
							nm_usuario_p);
 
			update	pls_requisicao 
			set	ie_estagio	= 2, 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario	= nm_usuario_p, 
				cd_senha_externa = nr_seq_origem_p 
			where	nr_sequencia	= nr_seq_requisicao_w;
 
			select	count(1) 
			into STRICT	qt_registros_aud_w 
			from	pls_auditoria 
			where	nr_seq_requisicao	= nr_seq_requisicao_w 
			and	coalesce(dt_liberacao::text, '') = '';
 
			if (qt_registros_aud_w > 0) then 
				update	pls_auditoria 
				set	ie_status		= 'F', 
					dt_liberacao		= clock_timestamp(), 
					nr_seq_proc_interno	 = NULL, 
					dt_atualizacao		= clock_timestamp(), 
					nm_usuario		= nm_usuario_p 
				where	nr_seq_requisicao	= nr_seq_requisicao_w;
			end if;
 
			CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Requisição autorizada por decurso de prazo',null,nm_usuario_p);
 
			update	pls_auditoria_grupo 
			set	dt_liberacao		= clock_timestamp(), 
				ie_status		= 'S', 
				nm_usuario		= nm_usuario_p, 
				dt_atualizacao		= clock_timestamp() 
			where	coalesce(dt_liberacao::text, '') = '' 
			and	exists (	SELECT	1 
					from 	pls_auditoria x 
					where 	x.nr_seq_requisicao	= nr_seq_requisicao_w 
					and 	x.nr_sequencia 		= nr_seq_auditoria);
 
		elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
			update	pls_guia_plano_proc 
			set	ie_status	= 'S', 
				qt_autorizada	= qt_solicitada, 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario	= nm_usuario_p 
			where	nr_seq_guia	= nr_seq_guia_w 
			and	ie_status	= 'A';
 
			update	pls_guia_plano_mat 
			set	ie_status	= 'S', 
				qt_autorizada	= qt_solicitada, 
				dt_atualizacao	= clock_timestamp(), 
				nm_usuario	= nm_usuario_p 
			where	nr_seq_guia	= nr_seq_guia_w 
			and	ie_status	= 'A';
 
			select	nr_seq_segurado, 
				dt_solicitacao, 
				ie_tipo_guia 
			into STRICT	nr_seq_segurado_w, 
				dt_solicitacao_w, 
				ie_tipo_guia_w 
			from	pls_guia_plano 
			where	nr_sequencia = nr_seq_guia_w;
 
			if (coalesce(ie_gerar_senha_interna_w,'S')	= 'S') then 
				SELECT * FROM pls_gerar_validade_senha(nr_seq_guia_w, nr_seq_segurado_w, 0/*qt_dias_val_senha_p*/
, dt_solicitacao_w, ie_tipo_guia_w, nm_usuario_p, dt_solicitacao_varchar_w, cd_senha_w) INTO STRICT dt_solicitacao_varchar_w, cd_senha_w;
 
				dt_valid_senha_w := to_date(dt_solicitacao_varchar_w, 'dd/mm/rrrr');
			else 
				dt_valid_senha_w := to_date(clock_timestamp() + interval '60 days', 'dd/mm/rrrr');
				cd_senha_w	:= null;
			end if;
 
			update	pls_guia_plano 
			set	ie_estagio		= 6, 
				ie_status		= '1', 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p, 
				cd_senha 		= cd_senha_w, 
				dt_validade_senha 	= dt_valid_senha_w, 
				cd_senha_externa 	= nr_seq_origem_p 
			where	nr_sequencia		= nr_seq_guia_w;
 
			select	count(1) 
			into STRICT	qt_registros_aud_w 
			from	pls_auditoria 
			where	nr_seq_guia	= nr_seq_guia_w 
			and	coalesce(dt_liberacao::text, '') = '';
 
			if (qt_registros_aud_w > 0) then 
				update	pls_auditoria 
				set	ie_status		= 'F', 
					dt_liberacao		= clock_timestamp(), 
					nr_seq_proc_interno	 = NULL, 
					dt_atualizacao		= clock_timestamp(), 
					nm_usuario		= nm_usuario_p 
				where	nr_seq_guia		= nr_seq_guia_w;
			end if;
 
			CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Guia autorizada por decurso de prazo','',nm_usuario_p);
 
			update	pls_auditoria_grupo 
			set	dt_liberacao		= clock_timestamp(), 
				ie_status		= 'S', 
				nm_usuario		= nm_usuario_p, 
				dt_atualizacao		= clock_timestamp() 
			where	coalesce(dt_liberacao::text, '') = '' 
			and	exists (	SELECT	1 
					from 	pls_auditoria x 
					where 	x.nr_seq_guia 	= nr_seq_guia_w 
					and 	x.nr_sequencia 	= nr_seq_auditoria);
		end if;
	elsif (ie_tipo_resposta_w	= 'AO') and (ie_identificador_p	= 1) then 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_res_ord_serv_w 
		from	ptu_resposta_req_ord_serv 
		where	nr_seq_execucao	= nr_seq_execucao_p;
 
		if (nr_seq_res_ord_serv_w IS NOT NULL AND nr_seq_res_ord_serv_w::text <> '') then 
			select	count(1) 
			into STRICT	qt_proc_aut_w 
			from	ptu_resposta_req_servico 
			where	nr_seq_resp_req_ord	= nr_seq_res_ord_serv_w 
			and	ie_status_requisicao	= 2;
 
			select	count(1) 
			into STRICT	qt_proc_neg_w 
			from	ptu_resposta_req_servico 
			where	nr_seq_resp_req_ord	= nr_seq_res_ord_serv_w 
			and	ie_status_requisicao	= 1;
 
			select	cd_unimed_solicitante, 
				nr_seq_origem 
			into STRICT	cd_unimed_solicitante_w, 
				nr_seq_solic_w 
			from	ptu_resposta_req_ord_serv 
			where	nr_sequencia	= nr_seq_res_ord_serv_w;
		end if;
 
		if (qt_proc_aut_w	> 0) and (qt_proc_neg_w	= 0) then 
			update	ptu_requisicao_ordem_serv 
			set	ie_estagio			= 3, 
				dt_atualizacao			= clock_timestamp(), 
				nm_usuario			= nm_usuario_p 
			where	nr_transacao_solicitante	= nr_seq_solic_w 
			and	cd_unimed_solicitante		= cd_unimed_solicitante_w;
		elsif (qt_proc_aut_w	= 0) and (qt_proc_neg_w	> 0) then 
			update	ptu_requisicao_ordem_serv 
			set	ie_estagio			= 4, 
				dt_atualizacao			= clock_timestamp(), 
				nm_usuario			= nm_usuario_p 
			where	nr_transacao_solicitante	= nr_seq_solic_w 
			and	cd_unimed_solicitante		= cd_unimed_solicitante_w;
		elsif (qt_proc_aut_w	> 0) and (qt_proc_neg_w	> 0) then 
			update	ptu_requisicao_ordem_serv 
			set	ie_estagio			= 5, 
				dt_atualizacao			= clock_timestamp(), 
				nm_usuario			= nm_usuario_p 
			where	nr_transacao_solicitante	= nr_seq_solic_w 
			and	cd_unimed_solicitante		= cd_unimed_solicitante_w;
		end if;
	end if;
 
	insert	into ptu_confirmacao(nr_sequencia, cd_transacao, ie_tipo_cliente, 
		cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao, 
		dt_atualizacao, nm_usuario, nr_seq_origem, 
		nr_seq_requisicao, nr_seq_guia, 
		nm_usuario_nrec, dt_atualizacao_nrec, nr_versao, 
		ie_tipo_identificador, ie_tipo_resposta) 
	values (nextval('ptu_confirmacao_seq'), cd_transacao_p, ie_tipo_cliente_w, 
		cd_unimed_executora_p, cd_unimed_beneficiario_p, nr_seq_execucao_p, 
		clock_timestamp(), nm_usuario_p, nr_seq_origem_p, 
		nr_seq_requisicao_w, nr_seq_guia_w, 
		nm_usuario_p, clock_timestamp(), nr_versao_p, 
		ie_identificador_p, ie_tipo_resposta_w) returning nr_sequencia into nr_seq_confirmacao_w;
 
	if (ie_tipo_resposta_w	in ('PI','C','DP')) then 
		if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then 
			CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Recebida e processada a confirmação de recebimento da Unimed '||cd_unimed_beneficiario_p,null,nm_usuario_p);
			-- Se for uma requisição recebida por webService(TISS) então a guia gerada deve ser atualizada conforme a requisição 
			CALL ptu_atualizar_guia_proc_ws(nr_seq_requisicao_w, nm_usuario_p);
		elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
			CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Recebida e processada a confirmação de recebimento da Unimed '||cd_unimed_beneficiario_p,'',nm_usuario_p);
		end if;
	elsif (ie_tipo_resposta_w	= 'RA') then 
		if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then 
			CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Recebida e processada a confirmação de recebimento da Unimed '||cd_unimed_executora_p,null,nm_usuario_p);
			-- Se for uma requisição recebida por webService(TISS) então a guia gerada deve ser atualizada conforme a requisição 
			CALL ptu_atualizar_guia_proc_ws(nr_seq_requisicao_w, nm_usuario_p);
		elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
			CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Recebida e processada a confirmação de recebimento da Unimed '||cd_unimed_executora_p,'',nm_usuario_p);
		end if;
	end if;
 
	commit;
--end if; 
 
nr_seq_confirmacao_p	:= nr_seq_confirmacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_confirmacao_v60 ( ie_tipo_cliente_p ptu_confirmacao.ie_tipo_cliente%type, cd_unimed_executora_p ptu_confirmacao.cd_unimed_executora%type, cd_unimed_beneficiario_p ptu_confirmacao.cd_unimed_beneficiario%type, nr_seq_execucao_p ptu_confirmacao.nr_seq_execucao%type, nr_seq_origem_p ptu_confirmacao.nr_seq_origem%type, ie_identificador_p ptu_confirmacao.ie_tipo_identificador%type, cd_transacao_p ptu_confirmacao.cd_transacao%type, nr_versao_p ptu_confirmacao.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_confirmacao_p INOUT ptu_confirmacao.nr_sequencia%type, ie_possui_registro_p INOUT text) FROM PUBLIC;

