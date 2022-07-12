-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_hepatite_pck.get_dt_fim_tratamento ( cd_pessoa_fisica_p text, ie_tipo_doenca_p regra_alto_custo.ie_tipo_doenca%type) RETURNS timestamp AS $body$
DECLARE

    const_ie_data_fim CONSTANT varchar(1) := 'F';

BEGIN
    return alto_custo_hepatite_pck.get_dt_tratamento(cd_pessoa_fisica_p, ie_tipo_doenca_p, const_ie_data_fim);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_hepatite_pck.get_dt_fim_tratamento ( cd_pessoa_fisica_p text, ie_tipo_doenca_p regra_alto_custo.ie_tipo_doenca%type) FROM PUBLIC;
