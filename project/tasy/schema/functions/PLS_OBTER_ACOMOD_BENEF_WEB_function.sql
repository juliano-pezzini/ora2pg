-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_acomod_benef_web (nr_seq_plano_p bigint, ie_tipo_operacao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_acomodacao_w	bigint;


BEGIN

select	max(nr_seq_tipo_acomodacao)
into STRICT	nr_seq_acomodacao_w
from	pls_regra_plano_benef_web
where	nr_seq_plano = nr_seq_plano_p
and	ie_tipo_operacao = ie_tipo_operacao_p;

return	nr_seq_acomodacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_acomod_benef_web (nr_seq_plano_p bigint, ie_tipo_operacao_p text) FROM PUBLIC;

