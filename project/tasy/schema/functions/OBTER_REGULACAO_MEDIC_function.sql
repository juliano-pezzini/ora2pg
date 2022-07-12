-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regulacao_medic ( cd_material_p bigint, ie_tipo_regra_p text, ie_grupo_p text default 'N') RETURNS bigint AS $body$
DECLARE

									
	nr_seq_regra_w 		regra_regulacao.nr_sequencia%type;
	nr_seq_regra_cur_w 	regra_regulacao.nr_sequencia%type;	
	nr_seq_grupo_regulacao_w 	regra_regulacao.nr_seq_grupo_regulacao%type;	

	
	C01 CURSOR FOR
	SELECT 	a.nr_sequencia
	from	regra_regulacao a
	where	a.ie_tipo = ie_tipo_regra_p
	and		coalesce(a.ie_tipo_parecer,'R') = 'R'
	and		coalesce(a.cd_material, coalesce(cd_material_p,0)) = coalesce(cd_material_p,0)	
	order by   coalesce(a.cd_material, 0);
	

BEGIN

open C01;
loop
fetch C01 into	
	nr_seq_regra_cur_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
begin
	nr_seq_regra_w := nr_seq_regra_cur_w;
end;
end loop;
close C01;
	
	
	if (ie_grupo_p = 'S') then
	
		select	max(nr_seq_grupo_regulacao)
		into STRICT	nr_seq_grupo_regulacao_w
		from	regra_regulacao
		where	nr_sequencia = nr_seq_regra_w;
		
		return nr_seq_grupo_regulacao_w;
		
	end if;
	
	return nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regulacao_medic ( cd_material_p bigint, ie_tipo_regra_p text, ie_grupo_p text default 'N') FROM PUBLIC;

