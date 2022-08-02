-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_pedido_autorizacao ( nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_execucao_w				timestamp;
cd_carteirinha_w			varchar(20);
nr_seq_prestador_w			bigint;
cd_especialidade_w			integer;
cd_doenca_w				varchar(4);
cd_cooperativa_w			varchar(10);
cd_cooperativa_ww			varchar(10);
nr_seq_segurado_w			bigint;
nr_via_cartao_w				smallint;
cd_procedimento_w			bigint;
ie_origem_proced_w			smallint;
qt_procedimento_w			pls_guia_plano_proc.qt_solicitada%type;
nr_seq_material_w			bigint;
qt_material_w				pls_guia_plano_mat.qt_solicitada%type;
nr_seq_pedido_novo_w			bigint;
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
cd_serv_conversao_w			bigint;
nr_seq_prestador_exec_w			bigint;
nr_seq_pedido_aut_serv_w		bigint;
nr_seq_req_guia_proc_w			bigint;
nr_seq_req_guia_mat_w			bigint;
cd_espec_ptu_w				smallint;
ie_permite_pacote_w			varchar(2);
ie_tipo_segurado_w			varchar(2);
ie_somente_codigo_w			pls_conversao_proc.ie_somente_codigo%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		qt_solicitada,
		vl_procedimento,
		nr_seq_pacote
	from	pls_guia_plano_proc
	where	nr_seq_guia		= nr_seq_guia_p
	
union

	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		qt_solicitado,
		vl_procedimento,
		nr_seq_pacote
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	ie_status		= 'I';

c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_material,
		qt_solicitada,
		vl_material
	from	pls_guia_plano_mat
	where	nr_seq_guia		= nr_seq_guia_p
	
union

	SELECT	nr_sequencia,
		nr_seq_material,
		qt_solicitado,
		vl_material
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
cd_cooperativa_w	:= pls_obter_unimed_estab(cd_estabelecimento_p);

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
		substr(replace(replace(ds_indicacao_clinica,chr(13),''),chr(10),''),1,4000),
		ie_carater_atendimento,
		substr(replace(replace(ds_observacao,chr(13),''),chr(10),''),1,4000),
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
	--and	ie_classificacao	= 'P';
	begin
		select	ie_tipo_segurado
		into STRICT	ie_tipo_segurado_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	exception
	when others then
		ie_tipo_segurado_w	:= 'X';
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
	CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L','Enviado pedido de autorizacao para a Unimed '||cd_cooperativa_ww,null,nm_usuario_p);
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select	count(1)
	into STRICT	qt_registros_w
	from	ptu_pedido_autorizacao
	where	nr_seq_guia	= nr_seq_guia_p;

	if (qt_registros_w	<> 0) then
		goto final;
	end if;

	select	dt_solicitacao,
		nr_seq_prestador,
		nr_seq_segurado,
		pls_obter_dados_segurado(nr_seq_segurado, 'C'),
		ds_indicacao_clinica,
		ds_observacao,
		ie_tipo_processo,
		ie_carater_internacao
	into STRICT	dt_execucao_w,
		nr_seq_prestador_w,
		nr_seq_segurado_w,
		cd_carteirinha_w,
		ds_indic_clicnica_w,
		ds_observacao_w,
		ie_tipo_processo_w,
		ie_carater_intern_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;

	select	max(cd_doenca)
	into STRICT	cd_doenca_w
	from	pls_diagnostico
	where	ie_classificacao	= 'P'
	and	nr_seq_guia		= nr_seq_guia_p;

	if (ie_carater_intern_w	= 'U') then
		ie_urg_emerg_w	:= 'S';
	else
		ie_urg_emerg_w	:= 'N';
	end if;
	
	cd_cooperativa_ww	:= adiciona_zeros_esquerda(pls_obter_unimed_benef(nr_seq_segurado_w),4);
	CALL pls_guia_gravar_historico(nr_seq_guia_p,2,'Enviado pedido de autorizacao para a Unimed '||cd_cooperativa_ww,null,nm_usuario_p);
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

if (ie_tipo_processo_w	= 'I') then
	ie_tipo_cliente_w	:= 'U';
elsif (ie_tipo_processo_w	in ('P', 'W')) then
	ie_tipo_cliente_w	:= 'P';
end if;

begin
	select	ie_prestador_alto_custo
	into STRICT	ie_alto_custo_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_exec_w;
exception
when others then
	ie_alto_custo_w	:= 'N';
end;

if (ie_alto_custo_w	= 'S') then
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

insert	into ptu_pedido_autorizacao(nr_sequencia, dt_atendimento, ie_tipo_cliente,
	 cd_doenca_cid, ie_alto_custo, cd_unimed_prestador_req,
	 nr_seq_prestador_req, cd_especialidade, ie_urg_emerg,
	 cd_unimed_executora, cd_unimed_beneficiario, cd_unimed,
	 nr_via_cartao, nr_seq_execucao, nm_usuario,
	 dt_atualizacao, cd_usuario_plano, nr_seq_guia,
	 cd_transacao, nr_seq_requisicao, ds_ind_clinica,
	 ds_observacao, nr_seq_prest_alto_custo, cd_unimed_prestador,
	 nm_prestador_alto_custo)
values (nr_seq_pedido_novo_w, dt_execucao_w, ie_tipo_cliente_w,
	 cd_doenca_w, coalesce(ie_alto_custo_w,'N'), cd_cooperativa_w,
	 nr_seq_prestador_w, cd_espec_ptu_w, ie_urg_emerg_w,
	 cd_cooperativa_w, cd_cooperativa_ww, cd_unimed_w,
	 00, nr_seq_controle_exec_w, nm_usuario_p,
	 clock_timestamp(), cd_usuario_plano_w, nr_seq_guia_p,
	 '00500', nr_seq_requisicao_p, ds_indic_clicnica_w,
	 ds_observacao_w, nr_seq_prest_alto_custo_w, cd_uni_prest_alto_custo_w,
	 nm_prest_alto_custo_w);

insert	into ptu_controle_execucao(nr_sequencia, dt_atualizacao, nm_usuario,
	 nr_seq_pedido_compl, nr_seq_pedido_aut)
values (nr_seq_controle_exec_w, clock_timestamp(), nm_usuario_p,
	 null, nr_seq_pedido_novo_w);

open c01;
loop
fetch c01 into
	nr_seq_req_guia_proc_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	qt_procedimento_w,
	vl_procedimento_w,
	nr_seq_pacote_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

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
		cd_serv_conversao_w	:= null;
		
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
	else
		if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
			SELECT * FROM pls_obter_proced_conversao(	cd_procedimento_w, ie_origem_proced_w, nr_seq_prestador_w, cd_estabelecimento_p, 3, nr_seq_congenere_w, 1, 'E', null, null, null, null, null, cd_procedimento_ww, ie_origem_proced_ww, nr_seq_regra_w, ie_somente_codigo_w, clock_timestamp(), null, null, null) INTO STRICT cd_procedimento_ww, ie_origem_proced_ww, nr_seq_regra_w, ie_somente_codigo_w;

			if (cd_procedimento_w	= cd_procedimento_ww) then
				cd_procedimento_ww	:= null;
				ie_origem_proced_ww	:= null;
				cd_serv_conversao_w	:= null;
			else
				cd_serv_conversao_w	:= cd_procedimento_ww;
			end if;
		end if;
	end if;

	select	replace(to_char(campo_mascara_virgula(vl_procedimento_w)), ',', '')
	into STRICT	vl_servico_w
	;

	select	replace(to_char(vl_servico_w), '.', '')
	into STRICT	vl_servico_w
	;

	select	nextval('ptu_pedido_aut_servico_seq')
	into STRICT	nr_seq_pedido_aut_serv_w
	;
	
	insert	into ptu_pedido_aut_servico(nr_sequencia,cd_servico, ds_opme,
		 ie_tipo_tabela, nm_usuario, nr_seq_pedido,
		 dt_atualizacao, qt_servico, vl_servico,
		 ie_origem_servico, cd_servico_consersao)
	values (nr_seq_pedido_aut_serv_w, cd_procedimento_w, '',
		 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_novo_w,
		 clock_timestamp(), qt_procedimento_w, (vl_servico_w)::numeric ,
		 ie_origem_proced_w, cd_serv_conversao_w);
	commit;
	if (coalesce(cd_serv_conversao_w,0)	<> 0) then
		--ds_servico_w		:= pls_obter_regra_desc_item_scs(cd_serv_conversao_w,cd_procedimento_w,'P',nr_seq_requisicao_p,null,nr_seq_req_guia_proc_w);
		
		update	ptu_pedido_aut_servico
		set	ds_opme			= ds_servico_w
		where	nr_sequencia		= nr_seq_pedido_aut_serv_w;
	end if;
	end;
end loop;
close c01;

open c02;
loop
fetch c02 into
	nr_seq_req_guia_mat_w,
	nr_seq_material_w,
	qt_material_w,
	vl_material_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin

	select	ie_tipo_despesa
	into STRICT	ie_tipo_despesa_w
	from	pls_material
	where	nr_sequencia	= nr_seq_material_w;

	cd_material_w	:= substr(pls_obter_seq_codigo_material(nr_seq_material_w,''),1,8);

	if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
		cd_servico_w		:= cd_material_w;
		cd_serv_conversao_w	:= null;
		
		if (ie_tipo_despesa_w	= 2) then
			ie_tipo_tabela_w	:= '3';
		elsif (ie_tipo_despesa_w	in (1,3,7)) then
			ie_tipo_tabela_w	:= '2';
		end if;
		
		SELECT * FROM ptu_gerar_mat_envio_intercamb(cd_material_w, 'E', ie_tipo_tabela_w, ie_tipo_despesa_w, nm_usuario_p, cd_serv_conversao_w, ds_servico_w) INTO STRICT cd_serv_conversao_w, ds_servico_w;

		select	replace(to_char(campo_mascara_virgula(vl_material_w)), ',', '')
		into STRICT	vl_servico_w
		;
		
		select	replace(to_char(vl_servico_w), '.', '')
		into STRICT	vl_servico_w
		;

		select	nextval('ptu_pedido_aut_servico_seq')
		into STRICT	nr_seq_pedido_aut_serv_w
		;

		insert	into ptu_pedido_aut_servico(nr_sequencia, cd_servico, ds_opme,
			 ie_tipo_tabela, nm_usuario, nr_seq_pedido,
			 dt_atualizacao, qt_servico, vl_servico,
			 cd_servico_consersao)
		values (nr_seq_pedido_aut_serv_w, cd_servico_w, '',
			 ie_tipo_tabela_w, nm_usuario_p, nr_seq_pedido_novo_w,
			 clock_timestamp(), qt_material_w, vl_servico_w,
			 cd_serv_conversao_w);

		if (coalesce(cd_serv_conversao_w,0)	<> 0) then
			--ds_servico_w	:= pls_obter_regra_desc_item_scs(cd_serv_conversao_w,cd_servico_w,'M',nr_seq_requisicao_p,null,nr_seq_req_guia_mat_w);
			
			if (coalesce(vl_servico_w,0)	= 0) and (coalesce(ds_servico_w,'X')	<> 'X') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(196741);
			end if;
			
			update	ptu_pedido_aut_servico
			set	ds_opme			= ds_servico_w
			where	nr_sequencia		= nr_seq_pedido_aut_serv_w;
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
-- REVOKE ALL ON PROCEDURE ptu_gerar_pedido_autorizacao ( nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

