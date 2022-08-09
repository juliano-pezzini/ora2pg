-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_ocor_aut_opm_web ( nr_seq_ocor_combinada_p pls_ocor_aut_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_utiliza_filtro_p pls_ocor_aut_combinada.ie_utiliza_filtro%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
Validar a ocorrência combinada Valida Tipo internação X CID, onde é validado o 
 tipo de internação cadastrado na guia, com o CID informado. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ x] Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
qt_regra_valid_aut_opme_web_w	bigint;
ie_gerar_ocorrencia_w		varchar(2);
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;	
ie_tipo_ocorrencia_w		varchar(2);
ie_regra_w			varchar(2);	
nr_seq_oc_benef_w		pls_ocorrencia_benef.nr_sequencia%type;	
ie_gerou_ocor_cabecalho_w	varchar(2);

 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced		 
	from	pls_requisicao_proc 
	where	nr_seq_requisicao	= nr_seq_requisicao_p 
	and	ie_utiliza_opme		= 'S';

C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_material 
	from	pls_requisicao_mat 
	where	nr_seq_requisicao	= nr_seq_requisicao_p 
	and	ie_utiliza_opme		= 'S';

BEGIN 
 
select	count(1) 
into STRICT	qt_regra_valid_aut_opme_web_w 
from	pls_validacao_aut_opm_web 
where	nr_seq_ocor_aut_combinada	= nr_seq_ocor_combinada_p 
and	ie_situacao			= 'A';
 
if (qt_regra_valid_aut_opme_web_w > 0) then	 
	begin 
		select	nr_seq_prestador, 
			nr_seq_segurado 
		into STRICT	nr_seq_prestador_w, 
			nr_seq_segurado_w 
		from	pls_requisicao 
		where 	nr_sequencia	= nr_seq_requisicao_p;
	exception 
	when others then 
		nr_seq_prestador_w	:= null;
	end;		
	 
	for r_C01_w in C01 loop 
		begin 
			ie_gerar_ocorrencia_w	:= 'S';	
					 
			if (ie_utiliza_filtro_p	= 'S') then 
				/* Tratamento para filtros */
 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, null, nr_seq_requisicao_p, null, null, null, r_C01_w.nr_sequencia, null, null, r_C01_w.cd_procedimento, r_C01_w.ie_origem_proced, null, null, nr_seq_prestador_w, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
								 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;							
			end if;
			 
			if (ie_gerar_ocorrencia_w	= 'S') then 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_w, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, r_C01_w.nr_sequencia, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 5, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
						 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								null, nr_seq_requisicao_p, null, 
								null, null, r_C01_w.nr_sequencia, 
								null, null, null, 
								nm_usuario_p, cd_estabelecimento_p);			
			end if;
		end;
	end loop;
	for r_C02_w in C02 loop 
		begin 
			ie_gerar_ocorrencia_w	:= 'S';
			 
			if (ie_utiliza_filtro_p	= 'S') then 
				/* Tratamento para filtros */
 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, null, nr_seq_requisicao_p, null, null, null, null, r_C02_w.nr_sequencia, null, null, null, r_C02_w.nr_seq_material, null, nr_seq_prestador_w, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
								 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;
			end if;
			 
			if (ie_gerar_ocorrencia_w	= 'S') then	 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_w, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, null, r_C02_w.nr_sequencia, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 6, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
							 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								null, nr_seq_requisicao_p, null, 
								null, r_C02_w.nr_sequencia, null, 
								null, null, null, 
								nm_usuario_p, cd_estabelecimento_p);				
			end if;
		end;
	end loop;
end if;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_ocor_aut_opm_web ( nr_seq_ocor_combinada_p pls_ocor_aut_combinada.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_utiliza_filtro_p pls_ocor_aut_combinada.ie_utiliza_filtro%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;
