-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_ocor_aut_concor ( nr_seq_ocor_combinada_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_segurado_p bigint, nr_seq_motivo_glosa_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, ie_utiliza_filtro_p text, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
 
ie_regra_w			varchar(255);
ie_gerar_ocorrencia_w		varchar(255);
ie_gerou_ocor_cabecalho_w	varchar(255);
ie_tipo_ocorrencia_w		varchar(255);
nr_seq_oc_benef_w		bigint;
cd_prestador_w			varchar(30);
cd_medico_solic_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;

 
C01 CURSOR FOR 
	SELECT	nr_seq_concorrente, 
		ie_concorrente_anterior, 
		ie_valida_prestador, 
		ie_valida_execucao, 
		qt_dias_considerar, 
		coalesce(ie_valida_medico_solic, 'N') ie_valida_medico_solic, 
		ie_valida_proc_princ, 
		ie_tipo_qtde 
	from	pls_validacao_aut_conc 
	where	nr_seq_ocor_aut_combinada	= nr_seq_ocor_combinada_p 
	and	ie_situacao			= 'A';
	
C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from	pls_guia_plano_proc 
	where	nr_seq_guia		= nr_seq_guia_p;
	
C03 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from	pls_requisicao_proc 
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

C04 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from	pls_execucao_req_item 
	where	nr_seq_execucao		= nr_seq_execucao_p 
	and	coalesce(nr_seq_material::text, '') = '';

BEGIN 
 
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
	begin 
		select	nr_seq_prestador, 
			cd_medico_solicitante 
		into STRICT	nr_seq_prestador_w, 
			cd_medico_solic_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
	exception 
	when others then 
		nr_seq_prestador_w	:= null;
		cd_medico_solic_w	:= null;
	end;
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
	begin 
		select	nr_seq_prestador, 
			cd_medico_solicitante 
		into STRICT	nr_seq_prestador_w, 
			cd_medico_solic_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
	exception 
	when others then 
		nr_seq_prestador_w	:= null;
		cd_medico_solic_w	:= null;
	end;
elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then 
	begin 
		select	a.nr_seq_prestador, 
			b.cd_medico_solicitante 
		into STRICT	nr_seq_prestador_w, 
			cd_medico_solic_w 
		from	pls_execucao_requisicao a, 
			pls_requisicao b 
		where	b.nr_sequencia	= a.nr_seq_requisicao 
		and	a.nr_sequencia	= nr_seq_execucao_p;
	exception 
	when others then 
		nr_seq_prestador_w	:= null;
		cd_medico_solic_w	:= null;
	end;
end if;
 
begin 
	select	coalesce(pls_obter_cod_prestador(nr_seq_prestador_w,null),'0') 
	into STRICT	cd_prestador_w 
	;
exception 
when others then 
	cd_prestador_w := '0';
end;
 
for r_C01_w in C01 loop 
		begin	 
		if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
			for r_C02_w in C02 loop 
				begin 
				ie_gerar_ocorrencia_w	:= 'S';
 
				if (ie_utiliza_filtro_p	= 'S') then 
					/* Tratamento para filtros */
 
					SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, r_C02_w.nr_sequencia, null, null, null, null, r_C02_w.cd_procedimento, r_C02_w.ie_origem_proced, null, ie_gerou_ocor_cabecalho_w, nr_seq_prestador_w, null, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
									 
					if (ie_regra_w	= 'S') then 
						ie_gerar_ocorrencia_w	:= 'S';
					elsif (ie_regra_w	in ('E','N')) then 
						ie_gerar_ocorrencia_w	:= 'N';
					end if;
				end if;
				 
				if (ie_gerar_ocorrencia_w	= 'S') then 
				 
					ie_gerar_ocorrencia_w	:= pls_obter_se_proc_concorrente(r_C01_w.nr_seq_concorrente, nr_seq_guia_p, nr_seq_requisicao_p, 
												nr_seq_execucao_p, nr_seq_prestador_w, r_C02_w.cd_procedimento, 
												r_C02_w.ie_origem_proced, r_C01_w.ie_concorrente_anterior, r_C01_w.ie_valida_prestador, 
												cd_prestador_w, null, null, 
												r_C01_w.qt_dias_considerar, r_C01_w.ie_valida_medico_solic, cd_medico_solic_w, 
												r_C01_w.ie_valida_proc_princ, r_C01_w.ie_tipo_qtde);
													 
					if (ie_gerar_ocorrencia_w	= 'S') then 
					 
						nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, r_C02_w.nr_sequencia, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 1, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
								 
						CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
										nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
										r_C02_w.nr_sequencia, null, null, 
										null, null, null, 
										nm_usuario_p, cd_estabelecimento_p);
					end if;
				end if;
				end;
			end loop;
		elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
			for r_C03_w in C03 loop 
				begin 
				ie_gerar_ocorrencia_w	:= 'S';
 
				if (ie_utiliza_filtro_p	= 'S') then 
					/* Tratamento para filtros */
 
					SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, null, null, r_C03_w.nr_sequencia, null, null, r_C03_w.cd_procedimento, r_C03_w.ie_origem_proced, null, ie_gerou_ocor_cabecalho_w, nr_seq_prestador_w, null, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
									 
					if (ie_regra_w	= 'S') then 
						ie_gerar_ocorrencia_w	:= 'S';
					elsif (ie_regra_w	in ('E','N')) then 
						ie_gerar_ocorrencia_w	:= 'N';
					end if;
				end if;
					 
				if (ie_gerar_ocorrencia_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= pls_obter_se_proc_concorrente(r_C01_w.nr_seq_concorrente, nr_seq_guia_p, nr_seq_requisicao_p, 
												nr_seq_execucao_p, nr_seq_prestador_w, r_C03_w.cd_procedimento, 
												r_C03_w.ie_origem_proced, r_C01_w.ie_concorrente_anterior, r_C01_w.ie_valida_prestador, 
												cd_prestador_w, coalesce(r_C01_w.ie_valida_execucao,'N'), null, 
												r_C01_w.qt_dias_considerar, r_C01_w.ie_valida_medico_solic, cd_medico_solic_w, 
												r_C01_w.ie_valida_proc_princ, r_C01_w.ie_tipo_qtde);
							 
					if (ie_gerar_ocorrencia_w	= 'S') then 
						nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, r_C03_w.nr_sequencia, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 5, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
								 
						CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
										nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
										null, null, r_C03_w.nr_sequencia, 
										null, null, null, 
										nm_usuario_p, cd_estabelecimento_p);
					end if;
				end if;
				end;
			end loop;
		elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then 
			for r_C04_w in C04 loop 
				begin 
				ie_gerar_ocorrencia_w	:= 'S';
 
				if (ie_utiliza_filtro_p	= 'S') then 
					/* Tratamento para filtros */
 
					SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, null, null, null, null, r_C04_w.nr_sequencia, r_C04_w.cd_procedimento, r_C04_w.ie_origem_proced, null, ie_gerou_ocor_cabecalho_w, nr_seq_prestador_w, null, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
									 
					if (ie_regra_w	= 'S') then 
						ie_gerar_ocorrencia_w	:= 'S';
					elsif (ie_regra_w	in ('E','N')) then 
						ie_gerar_ocorrencia_w	:= 'N';
					end if;
				end if;
				 
				if (ie_gerar_ocorrencia_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= pls_obter_se_proc_concorrente(r_C01_w.nr_seq_concorrente, nr_seq_guia_p, nr_seq_requisicao_p, 
												nr_seq_execucao_p, nr_seq_prestador_w, r_C04_w.cd_procedimento, 
												r_C04_w.ie_origem_proced, r_C01_w.ie_concorrente_anterior, r_C01_w.ie_valida_prestador, 
												cd_prestador_w, null, null, 
												r_C01_w.qt_dias_considerar, r_C01_w.ie_valida_medico_solic, cd_medico_solic_w, 
												r_C01_w.ie_valida_proc_princ, r_C01_w.ie_tipo_qtde);
													 
					if (ie_gerar_ocorrencia_w	= 'S') then 
						nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, null, null, r_C04_w.nr_sequencia, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 10, cd_estabelecimento_p, 'N', nr_seq_execucao_p, nr_seq_oc_benef_w, null, null, null, null);
							 
						CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
										nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
										null, null, null, 
										null, r_C04_w.nr_sequencia, null, 
										nm_usuario_p, cd_estabelecimento_p);
					end if;
				end if;
				end;
			end loop;
		end if;
	end;
end loop;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_ocor_aut_concor ( nr_seq_ocor_combinada_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_segurado_p bigint, nr_seq_motivo_glosa_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, ie_utiliza_filtro_p text, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
