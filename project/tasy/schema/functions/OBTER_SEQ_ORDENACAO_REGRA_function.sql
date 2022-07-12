-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_ordenacao_regra (nr_seq_regra_p bigint, cd_pessoa_fisica_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_ordenacao_w bigint;
nr_sequencia_w bigint;
C01 CURSOR FOR
	SELECT CASE WHEN coalesce(cd_pessoa_fisica,0)=0 THEN CASE WHEN coalesce(cd_setor_atendimento,0)=0 THEN CASE WHEN coalesce(cd_perfil,0)=0 THEN 0  ELSE 1 END   ELSE 2 END   ELSE 3 END
	from	regra_prescr_proc_perfil
	where	nr_seq_regra	= nr_seq_regra_p
	and		coalesce(cd_perfil, cd_perfil_p)	= cd_perfil_p
	and		coalesce(cd_pessoa_fisica, cd_pessoa_fisica_p) = cd_pessoa_fisica_p
	and		coalesce(cd_setor_atendimento, cd_setor_atendimento_p) = cd_setor_atendimento_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_ordenacao_w := nr_sequencia_w;
	end;
end loop;
close C01;

return	nr_seq_ordenacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_ordenacao_regra (nr_seq_regra_p bigint, cd_pessoa_fisica_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;

