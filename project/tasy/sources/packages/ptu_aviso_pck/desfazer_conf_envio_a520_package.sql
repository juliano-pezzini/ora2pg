-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Desfazer envio A520



CREATE OR REPLACE PROCEDURE ptu_aviso_pck.desfazer_conf_envio_a520 ( nr_seq_arquivo_p ptu_aviso_arquivo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_concil_contab_w		pls_visible_false.ie_concil_contab%type;


BEGIN

select	coalesce(max(ie_concil_contab), 'N')
into STRICT	ie_concil_contab_w
from	pls_visible_false;

if (ie_concil_contab_w = 'S') then
	CALL pls_ctb_onl_gravar_movto_pck.gravar_movto_desfaz_envio_a520(nr_seq_arquivo_p, nm_usuario_p);
end if;

update	ptu_aviso_arquivo
set	dt_confirmacao_envio	 = NULL
where	nr_sequencia		= nr_seq_arquivo_p;

commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_pck.desfazer_conf_envio_a520 ( nr_seq_arquivo_p ptu_aviso_arquivo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;