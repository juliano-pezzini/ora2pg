-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_pck.get_afiliacao_eapb (cd_pessoa_fisica_p text, nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE

    const_ie_afiliacao constant varchar(1) := 'A';

BEGIN
    return alto_custo_pck.get_info_afiliacao(cd_pessoa_fisica_p, nr_atendimento_p, const_ie_afiliacao);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_pck.get_afiliacao_eapb (cd_pessoa_fisica_p text, nr_atendimento_p bigint) FROM PUBLIC;
