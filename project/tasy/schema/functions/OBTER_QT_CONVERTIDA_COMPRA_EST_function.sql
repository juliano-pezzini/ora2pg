-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_convertida_compra_est ( cd_material_p bigint, qt_material_p bigint, cd_unidade_medida_p text, nr_seq_marca_p bigint, cd_cgc_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_conv_compra_est_w	double precision := 0;
qt_conv_est_consumo_w	double precision := 0;
cd_unid_med_compra_w	varchar(30);
cd_unid_med_estoque_w	varchar(30);
cd_unid_med_consumo_w	varchar(30);
qt_existe_w		bigint;
qt_convertida_w		double precision;

c01 CURSOR FOR
SELECT	qt_conv_compra_est
from	material_marca
where	coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
and	cd_material		= cd_material_p
and	coalesce(cd_cnpj, cd_cgc_p)	= cd_cgc_p
and	cd_unidade_medida	= cd_unidade_medida_p
and	coalesce(qt_conv_compra_est,0)	> 0
and	nr_sequencia		= nr_seq_marca_p
order by	cd_cnpj desc,
	cd_estabelecimento desc;


BEGIN

if (coalesce(cd_material_p::text, '') = '') then

	qt_conv_compra_est_w := 1;
	qt_convertida_w	:= (qt_material_p * qt_conv_compra_est_w);

elsif (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (nr_seq_marca_p IS NOT NULL AND nr_seq_marca_p::text <> '') and (cd_unidade_medida_p IS NOT NULL AND cd_unidade_medida_p::text <> '') then
	begin

	select	count(*)
	into STRICT	qt_existe_w
	from	material_marca
	where	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p
	and	cd_material					= cd_material_p
	and	coalesce(cd_cnpj, cd_cgc_p) 				= cd_cgc_p
	and	cd_unidade_medida				= cd_unidade_medida_p
	and	nr_sequencia					= nr_seq_marca_p
	and	coalesce(qt_conv_compra_est, 0) > 0;

	if (qt_existe_w > 0) then
		open C01;
		loop
		fetch C01 into
			qt_conv_compra_est_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
		end loop;
		close C01;
	end if;
	end;

	qt_convertida_w	:= (qt_material_p * qt_conv_compra_est_w);

end if;

if (qt_conv_compra_est_w = 0) and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') and (cd_unidade_medida_p IS NOT NULL AND cd_unidade_medida_p::text <> '') then
	begin

	select	coalesce(max(qt_conv_compra_est),0)
	into STRICT	qt_conv_compra_est_w
	from	material_fornec
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_material		= cd_material_p
	and	cd_cgc			= cd_cgc_p
	and	cd_unid_medida		= cd_unidade_medida_p
	and	coalesce(ie_nota_fiscal,'S') = 'S';

	qt_convertida_w	:= (qt_material_p * qt_conv_compra_est_w);

	end;
end if;

if (qt_conv_compra_est_w = 0) then
	begin

	Select	(max(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'QCE'),1,255)))::numeric ,
		(max(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'QEC'),1,255)))::numeric ,
		max(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMC'),1,255)),
		max(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,255)),
		max(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMS'),1,255))
	into STRICT	qt_conv_compra_est_w,
		qt_conv_est_consumo_w,
		cd_unid_med_compra_w,
		cd_unid_med_estoque_w,
		cd_unid_med_consumo_w
	from	material
	where	cd_material	= cd_material_p;

	if (cd_unidade_medida_p = cd_unid_med_compra_w) then
		qt_convertida_w := (qt_material_p * qt_conv_compra_est_w);
	elsif (cd_unidade_medida_p = cd_unid_med_estoque_w) then
		qt_convertida_w := (qt_material_p * 1);
	elsif (cd_unidade_medida_p = cd_unid_med_consumo_w) then
		begin
		if (qt_conv_est_consumo_w > 0) then
			qt_convertida_w := (qt_material_p * (1 / qt_conv_est_consumo_w));
		else
			qt_convertida_w := 0;
		end if;
		end;
	else
		qt_convertida_w := (qt_material_p * 1);
	end if;

	end;
end if;

return	qt_convertida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_convertida_compra_est ( cd_material_p bigint, qt_material_p bigint, cd_unidade_medida_p text, nr_seq_marca_p bigint, cd_cgc_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
