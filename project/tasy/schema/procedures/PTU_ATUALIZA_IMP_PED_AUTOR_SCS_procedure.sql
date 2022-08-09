-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_atualiza_imp_ped_autor_scs ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_segurado_p bigint, ie_tipo_tabela_p text, ds_observacao_p text, ds_opme_p text, ie_alto_custo_p text, dt_atendimento_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, cd_unimed_exec_p text, ie_tipo_pedido_p text) AS $body$
DECLARE


qt_reg_consulta_w		bigint;
qt_reg_internacao_w		bigint;
nr_seq_regra_w			bigint;
qt_req_proc_w			bigint;
qt_req_proc_neg_w		bigint;
qt_req_mat_w			bigint;
qt_req_mat_neg_w		bigint;
nr_seq_guia_princ_w		bigint;
ie_proc_inesist_w		varchar(2)	:= 'N';
ie_estagio_w			bigint;
ie_estagio_req_w		bigint;
nr_versao_ptu_w			varchar(10);
cd_transacao_w			varchar(10);
ie_status_w			varchar(2);
nr_seq_plano_w			bigint;
nr_seq_tipo_acomodacao_w	bigint;
nr_seq_categoria_w		bigint;
ds_historico_w			varchar(4000);
qt_auditoria_w			bigint;
qt_regra_neg_w			bigint;
qt_pacote_w         integer;


BEGIN
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select	count(1)
	into STRICT	qt_reg_consulta_w
	from	pls_guia_plano_proc	a,
		procedimento		b
	where	nr_seq_guia		= nr_seq_guia_p
	and	a.cd_procedimento	= b.cd_procedimento
	and	b.ie_origem_proced	= a.ie_origem_proced
	and	b.cd_tipo_procedimento	= 71;

	select	count(1)
	into STRICT	qt_reg_internacao_w
	from	pls_guia_plano_proc	a,
		procedimento		b
	where	nr_seq_guia		= nr_seq_guia_p
	and	a.cd_procedimento	= b.cd_procedimento
	and	b.ie_origem_proced	= a.ie_origem_proced
	and	b.cd_tipo_procedimento	= 37;

	if (qt_reg_internacao_w	> 0) then
		begin
			select	nr_seq_guia_principal,
				nr_seq_plano
			into STRICT	nr_seq_guia_princ_w,
				nr_seq_plano_w
			from	pls_guia_plano
			where	nr_sequencia	= nr_seq_guia_p;
		exception
		when others then
			nr_seq_guia_princ_w		:= 0;
			nr_seq_plano_w			:= null;
		end;

		select	max(a.nr_seq_tipo_acomodacao)
		into STRICT	nr_seq_tipo_acomodacao_w
		from	pls_plano_acomodacao	a,
			pls_plano b
		where	b.nr_sequencia		= nr_seq_plano_w
		and	a.nr_seq_plano		= b.nr_sequencia
		and	a.ie_acomod_padrao 	= 'S';

		if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then
			select	max(a.nr_seq_categoria)
			into STRICT	nr_seq_categoria_w
			from	pls_plano_acomodacao	a,
				pls_plano b
			where	b.nr_sequencia		= nr_seq_plano_w
			and	a.nr_seq_plano		= b.nr_sequencia
			and	a.ie_acomod_padrao 	= 'S';

			select	max(nr_seq_tipo_acomodacao)
			into STRICT	nr_seq_tipo_acomodacao_w
			from	pls_regra_categoria
			where	nr_seq_categoria	= nr_seq_categoria_w
			and	ie_acomod_padrao	= 'S';
		end if;

		if (coalesce(nr_seq_guia_princ_w,0)	= 0) then
			update	pls_guia_plano
			set	/*ie_tipo_guia		= '1',*/
				nr_seq_tipo_acomodacao 	= nr_seq_tipo_acomodacao_w,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_guia_p;
		elsif (coalesce(nr_seq_guia_princ_w,0)	<> 0) then
			update	pls_guia_plano
			set	ie_tipo_guia		= '8',
				nr_seq_tipo_acomodacao 	= nr_seq_tipo_acomodacao_w,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_guia_p;
		end if;
	elsif (qt_reg_consulta_w	> 0) and (qt_reg_internacao_w	= 0) then
		update	pls_guia_plano
		set	/*ie_tipo_guia	= '3',*/
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_guia_p;
	end if;

	nr_seq_regra_w := pls_verif_reg_lib_intercambio(null, null, 'LR', nr_seq_guia_p, null, cd_unimed_exec_p, nr_seq_regra_w);

	if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
		CALL pls_consistir_guia(nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p);

		begin
			select	ie_estagio
			into STRICT	ie_estagio_w
			from	pls_guia_plano
			where	nr_sequencia = nr_seq_guia_p;
		exception
		when others then
			ie_estagio_w	:= 0;
		end;
	end if;

	select count(1)
	into STRICT   qt_pacote_w
	from   pls_guia_plano_proc
	where  nr_seq_guia   = nr_seq_guia_p
	and    ie_pacote_ptu = 'S';

	if (pls_obter_se_regra_negativa(nr_seq_guia_p, null) = 'S') then

		ds_historico_w	:= expressao_pck.obter_desc_expressao(1075687);

		if (ds_historico_w IS NOT NULL AND ds_historico_w::text <> '') then
			insert into pls_guia_plano_historico(nr_sequencia, nr_seq_guia, ie_tipo_log,
				dt_historico, dt_atualizacao, nm_usuario,
				ds_observacao, ie_origem_historico, ie_tipo_historico)
			values (	nextval('pls_guia_plano_historico_seq'), nr_seq_guia_p, 2,
				clock_timestamp(), clock_timestamp(), nm_usuario_p,
				ds_historico_w,'A','M');
		end if;

		if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
			CALL pls_atualiza_estagio_guia_inte(nr_seq_guia_p, 'N', nm_usuario_p, cd_estabelecimento_p);
		end if;

	elsif	((ie_tipo_tabela_p	= '4' AND ie_tipo_pedido_p	= 'C') or
		((ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') and ((nr_seq_regra_w	= 0) or (ie_estagio_w	= 2)))	or
		((ds_opme_p IS NOT NULL AND ds_opme_p::text <> '') and (ie_tipo_tabela_p	in ('2','3')))			or (dt_atendimento_p	< trunc(clock_timestamp())) or (qt_pacote_w      > 0 AND ie_tipo_pedido_p	= 'C')) then
		if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
			CALL pls_atualiza_estagio_guia_inte(nr_seq_guia_p, 'S', nm_usuario_p, cd_estabelecimento_p);
		end if;

		if (ie_tipo_pedido_p 	= 'A') then
			if	((ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') and ((nr_seq_regra_w	= 0) or (ie_estagio_w	= 2))) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075689) || chr(13);
			end if;
			if	((ds_opme_p IS NOT NULL AND ds_opme_p::text <> '') and (ie_tipo_tabela_p	in ('2','3'))) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075691) || chr(13);
			end if;
			if (dt_atendimento_p	< trunc(clock_timestamp())) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075693) || chr(13);
			end if;
			
		elsif (ie_tipo_pedido_p 	= 'C') then
			if	((ie_tipo_tabela_p	= '4') or (qt_pacote_w	> 0))  then
				ds_historico_w	:= expressao_pck.obter_desc_expressao(1075695) || chr(13);
			end if;
			if	(ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '' AND nr_seq_regra_w	= 0) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075699) || chr(13);
			end if;
			if	((ds_opme_p IS NOT NULL AND ds_opme_p::text <> '') and (ie_tipo_tabela_p	in ('2','3'))) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075701) || chr(13);
			end if;
			if (dt_atendimento_p	< trunc(clock_timestamp())) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075703) || chr(13);
			end if;
		end if;

		if (ds_historico_w IS NOT NULL AND ds_historico_w::text <> '') then
			insert into pls_guia_plano_historico(nr_sequencia, nr_seq_guia, ie_tipo_log,
				dt_historico, dt_atualizacao, nm_usuario,
				ds_observacao, ie_origem_historico, ie_tipo_historico)
			values (	nextval('pls_guia_plano_historico_seq'), nr_seq_guia_p, 2,
				clock_timestamp(), clock_timestamp(), nm_usuario_p,
				ds_historico_w,'A','M');
		end if;	
	else
		if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
			CALL pls_atualiza_estagio_guia_inte(nr_seq_guia_p, 'N', nm_usuario_p, cd_estabelecimento_p);
		end if;
	end if;

	nr_versao_ptu_w	:= pls_obter_versao_scs;

	if (nr_versao_ptu_w = '035') then
		cd_transacao_w	:= '00401';
	else
		cd_transacao_w	:= '00501';
	end if;

	CALL ptu_consistir_transacao(cd_transacao_w,nr_seq_guia_p,null,null,cd_estabelecimento_p,nm_usuario_p);

elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	select	count(1)
	into STRICT	qt_reg_consulta_w
	from	pls_requisicao_proc	a,
		procedimento		b
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	a.cd_procedimento	= b.cd_procedimento
	and	b.ie_origem_proced	= a.ie_origem_proced
	and	b.cd_tipo_procedimento	= 71;

	select	count(1)
	into STRICT	qt_reg_internacao_w
	from	pls_requisicao_proc	a,
		procedimento		b
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	a.cd_procedimento	= b.cd_procedimento
	and	b.ie_origem_proced	= a.ie_origem_proced
	and	b.cd_tipo_procedimento	= 37;

	if (qt_reg_internacao_w	> 0) then
		begin
			select	nr_seq_guia_principal,
				nr_seq_plano
			into STRICT	nr_seq_guia_princ_w,
				nr_seq_plano_w
			from	pls_requisicao
			where	nr_sequencia	= nr_seq_requisicao_p;
		exception
		when others then
			nr_seq_guia_princ_w	:= 0;
			nr_seq_plano_w		:= null;
		end;

		select	max(a.nr_seq_tipo_acomodacao)
		into STRICT	nr_seq_tipo_acomodacao_w
		from	pls_plano_acomodacao	a,
			pls_plano b
		where	b.nr_sequencia		= nr_seq_plano_w
		and	a.nr_seq_plano		= b.nr_sequencia
		and	a.ie_acomod_padrao 	= 'S';

		if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then
			select	max(a.nr_seq_categoria)
			into STRICT	nr_seq_categoria_w
			from	pls_plano_acomodacao	a,
				pls_plano b
			where	b.nr_sequencia		= nr_seq_plano_w
			and	a.nr_seq_plano		= b.nr_sequencia
			and	a.ie_acomod_padrao 	= 'S';

			select	max(nr_seq_tipo_acomodacao)
			into STRICT	nr_seq_tipo_acomodacao_w
			from	pls_regra_categoria
			where	nr_seq_categoria	= nr_seq_categoria_w
			and	ie_acomod_padrao	= 'S';
		end if;		

		if (coalesce(nr_seq_guia_princ_w,0)	= 0) then
			update	pls_requisicao
			set	/*ie_tipo_guia		= '1',	*/
		
				nr_seq_tipo_acomodacao 	= nr_seq_tipo_acomodacao_w,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_requisicao_p;
		elsif (coalesce(nr_seq_guia_princ_w,0)	<> 0) then
			update	pls_requisicao
			set	ie_tipo_guia		= '8',
				nr_seq_tipo_acomodacao 	= nr_seq_tipo_acomodacao_w,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_requisicao_p;
		end if;
	elsif (qt_reg_consulta_w	> 0) and (qt_reg_internacao_w	= 0) then
		update	pls_requisicao
		set	/*ie_tipo_guia	= '3',*/
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_requisicao_p;
	end if;

	nr_seq_regra_w := pls_verif_reg_lib_intercambio(null, null, 'LR', null, nr_seq_requisicao_p, cd_unimed_exec_p, nr_seq_regra_w);

	select	count(1)
	into STRICT	qt_req_proc_w
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	select	count(1)
	into STRICT	qt_req_proc_neg_w
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(cd_procedimento::text, '') = '';

	select	count(1)
	into STRICT	qt_req_mat_w
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	select	count(1)
	into STRICT	qt_req_mat_neg_w
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(nr_seq_material::text, '') = '';

	if	(((qt_req_proc_w	= qt_req_proc_neg_w)	and (qt_req_mat_w	= 0)	and (qt_req_mat_neg_w	= 0))	or
		((qt_req_mat_w		= qt_req_mat_neg_w) 	and (qt_req_proc_w	= 0)	and (qt_req_proc_neg_w	= 0))	or
		(qt_req_mat_w		= qt_req_mat_neg_w AND qt_req_proc_w	= qt_req_proc_neg_w)) then
		ie_proc_inesist_w	:= 'S';
	end if;

	if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
		CALL pls_consistir_requisicao(nr_seq_requisicao_p, cd_estabelecimento_p, nm_usuario_p);

		begin
			select	ie_estagio
			into STRICT	ie_estagio_req_w
			from	pls_requisicao
			where	nr_sequencia = nr_seq_requisicao_p;
		exception
		when others then
			ie_estagio_req_w	:= 0;
		end;
	end if;

	select count(1)
	into STRICT   qt_pacote_w
	from   pls_requisicao_proc
	where  nr_seq_requisicao   = nr_seq_requisicao_p
	and    ie_pacote_ptu = 'S';
	
	if (pls_obter_se_regra_negativa(null, nr_seq_requisicao_p) = 'S') then

		ds_historico_w	:= expressao_pck.obter_desc_expressao(1075687);

		if (ds_historico_w IS NOT NULL AND ds_historico_w::text <> '') then	
			insert	into pls_requisicao_historico(nr_sequencia, nr_seq_requisicao, ie_tipo_historico,
				ds_historico, dt_atualizacao, nm_usuario,
				dt_historico, ie_origem_historico)
			values (nextval('pls_requisicao_historico_seq'), nr_seq_requisicao_p, 'L',
				ds_historico_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), 'A');
		end if;

	elsif	((ie_tipo_tabela_p	= '4' AND ie_tipo_pedido_p	= 'C') or
		((ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') and ((nr_seq_regra_w	= 0)	or (ie_estagio_req_w	= 7)))	or
		((ds_opme_p IS NOT NULL AND ds_opme_p::text <> '') and (ie_tipo_tabela_p	in ('2','3')))				or
		(qt_pacote_w      > 0 AND ie_tipo_pedido_p	= 'C')	or (dt_atendimento_p	< trunc(clock_timestamp()))) 								and (ie_proc_inesist_w	= 'N')										then
		
		if (ie_tipo_pedido_p 	= 'A') then
			if	((ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') and ((nr_seq_regra_w	= 0) or (ie_estagio_req_w	= 7))) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075689) || chr(13);
			end if;
			if	((ds_opme_p IS NOT NULL AND ds_opme_p::text <> '') and (ie_tipo_tabela_p	in ('2','3'))) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075691) || chr(13);
			end if;
			if (dt_atendimento_p	< trunc(clock_timestamp())) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075693) || chr(13);
			end if;
		elsif (ie_tipo_pedido_p 	= 'C') then
			if	((ie_tipo_tabela_p	= '4') or (qt_pacote_w	> 0)) then
				ds_historico_w	:= expressao_pck.obter_desc_expressao(1075695) || chr(13);
			end if;
			if	(ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '' AND nr_seq_regra_w	= 0) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075699) || chr(13);
			end if;
			if	((ds_opme_p IS NOT NULL AND ds_opme_p::text <> '') and (ie_tipo_tabela_p	in ('2','3'))) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075701) || chr(13);
			end if;
			if (dt_atendimento_p	< trunc(clock_timestamp())) then
				ds_historico_w	:= ds_historico_w || expressao_pck.obter_desc_expressao(1075703) || chr(13);
			end if;
		end if;
		
		if (ds_historico_w IS NOT NULL AND ds_historico_w::text <> '') then
			insert	into pls_requisicao_historico(nr_sequencia, nr_seq_requisicao, ie_tipo_historico,
				ds_historico, dt_atualizacao, nm_usuario,
				dt_historico, ie_origem_historico)
			values (nextval('pls_requisicao_historico_seq'), nr_seq_requisicao_p, 'L',
				ds_historico_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), 'A');
		end if;
		
		select	count(1)
		into STRICT	qt_auditoria_w
		from	pls_auditoria
		where	nr_seq_requisicao	= nr_seq_requisicao_p
		and		coalesce(dt_liberacao::text, '') = '';
		
		if (qt_auditoria_w = 0) then
			
			update	pls_requisicao_proc
			set	ie_status	= 'A'
			where	nr_seq_requisicao	= nr_seq_requisicao_p;
			
			update	pls_requisicao_mat
			set	ie_status	= 'A'
			where	nr_seq_requisicao	= nr_seq_requisicao_p;
			
			update	pls_requisicao
			set	ie_estagio	= 4,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_requisicao_p;
			
			if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
				CALL pls_gerar_auditoria_requisicao(nr_seq_requisicao_p, nm_usuario_p,'AI');
				CALL ptu_gerar_grupo_aud_padrao(null, nr_seq_requisicao_p, 'GA', nm_usuario_p);
			end if;
		end if;
	end if;

	begin
		select	ie_estagio
		into STRICT	ie_estagio_w
		from	pls_requisicao
		where	nr_sequencia = nr_seq_requisicao_p;
	exception
	when others then
		ie_estagio_w	:= 0;
	end;

	if (coalesce(ie_estagio_w,0)	in (2,6)) then
		CALL pls_executar_req_interc_aprov(nr_seq_requisicao_p, cd_estabelecimento_p, nm_usuario_p);
	end if;

	nr_versao_ptu_w	:= pls_obter_versao_scs;

	if (nr_versao_ptu_w = '035') then
		cd_transacao_w	:= '00401';
	else
		cd_transacao_w	:= '00501';
	end if;

	CALL ptu_consistir_transacao(cd_transacao_w,null, nr_seq_requisicao_p,null,cd_estabelecimento_p,nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_atualiza_imp_ped_autor_scs ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_segurado_p bigint, ie_tipo_tabela_p text, ds_observacao_p text, ds_opme_p text, ie_alto_custo_p text, dt_atendimento_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, cd_unimed_exec_p text, ie_tipo_pedido_p text) FROM PUBLIC;
