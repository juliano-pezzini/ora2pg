-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finality:  Carregar mensagens da funcao OPS - Comunicacao Externa
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
CREATE OR REPLACE PROCEDURE hpms_configurar_portal_tws_pck.atualizar_mensagens_estip () AS $body$
DECLARE


qt_registro_w	integer;


BEGIN

update pls_comunic_ext_hist_web a
set    a.ds_login = (SELECT max(b.ds_login) from wsuite_usuario b where b.cd_pessoa_fisica = a.cd_pessoa_fisica_resp and (b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> ''))
where  coalesce(a.ds_login::text, '') = ''
and    a.ie_tipo_acesso = 'E'
and    (a.cd_pessoa_fisica_resp IS NOT NULL AND a.cd_pessoa_fisica_resp::text <> '');

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hpms_configurar_portal_tws_pck.atualizar_mensagens_estip () FROM PUBLIC;
