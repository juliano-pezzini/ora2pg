-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_unidades ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_apres_unid_w	bigint;


BEGIN

select	coalesce(max(nr_seq_apresent),999)
into STRICT	nr_seq_apres_unid_w
from	unidade_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p
and	cd_unidade_basica    = cd_unidade_basica_p
and	cd_unidade_compl     = cd_unidade_compl_p;

return	nr_seq_apres_unid_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_unidades ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text) FROM PUBLIC;

