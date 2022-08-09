-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_tipo_item_nf_mens ( ie_tipo_item_p text, nr_seq_tipo_lanc_p bigint, cd_estabelecimento_p bigint, cd_procedimento_p INOUT text, ie_origem_proced_p INOUT bigint, cd_material_p INOUT text, nr_seq_grupo_item_p INOUT bigint) AS $body$
DECLARE


ie_encontrou_regra_item_w	varchar(1);

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		cd_material,
		nr_seq_grupo_item
	from	pls_tipo_item_mens
	where	((ie_tipo_item	= coalesce(ie_tipo_item_p,ie_tipo_item)) or (coalesce(ie_tipo_item::text, '') = ''))
	and	((nr_seq_tipo_lanc = coalesce(nr_seq_tipo_lanc_p,nr_seq_tipo_lanc)) or (coalesce(nr_seq_tipo_lanc::text, '') = ''))
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(nr_seq_grupo_item::text, '') = ''
	order by
		coalesce(ie_tipo_item,'0'),
		coalesce(nr_seq_tipo_lanc,0),
		coalesce(nr_seq_grupo_item,0);

BEGIN

ie_encontrou_regra_item_w := 'N';

open C01;
loop
fetch C01 into
	cd_procedimento_p,
	ie_origem_proced_p,
	cd_material_p,
	nr_seq_grupo_item_p;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_encontrou_regra_item_w := 'S';
	end;
end loop;
close C01;

if (ie_encontrou_regra_item_w = 'N') then
	if (ie_tipo_item_p = '20') then
		select	max(nr_seq_grupo_item)
		into STRICT	nr_seq_grupo_item_p
		from	pls_item_grupo_tipo_mens
		where	ie_tipo_item = ie_tipo_item_p
		and	((nr_seq_tipo_lanc = nr_seq_tipo_lanc_p) or (coalesce(nr_seq_tipo_lanc::text, '') = ''));
	else
		select	max(nr_seq_grupo_item)
		into STRICT	nr_seq_grupo_item_p
		from	pls_item_grupo_tipo_mens
		where	ie_tipo_item = ie_tipo_item_p;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_tipo_item_nf_mens ( ie_tipo_item_p text, nr_seq_tipo_lanc_p bigint, cd_estabelecimento_p bigint, cd_procedimento_p INOUT text, ie_origem_proced_p INOUT bigint, cd_material_p INOUT text, nr_seq_grupo_item_p INOUT bigint) FROM PUBLIC;
