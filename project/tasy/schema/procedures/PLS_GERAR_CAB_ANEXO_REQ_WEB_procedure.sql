-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_cab_anexo_req_web ( nr_seq_requisicao_p bigint, ie_tipo_anexo_p text, nm_usuario_p text, nr_seq_anexo_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_anexo_w				pls_lote_anexo_guias_aut.nr_sequencia%type;
nm_profissional_solic_w		pls_lote_anexo_guias_aut.nm_profissional_solic%type;
nr_telef_prof_solic_w		pls_lote_anexo_guias_aut.nr_telef_prof_solic%type;
ds_email_prof_solic_w		pls_lote_anexo_guias_aut.ds_email_prof_solic%type;
cd_medico_solic_w			pls_guia_plano.cd_medico_solicitante%type;		
 
nr_seq_segurado_w			pls_segurado.nr_sequencia%type;
ie_sexo_w					pls_lote_anexo_guias_aut.ie_sexo%type;
qt_idade_benef_w			pls_lote_anexo_guias_aut.qt_idade_benef%type;		
 

BEGIN									 
 
select	max(nr_sequencia) 
into STRICT	nr_seq_anexo_w 
from	pls_lote_anexo_guias_aut 
where	nr_seq_requisicao = nr_seq_requisicao_p 
and		ie_tipo_anexo = ie_tipo_anexo_p;
 
if (coalesce(nr_seq_anexo_w::text, '') = '') then 
	select	nextval('pls_lote_anexo_guias_aut_seq') 
	into STRICT	nr_seq_anexo_w 
	;	
 
	select	max(cd_medico_solicitante) 
	into STRICT	cd_medico_solic_w 
	from	pls_requisicao 
	where	nr_sequencia	= nr_seq_requisicao_p;
	 
	select max(nr_seq_segurado) 
	into STRICT	nr_seq_segurado_w 
	from	pls_requisicao 
	where	nr_sequencia = nr_seq_requisicao_p;
 
	if (coalesce(ie_sexo_w::text, '') = '') then 
		ie_sexo_w := pls_obter_dados_segurado(nr_seq_segurado_w, 'SXS');
		if (ie_sexo_w = 'M') then 
			ie_sexo_w := '1';
		elsif (ie_sexo_w = 'F') then 
			ie_sexo_w := '3';
		end if;
	end if;
 
	if (coalesce(qt_idade_benef_w::text, '') = '') then 
		qt_idade_benef_w :=	pls_obter_dados_segurado(nr_seq_segurado_w, 'ID');
	end if;
	 
	if (cd_medico_solic_w IS NOT NULL AND cd_medico_solic_w::text <> '') then 
		nm_profissional_solic_w	:= substr(pls_obter_dados_medico(cd_medico_solic_w, 'NM'),1,70);
		nr_telef_prof_solic_w	:= substr(pls_obter_dados_medico(cd_medico_solic_w, 'TC'),1,11);
		ds_email_prof_solic_w	:= substr(pls_obter_dados_medico(cd_medico_solic_w, 'EC'),1,60);
	end if;
 
	 
	insert	into  pls_lote_anexo_guias_aut(nr_sequencia, ie_tipo_anexo, nr_seq_requisicao, 
											 nm_usuario, nm_usuario_nrec, dt_atualizacao, 
											 dt_atualizacao_nrec, nm_profissional_solic, nr_telef_prof_solic, 
											 ds_email_prof_solic, ie_sexo, qt_idade_benef ) 
									 values (nr_seq_anexo_w, ie_tipo_anexo_p, nr_seq_requisicao_p, 
											 nm_usuario_p, nm_usuario_p, clock_timestamp(), 
											 clock_timestamp(), nm_profissional_solic_w, nr_telef_prof_solic_w, 
											 ds_email_prof_solic_w, ie_sexo_w, qt_idade_benef_w);			
 
	commit;
end if;
 
nr_seq_anexo_p := nr_seq_anexo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_cab_anexo_req_web ( nr_seq_requisicao_p bigint, ie_tipo_anexo_p text, nm_usuario_p text, nr_seq_anexo_p INOUT bigint) FROM PUBLIC;

