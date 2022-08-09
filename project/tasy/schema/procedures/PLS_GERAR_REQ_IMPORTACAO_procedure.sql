-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_req_importacao ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_guia_plano_imp_p pls_guia_plano_imp.nr_sequencia%type, nr_seq_requisicao_p INOUT pls_requisicao.nr_sequencia%type) AS $body$
DECLARE

					
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Pega as informacos das tabelas IMP e gera a REQUISICAO 
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ x ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_guia_plano_w		pls_guia_plano.nr_sequencia%type;	
nr_seq_segurado_w      		pls_segurado.nr_sequencia%type;
cd_medico_solic_w		pessoa_fisica.cd_pessoa_fisica%type;
ie_carater_internacao_imp_w	pls_guia_plano.ie_carater_internacao%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
cd_procedimento_w		procedimento.cd_procedimento%type;
ie_classificacao_w		pls_diagnostico.ie_classificacao%type := 'P';
dados_tipo_conv_tiss_w		pls_cta_valorizacao_pck.dados_tipo_conv_tiss;
cd_cgc_outorgante_w		pls_outorgante.cd_cgc_outorgante%type;
nr_seq_uni_exec_w		pls_requisicao.nr_seq_uni_exec%type;
ie_consulta_urgencia_w		pls_requisicao.ie_consulta_urgencia%type;
nr_seq_tipo_acomodacao_w	pls_plano_acomodacao.nr_seq_tipo_acomodacao%type;
nr_seq_categoria_w		pls_plano_acomodacao.nr_seq_categoria%type;
nr_seq_guia_principal_w		pls_requisicao.nr_seq_guia_principal%type;
ie_utilizar_prest_solic_w		pls_param_importacao_guia.ie_utilizar_prest_solic%type;
nr_seq_prestador_w			pls_requisicao.nr_seq_prestador%type;

nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;
nr_seq_requisicao_proc_w	pls_requisicao_proc.nr_sequencia%type := 0;
nr_seq_requisicao_mat_w		pls_requisicao_mat.nr_sequencia%type := 0;

C01 CURSOR( nr_seq_guia_plano_imp_pc	pls_guia_plano_imp.nr_sequencia%type ) FOR
	SELECT	b.cd_usuario_plano,
		b.ie_tipo_guia,
		b.ie_recem_nascido,
		b.ds_indicacao_clinica,
		b.dt_sugerida_internacao,
		b.qt_diaria_solic,
		b.dt_solicitacao,
		b.cd_guia_prestador,
		b.ie_regime_internacao,
		pls_obter_prestador_imp(b.cd_cgc_prest_solic, b.cd_cpf_prest_solic, b.cd_prestador_solic, '', '', '', 'G') nr_seq_prest_solic,
		pls_obter_prestador_imp('', '', b.cd_prestador_exec, '', '', '', 'G') nr_seq_prest_exec,
		pls_obter_dados_medico_imp(b.nr_conselho_prof_solic, pls_obter_sg_uf_tiss(b.cd_uf_conselho_prof_solic), b.cd_conselho_prof_solic, 'CP', 'G') cd_medico_solic,
		pls_obter_seq_conselho_tiss(b.cd_conselho_prof_solic) nr_seq_conselho,		
		pls_obter_dados_segurado_imp(b.cd_usuario_plano, 'SS', 'G') nr_seq_segurado,
		pls_obter_dados_segurado_imp(b.cd_usuario_plano, 'SP', 'G') nr_seq_plano,
		(SELECT	max(a.nr_sequencia)
		from	pls_clinica a
		where	((a.cd_tiss = b.ie_tipo_internacao) or (coalesce(a.cd_tiss::text, '') = '' and a.cd_clinica = b.ie_tipo_internacao))) nr_seq_clinica,
		(select	max(a.nr_sequencia)
		from	cbo_saude a
		where	a.cd_cbo	=  b.cd_cbo_saude
		and	((a.ie_situacao = 'A') or (coalesce(a.ie_situacao::text, '') = ''))) nr_seq_cbo_saude,
		b.cd_guia_principal,
		b.ie_carater_atendimento,
		b.ds_observacao,
		b.ie_anexo_guia,
		b.cd_versao,
		b.cd_ausencia_val_benef_tiss,
		b.cd_ident_biometria_benef,
		b.cd_template_biomet_benef,
		b.cd_validacao_benef_tiss,
		b.ie_tipo_ident_benef,
		b.ie_etapa_autorizacao,
		b.ie_cobertura_especial
	from	pls_guia_plano_imp b
	where	b.nr_sequencia = nr_seq_guia_plano_imp_pc;
		
C02 CURSOR( 	nr_seq_guia_plano_imp_pc	pls_guia_plano_imp.nr_sequencia%type,
		nr_seq_guia_plano_pc	  	pls_guia_plano.nr_sequencia%type) FOR
		
	SELECT	qt_solicitada,
		cd_tabela,              
		cd_procedimento,
		(SELECT a.nr_seq_prestador
		from	pls_guia_plano a
		where	a.nr_sequencia = nr_seq_guia_plano_pc) nr_seq_prestador
	from	pls_guia_plano_proc_imp
	where	nr_seq_guia_plano_imp = nr_seq_guia_plano_imp_p;
	
C03 CURSOR( nr_seq_guia_plano_imp_pc	pls_guia_plano_imp.nr_sequencia%type ) FOR
	SELECT	b.qt_solicitada,
		b.cd_tabela,              
		b.cd_material,
		(SELECT	max(a.nr_sequencia)
		from	pls_material a
		where	a.cd_material_ops = b.cd_material) nr_seq_material			
	from	pls_guia_plano_mat_imp b
	where	b.nr_seq_guia_plano_imp = nr_seq_guia_plano_imp_p;

C04 CURSOR( nr_seq_guia_plano_imp_pc	pls_guia_plano_imp.nr_sequencia%type ) FOR
	SELECT	b.cd_doenca,
		b.ie_indicador_acidente  			
	from	pls_guia_plano_diag_imp b
	where	b.nr_seq_guia_plano_imp = nr_seq_guia_plano_imp_p
	order by nr_sequencia asc;


BEGIN

begin

select	cd_cgc_outorgante
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante
where	cd_estabelecimento = cd_estabelecimento_p;

exception
when others then

select	max(cd_cgc_outorgante)
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante;	

end;

select	max(nr_sequencia)
into STRICT	nr_seq_uni_exec_w
from	pls_congenere
where	cd_cgc = cd_cgc_outorgante_w
and	(cd_cooperativa IS NOT NULL AND cd_cooperativa::text <> '');


--Realiza select dos campos IMP e cria a Guia nas tabelas quentes
for C01_w in C01( nr_seq_guia_plano_imp_p ) loop
	begin	
		select	nextval('pls_requisicao_seq')
		into STRICT	nr_seq_requisicao_w
		;
			
		if ( C01_w.ie_carater_atendimento = '1') then
			ie_carater_internacao_imp_w := 'E';
			ie_consulta_urgencia_w := 'N';
		elsif ( C01_w.ie_carater_atendimento = '2') then
			ie_carater_internacao_imp_w := 'U';
			ie_consulta_urgencia_w := 'S';
		end if;
	
		if (C01_w.ie_tipo_guia in ('1','8')) then
			select	max(a.nr_seq_tipo_acomodacao)
			into STRICT	nr_seq_tipo_acomodacao_w
			from	pls_plano_acomodacao	a,
				pls_plano b
			where	b.nr_sequencia		= C01_w.nr_seq_plano
			and	a.nr_seq_plano		= b.nr_sequencia
			and	a.ie_acomod_padrao 	= 'S';

				if (coalesce(nr_seq_tipo_acomodacao_w::text, '') = '') then
					select	max(a.nr_seq_categoria)
					into STRICT	nr_seq_categoria_w
					from	pls_plano_acomodacao	a,
						pls_plano b
					where	b.nr_sequencia		= C01_w.nr_seq_plano
					and	a.nr_seq_plano		= b.nr_sequencia
					and	a.ie_acomod_padrao 	= 'S';

					select	max(nr_seq_tipo_acomodacao)
					into STRICT	nr_seq_tipo_acomodacao_w
					from	pls_regra_categoria
					where	nr_seq_categoria	= nr_seq_categoria_w
					and	ie_acomod_padrao	= 'S';
				end if;
		end if;
		
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_guia_principal_w
		from	pls_guia_plano a
		where	a.cd_guia		= C01_w.cd_guia_principal
		and	a.nr_seq_segurado	= C01_w.nr_seq_segurado
		and	a.nr_seq_prestador	= C01_w.nr_seq_prest_exec;		
		
		if (coalesce(nr_seq_guia_principal_w::text, '') = '') then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_guia_principal_w
			from	pls_guia_plano a
			where	a.cd_guia		= C01_w.cd_guia_principal
			and	a.nr_seq_segurado	= C01_w.nr_seq_segurado
			and	a.nr_seq_prestador	= C01_w.nr_seq_prest_solic;
			
			if (coalesce(nr_seq_guia_principal_w::text, '') = '') then
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_guia_principal_w
				from	pls_guia_plano a
				where	a.cd_guia		= C01_w.cd_guia_principal
				and	a.nr_seq_segurado	= C01_w.nr_seq_segurado;
			end if;
		end if;
		
		begin
			select	coalesce(ie_utilizar_prest_solic, 'N')
			into STRICT		ie_utilizar_prest_solic_w
			from	pls_param_importacao_guia;
		exception
		when others then
			ie_utilizar_prest_solic_w := 'N';
		end;
		
		if (ie_utilizar_prest_solic_w = 'S') then
		    nr_seq_prestador_w    := coalesce(C01_w.nr_seq_prest_solic, C01_w.nr_seq_prest_exec);
		else
		    nr_seq_prestador_w    := coalesce(C01_w.nr_seq_prest_exec, C01_w.nr_seq_prest_solic);
		end if;
		
		insert into pls_requisicao(	nr_sequencia,			ie_estagio,			cd_estabelecimento,
						ie_status,			nm_usuario,			cd_versao,
						dt_atualizacao,			nm_usuario_nrec,		dt_atualizacao_nrec,
						nr_seq_prestador,		nr_seq_segurado,		cd_medico_solicitante,
						nr_seq_plano,			nr_seq_clinica,			ie_carater_atendimento,
						ie_regime_internacao,		cd_guia_prestador,		dt_solicitacao,
						qt_dia_solicitado,		cd_guia_principal,		ds_observacao,
						ds_indicacao_clinica,		nr_seq_cbo_saude,		ie_tipo_guia,
						dt_internacao_sugerida,		ie_recem_nascido,		nr_seq_guia_principal,
						ie_origem_solic,		ie_tipo_processo,		ie_anexo_guia,
						nr_seq_conselho,		dt_requisicao,			nm_usuario_solic,
						nr_seq_tipo_acomodacao,		ie_tipo_gat,			nr_seq_prestador_exec,
						nr_seq_uni_exec,		ie_consulta_urgencia,		cd_ausencia_val_benef_tiss,
						cd_ident_biometria_benef,	cd_template_biomet_benef,	cd_validacao_benef_tiss,
						ie_tipo_ident_benef,		ie_etapa_autorizacao,		ie_cobertura_especial)
					values ( nr_seq_requisicao_w,		1,				cd_estabelecimento_p,
						'P',				nm_usuario_p,			C01_w.cd_versao,
						clock_timestamp(),			nm_usuario_p,			clock_timestamp(),
						nr_seq_prestador_w,		C01_w.nr_seq_segurado,		C01_w.cd_medico_solic,
						C01_w.nr_seq_plano,		C01_w.nr_seq_clinica,		ie_carater_internacao_imp_w,
						C01_w.ie_regime_internacao,	C01_w.cd_guia_prestador,	C01_w.dt_solicitacao,
						C01_w.qt_diaria_solic,		C01_w.cd_guia_principal,	C01_w.ds_observacao,
						C01_w.ds_indicacao_clinica,	C01_w.nr_seq_cbo_saude,		C01_w.ie_tipo_guia,
						C01_w.dt_sugerida_internacao,	C01_w.ie_recem_nascido,		nr_seq_guia_principal_w,
						'E',				'E',				C01_w.ie_anexo_guia,
						C01_w.nr_seq_conselho,		clock_timestamp(),			nm_usuario_p,
						nr_seq_tipo_acomodacao_w,	'N',				C01_w.nr_seq_prest_exec,
						nr_seq_uni_exec_w,		ie_consulta_urgencia_w,		C01_w.cd_ausencia_val_benef_tiss,
						C01_w.cd_ident_biometria_benef,	C01_w.cd_template_biomet_benef,	C01_w.cd_validacao_benef_tiss,
						C01_w.ie_tipo_ident_benef,	C01_w.ie_etapa_autorizacao,	C01_w.ie_cobertura_especial);
						
		--Atualizar status das tabelas IMP para 1 - Integrado e salva a sequencia da guia
		update	pls_guia_plano_imp
		set	ie_status 		= 1,
			nr_seq_requisicao 	= nr_seq_requisicao_w,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia 		=  nr_seq_guia_plano_imp_p;
		
		if	pls_obter_se_segurado_intercam(null, nr_seq_requisicao_w, null) = 'S' then
			CALL pls_alterar_tipo_processo_req(nr_seq_requisicao_w, 'I', nm_usuario_p);
		end if;
	end;
end loop;


--Realiza select dos campos IMP do procedimento e cria os itens na Guia
for C02_w in C02( nr_seq_guia_plano_imp_p, nr_seq_guia_plano_w ) loop
	begin	
	
		dados_tipo_conv_tiss_w	:= pls_obter_conversao_tab_tiss(C02_w.cd_tabela, cd_estabelecimento_p, C02_w.cd_procedimento, '', 'A', C02_w.nr_seq_prestador, null);
		
		if ( dados_tipo_conv_tiss_w.ie_tipo_tabela in ('06')) then
			ie_origem_proced_w	:= 5; --CBHPM
		elsif ( dados_tipo_conv_tiss_w.ie_tipo_tabela in ('18','22')) then
			ie_origem_proced_w	:= 8; --TUSS 		
		elsif (dados_tipo_conv_tiss_w.ie_tipo_tabela in ('90','98','00')) then
			ie_origem_proced_w	:= 4; --PROPRIO 				
		end if;
		cd_procedimento_w :=  C02_w.cd_procedimento;
		
		
		/* Tratar a conversao de procedimentos TUSS - OPS - Cadastro de Regras / Procedimentos TUSS */

		if ( ie_origem_proced_w	= 8) then
			SELECT * FROM pls_converte_codigo_tuss( cd_procedimento_w, ie_origem_proced_w, cd_procedimento_w, ie_origem_proced_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
		end if;
		
		insert into pls_requisicao_proc(	
				nr_sequencia, dt_atualizacao, ie_status,
				nm_usuario, cd_procedimento, ie_origem_proced,
				qt_solicitado, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_requisicao, ie_estagio )    				
			values (	nextval('pls_requisicao_proc_seq'), clock_timestamp(), 'U',
				nm_usuario_p, cd_procedimento_w,ie_origem_proced_w,
				C02_w.qt_solicitada, clock_timestamp(), nm_usuario_p,
				nr_seq_requisicao_w, 'AE' ) returning nr_sequencia into nr_seq_requisicao_proc_w;
		
		CALL pls_atualiza_valor_proc_aut(nr_seq_requisicao_proc_w, 'R', nm_usuario_p);
		CALL pls_inserir_obs_regra_intercam(nr_seq_requisicao_proc_w, null, 'P', nm_usuario_p);
		CALL pls_gerar_de_para_req_intercam(nr_seq_requisicao_proc_w, null, null, null, null, null, null, cd_estabelecimento_p, nm_usuario_p);
	end;
end loop;

--Realiza select dos campos IMP do material e cria os itens na Guia
for C03_w in C03( nr_seq_guia_plano_imp_p ) loop
	begin	
		insert into pls_requisicao_mat(	
			nr_sequencia, dt_atualizacao, ie_status,
			nm_usuario, nr_seq_material, qt_solicitado,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_requisicao,
			ie_estagio)        
		values (nextval('pls_requisicao_mat_seq'), clock_timestamp(), 'U',
			nm_usuario_p, C03_w.nr_seq_material, C03_w.qt_solicitada, 
			clock_timestamp(), nm_usuario_p, nr_seq_requisicao_w,
			'AE') returning nr_sequencia into nr_seq_requisicao_mat_w;
			
		CALL pls_inserir_obs_regra_intercam(nr_seq_requisicao_mat_w, null, 'M', nm_usuario_p);	
		CALL pls_gerar_de_para_req_intercam(null,nr_seq_requisicao_mat_w, null, null, null, null, null, cd_estabelecimento_p, nm_usuario_p);
	end;
end loop;


--Realiza select dos campos IMP dos diagnosticos e criar na Guia
for C04_w in C04( nr_seq_guia_plano_imp_p ) loop
	begin	
		insert into pls_requisicao_diagnostico(	
			nr_sequencia, dt_atualizacao, ie_classificacao,
			nm_usuario, ie_indicacao_acidente, cd_doenca,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_requisicao )        
		values (nextval('pls_requisicao_diagnostico_seq'), clock_timestamp(), ie_classificacao_w,
			nm_usuario_p, C04_w.ie_indicador_acidente, C04_w.cd_doenca, 
			clock_timestamp(), nm_usuario_p, nr_seq_requisicao_w );
		
		--Somente o primeiro diagnostico deve ser Principal os demais devem ser secundarios
		ie_classificacao_w := 'S';
					
	end;
end loop;

CALL pls_tiss_guia_consulta(null, nr_seq_requisicao_w, nm_usuario_p);

nr_seq_requisicao_p := nr_seq_requisicao_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_req_importacao ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_guia_plano_imp_p pls_guia_plano_imp.nr_sequencia%type, nr_seq_requisicao_p INOUT pls_requisicao.nr_sequencia%type) FROM PUBLIC;
