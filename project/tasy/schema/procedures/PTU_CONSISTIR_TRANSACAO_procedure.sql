-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_consistir_transacao ( cd_transacao_p text, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_complemento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_tipo_cliente_w			varchar(2)	:='';
cd_unimed_executora_w			smallint	:=0;
cd_unimed_beneficiario_w		smallint	:=0;
nr_seq_execucao_w			bigint	:=0;
cd_unimed_w				smallint	:=0;
cd_usuario_plano_w			varchar(13)	:='';
nr_via_cartao_w				smallint	:=0;
ie_alto_custo_w				varchar(2)	:='';
ie_urg_emerg_w				varchar(2)	:='';
cd_doenca_cid_w				varchar(6)	:='';
nr_seq_prest_alt_cust_w			bigint	:=0;
cd_unimed_prest_req_w			smallint	:=0;
nr_seq_prestador_req_w			bigint	:=0;
cd_unimed_prestador_w			smallint	:=0;
nr_seq_prestador_w			bigint	:=0;
cd_especialidade_w			smallint	:=0;
qt_dias_doenca_w			smallint	:=0;
dt_atendimento_w			timestamp;
ds_observacao_w				varchar(2000)	:='';
ds_ind_clinica_w			varchar(2000)	:='';
ds_biometria_w				varchar(2000)	:='';
cd_servico_w				bigint	:=0;
qt_servico_w				smallint	:=0;
ds_opme_w				varchar(100)	:='';
--vl_servico_w
ie_origem_servico_w			smallint	:=0;
ie_tipo_tabela_w			varchar(2)	:='';
nr_seq_glosa_w				bigint	:=0;
nr_seq_guia_proc_w			bigint	:=0;
nr_seq_guia_mat_w			bigint	:=0;
nr_seq_req_proc_w			bigint	:=0;
nr_seq_req_mat_w			bigint	:=0;
nr_seq_transacao_w			bigint	:=0;
ie_tipo_transacao_w			varchar(3)	:='';
nr_seq_procedimento_w			bigint	:=0;
nr_seq_material_w			bigint;
nr_seq_pai_w				bigint	:=0;
ie_origem_serv_w			smallint	:=0;
nm_prestador_w				varchar(40)	:='';
nr_seq_origem_w				bigint	:=0;
dt_validade_w				timestamp;
nm_benficiario_w			varchar(60)	:='';
dt_prov_atendimento_w			timestamp;
cd_unimed_prestador_req_w		smallint	:=0;
cd_carteirinha_w			varchar(17)	:= 'X';
qt_reg_existe_w				smallint	:=0;
nr_seq_segurado_w			bigint;
cd_pessoa_fisica_w			varchar(10);
nr_cpf_w				varchar(11);
nr_via_solicitacao_w			integer;
ie_status_w				varchar(11);
cd_inconsistencia_w			smallint;
nr_seq_ocorrencia_w			bigint;
ie_estagio_guia_w			bigint;
ie_estagio_req_w			bigint;
qt_inconsist_ptu_w			bigint	:= 0;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		qt_solicitada,
		ie_status
	from	pls_guia_plano_proc
	where	nr_seq_guia		= nr_seq_guia_p
	
union

	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		qt_solicitado,
		ie_status
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_material,
		qt_solicitada,
		ie_status
	from	pls_guia_plano_mat
	where	nr_seq_guia		= nr_seq_guia_p
	
union

	SELECT	nr_sequencia,
		nr_seq_material,
		qt_solicitado,
		ie_status
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

C03 CURSOR FOR
	SELECT	nr_seq_motivo_glosa
	from	pls_guia_glosa
	where	nr_seq_guia		= nr_seq_guia_p
	and	ie_tipo_transacao_w	= 'G'
	
union

	SELECT	nr_seq_motivo_glosa
	from	pls_requisicao_glosa
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	ie_tipo_transacao_w	= 'R';

C04 CURSOR FOR
	SELECT	nr_seq_motivo_glosa
	from	pls_guia_glosa
	where (nr_seq_guia_proc	= nr_seq_procedimento_w or coalesce(nr_seq_procedimento_w::text, '') = '')
	and (nr_seq_guia_mat	= nr_seq_material_w 	or coalesce(nr_seq_material_w::text, '') = '')
	and	ie_tipo_transacao_w	= 'G'
	
union

	SELECT	nr_seq_motivo_glosa
	from	pls_requisicao_glosa
	where	((nr_seq_req_proc	= nr_seq_procedimento_w and coalesce(nr_seq_req_mat::text, '') = '')
	or (nr_seq_req_mat		= nr_seq_material_w 	and coalesce(nr_seq_req_proc::text, '') = ''))
	and	ie_tipo_transacao_w	= 'R';

C05 CURSOR FOR
	SELECT	b.cd_inconsistencia
	from	pls_acao_glosa_tiss	a,
		ptu_inconsistencia	b
	where	a.nr_seq_inconsis_scs	= b.nr_sequencia
	and	a.nr_seq_motivo_glosa	= nr_seq_glosa_w;

C06 CURSOR FOR
	SELECT	nr_seq_ocorrencia
	from	pls_ocorrencia_benef
	where	((nr_seq_proc		= nr_seq_procedimento_w	and coalesce(nr_seq_mat::text, '') = '')
	or (nr_seq_mat		= nr_seq_material_w	and coalesce(nr_seq_proc::text, '') = ''))
	and (ie_tipo_transacao_w	= 'R'
	and	(nr_seq_requisicao IS NOT NULL AND nr_seq_requisicao::text <> ''))
	
union

	SELECT	nr_seq_ocorrencia
	from	pls_ocorrencia_benef
	where	((nr_seq_proc		= nr_seq_procedimento_w	and coalesce(nr_seq_mat::text, '') = '')
	or (nr_seq_mat		= nr_seq_material_w	and coalesce(nr_seq_proc::text, '') = ''))
	and (ie_tipo_transacao_w	= 'G'
	and	(nr_seq_guia_plano IS NOT NULL AND nr_seq_guia_plano::text <> ''));

C07 CURSOR FOR
	SELECT	nr_seq_ocorrencia
	from	pls_ocorrencia_benef
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(nr_seq_proc::text, '') = ''
	and	coalesce(nr_seq_mat::text, '') = ''
	and	ie_tipo_transacao_w	= 'R'
	
union

	SELECT	nr_seq_ocorrencia
	from	pls_ocorrencia_benef
	where	nr_seq_guia_plano	= nr_seq_guia_p
	and	coalesce(nr_seq_proc::text, '') = ''
	and	coalesce(nr_seq_mat::text, '') = ''
	and	ie_tipo_transacao_w	= 'G';

C08 CURSOR FOR
	SELECT	b.cd_inconsistencia
	from	pls_ocorrencia_scs	a,
		ptu_inconsistencia	b
	where	a.nr_seq_inconsis_scs	= b.nr_sequencia
	and	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_w;


BEGIN

if (cd_transacao_p	 ('00401','00304','00501','00404')) then
	begin
		select	nr_sequencia, ie_tipo_cliente, cd_unimed_executora,
			cd_unimed_beneficiario, nr_seq_execucao, cd_unimed,
			cd_usuario_plano, nr_via_cartao, ie_alto_custo,
			ie_urg_emerg, cd_doenca_cid, nr_seq_prest_alto_custo,
			cd_unimed_prestador_req, nr_seq_prestador_req, cd_unimed_prestador,
			nr_seq_prestador, cd_especialidade, qt_dias_doenca,
			dt_atendimento, ds_observacao, ds_ind_clinica,
			ds_biometria
		into STRICT	nr_seq_pai_w, ie_tipo_cliente_w, cd_unimed_executora_w,
			cd_unimed_beneficiario_w, nr_seq_execucao_w, cd_unimed_w,
			cd_usuario_plano_w, nr_via_cartao_w, ie_alto_custo_w,
			ie_urg_emerg_w, cd_doenca_cid_w, nr_seq_prest_alt_cust_w,
			cd_unimed_prest_req_w, nr_seq_prestador_req_w, cd_unimed_prestador_w,
			nr_seq_prestador_w, cd_especialidade_w, qt_dias_doenca_w,
			dt_atendimento_w, ds_observacao_w, ds_ind_clinica_w,
			ds_biometria_w
		from	ptu_pedido_autorizacao
		where (nr_seq_guia		= nr_seq_guia_p
		or	nr_seq_requisicao	= nr_seq_requisicao_p);
	exception
	when others then
		select	nr_sequencia, ie_tipo_cliente, cd_unimed_executora,
			cd_unimed_beneficiario, nr_seq_execucao, cd_unimed,
			cd_usuario_plano, cd_unimed_prestador_req, nr_seq_prestador_req,
			nr_seq_prestador, cd_especialidade, ds_observacao,
			ds_biometria
		into STRICT	nr_seq_pai_w, ie_tipo_cliente_w, cd_unimed_executora_w,
			cd_unimed_beneficiario_w, nr_seq_execucao_w, cd_unimed_w,
			cd_usuario_plano_w, cd_unimed_prest_req_w, nr_seq_prestador_req_w,
			nr_seq_prestador_w, cd_especialidade_w, ds_observacao_w,
			ds_biometria_w
		from	ptu_pedido_compl_aut
		where (nr_seq_guia		= nr_seq_guia_p
		or	nr_seq_requisicao	= nr_seq_requisicao_p);
	end;
elsif (cd_transacao_p	in ('00507','00607','00807')) then
	select	nr_sequencia, ie_tipo_cliente, ie_urg_emerg,
		cd_unimed_executora, cd_unimed_beneficiario, cd_unimed,
		cd_usuario_plano, nr_via_cartao, nr_seq_origem,
		dt_validade, coalesce(nm_benficiario,'X'), dt_prov_atendimento,
		cd_doenca_cid, cd_unimed_prestador_req, nr_seq_prestador_req,
		cd_unimed_prestador, nr_seq_prestador, cd_especialidade,
		ds_observacao, ds_ind_clinica
	into STRICT	nr_seq_pai_w, ie_tipo_cliente_w, ie_urg_emerg_w,
		cd_unimed_executora_w, cd_unimed_beneficiario_w, cd_unimed_w,
		cd_usuario_plano_w, nr_via_cartao_w, nr_seq_origem_w,
		dt_validade_w, nm_benficiario_w, dt_prov_atendimento_w,
		cd_doenca_cid_w, cd_unimed_prestador_req_w, nr_seq_prestador_req_w,
		cd_unimed_prestador_w, nr_seq_prestador_w, cd_especialidade_w,
		ds_observacao_w, ds_ind_clinica_w
	from	ptu_requisicao_ordem_serv
	where (nr_seq_guia		= nr_seq_guia_p
	or	nr_seq_requisicao	= nr_seq_requisicao_p);
end if;

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '')then
	nr_seq_transacao_w 	:= nr_seq_guia_p;
	ie_tipo_transacao_w	:= 'G';

	select	ie_estagio
	into STRICT	ie_estagio_guia_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_seq_guia_p;
else
	nr_seq_transacao_w	:= nr_seq_requisicao_p;
	ie_tipo_transacao_w	:= 'R';

	select	ie_estagio
	into STRICT	ie_estagio_req_w
	from	pls_requisicao
	where	nr_sequencia	= nr_seq_requisicao_p;
end if;

nr_seq_material_w	:= null;
nr_seq_procedimento_w	:= null;

open C01;
loop
fetch C01 into
	nr_seq_procedimento_w,
	cd_servico_w,
	ie_origem_serv_w,
	qt_servico_w,
	ie_status_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_status_w	in ('S','U','N','M','G')) and ((coalesce(ie_estagio_guia_w,0) in (2,4,5,10)) or (coalesce(ie_estagio_req_w,0) in (6,7))) then
/*
	--------------------------------2001
		if	(cd_unimed_executora_w	= cd_unimed_beneficiario_w) then
			ptu_inserir_inconsistencia(	null, null, 2001,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
							null, null, nm_usuario_p);

			update	pls_guia_plano_proc
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_procedimento_w
			and	nr_seq_guia		= nr_seq_guia_p;

			qt_inconsist_ptu_w	:= 1;
		end if;

	--------------------------------2002
		cd_carteirinha_w	:= to_char(adiciona_zeros_esquerda(cd_unimed_w, 4)||cd_usuario_plano_w);
		begin
		select	a.nr_sequencia,
			a.cd_pessoa_fisica,
			b.nr_via_solicitacao
		into	nr_seq_segurado_w,
			cd_pessoa_fisica_w,
			nr_via_solicitacao_w
		from	pls_segurado_carteira	b,
			pls_segurado		a
		where	b.cd_usuario_plano	= cd_carteirinha_w
		and	a.nr_sequencia		= b.nr_seq_segurado
		and	a.cd_estabelecimento 	= cd_estabelecimento_p;
		exception
		when others then
			nr_seq_segurado_w	:= 0;
			cd_pessoa_fisica_w	:= 'X';
		end;

		if	(nr_seq_segurado_w	= 0) then
			ptu_inserir_inconsistencia(	null, null, 2002,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
							null, null, nm_usuario_p);

			update	pls_guia_plano_proc
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_procedimento_w
			and	nr_seq_guia		= nr_seq_guia_p;

			qt_inconsist_ptu_w	:= 1;
		end if;

	--------------------------------2004
		if	(cd_pessoa_fisica_w	<> 'X') then
			select	nvl(nr_cpf,'X')
			into	nr_cpf_w
			from	pessoa_fisica
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

			if	(nr_cpf_w	= 'X') then
				ptu_inserir_inconsistencia(	null, null, 2004,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
								null, null, nm_usuario_p);

				update	pls_guia_plano_proc
				set	ie_status		= 'N'
				where	nr_sequencia		= nr_seq_procedimento_w
				and	nr_seq_guia		= nr_seq_guia_p;

				qt_inconsist_ptu_w	:= 1;
			end if;
		end if;

	--------------------------------2028
		if	(nr_via_solicitacao_w	<> nr_via_cartao_w) and (nr_via_cartao_w	<> 0) then
			ptu_inserir_inconsistencia(	null, null, 2028,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
							null, null, nm_usuario_p);

			update	pls_guia_plano_proc
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_procedimento_w
			and	nr_seq_guia		= nr_seq_guia_p;

			qt_inconsist_ptu_w	:= 1;
		end if;

	--------------------------------2003
		if	(qt_servico_w	= 0) then
			ptu_inserir_inconsistencia(	null, null, 2003,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
							null, null, nm_usuario_p);

			update	pls_guia_plano_proc
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_procedimento_w
			and	nr_seq_guia		= nr_seq_guia_p;
		end if;

	--------------------------------2031
		if	(cd_servico_w	= 0) then
			ptu_inserir_inconsistencia(	null, null, 2031,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
							null, null, nm_usuario_p);

			update	pls_guia_plano_proc
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_procedimento_w
			and	nr_seq_guia		= nr_seq_guia_p;
		end if;

	--------------------------------2045
		if	(ie_alto_custo_w	= 'S') then
			ptu_inserir_inconsistencia(	null, null, 2045,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
							null, null, nm_usuario_p);
		end if;
*/
		open C03;
		loop
		fetch C03 into
			nr_seq_glosa_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			open C05;
			loop
			fetch C05 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
								null, null, nm_usuario_p);

				end;
			end loop;
			close C05;

			if (coalesce(cd_inconsistencia_w::text, '') = '') then
				CALL ptu_gerar_incosist_scs(	nr_seq_glosa_w, nr_seq_transacao_w, ie_tipo_transacao_w,
							cd_transacao_p, cd_estabelecimento_p, nr_seq_procedimento_w,
							null, nm_usuario_p);
			end if;
			end;
		end loop;
		close C03;

		open C04;
		loop
		fetch C04 into
			nr_seq_glosa_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			open C05;
			loop
			fetch C05 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
								null, null, nm_usuario_p);

				end;
			end loop;
			close C05;

			if (coalesce(cd_inconsistencia_w::text, '') = '') then
				CALL ptu_gerar_incosist_scs(	nr_seq_glosa_w, nr_seq_transacao_w, ie_tipo_transacao_w,
							cd_transacao_p, cd_estabelecimento_p, nr_seq_procedimento_w,
							null, nm_usuario_p);
			end if;
			end;
		end loop;
		close C04;

		open C06;
		loop
		fetch C06 into
			nr_seq_ocorrencia_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin
			open C08;
			loop
			fetch C08 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C08 */
				begin
				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
								null, null, nm_usuario_p);

				end;
			end loop;
			close C08;
			end;
		end loop;
		close C06;

		open C07;
		loop
		fetch C07 into
			nr_seq_ocorrencia_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
			begin
			open C08;
			loop
			fetch C08 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C08 */
				begin
				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
								null, null, nm_usuario_p);

				end;
			end loop;
			close C08;
			end;
		end loop;
		close C07;
	end if;

	end;
end loop;
close C01;

nr_seq_material_w	:= null;
nr_seq_procedimento_w	:= null;

open C02;
loop
fetch C02 into
	nr_seq_material_w,
	cd_servico_w,
	qt_servico_w,
	ie_status_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (ie_status_w	in ('S','U','N','M','G')) and ((coalesce(ie_estagio_guia_w,0) in (2,4,5,10)) or (coalesce(ie_estagio_req_w,0) in (6,7))) then
/*
	--------------------------------2001
		if	(cd_unimed_executora_w	= cd_unimed_beneficiario_w) then
			ptu_inserir_inconsistencia(	null, null, 2001,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, null,
							nr_seq_material_w, null, nm_usuario_p);

			update	pls_guia_plano_mat
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_material_w
			and	nr_seq_guia		= nr_seq_guia_p;

			qt_inconsist_ptu_w	:= 1;
		end if;

	--------------------------------2002
		cd_carteirinha_w	:= to_char(adiciona_zeros_esquerda(cd_unimed_w, 4)||cd_usuario_plano_w);
		begin
		select	a.nr_sequencia,
			a.cd_pessoa_fisica
		into	nr_seq_segurado_w,
			cd_pessoa_fisica_w
		from	pls_segurado_carteira	b,
			pls_segurado		a
		where	b.cd_usuario_plano	= cd_carteirinha_w
		and	a.nr_sequencia		= b.nr_seq_segurado
		and	a.cd_estabelecimento 	= cd_estabelecimento_p;
		exception
		when others then
			nr_seq_segurado_w	:= 0;
			cd_pessoa_fisica_w	:= '';
		end;
		if	(nr_seq_segurado_w	= 0) then
			ptu_inserir_inconsistencia(	null, null, 2002,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, null,
							nr_seq_material_w, null, nm_usuario_p);

			update	pls_guia_plano_mat
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_material_w
			and	nr_seq_guia		= nr_seq_guia_p;

			qt_inconsist_ptu_w	:= 1;
		end if;

	--------------------------------2004
		if	(cd_pessoa_fisica_w	<> '') then
			select	nvl(nr_cpf,'X')
			into	nr_cpf_w
			from	pessoa_fisica
			where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
			if	(nr_cpf_w	= 'X') then
				ptu_inserir_inconsistencia(	null, null, 2004,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, null,
								nr_seq_material_w, null, nm_usuario_p);

				update	pls_guia_plano_mat
				set	ie_status		= 'N'
				where	nr_sequencia		= nr_seq_material_w
				and	nr_seq_guia		= nr_seq_guia_p;

				qt_inconsist_ptu_w	:= 1;
			end if;
		end if;

	--------------------------------2028
		if	(nr_via_solicitacao_w	<> nr_via_cartao_w) and (nr_via_cartao_w	<> 0)then
			ptu_inserir_inconsistencia(	null, null, 2028,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, nr_seq_procedimento_w,
							null, null, nm_usuario_p);

			update	pls_guia_plano_mat
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_material_w
			and	nr_seq_guia		= nr_seq_guia_p;

			qt_inconsist_ptu_w	:= 1;
		end if;

	--------------------------------2003
		if	(qt_servico_w	= 0) then
			ptu_inserir_inconsistencia(	null, null, 2003,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, null,
							nr_seq_material_w, null, nm_usuario_p);

			update	pls_guia_plano_mat
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_material_w
			and	nr_seq_guia		= nr_seq_guia_p;
		end if;

	--------------------------------2031
		if	(cd_servico_w	= 0) then
			ptu_inserir_inconsistencia(	null, null, 2031,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, null,
							nr_seq_material_w, null, nm_usuario_p);

			update	pls_guia_plano_mat
			set	ie_status		= 'N'
			where	nr_sequencia		= nr_seq_material_w
			and	nr_seq_guia		= nr_seq_guia_p;
		end if;

	--------------------------------2045
		if	(ie_alto_custo_w	= 'S') then
			ptu_inserir_inconsistencia(	null, null, 2045,
							'',cd_estabelecimento_p, nr_seq_transacao_w,
							ie_tipo_transacao_w, cd_transacao_p, null,
							nr_seq_material_w, null, nm_usuario_p);
		end if;
*/
		open C03;
		loop
		fetch C03 into
			nr_seq_glosa_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			open C05;
			loop
			fetch C05 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin

				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, null,
								nr_seq_material_w, null, nm_usuario_p);
				end;
			end loop;
			close C05;

			if (coalesce(cd_inconsistencia_w::text, '') = '') then
				CALL ptu_gerar_incosist_scs(	nr_seq_glosa_w, nr_seq_transacao_w, ie_tipo_transacao_w,
							cd_transacao_p, cd_estabelecimento_p, null,
							nr_seq_material_w, nm_usuario_p);
			end if;
			end;
		end loop;
		close C03;

		open C04;
		loop
		fetch C04 into
			nr_seq_glosa_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			open C05;
			loop
			fetch C05 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
				begin
				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, null,
								nr_seq_material_w, null, nm_usuario_p);

				end;
			end loop;
			close C05;

			if (coalesce(cd_inconsistencia_w::text, '') = '') then
				CALL ptu_gerar_incosist_scs(	nr_seq_glosa_w, nr_seq_transacao_w, ie_tipo_transacao_w,
							cd_transacao_p, cd_estabelecimento_p, null,
							nr_seq_material_w, nm_usuario_p);
			end if;
			end;
		end loop;
		close C04;

		open C06;
		loop
		fetch C06 into
			nr_seq_ocorrencia_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin
			open C08;
			loop
			fetch C08 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C08 */
				begin

				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, null,
								nr_seq_material_w, null, nm_usuario_p);
				end;
			end loop;
			close C08;
			end;
		end loop;
		close C06;

		open C07;
		loop
		fetch C07 into
			nr_seq_ocorrencia_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
			begin
			open C08;
			loop
			fetch C08 into
				cd_inconsistencia_w;
			EXIT WHEN NOT FOUND; /* apply on C08 */
				begin

				CALL ptu_inserir_inconsistencia(	null, null, cd_inconsistencia_w,
								'',cd_estabelecimento_p, nr_seq_transacao_w,
								ie_tipo_transacao_w, cd_transacao_p, null,
								nr_seq_material_w, null, nm_usuario_p);
				end;
			end loop;
			close C08;
			end;
		end loop;
		close C07;
	end if;
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_consistir_transacao ( cd_transacao_p text, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_complemento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
