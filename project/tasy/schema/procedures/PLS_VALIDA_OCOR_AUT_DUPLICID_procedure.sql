-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_ocor_aut_duplicid ( nr_seq_ocor_combinada_p pls_ocor_aut_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type, ie_utiliza_filtro_p text, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Validar a duplicidade nas funções da requisição e da guia 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [X] Tasy (Delphi/Java) [X] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ie_valida_tipo_guia_w		pls_validacao_aut_duplicid.ie_valida_tipo_guia%type;
ie_valida_data_solic_w		pls_validacao_aut_duplicid.ie_valida_data_solic%type;
ie_valida_beneficiario_w	pls_validacao_aut_duplicid.ie_valida_beneficiario%type;
ie_valida_medico_solic_w	pls_validacao_aut_duplicid.ie_valida_medico_solic%type;
ie_valida_prestador_w		pls_validacao_aut_duplicid.ie_valida_prestador%type;
ie_valida_cd_guia_w		pls_validacao_aut_duplicid.ie_valida_cd_guia%type;

cd_guia_w			pls_guia_plano.cd_guia%type;
nr_seq_prestador_w		pls_guia_plano.nr_seq_prestador%type;
cd_medico_solicitante_w		pls_guia_plano.cd_medico_solicitante%type;
ie_tipo_guia_w			pls_guia_plano.ie_tipo_guia%type;
dt_solicitacao_w		pls_guia_plano.dt_solicitacao%type;

nr_seq_prestador_ww		pls_requisicao.nr_seq_prestador%type;
cd_medico_solicitante_ww	pls_requisicao.cd_medico_solicitante%type;
ie_tipo_guia_ww			pls_requisicao.ie_tipo_guia%type;
dt_requisicao_w			pls_requisicao.dt_requisicao%type;

nr_seq_oc_benef_w		pls_ocorrencia_benef.nr_sequencia%type;

qt_requisicoes_w		bigint;
qt_guias_w			bigint;
ie_gerar_ocorrencia_w		varchar(1);
ie_regra_w			varchar(1);
ie_tipo_ocorrencia_w		varchar(1);
ds_sql_w			varchar(4000);
bind_sql_w			sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;

 

BEGIN 
 
begin 
	select	ie_valida_tipo_guia, 
		ie_valida_data_solic, 
		ie_valida_beneficiario, 
		ie_valida_medico_solic, 
		ie_valida_prestador,   
		ie_valida_cd_guia 
	into STRICT	ie_valida_tipo_guia_w, 
		ie_valida_data_solic_w, 
		ie_valida_beneficiario_w, 
		ie_valida_medico_solic_w, 
		ie_valida_prestador_w,   
		ie_valida_cd_guia_w 
	from	pls_validacao_aut_duplicid 
	where	nr_seq_ocor_aut_combinada	= nr_seq_ocor_combinada_p 
	and	ie_situacao			= 'A';
exception 
when others then 
	ie_valida_tipo_guia_w		:= 'N';
	ie_valida_data_solic_w		:= 'N';
	ie_valida_beneficiario_w	:= 'N';
	ie_valida_medico_solic_w	:= 'N';
	ie_valida_prestador_w		:= 'N';
	ie_valida_cd_guia_w		:= 'N';
end;
 
ie_gerar_ocorrencia_w	:= 'N';
	 
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
	ds_sql_w :=	'select count(1) ' || 
			'from	pls_guia_plano ' || 
			'where	ie_estagio	not in (4, 7, 8) ' || 
			'and	nr_sequencia	<> '|| nr_seq_guia_p;
	 
	/* Caso algum dos campos esteja marcado, deve adicionar a restrição referente ao campo assinalado*/
 
	if (coalesce(ie_valida_tipo_guia_w,'N') = 'S') then 
		select 	ie_tipo_guia 
		into STRICT	ie_tipo_guia_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
		 
		ds_sql_w :=	ds_sql_w ||' and ie_tipo_guia	= :ie_tipo_guia ';
		bind_sql_w := sql_pck.bind_variable(	':ie_tipo_guia', ie_tipo_guia_w, bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_data_solic_w,'N') = 'S') then 
		select 	dt_solicitacao 
		into STRICT	dt_solicitacao_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
	 
		ds_sql_w :=	ds_sql_w ||' and trunc(dt_solicitacao,''dd'')	= :dt_solicitacao ';
		bind_sql_w := sql_pck.bind_variable(	':dt_solicitacao', trunc(dt_solicitacao_w,'dd'), bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_beneficiario_w,'N') = 'S') then 
		ds_sql_w :=	ds_sql_w ||' and nr_seq_segurado	= :nr_seq_segurado ';
		bind_sql_w := sql_pck.bind_variable(	':nr_seq_segurado', nr_seq_segurado_p, bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_medico_solic_w,'N') = 'S') then 
		select 	cd_medico_solicitante 
		into STRICT	cd_medico_solicitante_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
		 
		ds_sql_w :=	ds_sql_w ||' and cd_medico_solicitante	= :cd_medico_solicitante ';
		bind_sql_w := sql_pck.bind_variable(	':cd_medico_solicitante', cd_medico_solicitante_w, bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_prestador_w,'N') = 'S') then 
		select 	nr_seq_prestador 
		into STRICT	nr_seq_prestador_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
		 
		ds_sql_w :=	ds_sql_w ||' and nr_seq_prestador	= :nr_seq_prestador ';
		bind_sql_w := sql_pck.bind_variable(	':nr_seq_prestador', nr_seq_prestador_w, bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_cd_guia_w,'N') = 'S') then 
		select 	cd_guia 
		into STRICT	cd_guia_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
		 
		ds_sql_w :=	ds_sql_w ||' and cd_guia	= :cd_guia ';
		bind_sql_w := sql_pck.bind_variable(	':cd_guia', cd_guia_w, bind_sql_w);
	end if;
	 
	/* Caso algum dos campos da regra esteja marcado, deve ser executado o select*/
 
	if (ie_valida_tipo_guia_w	= 'S')		or (ie_valida_data_solic_w		= 'S')	or (ie_valida_beneficiario_w	= 'S')	or (ie_valida_medico_solic_w = 'S')	or (ie_valida_prestador_w		= 'S')	or (ie_valida_cd_guia_w = 'S') then 
		 
		bind_sql_w := sql_pck.executa_sql_cursor(ds_sql_w, bind_sql_w);
		fetch cursor_w into qt_guias_w;
		close cursor_w;
		 
		if (qt_guias_w	> 0) then 
			ie_gerar_ocorrencia_w	:= 'S';
		end if;
	end if;
	 
	if (ie_gerar_ocorrencia_w	= 'S') then 
		if ( ie_utiliza_filtro_p	= 'S' ) then 
			/* Tratamento para filtros */
 
			SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, null, null, null, null, null, null, null, null, null, null, null, nr_seq_prestador_w, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
								 
				if ( ie_regra_w	= 'S' ) then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif ( ie_regra_w	in ('E','N') ) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;					
		end if;
		 
		if ( ie_gerar_ocorrencia_w	= 'S') then 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, null, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 7, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
						 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							nr_seq_guia_p, null, null, 
							null, null, null, 
							null, null, null, 
							nm_usuario_p, cd_estabelecimento_p);		
		end if;
	end if;
 
 
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
	ds_sql_w :=	'select count(1) ' || 
			'from	pls_requisicao ' || 
			'where	ie_estagio	not in (1, 3, 7) ' || 
			'and	nr_sequencia	<> '|| nr_seq_requisicao_p;
	 
	/* Caso algum dos campos esteja marcado, deve adicionar a restrição referente ao campo assinalado*/
 
	if (coalesce(ie_valida_tipo_guia_w,'N') = 'S') then 
		select	ie_tipo_guia 
		into STRICT	ie_tipo_guia_ww 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
	 
		ds_sql_w :=	ds_sql_w ||' and ie_tipo_guia	= :ie_tipo_guia ';
		bind_sql_w := sql_pck.bind_variable(	':ie_tipo_guia', ie_tipo_guia_ww, bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_data_solic_w,'N') = 'S') then 
		select	dt_requisicao 
		into STRICT	dt_requisicao_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
		 
		ds_sql_w :=	ds_sql_w ||' and trunc(dt_requisicao ,''dd'')	= :dt_requisicao ';
		bind_sql_w := sql_pck.bind_variable(	':dt_requisicao', trunc(dt_requisicao_w,'dd'), bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_beneficiario_w,'N') = 'S') then 
		ds_sql_w :=	ds_sql_w ||' and nr_seq_segurado	= :nr_seq_segurado ';
		bind_sql_w := sql_pck.bind_variable(	':nr_seq_segurado', nr_seq_segurado_p, bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_medico_solic_w,'N') = 'S') then 
		select	cd_medico_solicitante 
		into STRICT	cd_medico_solicitante_ww 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
		 
		ds_sql_w :=	ds_sql_w ||' and cd_medico_solicitante	= :cd_medico_solicitante ';
		bind_sql_w := sql_pck.bind_variable(	':cd_medico_solicitante', cd_medico_solicitante_ww, bind_sql_w);
	end if;
	 
	if (coalesce(ie_valida_prestador_w,'N') = 'S') then 
		select	nr_seq_prestador 
		into STRICT	nr_seq_prestador_ww 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
		 
		ds_sql_w :=	ds_sql_w ||' and nr_seq_prestador	= :nr_seq_prestador ';
		bind_sql_w := sql_pck.bind_variable(	':nr_seq_prestador', nr_seq_prestador_ww, bind_sql_w);
	end if;
	 
	/* Caso algum dos campos da regra esteja marcado, deve ser executado o select*/
 
	if (ie_valida_tipo_guia_w	= 'S')		or (ie_valida_data_solic_w		= 'S')	or (ie_valida_beneficiario_w	= 'S')	or (ie_valida_medico_solic_w = 'S')	or (ie_valida_prestador_w		= 'S')	or (ie_valida_cd_guia_w = 'S') then 
		 
		bind_sql_w := sql_pck.executa_sql_cursor(ds_sql_w, bind_sql_w);
		fetch cursor_w into qt_requisicoes_w;
		close cursor_w;
		 
		if (qt_requisicoes_w	> 0) then 
			ie_gerar_ocorrencia_w	:= 'S';
		end if;
	end if;
	 
	if (ie_gerar_ocorrencia_w	= 'S') then 
		if ( ie_utiliza_filtro_p	= 'S' ) then 
			/* Tratamento para filtros */
 
			SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, null, nr_seq_requisicao_p, null, null, null, null, null, null, null, null, null, null, nr_seq_prestador_ww, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
								 
				if ( ie_regra_w	= 'S' ) then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif ( ie_regra_w	in ('E','N') ) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;					
		end if;
		 
		if ( ie_gerar_ocorrencia_w	= 'S') then 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, null, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 9, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
						 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							null, nr_seq_requisicao_p, null, 
							null, null, null, 
							null, null, null, 
							nm_usuario_p, cd_estabelecimento_p);		
		end if;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_ocor_aut_duplicid ( nr_seq_ocor_combinada_p pls_ocor_aut_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type, ie_utiliza_filtro_p text, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;

