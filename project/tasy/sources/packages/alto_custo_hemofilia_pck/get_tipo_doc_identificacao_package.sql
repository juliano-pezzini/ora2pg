-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_hemofilia_pck.get_tipo_doc_identificacao (cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) RETURNS varchar AS $body$
BEGIN
    return alto_custo_pck.get_tipo_doc_identificacao(cd_pessoa_fisica_p);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_hemofilia_pck.get_tipo_doc_identificacao (cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type) FROM PUBLIC;
