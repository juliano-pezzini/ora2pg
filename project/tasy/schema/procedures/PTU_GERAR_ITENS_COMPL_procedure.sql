-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_itens_compl ( nr_seq_pedido_aut_compl_p ptu_pedido_compl_aut.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


ie_origem_proced_w		bigint;
ie_origem_padrao_scs_w 		bigint;
ie_origem_conversao_w		bigint;
ie_origem_recebida_w		bigint;
ie_regra_interna_valor_w	pls_param_intercambio_scs.ie_regra_interna_valor%type;
ie_somente_codigo_w		pls_conversao_proc.ie_somente_codigo%type;
cd_servico_w  			ptu_pedido_compl_aut_serv.cd_servico%type;
cd_procedimento_w		procedimento.cd_procedimento%type;
cd_procedimento_ptu_w		procedimento.cd_procedimento%type;
cd_servico_conversao_w		procedimento.cd_procedimento%type;
nr_seq_regra_w			pls_conversao_proc.nr_sequencia%type;
nr_seq_material_w		pls_material.nr_sequencia%type;
ds_material_w			material.ds_material%type;
dt_referencia_w			timestamp;

nr_seq_req_proc_w		pls_requisicao_proc.nr_sequencia%type;
nr_seq_guia_proc_w		pls_guia_plano_proc.nr_sequencia%type;
nr_seq_req_mat_w		pls_requisicao_mat.nr_sequencia%type;
nr_seq_guia_mat_w		pls_guia_plano_mat.nr_sequencia%type;

qt_reg_proc_w			integer;


C01 CURSOR( nr_seq_pedido_aut_compl_pc  	ptu_pedido_compl_aut.nr_sequencia%type ) FOR
	SELECT	a.nr_seq_guia,
		a.nr_seq_requisicao,
		(SELECT	max(c.nr_sequencia)
		from	pls_congenere c
		where	c.cd_cooperativa = a.cd_unimed_beneficiario
		and 	c.ie_situacao 	= 'A') nr_seq_congenere,
		b.nr_sequencia nr_seq_aut_serv,
		b.vl_uni_servico,
		b.ie_tipo_tabela,
		b.cd_servico,
		b.qt_servico,
		b.ds_opme,
		b.ie_tipo_anexo,
		b.ie_pacote,
		b.cd_anvisa,
		b.cd_referencia_fab,
		b.ie_origem_servico
	from	ptu_pedido_compl_aut a,
		ptu_pedido_compl_aut_serv b
	where	b.nr_seq_pedido = a.nr_sequencia
	and	a.nr_sequencia = nr_seq_pedido_aut_compl_pc;

BEGIN

dt_referencia_w	:= trunc(clock_timestamp(),'dd');

--Validacao regra de valorizacao depois  de gerar os itens na autorizacao / requisicao chama estas rotinas
select	max(ie_regra_interna_valor)
into STRICT	ie_regra_interna_valor_w
from	pls_param_intercambio_scs;

--Carrega os itens importados no pedido de autorizacao
for c01_w in C01( nr_seq_pedido_aut_compl_p ) loop

	ie_origem_recebida_w	:= c01_w.ie_origem_servico;
	ie_origem_proced_w	:= null;	
	nr_seq_req_mat_w	:= null;
	nr_seq_guia_mat_w	:= null;
	nr_seq_req_proc_w	:= null;
	nr_seq_guia_proc_w	:= null;

	--0 = ROL Unimed/AMB/CBHPM.

	--1 = Servicos Hospitalares / Taxas / Complementos (Codigos da Tabela C - Anexo 01)

	--4 = Servico com Custo Fechado / Pacote (ainda sem codigos definidos)
	if ( c01_w.ie_tipo_tabela	in ('0','1','4')) then
	
		if (c01_w.ie_tipo_tabela <> '4') then
			select	count(1)
			into STRICT	qt_reg_proc_w
			from	procedimento
			where	cd_procedimento	= c01_w.cd_servico
			and	ie_situacao	= 'A';
		else
			select	count(1)
			into STRICT	qt_reg_proc_w
			from	procedimento
			where	cd_procedimento	= c01_w.cd_servico
			and	ie_origem_proced = 4 -- Propria
			and	ie_situacao	= 'A';			
		end if;

		/* Se encontrar o procedimento na base e o tipo de tabela enviada no arquivo for "0 - Rol de Procedimentos Unimed" e verificada a regra de origem padrao na funcao
		OPS - Gestao de Operadoras > Parametros da OPS > Intercambio > Intercambio SCS */
		if (qt_reg_proc_w	> 0) and (c01_w.ie_tipo_tabela	= '0') then
			begin
				select	max(ie_origem_proced_padrao)
				into STRICT	ie_origem_proced_w
				from	pls_param_intercambio_scs;
			exception
			when others then
				ie_origem_proced_w	:= null;
			end;

			-- Se encontrar regra de origem padrao, sera verificado novamente se existe cadastro do procedimento na base, mas com a origem padrao cadastrada
			if (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
				select	count(1)
				into STRICT	qt_reg_proc_w
				from	procedimento
				where	cd_procedimento		= c01_w.cd_servico
				and	ie_origem_proced	= ie_origem_proced_w
				and	ie_situacao		= 'A';
			end if;
		end if;

		if (qt_reg_proc_w	> 0) then
			if (c01_w.ie_tipo_tabela	= '4') then
				select	count(1)
				into STRICT	qt_reg_proc_w
				from	procedimento
				where	cd_procedimento		= c01_w.cd_servico
				and	ie_origem_proced	= 4 -- Propria
				and	ie_situacao		= 'A';

				if (qt_reg_proc_w	> 0) then
					ie_origem_proced_w	:= 4; -- Propria
				end if;
			end if;


			if ( coalesce(ie_origem_proced_w::text, '') = '' ) then
				-- Se nao encontrar origem padrao cadastrada na regra da funcao OPS - Gestao de Operadoras > Parametros da OPS > Intercambio > Intercambio SCS, esta origem sera obtida do select abaixo
				select	max(ie_origem_proced)
				into STRICT	ie_origem_proced_w
				from    procedimento
				where   cd_procedimento		= c01_w.cd_servico
				and	ie_origem_proced	in (1,4,5,8)
				and	ie_situacao		= 'A';
			end if;
			
			SELECT * FROM pls_obter_proced_conversao(	c01_w.cd_servico, ie_origem_proced_w, null, cd_estabelecimento_p, 3, c01_w.nr_seq_congenere, 2, 'R', null, null, null, null, null, cd_servico_conversao_w, ie_origem_conversao_w, nr_seq_regra_w, ie_somente_codigo_w, clock_timestamp(), null, null, null) INTO STRICT cd_servico_conversao_w, ie_origem_conversao_w, nr_seq_regra_w, ie_somente_codigo_w;

			if ( c01_w.cd_servico	<> cd_servico_conversao_w ) then
				cd_procedimento_ptu_w	:= c01_w.cd_servico;
			end if;

			cd_servico_w	:= coalesce(cd_servico_conversao_w, c01_w.cd_servico);
		else
			--Se nao encontrar nenhuma origem o sistema tentar buscar a origem de uma regra especifica de conversao de itens
			begin
				select	cd_procedimento,
					ie_origem_proced
				into STRICT	cd_procedimento_w,
					ie_origem_proced_w
				from	pls_conv_item_inexist_ptu
				where	ie_tipo_tabela		= c01_w.ie_tipo_tabela
				and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '')
				and	(ie_origem_proced IS NOT NULL AND ie_origem_proced::text <> '')
				and	ie_situacao		= 'A';
			exception
			when others then
				cd_procedimento_w 	:= null;
				ie_origem_proced_w	:= null;
				cd_procedimento_ptu_w	:= null;
			end;

			if	(ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '' AND cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
				cd_servico_conversao_w	:= cd_procedimento_w;
				ie_origem_conversao_w	:= ie_origem_proced_w;
				cd_procedimento_ptu_w	:= null;
				cd_servico_w		:= coalesce(cd_servico_conversao_w, c01_w.cd_servico);
			else
				--Se nao encontrar nenhum item na base o sistema vai gerar inconsistencia
				cd_servico_conversao_w	:= null;
				ie_origem_conversao_w	:= null;
				cd_procedimento_ptu_w	:= null;
				cd_servico_w		:= null;
			end if;

		end if;

		if (c01_w.nr_seq_requisicao IS NOT NULL AND c01_w.nr_seq_requisicao::text <> '') then

			insert	into pls_requisicao_proc(nr_sequencia, cd_procedimento, qt_solicitado,
				ie_status, nr_seq_requisicao, dt_atualizacao,
				nm_usuario, ie_origem_proced, vl_procedimento,
				ie_estagio, cd_procedimento_ptu, ds_procedimento_ptu,
				ie_tipo_anexo, ie_pacote_ptu)
			values (nextval('pls_requisicao_proc_seq'), cd_servico_w, c01_w.qt_servico,
				CASE WHEN coalesce(ie_origem_proced_w::text, '') = '' THEN  'N'  ELSE 'U' END , c01_w.nr_seq_requisicao, clock_timestamp(),
				nm_usuario_p, coalesce(ie_origem_conversao_w,ie_origem_proced_w), c01_w.vl_uni_servico,
				CASE WHEN coalesce(ie_origem_proced_w::text, '') = '' THEN  'N'  ELSE 'AE' END , cd_procedimento_ptu_w, c01_w.ds_opme,
				CASE WHEN c01_w.ie_tipo_anexo=1 THEN 'QU' WHEN c01_w.ie_tipo_anexo=2 THEN 'RA' WHEN c01_w.ie_tipo_anexo=3 THEN 'OP' WHEN c01_w.ie_tipo_anexo=9 THEN '' END , c01_w.ie_pacote) returning nr_sequencia into nr_seq_req_proc_w;


			--Se nao encontrar nenhum item na base o sistema vai gerar inconsistencia
			if ( coalesce(ie_origem_proced_w::text, '') = '' ) then
				CALL ptu_inserir_inconsistencia(	null, null, 2009,
								'',cd_estabelecimento_p, c01_w.nr_seq_requisicao,
								'R', '00501', nr_seq_req_proc_w,
								null, null, nm_usuario_p);

				CALL ptu_inserir_inconsistencia(	null, null, 2009,
								'',cd_estabelecimento_p, c01_w.nr_seq_requisicao,
								'R', '00404', nr_seq_req_proc_w,
								null, null, nm_usuario_p);
			end if;

		elsif (c01_w.nr_seq_guia IS NOT NULL AND c01_w.nr_seq_guia::text <> '') then

			insert	into pls_guia_plano_proc(nr_sequencia, cd_procedimento, qt_solicitada,
				ie_status, nr_seq_guia, dt_atualizacao,
				nm_usuario, ie_origem_proced, vl_procedimento,
				ie_tipo_anexo, ie_pacote_ptu, cd_procedimento_ptu,
				ds_procedimento_ptu)
			values (nextval('pls_guia_plano_proc_seq'), coalesce(cd_servico_conversao_w,c01_w.cd_servico),  c01_w.qt_servico,
				'U', c01_w.nr_seq_guia, clock_timestamp(),
				nm_usuario_p, coalesce(ie_origem_conversao_w,ie_origem_proced_w), c01_w.vl_uni_servico,
				CASE WHEN c01_w.ie_tipo_anexo=1 THEN 'QU' WHEN c01_w.ie_tipo_anexo=2 THEN 'RA' WHEN c01_w.ie_tipo_anexo=3 THEN 'OP' WHEN c01_w.ie_tipo_anexo=9 THEN '' END , c01_w.ie_pacote, cd_procedimento_ptu_w,
				c01_w.ds_opme) returning nr_sequencia into nr_seq_guia_proc_w;


			if (ie_regra_interna_valor_w = 'S' and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '')) then
				CALL pls_atualiza_valor_proc_aut(nr_seq_guia_proc_w, 'A', nm_usuario_p);
			end if;

			--Se nao encontrar nenhum item na base o sistema vai gerar inconsistencia
			if ( coalesce(ie_origem_proced_w::text, '') = '' ) then

				CALL ptu_inserir_inconsistencia(null, null, 2009,
							'',cd_estabelecimento_p, c01_w.nr_seq_guia,
							'G', '00501', nr_seq_guia_proc_w,
							null, null, nm_usuario_p);

				CALL ptu_inserir_inconsistencia(null, null, 2009,
							'',cd_estabelecimento_p, c01_w.nr_seq_guia,
							'G', '00404', nr_seq_guia_proc_w,
							null, null, nm_usuario_p);
			end if;
		end if;

	--2 = Materiais (Codigos da Tabela E - Anexo 01)

	--3 = Medicamentos (Codigos da Tabela D - Anexo 01)
	elsif ( c01_w.ie_tipo_tabela in ('2','3','5','6')) then

		SELECT * FROM ptu_gerar_mat_envio_intercamb(c01_w.cd_servico, 'R', c01_w.ie_tipo_tabela, null, nm_usuario_p, cd_servico_conversao_w, ds_material_w) INTO STRICT cd_servico_conversao_w, ds_material_w;

		if (cd_servico_conversao_w IS NOT NULL AND cd_servico_conversao_w::text <> '') then

			select	max(nr_sequencia)
			into STRICT	nr_seq_material_w
			from	pls_material
			where	cd_material_ops	= to_char(cd_servico_conversao_w)
			and	dt_referencia_w	between dt_inclusao and (coalesce(dt_exclusao,dt_referencia_w));

			if (coalesce(nr_seq_material_w::text, '') = '') then
				SELECT * FROM pls_obter_mat_a900_vigente( nr_seq_material_w, clock_timestamp(), cd_servico_conversao_w, null) INTO STRICT  nr_seq_material_w, cd_servico_conversao_w;
			end if;

		else
			nr_seq_material_w	:= substr(pls_obter_seq_codigo_material('',c01_w.cd_servico),1,8);
		end if;

		select	max(nr_sequencia)
		into STRICT	nr_seq_material_w
		from	pls_material
		where	nr_sequencia	= nr_seq_material_w;

		---Esta validacao se aplica somente para Guia
		if ( coalesce(nr_seq_material_w::text, '') = '') then
			select	nr_seq_material
			into STRICT	nr_seq_material_w
			from	pls_conv_item_inexist_ptu
			where	(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '')
			and	ie_tipo_tabela		= c01_w.ie_tipo_tabela
			and	ie_situacao		= 'A';

			if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
				select	max(cd_material_ops)
				into STRICT	cd_servico_conversao_w
				from	pls_material
				where	nr_sequencia	= nr_seq_material_w;
			end if;
		end if;


		if (c01_w.nr_seq_requisicao IS NOT NULL AND c01_w.nr_seq_requisicao::text <> '') then

			insert	into pls_requisicao_mat(nr_sequencia, nr_seq_material, qt_solicitado,
				ie_status, nr_seq_requisicao, dt_atualizacao,
				nm_usuario, vl_material, ie_estagio,
				cd_material_ptu, ds_material_ptu, ie_tipo_anexo,
				nr_registro_anvisa, cd_ref_fabricante_imp)
			values ( nextval('pls_requisicao_mat_seq'), nr_seq_material_w, c01_w.qt_servico,
				'U', c01_w.nr_seq_requisicao, clock_timestamp(),
				nm_usuario_p,  c01_w.vl_uni_servico, CASE WHEN coalesce(nr_seq_material_w::text, '') = '' THEN  'N'  ELSE 'AE' END ,
				c01_w.cd_servico, c01_w.ds_opme, CASE WHEN c01_w.ie_tipo_anexo=1 THEN 'QU' WHEN c01_w.ie_tipo_anexo=2 THEN 'RA' WHEN c01_w.ie_tipo_anexo=3 THEN 'OP' WHEN c01_w.ie_tipo_anexo=9 THEN '' END ,
				c01_w.cd_anvisa, c01_w.cd_referencia_fab) returning nr_sequencia into nr_seq_req_mat_w;

			if ( coalesce(nr_seq_material_w::text, '') = '' ) then
				CALL ptu_inserir_inconsistencia(	null, null, 2009,
								'',cd_estabelecimento_p, c01_w.nr_seq_requisicao,
								'R', '00501', null,
								nr_seq_req_mat_w, null, nm_usuario_p);

				CALL ptu_inserir_inconsistencia(	null, null, 2009,
								'',cd_estabelecimento_p, c01_w.nr_seq_requisicao,
								'R', '00404', null,
								nr_seq_req_mat_w, null, nm_usuario_p);

			end if;

		elsif (c01_w.nr_seq_guia IS NOT NULL AND c01_w.nr_seq_guia::text <> '') then

			insert	into pls_guia_plano_mat(nr_sequencia, nr_seq_material, qt_solicitada,
				ie_status, nr_seq_guia, dt_atualizacao,
				nm_usuario, vl_material, ie_tipo_anexo,
				cd_material_ptu, ds_material_ptu, nr_registro_anvisa,
				cd_ref_fabricante_imp)
			values ( nextval('pls_guia_plano_mat_seq'), nr_seq_material_w, c01_w.qt_servico,
				'U', c01_w.nr_seq_guia, clock_timestamp(),
				nm_usuario_p,  c01_w.vl_uni_servico, CASE WHEN c01_w.ie_tipo_anexo=1 THEN 'QU' WHEN c01_w.ie_tipo_anexo=2 THEN 'RA' WHEN c01_w.ie_tipo_anexo=3 THEN 'OP' WHEN c01_w.ie_tipo_anexo=9 THEN '' END ,
				c01_w.cd_servico, c01_w.ds_opme, c01_w.cd_anvisa,
				c01_w.cd_referencia_fab) returning nr_sequencia into nr_seq_guia_mat_w;

			if (ie_regra_interna_valor_w 	= 'S' and   (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') ) then
				CALL pls_atualiza_valor_mat_aut(nr_seq_guia_mat_w, 'A', nm_usuario_p);

			elsif ( coalesce(nr_seq_material_w::text, '') = '' ) then

				CALL ptu_inserir_inconsistencia(	null, null, 2009,
								'',cd_estabelecimento_p, c01_w.nr_seq_guia,
								'G', '00501', null,
								nr_seq_guia_mat_w, null, nm_usuario_p);

				CALL ptu_inserir_inconsistencia(	null, null, 2009,
								'',cd_estabelecimento_p, c01_w.nr_seq_guia,
								'G', '00404', null,
								nr_seq_guia_mat_w, null, nm_usuario_p);
			end if;
		end if;
	end if;

	--Atualiza informacoes dos itens na tabela de servico do PTU
	update	ptu_pedido_compl_aut_serv
	set	nr_seq_guia_proc	= nr_seq_guia_proc_w,
		nr_seq_req_proc		= nr_seq_req_proc_w,
		nr_seq_guia_mat		= nr_seq_guia_mat_w,
		nr_seq_req_mat		= nr_seq_req_mat_w,
		cd_servico_conversao	= cd_servico_conversao_w,
		ie_origem_servico	= ie_origem_recebida_w
	where	nr_sequencia		= c01_w.nr_seq_aut_serv;

	commit;

end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_itens_compl ( nr_seq_pedido_aut_compl_p ptu_pedido_compl_aut.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
