-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_pedido_autoriz_v40 ( nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, nr_versao_ptu_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Gerar a transação de pedido de autorização do PTU, via SCS 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
dt_execucao_w				timestamp;
cd_carteirinha_w			varchar(20);
nr_seq_prestador_w			bigint;
cd_especialidade_w			integer;
cd_doenca_w				varchar(4);
cd_cooperativa_w			varchar(10);
cd_cooperativa_ww			varchar(10);
nr_seq_segurado_w			bigint;
nr_via_cartao_w				smallint;
nr_ident_exec_w				bigint;
cd_procedimento_w			bigint;
ie_origem_proced_w			smallint;
qt_procedimento_w			double precision;
qt_proc_solicitada_w			double precision;
qt_proc_autorizada_w			double precision;
nr_seq_material_w			bigint;
qt_material_w				double precision;
qt_mat_solicitada_w			double precision;
qt_mat_autorizada_w			double precision;
nr_seq_pedido_novo_w			bigint;
cd_pessoa_fisica_w			varchar(20);
qt_registros_w				smallint;
cd_usuario_plano_w			varchar(13);
ds_indic_clicnica_w			varchar(4000);
ds_observacao_w				varchar(4000);
ie_tipo_processo_w			varchar(2);
ie_tipo_cliente_w			varchar(2);
nr_seq_prest_alto_custo_w		bigint;
cd_uni_prest_alto_custo_w		smallint;
ie_alto_custo_w				varchar(2);
ie_classificacao_w			smallint;
ie_tipo_tabela_w			varchar(2);
ds_servico_w				varchar(80);
ds_servico_regra_w			varchar(80);
ie_tipo_despesa_w			smallint;
ie_carater_intern_w			varchar(2);
ie_carater_atend_w			varchar(2);
ie_urg_emerg_w				varchar(2);
vl_procedimento_w			double precision;
vl_material_w				double precision;
nm_prest_alto_custo_w			varchar(25);
cd_material_w				varchar(8);
cd_servico_w				integer;
nr_seq_pacote_w				bigint;
vl_servico_w				varchar(14);
nr_seq_controle_exec_w			bigint;
ie_tipo_pacote_w			varchar(2);
cd_proc_pacote_w			bigint;
ie_origem_proced_pcte_w			bigint;
ds_proc_pacote_w			varchar(100);
cd_unimed_w				varchar(4);
cd_procedimento_ww			bigint;
ie_origem_proced_ww			smallint;
nr_seq_regra_w				bigint;
nr_seq_congenere_w			bigint;
nr_seq_prestador_exec_w			bigint;
nr_seq_pedido_aut_serv_w		bigint;
nr_seq_req_guia_proc_w			bigint;
nr_seq_req_guia_mat_w			bigint;
cd_espec_ptu_w				smallint;
ie_permite_pacote_w			varchar(2);
ie_tipo_segurado_w			varchar(2);
nr_via_solicitacao_w			bigint;
vl_total_w				double precision	:= 0;
cd_procedimento_ptu_w			bigint;
ds_procedimento_ptu_w			varchar(80);
cd_material_ptu_w			varchar(255);
ds_material_ptu_w			varchar(80);
ie_tipo_envio_via_w			bigint;
qt_reg_generico_w			bigint;
cd_cgc_outorgante_w			varchar(14);
nr_seq_guia_princ_w			bigint;

ie_tipo_repasse_w			pls_segurado.ie_tipo_repasse%type;

c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced, 
		qt_solicitada, 
		qt_autorizada, 
		vl_procedimento, 
		nr_seq_pacote, 
		cd_procedimento_ptu, 
		ds_procedimento_ptu 
	from	pls_guia_plano_proc 
	where	nr_seq_guia		= nr_seq_guia_p 
	and	ie_status		= 'I' 
	
union
 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced, 
		qt_solicitado, 
		qt_procedimento, 
		vl_procedimento, 
		nr_seq_pacote, 
		cd_procedimento_ptu, 
		ds_procedimento_ptu 
	from	pls_requisicao_proc 
	where	nr_seq_requisicao	= nr_seq_requisicao_p 
	and	ie_status		= 'I';

c02 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_material, 
		qt_solicitada, 
		qt_autorizada, 
		vl_material, 
		cd_material_ptu, 
		ds_material_ptu 
	from	pls_guia_plano_mat 
	where	nr_seq_guia		= nr_seq_guia_p 
	and	ie_status		= 'I' 
	
union
 
	SELECT	nr_sequencia, 
		nr_seq_material, 
		qt_solicitado, 
		qt_material, 
		vl_material, 
		cd_material_ptu, 
		ds_material_ptu 
	from	pls_requisicao_mat 
	where	nr_seq_requisicao	= nr_seq_requisicao_p 
	and	ie_status		= 'I';

C03 CURSOR FOR 
	SELECT	a.cd_procedimento, 
		a.ie_origem_proced 
	from	pls_pacote		b, 
		pls_pacote_procedimento	a 
	where	a.nr_seq_pacote = b.nr_sequencia 
	and	a.nr_seq_pacote	= nr_seq_pacote_w;


BEGIN 
select	max(cd_cgc_outorgante) 
into STRICT	cd_cgc_outorgante_w 
from	pls_outorgante;
 
select	max(cd_cooperativa) 
into STRICT	cd_cooperativa_w 
from	pls_congenere 
where	cd_cgc			= cd_cgc_outorgante_w 
and	(cd_cooperativa IS NOT NULL AND cd_cooperativa::text <> '');
 
if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
	select	count(1) 
	into STRICT	qt_registros_w 
	from	ptu_pedido_autorizacao 
	where	nr_seq_requisicao	= nr_seq_requisicao_p;
 
	if (qt_registros_w	<> 0) then 
		goto final;
	end if;
 
	select	dt_requisicao, 
		pls_obter_dados_segurado(nr_seq_segurado, 'C'), 
		nr_seq_segurado, 
		nr_seq_prestador, 
		nr_seq_prestador_exec, 
		ie_tipo_processo, 
		substr(ds_indicacao_clinica,1,999), 
		ie_carater_atendimento, 
		substr(ds_observacao,1,999), 
		cd_especialidade 
	into STRICT	dt_execucao_w, 
		cd_carteirinha_w, 
		nr_seq_segurado_w, 
		nr_seq_prestador_w, 
		nr_seq_prestador_exec_w, 
		ie_tipo_processo_w, 
		ds_indic_clicnica_w, 
		ie_carater_atend_w, 
		ds_observacao_w, 
		cd_especialidade_w 
	from	pls_requisicao 
	where	nr_sequencia		= nr_seq_requisicao_p;
 
	select	max(cd_doenca) 
	into STRICT	cd_doenca_w 
	from	pls_requisicao_diagnostico 
	where	nr_seq_requisicao	= nr_seq_requisicao_p;
 
	begin 
		select	ie_tipo_segurado, 
			ie_tipo_repasse 
		into STRICT	ie_tipo_segurado_w, 
			ie_tipo_repasse_w 
		from	pls_segurado 
		where	nr_sequencia	= nr_seq_segurado_w;
	exception 
	when others then 
		ie_tipo_segurado_w	:= 'X';
		ie_tipo_repasse_w	:= 'X';
	end;
	 
	if (coalesce(ie_tipo_segurado_w,'X')	= 'T') then 
		begin 
			select	coalesce(nr_cartao_intercambio,cd_usuario_plano) 
			into STRICT	cd_carteirinha_w 
			from	pls_segurado_carteira 
			where	nr_seq_segurado	= nr_seq_segurado_w;
		exception 
		when others then 
			cd_carteirinha_w	:= 'X';
		end;
		 
		if (coalesce(cd_carteirinha_w,'X')	= 'X') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(191728);
		end if;
	elsif (coalesce(ie_tipo_segurado_w,'X') in ('T','C') and ie_tipo_repasse_w = 'P') then 
		begin 
			select	nr_cartao_intercambio 
			into STRICT	cd_carteirinha_w 
			from	pls_segurado_carteira 
			where	nr_seq_segurado	= nr_seq_segurado_w;
		exception 
		when others then 
			cd_carteirinha_w	:= 'X';
		end;
		 
		if (coalesce(cd_carteirinha_w,'X')	= 'X') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(191728);
		end if;
	end if;
	 
	if (ie_carater_atend_w	= 'U') then 
		ie_urg_emerg_w	:= 'S';
	else 
		ie_urg_emerg_w	:= 'N';
	end if;
	 
	begin 
		select	cd_ptu 
		into STRICT	cd_espec_ptu_w 
		from	especialidade_medica 
		where	cd_especialidade	= cd_especialidade_w;
	exception 
	when others then 
		cd_espec_ptu_w	:= cd_especialidade_w;
	end;
	 
	cd_cooperativa_ww	:= adiciona_zeros_esquerda(pls_obter_unimed_benef(nr_seq_segurado_w),4);
	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L','Enviado pedido de autorização para a Unimed '||cd_cooperativa_ww,null,nm_usuario_p);
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
	select	count(1) 
	into STRICT	qt_registros_w 
	from	ptu_pedido_autorizacao 
	where	nr_seq_guia	= nr_seq_guia_p;
 
	if (qt_registros_w	<> 0) then 
		goto final;
	end if;
	 
	select	dt_solicitacao, 
		pls_obter_dados_segurado(nr_seq_segurado, 'C'), 
		nr_seq_segurado, 
		nr_seq_prestador, 
		ie_tipo_processo, 
		substr(ds_indicacao_clinica,1,999), 
		ie_carater_internacao, 
		substr(ds_observacao,1,999), 
		cd_especialidade, 
		nr_seq_guia_principal 
	into STRICT	dt_execucao_w, 
		cd_carteirinha_w, 
		nr_seq_segurado_w, 
		nr_seq_prestador_w, 
		ie_tipo_processo_w, 
		ds_indic_clicnica_w, 
		ie_carater_atend_w, 
		ds_observacao_w, 
		cd_especialidade_w, 
		nr_seq_guia_princ_w 
	from	pls_guia_plano 
	where	nr_sequencia	= nr_seq_guia_p;
 
	 
	if (coalesce(nr_seq_guia_princ_w,0)	> 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(253366);
	end if;
	 
	select	max(cd_doenca) 
	into STRICT	cd_doenca_w 
	from	pls_diagnostico 
	where	ie_classificacao	= 'P' 
	and	nr_seq_guia		= nr_seq_guia_p;
 
	begin 
		select	ie_tipo_segurado 
		into STRICT	ie_tipo_segurado_w 
		from	pls_segurado 
		where	nr_sequencia	= nr_seq_segurado_w;
	exception 
	when others then 
		ie_tipo_segurado_w	:= null;
	end;
	if (ie_tipo_segurado_w IS NOT NULL AND ie_tipo_segurado_w::text <> '') then 
		begin 
			select	coalesce(nr_cartao_intercambio,cd_usuario_plano) 
			into STRICT	cd_carteirinha_w 
			from	pls_segurado_carteira 
			where	nr_seq_segurado	= nr_seq_segurado_w;
		exception 
		when others then 
			cd_carteirinha_w	:= null;
		end;
		 
		if (coalesce(cd_carteirinha_w::text, '') = '') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(191728);
		end if;
	end if;
 
	if (ie_carater_atend_w	= 'U') then 
		ie_urg_emerg_w	:= 'S';
	else 
		ie_urg_emerg_w	:= 'N';
	end if;
 
	begin 
		select	cd_ptu 
		into STRICT	cd_espec_ptu_w 
		from	especialidade_medica 
		where	cd_especialidade	= cd_especialidade_w;
	exception 
	when others then 
		cd_espec_ptu_w	:= cd_especialidade_w;
	end;
 
	if ((pls_obter_unimed_benef(nr_seq_segurado_w) IS NOT NULL AND (pls_obter_unimed_benef(nr_seq_segurado_w))::text <> '')) then	 
		cd_cooperativa_ww	:= adiciona_zeros_esquerda(pls_obter_unimed_benef(nr_seq_segurado_w),4);
		CALL pls_guia_gravar_historico(nr_seq_guia_p,2,'Enviado pedido de autorização para a Unimed '||cd_cooperativa_ww,'',nm_usuario_p);
	else 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(246588);
	end if;
end if;
 
if (length(cd_carteirinha_w) >= 17) then 
	select	nr_seq_congenere 
	into STRICT	nr_seq_congenere_w 
	from	pls_segurado 
	where	nr_sequencia	= nr_seq_segurado_w;
	 
	if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then 
		cd_unimed_w		:= adiciona_zeros_esquerda(pls_obter_unimed_benef(nr_seq_segurado_w),4);
		cd_usuario_plano_w	:= substr(cd_carteirinha_w,5,17);
	else 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(131177);
	end if;
else 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(179717);
end if;
 
select	max(coalesce(nr_via_solicitacao,1)) 
into STRICT	nr_via_cartao_w 
from	pls_segurado_carteira 
where	nr_seq_segurado	= nr_seq_segurado_w;
 
select	nextval('ptu_pedido_autorizacao_seq') 
into STRICT	nr_seq_pedido_novo_w
;
 
select	nextval('ptu_controle_execucao_seq') 
into STRICT	nr_seq_controle_exec_w
;
 
begin 
	select	CASE WHEN coalesce(ie_tipo_rede_min_ptu,3)=3 THEN 1 WHEN coalesce(ie_tipo_rede_min_ptu,3)=1 THEN 3  ELSE 2 END  
	into STRICT	ie_alto_custo_w 
	from	pls_prestador 
	where	nr_sequencia	= nr_seq_prestador_exec_w;
exception 
when others then 
	ie_alto_custo_w	:= '3';
end;
 
if (ie_alto_custo_w	in ('1','2')) then 
	begin 
		select	(coalesce(cd_prestador,nr_sequencia))::numeric  
		into STRICT	nr_seq_prest_alto_custo_w 
		from	pls_prestador 
		where	nr_sequencia	= nr_seq_prestador_exec_w;
	exception 
	when others then 
		nr_seq_prest_alto_custo_w	:= 0;
	end;
 
	cd_uni_prest_alto_custo_w	:= cd_cooperativa_w;
	nm_prest_alto_custo_w		:= substr(pls_obter_dados_prestador(nr_seq_prestador_exec_w,'N'),1,25);
else 
	nr_seq_prest_alto_custo_w	:= 0;
	cd_uni_prest_alto_custo_w	:= 0;
end if;
 
begin 
	select	ie_permite_pacote 
	into STRICT	ie_permite_pacote_w 
	from	pls_param_intercambio_scs;
exception 
when others then 
	ie_permite_pacote_w	:= 'N';
end;
 
select	max(ie_tipo_envio_via) 
into STRICT	ie_tipo_envio_via_w 
from	pls_regra_limite_envio_scs 
where (coalesce(nr_seq_congenere::text, '') = '' 
or	nr_seq_congenere	= nr_seq_congenere_w);
 
if (ie_tipo_envio_via_w	= 2) then 
	nr_via_cartao_w	:= 0;
end if;
 
insert	into ptu_pedido_autorizacao(nr_sequencia, dt_atendimento, ie_tipo_cliente, 
	 cd_doenca_cid, ie_alto_custo, cd_unimed_prestador_req, 
	 nr_seq_prestador_req, cd_especialidade, ie_urg_emerg, 
	 cd_unimed_executora, cd_unimed_beneficiario, cd_unimed, 
	 nr_via_cartao, nr_seq_execucao, nm_usuario, 
	 dt_atualizacao, cd_usuario_plano, nr_seq_guia, 
	 cd_transacao, nr_seq_requisicao, ds_ind_clinica, 
	 ds_observacao, nr_seq_prest_alto_custo, cd_unimed_prestador, 
	 nm_prestador_alto_custo, nr_versao, nm_usuario_nrec, 
	 dt_atualizacao_nrec) 
values (nr_seq_pedido_novo_w, dt_execucao_w, 'U', 
	 cd_doenca_w, coalesce(ie_alto_custo_w,'3'), CASE WHEN coalesce(nr_seq_prestador_w::text, '') = '' THEN null  ELSE cd_cooperativa_w END , 
	 nr_seq_prestador_w, cd_espec_ptu_w, ie_urg_emerg_w, 
	 cd_cooperativa_w, cd_cooperativa_ww, cd_unimed_w, 
	 nr_via_cartao_w, nr_seq_controle_exec_w, nm_usuario_p, 
	 clock_timestamp(), cd_usuario_plano_w, nr_seq_guia_p, 
	 '00600', nr_seq_requisicao_p, ds_indic_clicnica_w, 
	 ds_observacao_w, nr_seq_prest_alto_custo_w, cd_uni_prest_alto_custo_w, 
	 nm_prest_alto_custo_w, nr_versao_ptu_p, nm_usuario_p, 
	 clock_timestamp());
 
insert	into ptu_controle_execucao(nr_sequencia, dt_atualizacao, nm_usuario, 
	 nr_seq_pedido_compl, nr_seq_pedido_aut, nm_usuario_nrec, 
	 dt_atualizacao_nrec) 
values (nr_seq_controle_exec_w, clock_timestamp(), nm_usuario_p, 
	 null, nr_seq_pedido_novo_w, nm_usuario_p, 
	 clock_timestamp());
 
open c01;
loop 
fetch c01 into 
	nr_seq_req_guia_proc_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	qt_proc_solicitada_w, 
	qt_proc_autorizada_w, 
	vl_procedimento_w, 
	nr_seq_pacote_w, 
	cd_procedimento_ptu_w, 
	ds_procedimento_ptu_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	vl_total_w	:= 0;
 
	select	max(ie_classificacao) 
	into STRICT	ie_classificacao_w 
	from	procedimento 
	where	cd_procedimento		= cd_procedimento_w 
	and	ie_origem_proced	= ie_origem_proced_w;
 
	if (ie_classificacao_w	= 1) then 
		ie_tipo_tabela_w	:= '0';
	elsif (ie_classificacao_w	= 2) then 
		ie_tipo_tabela_w	:= '1';
	elsif (ie_classificacao_w	= 3) then 
		ie_tipo_tabela_w	:= '1';
	else 
		ie_tipo_tabela_w	:= '0';
	end if;
 
	if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') and (coalesce(ie_permite_pacote_w,'N')	= 'S') then 
		ie_tipo_pacote_w	:= ptu_obter_modo_envio_pacote(cd_cooperativa_w, cd_cooperativa_ww, nm_usuario_p);
		 
		if (ie_tipo_pacote_w	= 'A') then 
			open C03;
			loop 
			fetch C03 into 
				cd_proc_pacote_w, 
				ie_origem_proced_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin 
 
				ds_proc_pacote_w	:= substr(obter_descricao_procedimento(cd_proc_pacote_w,ie_origem_proced_pcte_w),1,100);
 
				update	ptu_pedido_autorizacao 
				set	ds_observacao	= ds_observacao||cd_proc_pacote_w||' - '||ds_proc_pacote_w||',' 
				where	nr_sequencia	= nr_seq_pedido_novo_w;
 
				end;
			end loop;
			close C03;
		end if;
 
		ie_tipo_tabela_w	:= '4';
	end if;
 
	select	nextval('ptu_pedido_aut_servico_seq') 
	into STRICT	nr_seq_pedido_aut_serv_w 
	;
	 
	if (qt_proc_autorizada_w IS NOT NULL AND qt_proc_autorizada_w::text <> '') and (qt_proc_autorizada_w > 0) then 
		qt_procedimento_w	:= qt_proc_autorizada_w;
	else 
		qt_procedimento_w	:= qt_proc_solicitada_w;
	end if;
	 
	if (coalesce(vl_procedimento_w, 0) > 0) then 
	--	(nr_seq_pacote_w is null) then 
		vl_total_w	:= vl_procedimento_w * qt_procedimento_w;
	--elsif	(nvl(vl_procedimento_w,0)	> 0) and (nr_seq_pacote_w	is not null) then 
	--	vl_total_w	:= vl_procedimento_w; 
	end if;
	 
	if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
		insert	into ptu_pedido_aut_servico(nr_sequencia,cd_servico, ds_opme, 
			 ie_tipo_tabela, nm_usuario, nr_seq_pedido, 
			 dt_atualizacao, qt_servico, vl_servico, 
			 ie_origem_servico, cd_servico_consersao, nr_seq_req_proc, 
			 nm_usuario_nrec, dt_atualizacao_nrec) 
		values (nr_seq_pedido_aut_serv_w, cd_procedimento_w, ds_procedimento_ptu_w, 
			 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_novo_w, 
			 clock_timestamp(), qt_procedimento_w, vl_total_w, 
			 ie_origem_proced_w, cd_procedimento_ptu_w, nr_seq_req_guia_proc_w, 
			 nm_usuario_p, clock_timestamp());
 
	elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
		insert	into ptu_pedido_aut_servico(nr_sequencia,cd_servico, ds_opme, 
			 ie_tipo_tabela, nm_usuario, nr_seq_pedido, 
			 dt_atualizacao, qt_servico, vl_servico, 
			 ie_origem_servico, cd_servico_consersao, nr_seq_guia_proc, 
			 nm_usuario_nrec, dt_atualizacao_nrec) 
		values (nr_seq_pedido_aut_serv_w, cd_procedimento_w, ds_procedimento_ptu_w, 
			 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_novo_w, 
			 clock_timestamp(), qt_procedimento_w, vl_total_w, 
			 ie_origem_proced_w, cd_procedimento_ptu_w, nr_seq_req_guia_proc_w, 
			 nm_usuario_p, clock_timestamp());
	end if;
	 
	if (coalesce(cd_procedimento_ptu_w,0)	<> 0) then 
		if (coalesce(vl_procedimento_w,0)	= 0) and (coalesce(ds_procedimento_ptu_w,'X')	<> 'X') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(196741);
		end if;
		 
		select	count(1) 
		into STRICT	qt_reg_generico_w 
		from	pls_regra_generico_ptu 
		where	cd_proc_mat_generico	= cd_procedimento_ptu_w;
		 
		if (qt_reg_generico_w	> 0) and (coalesce(ds_procedimento_ptu_w,'X')	= 'X') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(216706);
		end if;
	end if;
	end;
end loop;
close c01;
 
open c02;
loop 
fetch c02 into 
	nr_seq_req_guia_mat_w, 
	nr_seq_material_w, 
	qt_mat_solicitada_w, 
	qt_mat_autorizada_w, 
	vl_material_w, 
	cd_material_ptu_w, 
	ds_material_ptu_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin 
	vl_total_w	:= 0;
 
	select	ie_tipo_despesa 
	into STRICT	ie_tipo_despesa_w 
	from	pls_material 
	where	nr_sequencia	= nr_seq_material_w;
 
	cd_material_w	:= substr(pls_obter_seq_codigo_material(nr_seq_material_w,''),1,8);
 
	if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then 
		cd_servico_w		:= cd_material_w;
		 
		if (ie_tipo_despesa_w	= 2) then 
			ie_tipo_tabela_w	:= '3';
		elsif (ie_tipo_despesa_w	= 3) then 
			ie_tipo_tabela_w	:= '2';
		else 
			ie_tipo_tabela_w	:= '2';
		end if;
 
		select	nextval('ptu_pedido_aut_servico_seq') 
		into STRICT	nr_seq_pedido_aut_serv_w 
		;
		 
		if (qt_mat_autorizada_w IS NOT NULL AND qt_mat_autorizada_w::text <> '') and (qt_mat_autorizada_w > 0) then 
			qt_material_w	:= qt_mat_autorizada_w;
		else 
			qt_material_w	:= qt_mat_solicitada_w;
		end if;
		 
		if (coalesce(vl_material_w,0)	> 0) then 
			vl_total_w	:= vl_material_w * qt_material_w;
		end if;
 
		if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
			insert	into ptu_pedido_aut_servico(nr_sequencia, cd_servico, ds_opme, 
				 ie_tipo_tabela, nm_usuario, nr_seq_pedido, 
				 dt_atualizacao, qt_servico, vl_servico, 
				 cd_servico_consersao, nr_seq_req_mat, nm_usuario_nrec, 
				 dt_atualizacao_nrec) 
			values (nr_seq_pedido_aut_serv_w, cd_servico_w, ds_material_ptu_w, 
				 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_novo_w, 
				 clock_timestamp(), qt_material_w, vl_total_w, 
				 cd_material_ptu_w, nr_seq_req_guia_mat_w, nm_usuario_p, 
				 clock_timestamp());
		elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
			insert	into ptu_pedido_aut_servico(nr_sequencia, cd_servico, ds_opme, 
				 ie_tipo_tabela, nm_usuario, nr_seq_pedido, 
				 dt_atualizacao, qt_servico, vl_servico, 
				 cd_servico_consersao, nr_seq_guia_mat, nm_usuario_nrec, 
				 dt_atualizacao_nrec) 
			values (nr_seq_pedido_aut_serv_w, cd_servico_w, ds_material_ptu_w, 
				 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_novo_w, 
				 clock_timestamp(), qt_material_w, vl_total_w, 
				 cd_material_ptu_w, nr_seq_req_guia_mat_w, nm_usuario_p, 
				 clock_timestamp());
		end if;
 
		if (coalesce(cd_material_ptu_w,0)	<> 0) then 
			if (coalesce(vl_material_w,0)	= 0) and (coalesce(ds_material_ptu_w,'X')	<> 'X') then 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(196741);
			end if;
			 
			select	count(1) 
			into STRICT	qt_reg_generico_w 
			from	pls_regra_generico_ptu 
			where	cd_proc_mat_generico	= cd_material_ptu_w;
			 
			if (qt_reg_generico_w	> 0) and (coalesce(ds_material_ptu_w,'X')	= 'X') then 
				CALL wheb_mensagem_pck.exibir_mensagem_abort(216706);
			end if;
		end if;
	end if;
	end;
end loop;
close c02;
 
<<final>> 
qt_registros_w	:= 0;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_pedido_autoriz_v40 ( nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, nr_versao_ptu_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
