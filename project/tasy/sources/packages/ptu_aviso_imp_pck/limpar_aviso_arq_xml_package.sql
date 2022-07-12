-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Limpar tabela que carrega arquivo XML
CREATE OR REPLACE PROCEDURE ptu_aviso_imp_pck.limpar_aviso_arq_xml ( nr_seq_lote_p ptu_aviso_arq_xml.nr_seq_lote%type, ie_tipo_arquivo_p ptu_aviso_arq_xml.ie_tipo_arquivo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
delete FROM ptu_aviso_arq_xml
where dt_atualizacao_nrec < clock_timestamp() - interval '1 days';

delete	FROM ptu_aviso_arq_xml
where	nr_seq_lote	= nr_seq_lote_p
and	ie_tipo_arquivo	= ie_tipo_arquivo_p;

delete	FROM ptu_aviso_arq_xml
where	nm_usuario_nrec	= nm_usuario_p;

commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_imp_pck.limpar_aviso_arq_xml ( nr_seq_lote_p ptu_aviso_arq_xml.nr_seq_lote%type, ie_tipo_arquivo_p ptu_aviso_arq_xml.ie_tipo_arquivo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;