-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_ordenacao_pa (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_order_by_w			varchar(4000);
cd_estabelecimento_w	smallint;
cd_perfil_w				integer;
cd_setor_atendimento_w  integer;

ds_sql_w				varchar(4000);
ie_order_by				varchar(1) := 'N';

c01 CURSOR FOR
	SELECT	' '||ds_sql
	from	regra_ordenacao_pa
	where	coalesce(ie_situacao,'I') = 'A'
	and  	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	and		coalesce(cd_perfil,cd_perfil_w) = cd_perfil_w
	and		coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w
	order by cd_estabelecimento, cd_perfil, cd_setor_atendimento;


BEGIN

ds_order_by_w := ' order by dt_entrada';

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	cd_estabelecimento_w := Obter_estab_usuario(nm_usuario_p);

	cd_perfil_w := obter_perfil_ativo;

	cd_setor_atendimento_w := obter_setor_usuario(nm_usuario_p);

	open c01;
	loop
	fetch c01 into
		ds_sql_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			if (ie_order_by = 'N') then
				ds_order_by_w := ds_sql_w;
				ie_order_by := 'S';
			end if;
		end;
	end loop;
	close c01;
end if;

return ds_order_by_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_ordenacao_pa (nm_usuario_p text) FROM PUBLIC;

