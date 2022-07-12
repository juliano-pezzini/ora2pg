-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- Limpar tabela que carrega arquivo XML
CREATE OR REPLACE PROCEDURE ptu_a1200_imp_pck.limpar_arq_xml ( ie_tipo_arquivo_p ptu_aviso_arq_xml.ie_tipo_arquivo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	delete  FROM ptu_aviso_arq_xml
	where  	dt_atualizacao_nrec < clock_timestamp() - interval '1 days'
	and  	ie_tipo_arquivo_p = ie_tipo_arquivo_p;

	if (ie_tipo_arquivo_p IS NOT NULL AND ie_tipo_arquivo_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

		delete	FROM ptu_aviso_arq_xml
		where	ie_tipo_arquivo_p = ie_tipo_arquivo_p
		and  	nm_usuario_nrec   = nm_usuario_p;
		
	end if;

	commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_a1200_imp_pck.limpar_arq_xml ( ie_tipo_arquivo_p ptu_aviso_arq_xml.ie_tipo_arquivo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
