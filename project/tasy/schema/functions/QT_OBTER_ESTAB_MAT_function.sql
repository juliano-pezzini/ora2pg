-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_estab_mat ( cd_material_p bigint, nr_seq_lote_p bigint default 0) RETURNS bigint AS $body$
DECLARE


nr_seq_estab_w		bigint;
qt_estab_w		double precision;
nr_seq_marca_w		double precision := 0;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;


BEGIN

select coalesce(max(nr_seq_marca),0)
into STRICT nr_seq_marca_w
from material_lote_fornec
where nr_sequencia = nr_seq_lote_p;

cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento, 0);
nr_seq_estab_w := Obter_Param_Usuario(3130, 375, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_w, nr_seq_estab_w);

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (nr_seq_estab_w > 0) then

		select	max(converte_estab_hor(ie_tempo_estab, qt_estabilidade))
		into STRICT	qt_estab_w
		from	material_armazenamento
		where	nr_seq_estagio = nr_seq_estab_w
		and	cd_material = cd_material_p
		and 	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
		and 	coalesce(nr_seq_marca, nr_seq_marca_w) =  nr_seq_marca_w;
else
		qt_estab_w := null;
end if;

return qt_estab_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_estab_mat ( cd_material_p bigint, nr_seq_lote_p bigint default 0) FROM PUBLIC;
