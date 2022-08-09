-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_componente_kit ( ie_tipo_p text, cd_especialidade_p text, cd_material_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			integer;
ds_kits_nao_excluidos_w		varchar(255) := 'X';
ie_situacao_w			varchar(1);
ie_tipo_w			varchar(1);
ie_forma_baixa_w		varchar(1);
ie_material_pai_w		varchar(1);
cd_especialidade_w		integer;

c01 CURSOR FOR
	SELECT	c.nr_sequencia
	from	kit_material b,
		componente_kit c
	where   b.cd_kit_material = c.cd_kit_material
	and     b.ie_tipo = ie_tipo_p
	and     c.cd_material = cd_material_p
	and	b.ie_situacao = 'A'
	and (b.cd_especialidade_medica = cd_especialidade_p or coalesce(cd_especialidade_p::text, '') = '');


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	begin
	delete	FROM componente_kit
	where	nr_sequencia = nr_sequencia_w;
	exception when others then
		ds_kits_nao_excluidos_w := ds_kits_nao_excluidos_w || ' - ' || nr_sequencia_w;
	end;

	end;
end loop;
close c01;

commit;

if (coalesce(ds_kits_nao_excluidos_w, 'X') <> 'X') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182546,'DS_KITS_NAO_EXCLUIDOS='||ds_kits_nao_excluidos_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_componente_kit ( ie_tipo_p text, cd_especialidade_p text, cd_material_p text, nm_usuario_p text) FROM PUBLIC;
