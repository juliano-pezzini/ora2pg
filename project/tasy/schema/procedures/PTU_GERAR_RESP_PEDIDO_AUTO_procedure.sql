-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_resp_pedido_auto ( nr_seq_controle_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_unimed_exec_w		smallint;
cd_unimed_benef_w		smallint;
cd_unimed_w			smallint;
cd_usuario_plano_w		varchar(30);
nr_seq_segurado_w		bigint;
nm_segurado_w			varchar(255);
ie_status_proc_w		varchar(2);
ds_procedimento_w		varchar(80);
ie_origem_proced_w		bigint;
cd_servico_w			integer;
qt_material_w			integer;
qt_proced_w			integer;
ds_material_w			varchar(80);
nr_seq_execucao_w		bigint;
ds_observacao_w			varchar(255);
ie_status_mat_w			varchar(2);
ie_estagio_proc_w		smallint;
ie_estagio_mat_w		smallint;
nr_seq_origem_w			bigint;
dt_validade_w			timestamp;
qt_registros_w			smallint;
qt_reg_w			varchar(4);
nr_seq_resp_novo_w		bigint;
ie_tipo_cliente_w		varchar(2);
nr_seq_pedido_w			bigint;
ie_tipo_tabela_w		varchar(2);
ds_servico_w			varchar(80);
nr_seq_material_w		bigint;
ie_autorizado_w			smallint;
qt_servico_w			bigint;
ie_origem_servico_w		bigint;
ie_tipo_servico_w		varchar(2);
ie_status_complemento_w		smallint;
nr_seq_pedido_compl_w		bigint;
nr_seq_pedido_aut_w		bigint;
nr_seq_guia_w			bigint;
nr_seq_requisicao_w		bigint;
ie_tipo_resposta_w		varchar(2);
nr_seq_resp_proc_w		bigint;
nr_seq_resp_mat_w		bigint;
cd_servico_consersao_w		bigint;
qt_reg_proc_aud_w		bigint;
qt_reg_mat_aud_w		bigint;
ie_estagio_w			bigint;
ds_opme_w			varchar(80);

C01 CURSOR FOR 
	SELECT	cd_servico, 
		cd_servico_consersao, 
		ie_tipo_tabela, 
		substr(ds_opme,1,80) 
	from	ptu_pedido_aut_servico 
	where	nr_seq_pedido = nr_seq_pedido_aut_w 
	
union
 
	SELECT	cd_servico, 
		cd_servico_conversao, 
		to_char(ie_tipo_tabela), 
		substr(ds_opme,1,80) 
	from	ptu_pedido_compl_aut_serv 
	where	nr_seq_pedido = nr_seq_pedido_compl_w;

c02 CURSOR FOR 
	SELECT	ie_origem_proced, 
		qt_autorizada, 
		ie_status 
	from	pls_guia_plano_proc 
	where	nr_seq_guia		= nr_seq_guia_w 
	and	cd_procedimento		= coalesce(cd_servico_consersao_w,cd_servico_w) 
	
union
 
	SELECT	ie_origem_proced, 
		qt_procedimento, 
		ie_status 
	from	pls_requisicao_proc 
	where	nr_seq_requisicao	= nr_seq_requisicao_w 
	and	cd_procedimento		= coalesce(cd_servico_consersao_w,cd_servico_w);

c03 CURSOR FOR 
	SELECT	qt_autorizada, 
		ie_status 
	from	pls_guia_plano_mat 
	where	nr_seq_guia		= nr_seq_guia_w 
	and	nr_seq_material		= pls_obter_seq_codigo_material('',cd_servico_w) 
	
union
 
	SELECT	qt_material, 
		ie_status 
	from	pls_requisicao_mat 
	where	nr_seq_requisicao	= nr_seq_requisicao_w 
	and	nr_seq_material		= pls_obter_seq_codigo_material('',cd_servico_w);
	
C04 CURSOR FOR 
	SELECT	ie_tipo_tabela, 
		coalesce(cd_servico_conversao,cd_servico), 
		qt_servico, 
		ie_origem_servico, 
		ie_tipo_servico, 
		ie_status_complemento 
	from	ptu_pedido_compl_aut_serv 
	where	nr_seq_pedido	= nr_seq_pedido_compl_w 
	and	ie_utilizado	= 'N';


BEGIN 
 
select	coalesce(nr_seq_pedido_compl,0), 
	coalesce(nr_seq_pedido_aut,0) 
into STRICT	nr_seq_pedido_compl_w, 
	nr_seq_pedido_aut_w 
from	ptu_controle_execucao 
where	nr_sequencia	= nr_seq_controle_p;
 
if (nr_seq_pedido_aut_w	<> 0) then 
	select	max(nr_seq_guia), 
		max(nr_seq_requisicao) 
	into STRICT	nr_seq_guia_w, 
		nr_seq_requisicao_w 
	from	ptu_pedido_autorizacao 
	where	nr_sequencia	= nr_seq_pedido_aut_w;
		 
	select	cd_unimed_executora, 
		cd_unimed_beneficiario, 
		cd_unimed, 
		cd_usuario_plano, 
		nr_seq_execucao, 
		ds_observacao, 
		ie_tipo_cliente 
	into STRICT	cd_unimed_exec_w, 
		cd_unimed_benef_w, 
		cd_unimed_w, 
		cd_usuario_plano_w, 
		nr_seq_execucao_w, 
		ds_observacao_w, 
		ie_tipo_cliente_w 
	from	ptu_pedido_autorizacao 
	where	nr_sequencia	= nr_seq_pedido_aut_w;
 
	if (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
		select	coalesce(dt_validade_senha,clock_timestamp()), 
			ie_estagio 
		into STRICT	dt_validade_w, 
			ie_estagio_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_w;
		 
		CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Enviada a resposta de pedido de autorização para a Unimed '||cd_unimed_exec_w,'',nm_usuario_p);
	elsif (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then 
		select	coalesce(dt_validade_senha,clock_timestamp()), 
			ie_estagio 
		into STRICT	dt_validade_w, 
			ie_estagio_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_w;
		 
		CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Enviada a resposta de pedido de autorização para a Unimed '||cd_unimed_exec_w,null,nm_usuario_p);
	end if;
	 
	ie_tipo_resposta_w	:= 'PA';
elsif (nr_seq_pedido_compl_w	<> 0) then 
	select	cd_unimed_executora, 
		cd_unimed_beneficiario, 
		cd_unimed, 
		cd_usuario_plano, 
		nr_seq_execucao, 
		ds_observacao, 
		ie_tipo_cliente, 
		nr_seq_guia, 
		nr_seq_requisicao 
	into STRICT	cd_unimed_exec_w, 
		cd_unimed_benef_w, 
		cd_unimed_w, 
		cd_usuario_plano_w, 
		nr_seq_execucao_w, 
		ds_observacao_w, 
		ie_tipo_cliente_w, 
		nr_seq_guia_w, 
		nr_seq_requisicao_w 
	from	ptu_pedido_compl_aut 
	where	nr_sequencia	= nr_seq_pedido_compl_w;
	 
	if (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
		select	coalesce(dt_validade_senha,clock_timestamp()) 
		into STRICT	dt_validade_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_w;
		 
		CALL pls_guia_gravar_historico(nr_seq_guia_w,2,'Enviada a resposta de pedido de autorização para a Unimed '||cd_unimed_exec_w,'',nm_usuario_p);
	elsif (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then 
		select	coalesce(dt_validade_senha,clock_timestamp()) 
		into STRICT	dt_validade_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_w;
		 
		CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L','Enviada a resposta de pedido de autorização para a Unimed '||cd_unimed_exec_w,null,nm_usuario_p);
	end if;
	 
	ie_tipo_resposta_w	:= 'PC';
end if;
 
qt_reg_w	:= adiciona_zeros_esquerda(cd_unimed_w, 4);
 
begin 
select	nr_seq_segurado 
into STRICT	nr_seq_segurado_w 
from  pls_segurado_carteira 
where  cd_usuario_plano    = qt_reg_w||cd_usuario_plano_w;
exception 
when others then 
	nr_seq_segurado_w	:= null;
end;
 
if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then 
	nm_segurado_w	:= substr(pls_obter_dados_segurado(nr_seq_segurado_w, 'N'),1,25);
else 
	nm_segurado_w	:= 'Beneficiario nao existe';
end if;
 
select	nextval('ptu_resposta_autorizacao_seq') 
into STRICT	nr_seq_resp_novo_w
;
 
insert	into ptu_resposta_autorizacao(nr_sequencia, cd_transacao, cd_unimed_executora, 
	 cd_unimed_beneficiario, nr_seq_execucao, nr_seq_guia, 
	 cd_unimed, cd_usuario_plano, nm_beneficiario, 
	 dt_atualizacao, nm_usuario, dt_validade, 
	 ds_observacao, ie_tipo_cliente, nr_seq_requisicao, 
	 nr_seq_origem, ie_tipo_resposta) 
values (nr_seq_resp_novo_w, '00401', cd_unimed_exec_w, 
	 cd_unimed_benef_w, nr_seq_execucao_w, nr_seq_guia_w, 
	 cd_unimed_w, cd_usuario_plano_w, nm_segurado_w, 
	 clock_timestamp(), nm_usuario_p, dt_validade_w, 
	 ds_observacao_w, ie_tipo_cliente_w, nr_seq_requisicao_w, 
	 nr_seq_controle_p, ie_tipo_resposta_w);
 
--if	(nr_seq_pedido_aut_w	<> 0) then 
	open c01;
	loop 
	fetch c01 into 
		cd_servico_w, 
		cd_servico_consersao_w, 
		ie_tipo_tabela_w, 
		ds_opme_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		ie_estagio_proc_w	:= null;
		ie_estagio_mat_w	:= null;
		ie_status_proc_w	:= '';
		ie_status_mat_w		:= '';
		 
		if (ie_tipo_tabela_w	in ('0','1','4')) then 
			open c02;
			loop 
			fetch c02 into 
				ie_origem_proced_w, 
				qt_proced_w, 
				ie_status_proc_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			end loop;
			close c02;
 
			if (coalesce(ie_origem_proced_w::text, '') = '') then 
				select	max(ie_origem_proced) 
				into STRICT	ie_origem_proced_w 
				from  procedimento 
				where  cd_procedimento		= coalesce(cd_servico_consersao_w,cd_servico_w) 
				and	ie_origem_proced	in (1,4,5) 
				and	ie_situacao		= 'A';
			end if;
 
			if (ie_status_proc_w	= 'A') then 
				ie_estagio_proc_w	:= 4;
			elsif (ie_status_proc_w	= 'N') then 
				ie_estagio_proc_w	:= 1;
			elsif (ie_status_proc_w	in ('P', 'S')) then 
				ie_estagio_proc_w	:= 2;
			end if;
			 
			if (ie_estagio_w	= 7) then 
				ie_estagio_proc_w	:= 1;
			elsif (ie_estagio_w	in (4,1)) then 
				ie_estagio_proc_w	:= 4;
			end if;
 
			if (cd_servico_w IS NOT NULL AND cd_servico_w::text <> '') then 
				if (coalesce(ds_opme_w,'X')	= 'X') then 
					select	substr(obter_descricao_procedimento(coalesce(cd_servico_consersao_w,cd_servico_w),ie_origem_proced_w),1,80), 
						nextval('ptu_resposta_aut_servico_seq') 
					into STRICT	ds_procedimento_w, 
						nr_seq_resp_proc_w 
					;
				else 
					ds_procedimento_w	:= ds_opme_w;
					 
					select	nextval('ptu_resposta_aut_servico_seq') 
					into STRICT	nr_seq_resp_proc_w 
					;
				end if;
 
				insert	into ptu_resposta_aut_servico(nr_sequencia, nr_seq_pedido, ie_tipo_tabela, 
					 cd_servico, ds_servico, ie_autorizado, 
					 dt_atualizacao, nm_usuario, qt_autorizado, 
					 ie_origem_servico) 
				values (nr_seq_resp_proc_w, nr_seq_resp_novo_w, ie_tipo_tabela_w, 
					 cd_servico_w, ds_procedimento_w, coalesce(ie_estagio_proc_w,1), 
					 clock_timestamp(), nm_usuario_p, CASE WHEN ie_estagio_proc_w=4 THEN 0 WHEN ie_estagio_proc_w=1 THEN 0  ELSE coalesce(qt_proced_w,0) END , 
					 ie_origem_proced_w);
				 
				if (coalesce(nr_seq_guia_w::text, '') = '') then 
					CALL ptu_inserir_inconsistencia(	null, null, 2002, 
									'',cd_estabelecimento_p, nr_seq_guia_w, 
									'G', '00401', nr_seq_resp_proc_w, 
									null, null, nm_usuario_p);
				elsif (coalesce(nr_seq_requisicao_w::text, '') = '') then 
					CALL ptu_inserir_inconsistencia(	null, null, 2002, 
									'',cd_estabelecimento_p, nr_seq_requisicao_w, 
									'R', '00401', nr_seq_resp_proc_w, 
									null, null, nm_usuario_p);
				end if;
			end if;
		elsif (ie_tipo_tabela_w	in ('2','3')) then 
			open c03;
			loop 
			fetch c03 into 
				qt_material_w, 
				ie_status_mat_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
			end loop;
			close c03;
			 
			if (ie_status_mat_w	= 'A') then 
				ie_estagio_mat_w	:= 4;
			elsif (ie_status_mat_w	= 'N') then 
				ie_estagio_mat_w	:= 1;
			elsif (ie_status_mat_w	in ('P', 'S')) then 
				ie_estagio_mat_w	:= 2;
			end if;
			 
			begin 
				select	nr_sequencia 
				into STRICT	nr_seq_material_w 
				from	pls_material 
				where	cd_material_ops = coalesce(cd_servico_consersao_w,cd_servico_w);
			exception 
			when others then 
				nr_seq_material_w	:= 0;
			end;
						 
			if (ie_estagio_w	= 7) then 
				ie_estagio_mat_w	:= 1;
			elsif (ie_estagio_w	in (4,1)) then 
				ie_estagio_mat_w	:= 4;
			end if;
			 
			if (cd_servico_w IS NOT NULL AND cd_servico_w::text <> '') then 
				if (coalesce(ds_opme_w,'X')	= 'X') then 
					select	substr(coalesce(pls_obter_desc_material(nr_seq_material_w),'Não encontrado'),1,80), 
						nextval('ptu_resposta_aut_servico_seq') 
					into STRICT	ds_material_w, 
						nr_seq_resp_mat_w 
					;
				else 
					ds_material_w	:= ds_opme_w;
					 
					select	nextval('ptu_resposta_aut_servico_seq') 
					into STRICT	nr_seq_resp_mat_w 
					;
				end if;
 
				insert	into ptu_resposta_aut_servico(nr_sequencia, nr_seq_pedido, ie_tipo_tabela, 
					 cd_servico, ds_servico, ie_autorizado, 
					 dt_atualizacao, nm_usuario, qt_autorizado) 
				values (nr_seq_resp_mat_w, nr_seq_resp_novo_w, ie_tipo_tabela_w, 
					 cd_servico_w, ds_material_w, coalesce(ie_estagio_mat_w,1), 
					 clock_timestamp(), nm_usuario_p, CASE WHEN ie_estagio_mat_w=4 THEN 0 WHEN ie_estagio_mat_w=1 THEN 0  ELSE coalesce(qt_material_w,0) END );
				 
				if (coalesce(nr_seq_guia_w::text, '') = '') then 
					CALL ptu_inserir_inconsistencia(	null, null, 2002, 
									'',cd_estabelecimento_p, nr_seq_guia_w, 
									'G', '00401', nr_seq_resp_mat_w, 
									null, null, nm_usuario_p);
				elsif (coalesce(nr_seq_requisicao_w::text, '') = '') then 
					CALL ptu_inserir_inconsistencia(	null, null, 2002, 
									'',cd_estabelecimento_p, nr_seq_requisicao_w, 
									'R', '00401', nr_seq_resp_mat_w, 
									null, null, nm_usuario_p);
				end if;
			end if;
		end if;
 
		end;
	end loop;
	close c01;
	 
	if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then		 
		select	count(1) 
		into STRICT	qt_reg_proc_aud_w 
		from	pls_requisicao_proc 
		where	nr_seq_requisicao	= nr_seq_requisicao_w 
		and	ie_status		= 'A';
		 
		select	count(1) 
		into STRICT	qt_reg_mat_aud_w 
		from	pls_requisicao_proc 
		where	nr_seq_requisicao	= nr_seq_requisicao_w 
		and	ie_status		= 'A';
	elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then 
		select	count(1) 
		into STRICT	qt_reg_proc_aud_w 
		from	pls_guia_plano_proc 
		where	nr_seq_guia	= nr_seq_guia_w 
		and	ie_status	= 'A';
		 
		select	count(1) 
		into STRICT	qt_reg_mat_aud_w 
		from	pls_guia_plano_mat 
		where	nr_seq_guia	= nr_seq_guia_w 
		and	ie_status	= 'A';
	end if;
	if	((qt_reg_proc_aud_w	> 0) or (qt_reg_mat_aud_w > 0)) and (nr_seq_resp_novo_w IS NOT NULL AND nr_seq_resp_novo_w::text <> '') then 
		update	ptu_resposta_aut_servico 
		set	ie_autorizado		= 4 
		where	nr_seq_pedido	= nr_seq_resp_novo_w;
		 
		update	ptu_resposta_aut_servico 
		set	ie_autorizado		= 4 
		where	nr_seq_pedido	= nr_seq_resp_novo_w;
	end if;
/*elsif	(nr_seq_pedido_compl_w	<> 0) then 
	open C04; 
	loop 
	fetch C04 into	 
		ie_tipo_tabela_w, 
		cd_servico_w, 
		qt_servico_w, 
		ie_origem_servico_w, 
		ie_tipo_servico_w, 
		ie_status_complemento_w; 
	exit when C04%notfound; 
		begin 
		 
		if	(ie_tipo_servico_w	= 'P') then 
			ds_servico_w	:= substr(obter_descricao_procedimento(cd_servico_w,ie_origem_servico_w),1,80); 
		elsif	(ie_tipo_servico_w	= 'M') then 
			select	nr_sequencia 
			into	nr_seq_material_w 
			from	pls_material 
			where	cd_material_ops = cd_servico_w; 
			ds_servico_w	:= substr(nvl(pls_obter_desc_material(nr_seq_material_w),'Não encontrado'),1,80); 
		end if; 
		 
		if	(ie_status_complemento_w	= 1) then 
			ie_autorizado_w	:= 2; 
		elsif	(ie_status_complemento_w	= 2) then 
			ie_autorizado_w	:= 1; 
		elsif	(ie_status_complemento_w	= 4) then 
			ie_autorizado_w	:= 4; 
		end if; 
		 
		insert	into ptu_resposta_aut_servico 
			(nr_sequencia, nr_seq_pedido, ie_tipo_tabela, 
			 cd_servico, ds_servico, ie_autorizado, 
			 dt_atualizacao, nm_usuario, qt_autorizado) 
		values	(ptu_resposta_aut_servico_seq.nextval, nr_seq_resp_novo_w, ie_tipo_tabela_w, 
			 cd_servico_w, ds_servico_w, ie_autorizado_w, 
			 sysdate, nm_usuario_p, qt_servico_w); 
		end; 
	end loop; 
	close C04; 
end if;*/
 
 
--ptu_consistir_transacao('00401',nr_seq_guia_w,nr_seq_requisicao_w,cd_estabelecimento_p,nm_usuario_p); 
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_resp_pedido_auto ( nr_seq_controle_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

