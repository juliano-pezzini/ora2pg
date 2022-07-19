-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ocorr_liminar_judic ( nr_seq_segurado_p bigint, nr_seq_processo_p bigint, nr_seq_requisicao_p bigint, nm_usuario_p text, nr_seq_regra_p INOUT bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar ocorrencia liminar judicial.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ x]    Objetos do dicionario [ x] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_area_w			bigint;
cd_especialidade_w		bigint;
cd_grupo_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
ie_origem_proc_w		bigint;
ie_estagio_w			smallint;
ie_gerou_ocorr_w		varchar(2)	:= 'N';
nr_seq_auditoria_w		bigint;
nr_seq_requisicao_w		bigint;
nr_seq_material_w		bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_regra_w			bigint	:= null;
nr_seq_prestador_w		bigint;
nr_seq_processo_w		bigint;
nr_seq_req_proc_w		bigint;
nr_seq_req_mat_w		bigint;
nr_seq_contrato_w		bigint;
qt_reg_proc_w			bigint;
qt_reg_mat_w			bigint;
qt_reg_prest_w			bigint;
qt_reg_seg_w			bigint;
qt_ocorr_liminar_antiga_w	bigint;
ie_impacto_reajuste_w		processo_judicial_liminar.ie_impacto_reajuste%type;
nr_seq_tabela_w			pls_tabela_preco.nr_sequencia%type;
nr_seq_nova_tabela_w		pls_tabela_preco.nr_sequencia%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
ie_tipo_processo_w		pls_requisicao.ie_tipo_processo%type;
ie_tipo_intercambio_w		pls_requisicao.ie_tipo_intercambio%type;
ie_liminar_intercambio_w	varchar(2) := 'N';
qt_ped_w			integer := 0;
nr_seq_processo_jud_reaj_w	pls_processo_judicial_reaj.nr_sequencia%type;
ie_considerar_dependente_w	pls_processo_judicial_reaj.ie_considerar_dependente%type;
qt_registro_w			integer;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
ie_considera_codigo_pf_w	processo_judicial_liminar.ie_considera_codigo_pf%type;	

C00 CURSOR FOR
	SELECT	nr_sequencia
	from	processo_judicial_liminar
	where	(((coalesce(ie_considera_codigo_pf, 'N') = 'N'	and nr_seq_segurado	= nr_seq_segurado_p)
	or (coalesce(ie_considera_codigo_pf, 'N') = 'S'		and pls_obter_dados_segurado(nr_seq_segurado, 'PF')	= cd_pessoa_fisica_w))
	or	nr_seq_contrato		= nr_seq_contrato_w)
	and	ie_estagio		= 2
	and	ie_impacto_autorizacao	= 'S'
	and	clock_timestamp()	between(dt_inicio_validade) and (coalesce(dt_fim_validade,clock_timestamp()));

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_requisicao
	from	pls_auditoria
	where	coalesce(dt_liberacao::text, '') = ''
	and	(nr_seq_requisicao IS NOT NULL AND nr_seq_requisicao::text <> '')
	and (nr_seq_segurado	= nr_seq_segurado_p
	or	pls_obter_dados_segurado(nr_seq_segurado,'NC') = nr_seq_contrato_w);

C02 CURSOR FOR
	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_w
	and	ie_status		<> 'S';

C03 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_material
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_w
	and	ie_status		<> 'S';

C05 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_sequencia
	from	pls_ocorrencia		a,
		pls_ocorrencia_regra	b
	where	a.nr_sequencia		= b.nr_seq_ocorrencia
	and	a.ie_situacao		= 'A'
	and	a.ie_auditoria		= 'S'
	and	b.ie_aplicacao_regra	= 'A'
	and	b.ie_possui_liminar	= 'S'
	and	b.ie_situacao		= 'A'
	and	clock_timestamp() between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,clock_timestamp());

C06 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_sequencia
	from	pls_ocorrencia			a,
		pls_ocor_aut_combinada		b,
		pls_validacao_aut_liminar 	c
	where	b.nr_seq_ocorrencia		= a.nr_sequencia
	and	c.nr_seq_ocor_aut_combinada	= b.nr_sequencia
	and	a.ie_situacao			= 'A'
	and	a.ie_auditoria			= 'S'
	and	clock_timestamp() between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,clock_timestamp())
	and	b.ie_aplicacao_regra		= 30
	and	c.ie_valida_liminar		= 'S'
	and	c.ie_situacao			= 'A';

C07 CURSOR(	ie_considerar_dependente_pc	pls_processo_judicial_reaj.ie_considerar_dependente%type,
		nr_seq_segurado_pc		pls_segurado.nr_sequencia%type) FOR
	SELECT	nr_sequencia nr_seq_segurado
	from	pls_segurado
	where	ie_considerar_dependente_pc = 'S'
	and	((nr_seq_titular = nr_seq_segurado_pc) or (nr_sequencia = nr_seq_segurado_pc))
	
union

	SELECT	nr_sequencia nr_seq_segurado
	from	pls_segurado
	where	ie_considerar_dependente_pc = 'N'
	and	nr_sequencia = nr_seq_segurado_pc;

c08 CURSOR(	cd_pessoa_fisica_pc	pessoa_fisica.cd_pessoa_fisica%type,
		nr_seq_segurado_pc	pls_segurado.nr_sequencia%type) FOR
	SELECT	nr_sequencia nr_seq_segurado
	from	pls_segurado
	where	cd_pessoa_fisica = cd_pessoa_fisica_pc
	and	nr_sequencia <> nr_seq_segurado_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_cancelamento::text, '') = '';
	
BEGIN

if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	select	coalesce(nr_seq_prestador,0),
		ie_estagio,
		coalesce(ie_tipo_processo, 'X'),
		coalesce(ie_tipo_intercambio, 'X')
	into STRICT	nr_seq_prestador_w,
		ie_estagio_w,
		ie_tipo_processo_w,
		ie_tipo_intercambio_w
	from	pls_requisicao
	where	nr_sequencia	= nr_seq_requisicao_p;
	
	begin
		select	nr_seq_contrato,
			cd_pessoa_fisica
		into STRICT	nr_seq_contrato_w,
			cd_pessoa_fisica_w
		from	pls_segurado
		where	nr_sequencia = nr_seq_segurado_p;
	exception
	when others then
		nr_seq_contrato_w := 0;
	end;

	if (ie_estagio_w	in (4,6,7,10)) then
		nr_seq_requisicao_w	:= nr_seq_requisicao_p;
		open C00;
		loop
		fetch C00 into
			nr_seq_processo_w;
		EXIT WHEN NOT FOUND; /* apply on C00 */
			begin
			
			select	count(1)
			into STRICT	qt_ocorr_liminar_antiga_w
			from	pls_ocorrencia		a,
				pls_ocorrencia_regra	b
			where	a.nr_sequencia		= b.nr_seq_ocorrencia
			and	a.ie_situacao		= 'A'
			and	a.ie_auditoria		= 'S'
			and	b.ie_aplicacao_regra	= 'A'
			and	b.ie_possui_liminar	= 'S';
			
			if (qt_ocorr_liminar_antiga_w > 0) then
				open C05;
				loop
				fetch C05 into
					nr_seq_ocorrencia_w,
					nr_seq_regra_w;
				EXIT WHEN NOT FOUND; /* apply on C05 */
					begin
					select	count(*)
					into STRICT	qt_reg_proc_w
					from	processo_judicial_proc
					where	nr_seq_processo	= nr_seq_processo_w;
					
					select	count(*)
					into STRICT	qt_reg_mat_w
					from	processo_judicial_mat
					where	nr_seq_processo	= nr_seq_processo_w;
					
					select	count(*)
					into STRICT	qt_reg_prest_w
					from	processo_judicial_prest
					where	nr_seq_processo	= nr_seq_processo_w;
					if	((qt_reg_proc_w	> 0) or (qt_reg_mat_w	> 0) or (qt_reg_prest_w	> 0))then
						
						open C02;
						loop
						fetch C02 into
							nr_seq_req_proc_w,
							cd_procedimento_w,
							ie_origem_proced_w;
						EXIT WHEN NOT FOUND; /* apply on C02 */
							begin
							SELECT * FROM pls_obter_estrut_proc(	cd_procedimento_w, ie_origem_proced_w, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w;
							select	count(*)
							into STRICT	qt_reg_proc_w
							from	processo_judicial_proc		a,
								processo_judicial_liminar	b
							where	b.nr_sequencia					= nr_seq_processo_w
							and	a.nr_seq_processo				= b.nr_sequencia
							and	coalesce(a.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w
							and	coalesce(a.ie_origem_proced,ie_origem_proc_w)	= ie_origem_proc_w
							and	coalesce(a.cd_grupo_proc,cd_grupo_w)			= cd_grupo_w
							and	coalesce(a.cd_especialidade, cd_especialidade_w)	= cd_especialidade_w
							and	coalesce(a.cd_area_procedimento, cd_area_w)		= cd_area_w
							and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
							
							if (qt_reg_proc_w	> 0) then
								if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
									ie_liminar_intercambio_w := 'S';
								else
									CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													nr_seq_req_proc_w, null, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
								end if;
							end if;
							end;
						end loop;
						close C02;
						
						open C03;
						loop
						fetch C03 into
							nr_seq_req_mat_w,
							nr_seq_material_w;
						EXIT WHEN NOT FOUND; /* apply on C03 */
							begin
							select	count(*)
							into STRICT	qt_reg_mat_w
							from	processo_judicial_mat		a,
								processo_judicial_liminar	b
							where	b.nr_sequencia					= nr_seq_processo_w
							and	a.nr_seq_processo				= b.nr_sequencia
							and (coalesce(a.nr_seq_material::text, '') = '' or	a.nr_seq_material	= nr_seq_material_w)
							and (coalesce(a.nr_seq_estrut_mat::text, '') = '' or	
								pls_obter_se_estruturas_mat(a.nr_seq_estrut_mat, nr_seq_material_w)  = 'S')
							and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
							
							if (qt_reg_mat_w	> 0) then
								if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
									ie_liminar_intercambio_w := 'S';
								else
									CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													null, nr_seq_req_mat_w, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
								end if;
							end if;
							end;
						end loop;
						close C03;
						
						if (nr_seq_prestador_w	<> 0) then
							select	count(*)
							into STRICT	qt_reg_prest_w
							from	processo_judicial_prest		a,
								processo_judicial_liminar	b
							where	b.nr_sequencia		= nr_seq_processo_w
							and	a.nr_seq_processo	= b.nr_sequencia
							and	a.nr_seq_prestador	= nr_seq_prestador_w
							and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
							
							if (qt_reg_prest_w	> 0) then
								if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
									ie_liminar_intercambio_w := 'S';
								else
									CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													null, null, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
								end if;
							end if;
						end if;
					else
						if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
							ie_liminar_intercambio_w := 'S';
						else
							CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													null, null, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
						end if;
					end if;
					end;
				end loop;
				close C05;
			else
				open C06;
				loop
				fetch C06 into
					nr_seq_ocorrencia_w,
					nr_seq_regra_w;
				EXIT WHEN NOT FOUND; /* apply on C06 */
					begin
					select	count(*)
					into STRICT	qt_reg_proc_w
					from	processo_judicial_proc
					where	nr_seq_processo	= nr_seq_processo_w;
					
					select	count(*)
					into STRICT	qt_reg_mat_w
					from	processo_judicial_mat
					where	nr_seq_processo	= nr_seq_processo_w;
					
					select	count(*)
					into STRICT	qt_reg_prest_w
					from	processo_judicial_prest
					where	nr_seq_processo	= nr_seq_processo_w;
					if	((qt_reg_proc_w	> 0) or (qt_reg_mat_w	> 0) or (qt_reg_prest_w	> 0))then
						
						open C02;
						loop
						fetch C02 into
							nr_seq_req_proc_w,
							cd_procedimento_w,
							ie_origem_proced_w;
						EXIT WHEN NOT FOUND; /* apply on C02 */
							begin
							SELECT * FROM pls_obter_estrut_proc(	cd_procedimento_w, ie_origem_proced_w, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w;
							select	count(*)
							into STRICT	qt_reg_proc_w
							from	processo_judicial_proc		a,
								processo_judicial_liminar	b
							where	b.nr_sequencia					= nr_seq_processo_w
							and	a.nr_seq_processo				= b.nr_sequencia
							and	coalesce(a.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w
							and	coalesce(a.ie_origem_proced,ie_origem_proc_w)	= ie_origem_proc_w
							and	coalesce(a.cd_grupo_proc,cd_grupo_w)			= cd_grupo_w
							and	coalesce(a.cd_especialidade, cd_especialidade_w)	= cd_especialidade_w
							and	coalesce(a.cd_area_procedimento, cd_area_w)		= cd_area_w
							and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
							
							if (qt_reg_proc_w	> 0) then
								if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
									ie_liminar_intercambio_w := 'S';
								else
									CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													nr_seq_req_proc_w, null, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
								end if;
							end if;
							end;
						end loop;
						close C02;
						
						open C03;
						loop
						fetch C03 into
							nr_seq_req_mat_w,
							nr_seq_material_w;
						EXIT WHEN NOT FOUND; /* apply on C03 */
							begin
							select	count(*)
							into STRICT	qt_reg_mat_w
							from	processo_judicial_mat		a,
								processo_judicial_liminar	b
							where	b.nr_sequencia					= nr_seq_processo_w
							and	a.nr_seq_processo				= b.nr_sequencia
							and (coalesce(a.nr_seq_material::text, '') = '' or	a.nr_seq_material	= nr_seq_material_w)
							and (coalesce(a.nr_seq_estrut_mat::text, '') = '' or	
								pls_obter_se_estruturas_mat(a.nr_seq_estrut_mat, nr_seq_material_w)  = 'S')
							and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
							
							if (qt_reg_mat_w	> 0) then
								if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
									ie_liminar_intercambio_w := 'S';
								else
									CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													null, nr_seq_req_mat_w, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
								end if;
							end if;
							end;
						end loop;
						close C03;
						
						if (nr_seq_prestador_w	<> 0) then
							select	count(*)
							into STRICT	qt_reg_prest_w
							from	processo_judicial_prest		a,
								processo_judicial_liminar	b
							where	b.nr_sequencia		= nr_seq_processo_w
							and	a.nr_seq_processo	= b.nr_sequencia
							and	a.nr_seq_prestador	= nr_seq_prestador_w
							and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
							
							if (qt_reg_prest_w	> 0) then
								if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
									ie_liminar_intercambio_w := 'S';
								else
									CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													null, null, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
								end if;
							end if;
						end if;
					else
						if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') then
							ie_liminar_intercambio_w := 'S';
						else
							CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
													null, null, nr_seq_segurado_p,
													nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
						end if;
					end if;
					end;
				end loop;
				close C06;
			end if;
			end;
		end loop;
		close C00;

		if (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'I') and (ie_liminar_intercambio_w = 'S') then

			select	count(1)
			into STRICT	qt_ped_w
			from	ptu_pedido_autorizacao
			where	nr_seq_requisicao = nr_seq_requisicao_w;
			
			if (qt_ped_w > 0) then
				
				update	ptu_pedido_autorizacao
				set	ie_liminar = 'S'
				where	nr_seq_requisicao = nr_seq_requisicao_w;

				CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L', 'A ' || lower(wheb_mensagem_pck.get_texto(1110191)) || ' teve o campo "Liminar" marcado, devido a liminar ' || lower(wheb_mensagem_pck.get_texto(1110193)) || ': ' || nr_seq_processo_w,null,nm_usuario_p);
			else
				select	count(1)
				into STRICT	qt_ped_w
				from	ptu_pedido_compl_aut
				where	nr_seq_requisicao = nr_seq_requisicao_w;
				
				if (qt_ped_w > 0) then
				
					update	ptu_pedido_compl_aut
					set	ie_liminar = 'S'
					where	nr_seq_requisicao = nr_seq_requisicao_w;
				
					CALL pls_requisicao_gravar_hist(nr_seq_requisicao_w,'L', 'A ' || lower(wheb_mensagem_pck.get_texto(1110191)) || ' teve o campo "Liminar" marcado, devido a liminar ' || lower(wheb_mensagem_pck.get_texto(1110193)) || ': ' || nr_seq_processo_w,null,nm_usuario_p);
				end if;
			end if;
		end if;
	end if;
else	
	select	coalesce(nr_seq_contrato,0),
		coalesce(ie_impacto_reajuste,'N'),
		coalesce(ie_considera_codigo_pf, 'N')
	into STRICT	nr_seq_contrato_w,
		ie_impacto_reajuste_w,
		ie_considera_codigo_pf_w
	from	processo_judicial_liminar
	where	nr_sequencia = nr_seq_processo_p;
	
	open C01;
	loop
	fetch C01 into
		nr_seq_auditoria_w,
		nr_seq_requisicao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	coalesce(nr_seq_prestador,0)
		into STRICT	nr_seq_prestador_w
		from	pls_requisicao
		where	nr_sequencia	= nr_seq_requisicao_w;
		
		open C05;
		loop
		fetch C05 into
			nr_seq_ocorrencia_w,
			nr_seq_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			select	count(*)
			into STRICT	qt_reg_proc_w
			from	processo_judicial_proc
			where	nr_seq_processo	= nr_seq_processo_w;
			
			select	count(*)
			into STRICT	qt_reg_mat_w
			from	processo_judicial_mat
			where	nr_seq_processo	= nr_seq_processo_w;
			
			select	count(*)
			into STRICT	qt_reg_prest_w
			from	processo_judicial_prest
			where	nr_seq_processo	= nr_seq_processo_w;
			
			if	((qt_reg_proc_w	> 0) or (qt_reg_mat_w	> 0) or (qt_reg_prest_w	> 0))then
				open C02;
				loop
				fetch C02 into
					nr_seq_req_proc_w,
					cd_procedimento_w,
					ie_origem_proced_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					SELECT * FROM pls_obter_estrut_proc(	cd_procedimento_w, ie_origem_proced_w, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proc_w;
					select	count(*)
					into STRICT	qt_reg_proc_w
					from	processo_judicial_proc		a,
						processo_judicial_liminar	b
					where	b.nr_sequencia					= nr_seq_processo_p
					and	a.nr_seq_processo				= b.nr_sequencia
					and	coalesce(a.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w
					and	coalesce(a.ie_origem_proced,ie_origem_proc_w)	= ie_origem_proc_w
					and	coalesce(a.cd_grupo_proc,cd_grupo_w)			= cd_grupo_w
					and	coalesce(a.cd_especialidade, cd_especialidade_w)	= cd_especialidade_w
					and	coalesce(a.cd_area_procedimento, cd_area_w)		= cd_area_w
					and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
					
					if (qt_reg_proc_w	> 0) then
						CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
										nr_seq_req_proc_w, null, nr_seq_segurado_p,
										nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
					end if;
					end;
				end loop;
				close C02;
				
				open C03;
				loop
				fetch C03 into
					nr_seq_req_mat_w,
					nr_seq_material_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					select	count(*)
					into STRICT	qt_reg_mat_w
					from	processo_judicial_mat		a,
						processo_judicial_liminar	b
					where	b.nr_sequencia					= nr_seq_processo_p
					and	a.nr_seq_processo				= b.nr_sequencia
					and (coalesce(a.nr_seq_material::text, '') = '' or	a.nr_seq_material	= nr_seq_material_w)
					and (coalesce(a.nr_seq_estrut_mat::text, '') = '' or	
							pls_obter_se_estruturas_mat(a.nr_seq_estrut_mat, nr_seq_material_w)  = 'S')
					and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
					if (qt_reg_mat_w	> 0) then
						CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
										null, nr_seq_req_mat_w, nr_seq_segurado_p,
										nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
					end if;
					end;
				end loop;
				close C03;
				
				if (nr_seq_prestador_w	<> 0) then
					select	count(*)
					into STRICT	qt_reg_prest_w
					from	processo_judicial_prest		a,
						processo_judicial_liminar	b
					where	b.nr_sequencia		= nr_seq_processo_p
					and	a.nr_seq_processo	= b.nr_sequencia
					and	a.nr_seq_prestador	= nr_seq_prestador_w
					and	clock_timestamp()	between(b.dt_inicio_validade) and (fim_dia(coalesce(b.dt_fim_validade,clock_timestamp())));
					
					if (qt_reg_prest_w	> 0) then
						CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
										null, null, nr_seq_segurado_p,
										nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
					end if;
				end if;
			else
				CALL pls_inserir_ocorr_req_benef(	nr_seq_ocorrencia_w, nr_seq_regra_w, nr_seq_requisicao_w,
											null, null, nr_seq_segurado_p,
											nr_seq_auditoria_w, nm_usuario_p, cd_estabelecimento_p);
			end if;
			end;
		end loop;
		close C05;
		end;
	end loop;
	close C01;
	
	if (ie_impacto_reajuste_w = 'S') then
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_processo_judicial_reaj
		where	nr_seq_processo	= nr_seq_processo_p
		and	((tx_reajuste IS NOT NULL AND tx_reajuste::text <> '') or (ie_impedir_reaj_indice = 'S'));
		
		if	((coalesce(qt_registro_w, 0) > 0) and (coalesce(nr_seq_segurado_p, 0) > 0)) then
			
			select	coalesce(max(ie_considerar_dependente), 'N')
			into STRICT	ie_considerar_dependente_w
			from	pls_processo_judicial_reaj
			where	nr_seq_processo = nr_seq_processo_p
			and	ie_considerar_dependente = 'S'; -- Nao pode considerar a vigencia dessa regra, pois se o reajuste for no mes posterior a liberacao acaba desconsiderando esta regra, caso a regra nao esteja vigente no "sysdate"
			
			select	coalesce(nr_seq_titular, nr_sequencia),
				cd_pessoa_fisica
			into STRICT	nr_seq_segurado_w,
				cd_pessoa_fisica_w
			from	pls_segurado
			where	nr_sequencia = nr_seq_segurado_p;
			
			for r_c07_w in c07(	ie_considerar_dependente_w,
						nr_seq_segurado_w) loop
				begin
				
				nr_seq_nova_tabela_w	:= null;
				
				select	max(nr_seq_tabela),
					max(nr_seq_contrato),
					max(nr_seq_plano)
				into STRICT	nr_seq_tabela_w,
					nr_seq_contrato_w,
					nr_seq_plano_w
				from	pls_segurado
				where	nr_sequencia	= r_c07_w.nr_seq_segurado;
				
				if (nr_seq_tabela_w IS NOT NULL AND nr_seq_tabela_w::text <> '') then
					nr_seq_nova_tabela_w := pls_duplicar_tab_preco_benef(	r_c07_w.nr_seq_segurado, nr_seq_tabela_w, nr_seq_nova_tabela_w, cd_estabelecimento_p, nm_usuario_p, 'N');
					
					if (nr_seq_nova_tabela_w IS NOT NULL AND nr_seq_nova_tabela_w::text <> '') then
						CALL pls_alterar_tabela_segurado(	nr_seq_contrato_w, r_c07_w.nr_seq_segurado, null,
										nr_seq_plano_w, nr_seq_nova_tabela_w, 'B',
										cd_estabelecimento_p, nm_usuario_p, clock_timestamp(),
										'S', 'S', 'S',
										nr_seq_tabela_w, 'S', 'N',
										nr_seq_tabela_w);
					end if;
				end if;
				end;
			end loop;
			
			if (ie_considera_codigo_pf_w = 'S') then
				for r_c08_w in c08(	cd_pessoa_fisica_w,
							nr_seq_segurado_p) loop
					begin
					nr_seq_nova_tabela_w	:= null;
					
					select	max(nr_seq_tabela),
						max(nr_seq_contrato),
						max(nr_seq_plano)
					into STRICT	nr_seq_tabela_w,
						nr_seq_contrato_w,
						nr_seq_plano_w
					from	pls_segurado
					where	nr_sequencia	= r_c08_w.nr_seq_segurado;
					
					if (nr_seq_tabela_w IS NOT NULL AND nr_seq_tabela_w::text <> '') then
						nr_seq_nova_tabela_w := pls_duplicar_tab_preco_benef(	r_c08_w.nr_seq_segurado, nr_seq_tabela_w, nr_seq_nova_tabela_w, cd_estabelecimento_p, nm_usuario_p, 'N');
						
						if (nr_seq_nova_tabela_w IS NOT NULL AND nr_seq_nova_tabela_w::text <> '') then
							CALL pls_alterar_tabela_segurado(	nr_seq_contrato_w, r_c08_w.nr_seq_segurado, null,
											nr_seq_plano_w, nr_seq_nova_tabela_w, 'B',
											cd_estabelecimento_p, nm_usuario_p, clock_timestamp(),
											'S', 'S', 'S',
											nr_seq_tabela_w, 'S', 'N',
											nr_seq_tabela_w);
						end if;
					end if;
					end;
				end loop;
			end if;
		end if;
	end if;
	
	update	processo_judicial_liminar
	set	ie_estagio	= 2,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_liberacao	= clock_timestamp(),
		nm_usuario_lib	= nm_usuario_p
	where	nr_sequencia	= nr_seq_processo_p;
end if;

nr_seq_regra_p	:= nr_seq_regra_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_ocorr_liminar_judic ( nr_seq_segurado_p bigint, nr_seq_processo_p bigint, nr_seq_requisicao_p bigint, nm_usuario_p text, nr_seq_regra_p INOUT bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

