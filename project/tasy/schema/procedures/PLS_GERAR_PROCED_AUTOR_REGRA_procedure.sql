-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_proced_autor_regra ( nr_seq_autorizacao_p bigint, nr_seq_requisicao_p bigint, ie_evento_p text, nm_usuario_p text, ie_lanc_auto_p INOUT text) AS $body$
DECLARE

 
nr_seq_regra_w				bigint;
ie_evento_w				varchar(10);
nr_seq_guia_proc_w			bigint;
nr_seq_req_proc_w			bigint;
cd_procedimento_w			bigint;
ie_origem_proced_w			bigint;
cd_estabelecimento_w			bigint;
nr_seq_prestador_w			bigint;
ie_tipo_guia_w				varchar(10);
ie_consulta_urg_w			varchar(2);
cd_medico_solic_w			varchar(20);
nr_seq_material_w			bigint;
nr_seq_guia_mat_w			bigint;
nr_seq_req_mat_w			bigint;
ie_restringe_estab_w			varchar(2);
ie_consist_somente_bt_dir_w		varchar(2);
nr_seq_uni_exec_w			bigint;
ie_origem_solic_w			varchar(2);
ie_origem_inclusao_w			varchar(2) := 'T';
ie_tipo_processo_w			varchar(2);
cd_especialidade_medica_w		integer;
cd_especialidade_w			integer;
qt_reg_w				integer;
qt_idade_w				integer;
nr_seq_segurado_w			bigint;
cd_pessoa_fisica_w			varchar(10);
qt_idade_min_w				integer;
qt_idade_max_w				integer;
nr_seq_tipo_acomodacao_w		bigint;
nr_seq_tipo_acomod_regra_w		bigint;
ie_regime_internacao_w			bigint;
ie_tipo_segurado_w			pls_segurado.ie_tipo_segurado%type;
nr_seq_prestador_exec_w		pls_requisicao.nr_seq_prestador_exec%type;

c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_especialidade_medica, 
		qt_idade_min, 
		qt_idade_max, 
		nr_seq_tipo_acomodacao 
	from	pls_regra_lanc_automatico 
	where	ie_situacao	= 'A' 
	and	((ie_restringe_estab_w	= 'N') 
	or	(ie_restringe_estab_w	= 'S' AND cd_estabelecimento = cd_estabelecimento_w)) 
	and	ie_evento = ie_evento_p 
	and	((ie_evento_p <> '8' and ((coalesce(ie_origem_lancamento::text, '') = '' or ie_origem_lancamento = 'A') or (ie_origem_lancamento = ie_origem_inclusao_w))) 
	or	(ie_evento_p = '8' and ((coalesce(ie_origem_lancamento::text, '') = '' and ie_origem_inclusao_w = 'T') or ie_origem_lancamento = 'A' or ie_origem_lancamento = ie_origem_inclusao_w))) 
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia 		= ie_tipo_guia_w)) 
	and	((coalesce(nr_seq_prestador::text, '') = '')	or (nr_seq_prestador 		= nr_seq_prestador_w)) 
	and	((coalesce(cd_medico_solicitante::text, '') = '')	or (cd_medico_solicitante 	= cd_medico_solic_w)) 
	and	((coalesce(nr_seq_uni_exec::text, '') = '') 		or (nr_seq_uni_exec 		= nr_seq_uni_exec_w)) 
	and	((coalesce(ie_consulta_urgencia::text, '') = '')	or (ie_consulta_urgencia	= coalesce(ie_consulta_urg_w,'N'))) 
	and	((coalesce(ie_regime_internacao::text, '') = '') 	or (ie_regime_internacao	= ie_regime_internacao_w));

c02 CURSOR FOR 
	SELECT	cd_procedimento, 
		ie_origem_proced, 
		nr_seq_material 
	from	pls_regra_lanc_aut_item 
	where	nr_seq_regra	= nr_seq_regra_w;

c03 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_especialidade_medica, 
		qt_idade_min, 
		qt_idade_max, 
		nr_seq_tipo_acomodacao 
	from	pls_regra_lanc_automatico 
	where	ie_situacao	= 'A' 
	and	((ie_restringe_estab_w	= 'N') 
	or	(ie_restringe_estab_w	= 'S' AND cd_estabelecimento = cd_estabelecimento_w)) 
	and	ie_evento = ie_evento_p 
	and	((ie_evento_p <> '8' and ((coalesce(ie_origem_lancamento::text, '') = '' or ie_origem_lancamento = 'A') or (ie_origem_lancamento = ie_origem_inclusao_w))) 
	or	(ie_evento_p = '8' and ((coalesce(ie_origem_lancamento::text, '') = '' and ie_origem_inclusao_w = 'T') or ie_origem_lancamento = 'A' or ie_origem_lancamento = ie_origem_inclusao_w))) 
	and	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia 		= ie_tipo_guia_w)) 
	and	((coalesce(nr_seq_prestador::text, '') = '')	or (nr_seq_prestador 		= nr_seq_prestador_w)) 
	and	((coalesce(cd_medico_solicitante::text, '') = '')	or (cd_medico_solicitante 	= cd_medico_solic_w)) 
	and	((coalesce(nr_seq_uni_exec::text, '') = '') 		or (nr_seq_uni_exec 		= nr_seq_uni_exec_w)) 
	and	((coalesce(ie_consulta_urgencia::text, '') = '')	or (ie_consulta_urgencia	= coalesce(ie_consulta_urg_w,'N'))) 
	and	((coalesce(ie_regime_internacao::text, '') = '') 	or (ie_regime_internacao	= ie_regime_internacao_w)) 
	and	((coalesce(cd_especialidade_medica::text, '') = '')	or (cd_especialidade_medica	= cd_especialidade_w)) 
	and	((coalesce(ie_tipo_segurado::text, '') = '')		or (ie_tipo_segurado		= ie_tipo_segurado_w)) 
	and	((coalesce(nr_seq_tipo_acomodacao::text, '') = '')	or (nr_seq_tipo_acomodacao	= nr_seq_tipo_acomodacao_w)) 
	and ((coalesce(nr_seq_prestador_exec::text, '') = '')	or (nr_seq_prestador_exec	= nr_seq_prestador_exec_w));
	
	 

BEGIN 
 
ie_lanc_auto_p		:= 'N';
ie_restringe_estab_w	:= pls_obter_se_controle_estab('LA');
 
if (coalesce(nr_seq_autorizacao_p, 0) <> 0) then 
	begin 
	 
	select	cd_estabelecimento, 
		nr_seq_prestador, 
		ie_tipo_guia, 
		cd_medico_solicitante, 
		nr_seq_uni_exec, 
		nr_seq_segurado, 
		nr_seq_tipo_acomodacao, 
		ie_origem_solic, 
		ie_regime_internacao 
	into STRICT	cd_estabelecimento_w, 
		nr_seq_prestador_w, 
		ie_tipo_guia_w, 
		cd_medico_solic_w, 
		nr_seq_uni_exec_w, 
		nr_seq_segurado_w, 
		nr_seq_tipo_acomodacao_w, 
		ie_origem_solic_w, 
		ie_regime_internacao_w 
	from	pls_guia_plano 
	where	nr_sequencia	= nr_seq_autorizacao_p;
	exception 
	when others then 
		cd_estabelecimento_w	 := 0;
		nr_seq_prestador_w		 := 0;
		ie_tipo_guia_w			 := 'X';
		cd_medico_solic_w		 := 'X';
		nr_seq_uni_exec_w		 := 0;
		nr_seq_segurado_w		 := 0;
		nr_seq_tipo_acomodacao_w := 0;
	end;
	 
	if (ie_origem_solic_w = 'P') then 
		ie_origem_inclusao_w := 'P';
	end if;
	 
	begin 
		select	cd_pessoa_fisica 
		into STRICT	cd_pessoa_fisica_w 
		from	pls_segurado 
		where	nr_sequencia 	= nr_seq_segurado_w;
	exception 
	when others then 
		cd_pessoa_fisica_w 	:= null;
	end;
 
	begin 
		select 	(substr(obter_idade_pf(cd_pessoa_fisica_w, clock_timestamp(), 'A'),1,5))::numeric  
		into STRICT	qt_idade_w 
		;
	exception 
	when others then 
		qt_idade_w := null;
	end;
 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_regra_w, 
		cd_especialidade_medica_w, 
		qt_idade_min_w, 
		qt_idade_max_w, 
		nr_seq_tipo_acomod_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		if	(qt_idade_min_w IS NOT NULL AND qt_idade_min_w::text <> '' AND qt_idade_min_w > qt_idade_w) or 
			(qt_idade_max_w IS NOT NULL AND qt_idade_max_w::text <> '' AND qt_idade_max_w < qt_idade_w) then 
			nr_seq_regra_w := 0;
		end if;
		 
		if (nr_seq_tipo_acomodacao_w <> nr_seq_tipo_acomod_regra_w) then 
			nr_seq_regra_w := 0;
		end if;
 
		if (coalesce(cd_especialidade_medica_w,0) > 0) then 
			select	count(1) 
			into STRICT	qt_reg_w 
			from	medico_especialidade 
			where	cd_pessoa_fisica = cd_medico_solic_w 
			and	cd_especialidade = cd_especialidade_medica_w;
			 
			if (qt_reg_w = 0) then 
				goto Final;
			end if;
		end if;
			 
		open c02;
		loop 
		fetch c02 into 
			cd_procedimento_w, 
			ie_origem_proced_w, 
			nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin 
			if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then 
				select	nextval('pls_guia_plano_proc_seq') 
				into STRICT	nr_seq_guia_proc_w 
				;
 
				insert into pls_guia_plano_proc(nr_sequencia, dt_atualizacao, nm_usuario, 
					 nr_seq_guia, cd_procedimento, ie_origem_proced, 
					 qt_solicitada, ie_status) 
				values (nr_seq_guia_proc_w, clock_timestamp(), nm_usuario_p, 
					 nr_seq_autorizacao_p, cd_procedimento_w, ie_origem_proced_w, 
					 1, 'U');
			elsif (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then 
				select	nextval('pls_guia_plano_mat_seq') 
				into STRICT	nr_seq_guia_mat_w 
				;
 
				insert into pls_guia_plano_mat(nr_sequencia, dt_atualizacao, nm_usuario, 
					 nr_seq_guia, nr_seq_material, qt_solicitada, 
					 ie_status) 
				values (nr_seq_guia_mat_w, clock_timestamp(), nm_usuario_p, 
					 nr_seq_autorizacao_p, nr_seq_material_w, 1, 
					 'U');
			end if;
			ie_lanc_auto_p	:= 'S';
			end;
		end loop;
		close c02;
		<<Final>> 
		qt_reg_w := 0;
		end;		
	end loop;
	close c01;
elsif (coalesce(nr_seq_requisicao_p, 0) <> 0) then 
	begin 
		select	cd_estabelecimento, 
			ie_tipo_guia, 
			nr_seq_prestador, 
			coalesce(ie_consulta_urgencia,'N'), 
			cd_medico_solicitante, 
			nr_seq_uni_exec, 
			ie_origem_solic, 
			ie_tipo_processo, 
			cd_especialidade, 
			nr_seq_tipo_acomodacao, 
			nr_seq_segurado, 
			nr_seq_prestador_exec, 
			ie_regime_internacao 
		into STRICT	cd_estabelecimento_w, 
			ie_tipo_guia_w, 
			nr_seq_prestador_w, 
			ie_consulta_urg_w, 
			cd_medico_solic_w, 
			nr_seq_uni_exec_w, 
			ie_origem_solic_w, 
			ie_tipo_processo_w, 
			cd_especialidade_w, 
			nr_seq_tipo_acomodacao_w, 
			nr_seq_segurado_w, 
			nr_seq_prestador_exec_w, 
			ie_regime_internacao_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
	exception 
	when others then 
		cd_estabelecimento_w		:= 0;
		nr_seq_prestador_w		:= 0;
		ie_tipo_guia_w			:= 'X';
		cd_medico_solic_w		:= 'X';
		ie_consulta_urg_w		:= 'N';
		nr_seq_uni_exec_w		:= 0;
		nr_seq_tipo_acomodacao_w	:= 0;
		nr_seq_segurado_w		:= 0;
	end;
 
	begin 
		select	ie_tipo_segurado, 
			cd_pessoa_fisica 
		into STRICT	ie_tipo_segurado_w, 
			cd_pessoa_fisica_w 
		from	pls_segurado 
		where	nr_sequencia	= nr_seq_segurado_w;
	exception 
	when others then 
		ie_tipo_segurado_w	:= 'X';
		cd_pessoa_fisica_w	:= null;
	end;
 
	if (ie_origem_solic_w = 'P') then 
		ie_origem_inclusao_w := 'P';
	end if;
	 
	begin 
		select 	(substr(obter_idade_pf(cd_pessoa_fisica_w, clock_timestamp(), 'A'),1,5))::numeric  
		into STRICT	qt_idade_w 
		;
	exception 
	when others then 
		qt_idade_w := null;
	end;	
	 
	open c03;
	loop 
	fetch c03 into 
		nr_seq_regra_w, 
		cd_especialidade_medica_w, 
		qt_idade_min_w, 
		qt_idade_max_w, 
		nr_seq_tipo_acomod_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin 
 
		if	(qt_idade_min_w IS NOT NULL AND qt_idade_min_w::text <> '' AND qt_idade_min_w > qt_idade_w) or 
			(qt_idade_max_w IS NOT NULL AND qt_idade_max_w::text <> '' AND qt_idade_max_w < qt_idade_w) then 
			nr_seq_regra_w := 0;
		end if;
		 
		if (coalesce(cd_especialidade_medica_w,0) > 0) then 
			select	count(1) 
			into STRICT	qt_reg_w 
			from	medico_especialidade 
			where	cd_pessoa_fisica = cd_medico_solic_w 
			and	cd_especialidade = cd_especialidade_medica_w;
			 
			if (qt_reg_w = 0) then 
				goto Final2;
			end if;
		end if;
		 
		if (pls_verifica_excessao_lanc_aut(nr_seq_regra_w, nr_seq_requisicao_p, null, null) = 'N') then 
			open c02;
			loop 
			fetch c02 into 
				cd_procedimento_w, 
				ie_origem_proced_w, 
				nr_seq_material_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin 
				if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then 
					select	nextval('pls_requisicao_proc_seq') 
					into STRICT	nr_seq_req_proc_w 
					;
 
					insert into pls_requisicao_proc(nr_sequencia, nr_seq_requisicao, cd_procedimento, 
						 ie_origem_proced, qt_solicitado, dt_atualizacao, 
						 nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
						 ie_status, ie_estagio, qt_proc_executado, 
						 ie_origem_inclusao) 
					values (nr_seq_req_proc_w, nr_seq_requisicao_p, cd_procedimento_w, 
						 ie_origem_proced_w, 1, clock_timestamp(), 
						 nm_usuario_p, clock_timestamp(), nm_usuario_p, 
						 'U', 'AA', 0, 
						 ie_origem_inclusao_w);
					 
					CALL pls_atualiza_valor_proc_aut(nr_seq_req_proc_w, 'R', nm_usuario_p);
					 
					if (substr(pls_obter_se_segurado_intercam(null,nr_seq_requisicao_p,null),1,4)	= 'S') then 
						CALL pls_gerar_de_para_req_intercam( nr_seq_req_proc_w, null, null, 
										null, null, null, 
										null, cd_estabelecimento_w, nm_usuario_p);	
					 
					end if;
										 
				elsif (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then 
					select	nextval('pls_requisicao_mat_seq') 
					into STRICT	nr_seq_req_mat_w 
					;
 
					insert into pls_requisicao_mat(nr_sequencia, nr_seq_requisicao, nr_seq_material, 
						 dt_atualizacao, nm_usuario, dt_atualizacao_nrec, 
						 nm_usuario_nrec, ie_status, ie_estagio, 
						 qt_solicitado, qt_mat_executado, ie_origem_inclusao) 
					values (nr_seq_req_proc_w, nr_seq_requisicao_p, nr_seq_material_w, 
						clock_timestamp(), nm_usuario_p, clock_timestamp(), 
						nm_usuario_p, 'U', 'AA', 
						1, 0, ie_origem_inclusao_w);
 
					if (substr(pls_obter_se_segurado_intercam(null,nr_seq_requisicao_p,null),1,4)	= 'S') then 
						CALL pls_gerar_de_para_req_intercam( null, nr_seq_req_mat_w, null, 
										null, null, null, 
										null, cd_estabelecimento_w, nm_usuario_p);
					end if;
				end if;
				ie_lanc_auto_p	:= 'S';
				end;
			end loop;
			close c02;
		end if;
		<<Final2>> 
		qt_reg_w := 0;
		end;
	end loop;
	close c03;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_proced_autor_regra ( nr_seq_autorizacao_p bigint, nr_seq_requisicao_p bigint, ie_evento_p text, nm_usuario_p text, ie_lanc_auto_p INOUT text) FROM PUBLIC;

