-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_req_desfazer_consistir ( nr_seq_requisicao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Desfazer a consist~encia da requisição, voltando seuj estágio para "Usuário (Aguardando ação)".
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_auditoria_w			integer;
nr_seq_requisicao_proc_w	bigint;
nr_seq_requisicao_mat_w		bigint;
qt_auditoria_iniciada_w		bigint;
qt_auditoria_assumida_w		bigint;
ie_requisicao_executada_w	varchar(1);
ie_tipo_intercambio_w		varchar(2);
ie_status_auditoria_w		varchar(2);
qt_pedido_autorizacao_w		integer;
qt_registros_w			integer;
ie_estagio_w			pls_requisicao.ie_estagio%type;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(nr_seq_motivo_exc::text, '') = '';

c02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(nr_seq_motivo_exc::text, '') = '';


BEGIN

if (coalesce(nr_seq_requisicao_p,0) <> 0) then

	select	ie_estagio
	into STRICT	ie_estagio_w
	from	pls_requisicao
	where	nr_sequencia = nr_seq_requisicao_p;

	if (ie_estagio_w <> '1') then
		CALL pls_requisicao_gravar_hist(nr_seq_requisicao_p,'L','Ação executada: Desfazer consistir.',null,nm_usuario_p);
	end if;

	begin
		select	coalesce(ie_tipo_intercambio,'X')
		into STRICT	ie_tipo_intercambio_w
		from	pls_requisicao
		where	nr_sequencia	= nr_seq_requisicao_p;
	exception
	when others then
		ie_tipo_intercambio_w	:= 'X';
	end;

	select	pls_obter_se_req_executada(nr_seq_requisicao_p)
	into STRICT	ie_requisicao_executada_w
	;

	if (ie_requisicao_executada_w = 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(197823);
		--Não foi possível desfazer a consistência, essa requisição já foi executada !
	end if;

	select	count(1)
	into STRICT	qt_auditoria_iniciada_w
	from	pls_auditoria a,
		pls_auditoria_grupo b
	where	a.nr_seq_requisicao	= nr_seq_requisicao_p
	and	a.nr_sequencia		= b.nr_seq_auditoria
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

	if (qt_auditoria_iniciada_w	> 0 ) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184258);
		--Não foi possível desfazer a consistência, o processo de auditoria desta requisição já foi iniciado !
	end if;

	select	count(1)
	into STRICT	qt_auditoria_assumida_w
	from	pls_auditoria a,
		pls_auditoria_grupo b
	where	a.nr_seq_requisicao	= nr_seq_requisicao_p
	and	a.nr_sequencia		= b.nr_seq_auditoria
	and	(nm_usuario_exec IS NOT NULL AND nm_usuario_exec::text <> '');

	if (qt_auditoria_assumida_w	> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184259);
		--Não foi possível desfazer a consistência, a análise desta requisição já foi assumida por um grupo de auditores !
	end if;

	select	count(1)
	into STRICT	qt_auditoria_w
	from	pls_auditoria
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	if (qt_auditoria_w	<> 0) then
		select	ie_status
		into STRICT	ie_status_auditoria_w
		from	pls_auditoria
		where	nr_seq_requisicao	= nr_seq_requisicao_p;

		if (ie_status_auditoria_w = 'AJ') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(223548);
			--Não foi possível desfazer a consistência, a análise desta requisição está aguardando justificativa do prestador !
		end if;

		--Realiza o Delete na tabela PLS_OCOR_AUT_BENEF_LOG
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_ocor_aut_benef_log
		where	nr_seq_requisicao	= nr_seq_requisicao_p;

		if (qt_registros_w > 0) then
			delete from pls_ocor_aut_benef_log
			where nr_seq_requisicao	= nr_seq_requisicao_p;
		end if;

		CALL pls_desfazer_auditoria_req(nr_seq_requisicao_p);
	end if;

	--Realiza o Delete na tabela PLS_OCOR_AUT_BENEF_LOG
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_ocor_aut_benef_log
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

	if (qt_registros_w > 0) then
		delete from pls_ocor_aut_benef_log
		where nr_seq_requisicao	= nr_seq_requisicao_p;
	end if;

	CALL pls_desfazer_ocorrencia(null,nr_seq_requisicao_p,null);

	delete from pls_solic_entrega_mat_med
	where  nr_seq_requisicao = nr_seq_requisicao_p;

	delete from pls_requisicao_glosa
	where nr_seq_requisicao	= nr_seq_requisicao_p;

	open c01;
	loop
	fetch c01 into
		nr_seq_requisicao_proc_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		delete from pls_requisicao_glosa
		where nr_seq_req_proc	= nr_seq_requisicao_proc_w;

		update	pls_requisicao_proc
		set	nr_seq_tipo_limitacao	 = NULL,
			nr_seq_cobertura	 = NULL,
			ie_tipo_cobertura	 = NULL,
			nr_seq_tratamento	 = NULL,
			qt_procedimento		 = NULL,
			ie_cobranca_prevista	 = NULL,
			nr_seq_tipo_carencia	 = NULL
		where	nr_sequencia		= nr_seq_requisicao_proc_w;
		end;
	end loop;
	close c01;

	open c02;
	loop
	fetch c02 into
		nr_seq_requisicao_mat_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		delete from pls_requisicao_glosa
		where nr_seq_req_mat	= nr_seq_requisicao_mat_w;
		end;

		update	pls_requisicao_mat
		set	nr_seq_tipo_limitacao	 = NULL,
			nr_seq_cobertura	 = NULL,
			nr_seq_tipo_carencia	 = NULL,
			ie_cobranca_prevista	 = NULL
		where	nr_sequencia		= nr_seq_requisicao_mat_w;
	end loop;
	close c02;

	update	pls_requisicao_proc
	set	ie_status		= 'U',
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(nr_seq_motivo_exc::text, '') = ''
	and	coalesce(cd_proc_inexistente::text, '') = '';

	update	pls_requisicao_mat
	set	ie_status		= 'U',
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(nr_seq_motivo_exc::text, '') = ''
	and	coalesce(cd_material_inexistente::text, '') = '';

	update	pls_requisicao
	set	ie_estagio		= 1,
		cd_senha		 = NULL,
		dt_validade_senha	 = NULL,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_requisicao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_req_desfazer_consistir ( nr_seq_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;

