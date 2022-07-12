-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_calc_volume_hemo ( nr_seq_derivado_p bigint, qt_peso_bolsa_p bigint, qt_peso_bolsa_vazia_p bigint, nr_seq_conservante_p bigint, cd_material_p bigint, ie_tipo_bolsa_p text default null) RETURNS bigint AS $body$
DECLARE


qt_densidade_w		double precision;
qt_volume_w		double precision;
qt_retorno_w		bigint;

BEGIN
if (nr_seq_derivado_p IS NOT NULL AND nr_seq_derivado_p::text <> '') then

	if (nr_seq_conservante_p IS NOT NULL AND nr_seq_conservante_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (coalesce(ie_tipo_bolsa_p::text, '') = '') then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado 	= nr_seq_derivado_p
		and	nr_seq_conservante 	= nr_seq_conservante_p
		and	cd_material	 	= cd_material_p
		and	coalesce(ie_tipo_bolsa::text, '') = '';
	elsif (nr_seq_conservante_p IS NOT NULL AND nr_seq_conservante_p::text <> '') and (coalesce(ie_tipo_bolsa_p::text, '') = '') then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado 	= nr_seq_derivado_p
		and	nr_seq_conservante 	= nr_seq_conservante_p
		and	coalesce(cd_material::text, '') = ''
		and	coalesce(ie_tipo_bolsa::text, '') = '';
	elsif (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (coalesce(ie_tipo_bolsa_p::text, '') = '') then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado 	= nr_seq_derivado_p
		and	cd_material	 	= cd_material_p
		and	coalesce(nr_seq_conservante::text, '') = ''
		and	coalesce(ie_tipo_bolsa::text, '') = '';
	elsif (coalesce(ie_tipo_bolsa_p::text, '') = '') then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado    = nr_seq_derivado_p
		and	coalesce(cd_material::text, '') = ''
		and	coalesce(nr_seq_conservante::text, '') = ''
		and	coalesce(ie_tipo_bolsa::text, '') = '';
	elsif (nr_seq_conservante_p IS NOT NULL AND nr_seq_conservante_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (ie_tipo_bolsa_p IS NOT NULL AND ie_tipo_bolsa_p::text <> '')  then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado 	= nr_seq_derivado_p
		and	nr_seq_conservante 	= nr_seq_conservante_p
		and	cd_material	 	= cd_material_p
		and	ie_tipo_bolsa = ie_tipo_bolsa_p;
	elsif (nr_seq_conservante_p IS NOT NULL AND nr_seq_conservante_p::text <> '') and (ie_tipo_bolsa_p IS NOT NULL AND ie_tipo_bolsa_p::text <> '')  then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado    = nr_seq_derivado_p
		and	nr_seq_conservante = nr_seq_conservante_p
		and	coalesce(cd_material::text, '') = ''
		and	ie_tipo_bolsa 	   = ie_tipo_bolsa_p;
	elsif (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (ie_tipo_bolsa_p IS NOT NULL AND ie_tipo_bolsa_p::text <> '')  then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado    = nr_seq_derivado_p
		and	cd_material	   = cd_material_p
		and	coalesce(nr_seq_conservante::text, '') = ''
		and	ie_tipo_bolsa 	   = ie_tipo_bolsa_p;
	elsif (ie_tipo_bolsa_p IS NOT NULL AND ie_tipo_bolsa_p::text <> '') then
		SELECT 	max(qt_densidade_hemo)
		into STRICT	qt_densidade_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado    = nr_seq_derivado_p
		and	coalesce(cd_material::text, '') = ''
		and	coalesce(nr_seq_conservante::text, '') = ''
		and	ie_tipo_bolsa      = ie_tipo_bolsa_p;
	end if;

	if (coalesce(qt_densidade_w::text, '') = '') then
		select	coalesce(max(qt_densidade_hemo),1)
		into STRICT	qt_densidade_w
		from	san_derivado
		where	nr_sequencia = nr_seq_derivado_p;
	end if;

	select	((coalesce(qt_peso_bolsa_p,0) - coalesce(qt_peso_bolsa_vazia_p,0)) / qt_densidade_w)
	into STRICT	qt_volume_w
	;

end if;

qt_retorno_w := qt_volume_w;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_calc_volume_hemo ( nr_seq_derivado_p bigint, qt_peso_bolsa_p bigint, qt_peso_bolsa_vazia_p bigint, nr_seq_conservante_p bigint, cd_material_p bigint, ie_tipo_bolsa_p text default null) FROM PUBLIC;

