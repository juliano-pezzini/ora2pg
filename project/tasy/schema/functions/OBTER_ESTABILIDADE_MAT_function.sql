-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estabilidade_mat (cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_estab_w	bigint;
qt_estab_w		double precision;


BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	coalesce(min(nr_sequencia),0)
	into STRICT	nr_seq_estab_w
	from	material_armazenamento
	where	cd_material							= cd_material_p
	and	coalesce(cd_estabelecimento, coalesce(wheb_usuario_pck.get_cd_estabelecimento,0)) = coalesce(wheb_usuario_pck.get_cd_estabelecimento,0)
	and	converte_estab_hor(ie_tempo_estab, qt_estabilidade)	=	(	SELECT	min(converte_estab_hor(ie_tempo_estab, qt_estabilidade))
												from	material_armazenamento
												where	cd_material = cd_material_p
											);

	if (nr_seq_estab_w > 0) then

		select	converte_estab_hor(ie_tempo_estab, qt_estabilidade)
		into STRICT	qt_estab_w
		from	material_armazenamento
		where	nr_sequencia = nr_seq_estab_w;

	else

		qt_estab_w := null;

	end if;

end if;

return qt_estab_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estabilidade_mat (cd_material_p bigint) FROM PUBLIC;

