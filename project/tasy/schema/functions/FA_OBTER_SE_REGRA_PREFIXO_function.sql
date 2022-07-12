-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_se_regra_prefixo ( cd_estabelecimento_p bigint, cd_perfil_p bigint ) RETURNS bigint AS $body$
DECLARE

				   
nr_seq_regra_w		bigint;
ie_has_timestamp_prefix_rule_w varchar(1) := 0;


BEGIN

nr_seq_regra_w := fa_obter_regra_receita_atual(cd_estabelecimento_p, cd_perfil_p);

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then

  select count(a.nr_sequencia)
  into STRICT ie_has_timestamp_prefix_rule_w
  from FA_REGRA_GERACAO_RECEITA a
  where a.nr_sequencia = nr_seq_regra_w
  and coalesce(si_use_timestamp_prefix,'N') = 'S'
  and (a.ds_timestamp_format IS NOT NULL AND a.ds_timestamp_format::text <> '');

end if;

return ie_has_timestamp_prefix_rule_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_se_regra_prefixo ( cd_estabelecimento_p bigint, cd_perfil_p bigint ) FROM PUBLIC;
