-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_reanalise_requisicao ( nr_seq_requisicao_p bigint, nr_seq_ocorrencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Gerar uma nova análise para uma requisição que havia sido negada. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[X] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_segurado_w			pls_requisicao.nr_seq_segurado%type;
ie_tipo_guia_w				pls_requisicao.ie_tipo_guia%type;
dt_requisicao_w				pls_requisicao.dt_requisicao%type;
cd_medico_solicitante_w			pls_requisicao.cd_medico_solicitante%type;
nr_seq_prestador_w			pls_requisicao.nr_seq_prestador%type;
ds_observacao_w				pls_requisicao.ds_observacao%type;
ie_auditoria_estip_w			pls_requisicao.ie_auditoria_estipulante%type;
cd_estabelecimento_w			pls_requisicao.cd_estabelecimento%type;
nr_seq_regra_pos_estip_w		pls_requisicao.nr_seq_regra_pos_estip%type;
ds_indicacao_clinica_w			pls_requisicao.ds_indicacao_clinica%type;
ie_anexo_quimioterapia_w		pls_requisicao.ie_anexo_quimioterapia%type;
ie_anexo_radioterapia_w			pls_requisicao.ie_anexo_radioterapia%type;
ie_anexo_opme_w				pls_requisicao.ie_anexo_opme%type;
ie_anexo_guia_w				pls_requisicao.ie_anexo_guia%type;
nr_seq_prestador_exec_w			pls_requisicao.nr_seq_prestador_exec%type;
nr_seq_auditoria_w			pls_auditoria.nr_sequencia%type;
ie_permite_compl_opme_w			pls_auditoria.ie_permite_compl_opme%type;
ie_auditoria_w				pls_ocorrencia.ie_auditoria%type;
nr_seq_motivo_glosa_w			pls_ocorrencia.nr_seq_motivo_glosa%type;
nr_seq_nivel_lib_w			pls_ocorrencia.nr_seq_nivel_lib%type;
nr_seq_regra_w				pls_ocorrencia_regra.nr_sequencia%type;
nr_seq_ordem_atual_w			pls_auditoria_grupo.nr_seq_ordem%type;
nr_seq_grupo_w				pls_auditoria_grupo.nr_seq_grupo%type;
nr_seq_auditoria_item_w			pls_auditoria_item.nr_sequencia%type;
nr_seq_pacote_w				pls_pacote.nr_sequencia%type;
ie_regra_preco_w			pls_pacote.ie_regra_preco%type;
ie_tipo_despesa_w			pls_material.ie_tipo_despesa%type;
ie_externo_w				pls_grupo_auditor.ie_tipo_auditoria%type;
ie_agrupa_grupo_aud_w			pls_param_analise_aut.ie_agrupa_grupo_aud%type;
ie_status_w				varchar(2);
ie_utiliza_nivel_w			varchar(1);
nr_seq_regra_preco_pac_w		bigint;
qt_grupo_w				bigint;
qt_fluxo_w				bigint;
nr_seq_fluxo_w				bigint;
nr_seq_grupo_auditor_w			bigint;
nr_seq_ocorrencia_benef_w		bigint;
nr_nivel_liberacao_w			bigint;
ie_recem_nascido_w			pls_requisicao.ie_recem_nascido%type;
nm_recem_nascido_w			pls_requisicao.nm_recem_nascido%type;
dt_nasc_recem_nascido_w			pls_requisicao.dt_nasc_recem_nascido%type;
ie_tipo_processo_w			pls_requisicao.ie_tipo_processo%type;

C01 CURSOR(nr_seq_requisicao_pc bigint) FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced, 
		qt_solicitado, 
		ie_status, 
		vl_procedimento, 
		vl_total_pacote, 
		ie_pacote_ptu, 
		ie_tipo_anexo 
	from	pls_requisicao_proc 
	where	nr_seq_requisicao	= nr_seq_requisicao_pc;

C02 CURSOR(nr_seq_requisicao_pc bigint) FOR 
	SELECT	nr_sequencia, 
		nr_seq_material, 
		qt_solicitado, 
		ie_status, 
		vl_material, 
		nr_seq_material_forn, 
		ie_tipo_anexo 
	from	pls_requisicao_mat 
	where	nr_seq_requisicao	= nr_seq_requisicao_pc;

C05 CURSOR(nr_seq_ocorrencia_pc bigint) FOR 
	SELECT 	nr_seq_grupo, 
		nr_seq_fluxo 
	from	pls_ocorrencia_grupo 
	where	nr_seq_ocorrencia	= nr_seq_ocorrencia_pc 
	and	ie_requisicao		= 'S';
	
BEGIN 
 
select	nr_seq_segurado, 
	ie_tipo_guia, 
	dt_requisicao, 
	cd_medico_solicitante, 
	nr_seq_prestador, 
	ds_observacao, 
	coalesce(ie_auditoria_estipulante,'N'), 
	cd_estabelecimento, 
	nr_seq_regra_pos_estip, 
	ds_indicacao_clinica, 
	ie_anexo_quimioterapia, 
	ie_anexo_radioterapia, 
	ie_anexo_opme, 
	ie_anexo_guia, 
	nr_seq_prestador_exec, 
	ie_recem_nascido, 
	nm_recem_nascido, 
	dt_nasc_recem_nascido, 
	ie_tipo_processo 
into STRICT	nr_seq_segurado_w, 
	ie_tipo_guia_w, 
	dt_requisicao_w, 
	cd_medico_solicitante_w, 
	nr_seq_prestador_w, 
	ds_observacao_w, 
	ie_auditoria_estip_w, 
	cd_estabelecimento_w, 
	nr_seq_regra_pos_estip_w, 
	ds_indicacao_clinica_w, 
	ie_anexo_quimioterapia_w, 
	ie_anexo_radioterapia_w, 
	ie_anexo_opme_w, 
	ie_anexo_guia_w, 
	nr_seq_prestador_exec_w, 
	ie_recem_nascido_w, 
	nm_recem_nascido_w, 
	dt_nasc_recem_nascido_w, 
	ie_tipo_processo_w 
from	pls_requisicao 
where	nr_sequencia	= nr_seq_requisicao_p;
 
-- Se o tipo de guia dor de internação é verificado se o prestador executor possui permissão para complementar as solicitações de OPME 
-- Regra esta na OPS - Cadastro de Regras / Regra complemento OPME TISS 
if ( ie_tipo_guia_w = '1' ) then 
	ie_permite_compl_opme_w := pls_obter_prest_compl_opme( nr_seq_requisicao_p, nr_seq_prestador_exec_w );
end if;
 
select 	nextval('pls_auditoria_seq') 
into STRICT	nr_seq_auditoria_w
;
 
insert into pls_auditoria(nr_sequencia, dt_auditoria, dt_atualizacao, 
	nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
	nr_seq_guia, nr_seq_requisicao, 
	ie_tipo_auditoria, nr_seq_segurado, ie_tipo_guia, 
	dt_solicitacao, cd_medico_solicitante, ie_status, 
	nr_seq_prestador, ds_observacao, ie_auditoria_estipulante, 
	cd_estabelecimento, ds_indicacao_clinica, nr_telef_celular_benef, 
	ie_anexo_quimioterapia, ie_anexo_radioterapia, ie_anexo_opme, 
	ie_anexo_guia, ie_permite_compl_opme, ie_recem_nascido, 
	nm_recem_nascido, dt_nasc_recem_nascido, ie_retorno_justific, ie_tipo_processo) 
values (nr_seq_auditoria_w, clock_timestamp(), clock_timestamp(), 
	nm_usuario_p, clock_timestamp(), nm_usuario_p, 
	null, nr_seq_requisicao_p, 
	'R', nr_seq_segurado_w, ie_tipo_guia_w, 
	dt_requisicao_w, cd_medico_solicitante_w, 'A', 
	nr_seq_prestador_w, ds_observacao_w, ie_auditoria_estip_w, 
	cd_estabelecimento_w, ds_indicacao_clinica_w, null, 
	ie_anexo_quimioterapia_w, ie_anexo_radioterapia_w, ie_anexo_opme_w, 
	ie_anexo_guia_w, ie_permite_compl_opme_w, ie_recem_nascido_w, 
	nm_recem_nascido_w, dt_nasc_recem_nascido_w, 'N', ie_tipo_processo_w);
 
select	max(nr_sequencia) 
into STRICT	nr_seq_regra_w 
from	pls_ocorrencia_regra	a 
where	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_p 
and	a.ie_situacao		= 'A';
 
begin 
	select	nr_seq_motivo_glosa, 
		ie_auditoria, 
		nr_seq_nivel_lib_w 
	into STRICT	nr_seq_motivo_glosa_w, 
		ie_auditoria_w, 
		nr_seq_nivel_lib_w 
	from	pls_ocorrencia 
	where	nr_sequencia	= nr_seq_ocorrencia_p;	
exception 
when others then 
	nr_seq_motivo_glosa_w	:= null;
	ie_auditoria_w		:= null;
end;
 
select	max(nr_nivel_liberacao) 
into STRICT	nr_nivel_liberacao_w 
from	pls_nivel_liberacao 
where	nr_sequencia	= nr_seq_nivel_lib_w;
	 
for r_C01_w in C01( nr_seq_requisicao_p ) loop 
	begin	 
		insert into pls_ocorrencia_benef(nr_sequencia, 
			nr_seq_segurado, 
			nr_seq_ocorrencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_requisicao, 
			nr_seq_conta, 
			nr_seq_proc, 
			nr_seq_mat, 
			nr_seq_regra, 
			nr_seq_guia_plano, 
			ie_auditoria, 
			nr_nivel_liberacao, 
			ds_observacao) 
		values (nextval('pls_ocorrencia_benef_seq'), 
			nr_seq_segurado_w, 
			nr_seq_ocorrencia_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_requisicao_p, 
			null, 
			r_C01_w.nr_sequencia, 
			null, 
			nr_seq_regra_w, 
			null, 
			ie_auditoria_w, 
			nr_nivel_liberacao_w, 
			'Ocorrência gerada através do envio manual da requisição para auditoria');			
 
		select	nextval('pls_auditoria_item_seq') 
		into STRICT	nr_seq_auditoria_item_w 
		;
		 
		if (r_C01_w.ie_status in ('P','S','I')) then 
			ie_status_w 	:= 'A';
		elsif (r_C01_w.ie_status = 'A') then 
			ie_status_w 	:= 'P';
		elsif (r_C01_w.ie_status in ('G','N')) then 
			ie_status_w	:= 'N';
		end if;
		 
		select 	coalesce(max(ie_classificacao),1) 
		into STRICT	ie_tipo_despesa_w 
		from	procedimento 
		where	cd_procedimento		= r_C01_w.cd_procedimento 
		and	ie_origem_proced	= r_C01_w.ie_origem_proced;
 
		if (nr_seq_prestador_w	> 0) then 
			select	max(nr_sequencia) 
			into STRICT	nr_seq_pacote_w 
			from	pls_pacote 
			where	coalesce(nr_seq_prestador,coalesce(nr_seq_prestador_w,0))	= coalesce(nr_seq_prestador_w,0) 
			and	cd_procedimento		= r_C01_w.cd_procedimento 
			and	ie_origem_proced	= r_C01_w.ie_origem_proced 
			and	ie_situacao		= 'A';
 
			if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then 
				select	coalesce(ie_regra_preco,'N') 
				into STRICT	ie_regra_preco_w 
				from	pls_pacote a 
				where	a.nr_sequencia = nr_seq_pacote_w;
 
				if (ie_regra_preco_w = 'S') then 
					SELECT * FROM pls_obter_regra_preco_pacote(	r_C01_w.cd_procedimento, r_C01_w.ie_origem_proced, 'R', r_C01_w.nr_sequencia, nm_usuario_p, nr_seq_pacote_w, nr_seq_regra_preco_pac_w) INTO STRICT nr_seq_pacote_w, nr_seq_regra_preco_pac_w;
				end if;
			end if;
 
			if (nr_seq_pacote_w IS NOT NULL AND nr_seq_pacote_w::text <> '') then 
				ie_tipo_despesa_w	:= '4';
			end if;
		end if;
 
		insert into pls_auditoria_item(nr_sequencia, nr_seq_auditoria, cd_procedimento, 
			ie_origem_proced, qt_original, nr_seq_proc_origem, 
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec, 
			nm_usuario_nrec, qt_ajuste, ie_status_solicitacao, 
			ie_status, ie_tipo_despesa, vl_item, 
			vl_total_pacote, ie_pacote_ptu, vl_original, 
			ie_tipo_anexo) 
		values (nr_seq_auditoria_item_w, nr_seq_auditoria_w, r_C01_w.cd_procedimento, 
			r_C01_w.ie_origem_proced, r_C01_w.qt_solicitado, r_C01_w.nr_sequencia, 
			clock_timestamp(), nm_usuario_p, clock_timestamp(), 
			nm_usuario_p, r_C01_w.qt_solicitado, ie_status_w, 
			ie_status_w, ie_tipo_despesa_w, r_C01_w.vl_procedimento, 
			r_C01_w.vl_total_pacote , r_C01_w.ie_pacote_ptu, r_C01_w.vl_procedimento, 
			r_C01_w.ie_tipo_anexo);
	end;
end loop;
 
for r_C02_w in C02( nr_seq_requisicao_p ) loop 
	begin 
		insert into pls_ocorrencia_benef(nr_sequencia, 
			nr_seq_segurado, 
			nr_seq_ocorrencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_requisicao, 
			nr_seq_conta, 
			nr_seq_proc, 
			nr_seq_mat, 
			nr_seq_regra, 
			nr_seq_guia_plano, 
			ie_auditoria, 
			nr_nivel_liberacao, 
			ds_observacao) 
		values (nextval('pls_ocorrencia_benef_seq'), 
			nr_seq_segurado_w, 
			nr_seq_ocorrencia_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_requisicao_p, 
			null, 
			null, 
			r_C02_w.nr_sequencia, 
			nr_seq_regra_w, 
			null, 
			ie_auditoria_w, 
			nr_nivel_liberacao_w, 
			'Ocorrência gerada através do envio manual da requisição para auditoria');	
	 
	 
		nr_seq_ocorrencia_benef_w := pls_inserir_ocorrencia(nr_seq_segurado_w, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, null, r_C02_w.nr_sequencia, nr_seq_regra_w, nm_usuario_p, 'Ocorrência gerada através do envio manual da requisição para auditoria', nr_seq_motivo_glosa_w, 6, cd_estabelecimento_w, 'N', null, nr_seq_ocorrencia_benef_w, null, null, null, null);
				 
		select	nextval('pls_auditoria_item_seq') 
		into STRICT	nr_seq_auditoria_item_w 
		;
		 
		if (r_C02_w.ie_status in ('P','S','I')) then 
			ie_status_w 	:= 'A';
		elsif (r_C02_w.ie_status = 'A') then 
			ie_status_w 	:= 'P';
		elsif (r_C02_w.ie_status in ('G','N')) then 
			ie_status_w	:= 'N';
		end if;
			 
		select 	max(ie_tipo_despesa) 
		into STRICT	ie_tipo_despesa_w 
		from	pls_material 
		where	nr_sequencia = r_C02_w.nr_seq_material;
		 
		insert into pls_auditoria_item(nr_sequencia, nr_seq_auditoria, qt_original, 
			nr_seq_mat_origem, dt_atualizacao, nm_usuario, 
			dt_atualizacao_nrec, nm_usuario_nrec, qt_ajuste, 
			nr_seq_material, ie_status_solicitacao, ie_status, 
			ie_tipo_despesa, vl_item, nr_seq_material_forn, vl_original, 
			ie_tipo_anexo) 
		values (nr_seq_auditoria_item_w, nr_seq_auditoria_w, r_C02_w.qt_solicitado, 
			r_C02_w.nr_sequencia, clock_timestamp(), nm_usuario_p, 
			clock_timestamp(), nm_usuario_p, r_C02_w.qt_solicitado, 
			r_C02_w.nr_seq_material, ie_status_w, ie_status_w, 
			ie_tipo_despesa_w, r_C02_w.vl_material, r_C02_w.nr_seq_material_forn, 
			r_C02_w.vl_material, r_C02_w.ie_tipo_anexo);	
	end;
end loop;
 
begin 
	select	coalesce(ie_agrupa_grupo_aud, 'S') 
	into STRICT	ie_agrupa_grupo_aud_w 
	from	pls_param_analise_aut;
exception 
when others then 
	ie_agrupa_grupo_aud_w	:= 'S';
end;
 
for r_C05_w in C05( nr_seq_ocorrencia_p ) loop 
	begin 
		if	((ie_auditoria_w	= 'S') or (ie_auditoria_w	= 'N' AND nr_seq_motivo_glosa_w IS NOT NULL AND nr_seq_motivo_glosa_w::text <> '')) then 
			if (ie_agrupa_grupo_aud_w = 'S') then 
				select	count(1) 
				into STRICT	qt_grupo_w 
				from	pls_auditoria_grupo 
				where	nr_seq_auditoria 	= nr_seq_auditoria_w 
				and	nr_seq_grupo 		= r_C05_w.nr_seq_grupo;
				 
 
				if (qt_grupo_w = 0) then 
					select	count(1) 
					into STRICT	qt_fluxo_w 
					from	pls_auditoria_grupo 
					where	nr_seq_auditoria 	= nr_seq_auditoria_w 
					and	nr_seq_ordem 		= r_C05_w.nr_seq_fluxo;
 
					if (qt_fluxo_w	> 0) then 
						select	max(nr_seq_ordem) + 1 
						into STRICT	nr_seq_ordem_atual_w 
						from	pls_auditoria_grupo 
						where	nr_seq_auditoria 	= nr_seq_auditoria_w;
						 
						nr_seq_fluxo_w	:= nr_seq_ordem_atual_w;
					else 
						nr_seq_fluxo_w	:= r_C05_w.nr_seq_fluxo;
					end if;
 
					insert into pls_auditoria_grupo(nr_sequencia, nr_seq_auditoria, nr_seq_grupo, 
						dt_atualizacao, nm_usuario, dt_atualizacao_nrec, 
						nm_usuario_nrec, nr_seq_ordem, ie_status, 
						ie_manual) 
					values (nextval('pls_auditoria_grupo_seq'), nr_seq_auditoria_w, r_C05_w.nr_seq_grupo, 
						clock_timestamp(), nm_usuario_p, clock_timestamp(), 
						nm_usuario_p, nr_seq_fluxo_w, 'U', 
						'N');
				end if;
			elsif (ie_agrupa_grupo_aud_w = 'N') then 
				select	count(1) 
				into STRICT	qt_fluxo_w 
				from	pls_auditoria_grupo 
				where	nr_seq_auditoria 	= nr_seq_auditoria_w 
				and	nr_seq_ordem 		= r_C05_w.nr_seq_fluxo;
 
				if (qt_fluxo_w	> 0) then 
					select	max(nr_seq_ordem) + 1 
					into STRICT	nr_seq_ordem_atual_w 
					from	pls_auditoria_grupo 
					where	nr_seq_auditoria 	= nr_seq_auditoria_w;
 
					nr_seq_fluxo_w	:= nr_seq_ordem_atual_w;
				else 
					nr_seq_fluxo_w	:= r_C05_w.nr_seq_fluxo;
				end if;
 
				insert into pls_auditoria_grupo(nr_sequencia, nr_seq_auditoria, nr_seq_grupo, 
					dt_atualizacao, nm_usuario, dt_atualizacao_nrec, 
					nm_usuario_nrec, nr_seq_ordem, ie_status, 
					ie_manual) 
				values (nextval('pls_auditoria_grupo_seq'), nr_seq_auditoria_w, r_C05_w.nr_seq_grupo, 
					clock_timestamp(), nm_usuario_p, clock_timestamp(), 
					nm_usuario_p, nr_seq_fluxo_w, 'U', 
					'N');
			end if;
		end if;
	end;
end loop;
 
select	coalesce(pls_obter_grupo_analise_atual(nr_seq_auditoria_w),0) 
into STRICT	nr_seq_grupo_auditor_w
;
 
if (ie_auditoria_estip_w = 'S') and ( nr_seq_grupo_auditor_w > 0) then 
	select	nr_seq_grupo 
	into STRICT	nr_seq_grupo_w 
	from	pls_auditoria_grupo 
	where	nr_sequencia = nr_seq_grupo_auditor_w;
 
	select	CASE WHEN ie_tipo_auditoria=3 THEN 'S'  ELSE 'N' END  
	into STRICT	ie_externo_w 
	from	pls_grupo_auditor 
	where	nr_sequencia	= nr_seq_grupo_w;
 
	if (ie_externo_w = 'S') and (coalesce(nr_seq_regra_pos_estip_w,0) > 0) then 
		CALL pls_enviar_email_requisicao(nr_seq_requisicao_p,1,nr_seq_regra_pos_estip_w,nm_usuario_p);
 
		update	pls_auditoria 
		set	ie_status			= 'AE', 
			ie_auditoria_estipulante	= 'S' 
		where	nr_sequencia			= nr_seq_auditoria_w;
	end if;
end if;
 
ie_utiliza_nivel_w := pls_obter_se_uti_nivel_lib_aut(cd_estabelecimento_w);
 
if (ie_utiliza_nivel_w = 'S') then 
	CALL pls_gerar_ocorr_glosa_aud_req(nr_seq_auditoria_w,nm_usuario_p);
end if;
 
begin 
	CALL pls_gerar_alerta_evento(2, nr_seq_auditoria_w, null, null, nm_usuario_p);
exception 
when others then 
	null;
end;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_reanalise_requisicao ( nr_seq_requisicao_p bigint, nr_seq_ocorrencia_p bigint, nm_usuario_p text) FROM PUBLIC;
