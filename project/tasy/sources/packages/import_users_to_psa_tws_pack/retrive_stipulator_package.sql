-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION import_users_to_psa_tws_pack.retrive_stipulator ( nm_usuario_web_p pls_grupo_contrato_web.nm_usuario_web%type) RETURNS SUBJECT.ID%TYPE AS $body$
DECLARE

				
ie_result_w   subject.id%TYPE;


BEGIN
select	a.id
into STRICT	ie_result_w
from    subject a,
	subject_client b,
	client c
where   b.id_subject = a.id
and     b.id_client = c.id
and     a.ds_replacement_login = nm_usuario_web_p
and     c.nm_client = 'stipulator';

RETURN ie_result_w;

EXCEPTION
WHEN no_data_found THEN
    ie_result_w := NULL;
    RETURN ie_result_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION import_users_to_psa_tws_pack.retrive_stipulator ( nm_usuario_web_p pls_grupo_contrato_web.nm_usuario_web%type) FROM PUBLIC;
