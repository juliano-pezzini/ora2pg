-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_calc_collect_conserv ( dt_vencimento_p timestamp, nr_seq_derivado_p bigint, nr_seq_conservante_p bigint, cd_material_p bigint, ie_tipo_bolsa_p text) RETURNS timestamp AS $body$
DECLARE


dt_producao_w		timestamp;			

BEGIN

if (nr_seq_derivado_p IS NOT NULL AND nr_seq_derivado_p::text <> '') then
	if (nr_seq_conservante_p IS NOT NULL AND nr_seq_conservante_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
		select 	dt_vencimento_p - max(coalesce(qt_dias_validade,0))
		into STRICT	dt_producao_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado 	= nr_seq_derivado_p
		and	nr_seq_conservante 	= nr_seq_conservante_p
		and	cd_material	 	= cd_material_p
		and	((ie_tipo_bolsa		= coalesce(ie_tipo_bolsa_p, ie_tipo_bolsa)) or
			((coalesce(ie_tipo_bolsa::text, '') = '') and (not exists (SELECT	1
								from	san_derivado_regra 
								where	nr_seq_derivado 	= nr_seq_derivado_p
								and	nr_seq_conservante 	= nr_seq_conservante_p
								and	cd_material	 	= cd_material_p
								and	ie_tipo_bolsa 		= ie_tipo_bolsa_p))));

			
	elsif (nr_seq_conservante_p IS NOT NULL AND nr_seq_conservante_p::text <> '') then
		select 	dt_vencimento_p - max(coalesce(qt_dias_validade,0))
		into STRICT	dt_producao_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado 	= nr_seq_derivado_p
		and	nr_seq_conservante 	= nr_seq_conservante_p
		and	coalesce(cd_material::text, '') = ''
		and	((ie_tipo_bolsa		= coalesce(ie_tipo_bolsa_p, ie_tipo_bolsa)) or
			((coalesce(ie_tipo_bolsa::text, '') = '') and (not exists (SELECT	1
								from	san_derivado_regra
								where	nr_seq_derivado 	= nr_seq_derivado_p
								and	nr_seq_conservante 	= nr_seq_conservante_p
								and	coalesce(cd_material::text, '') = ''
								and	ie_tipo_bolsa 		= ie_tipo_bolsa_p))));
	elsif (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
		select 	dt_vencimento_p - max(coalesce(qt_dias_validade,0))
		into STRICT	dt_producao_w
		FROM   	san_derivado_regra
		WHERE  	nr_seq_derivado 	= nr_seq_derivado_p
		and	cd_material	 	= cd_material_p	
		and	coalesce(nr_seq_conservante::text, '') = ''
		and	((ie_tipo_bolsa		= coalesce(ie_tipo_bolsa_p, ie_tipo_bolsa)) or
			((coalesce(ie_tipo_bolsa::text, '') = '') and (not exists (SELECT	1
								from	san_derivado_regra
								where	nr_seq_derivado 	= nr_seq_derivado_p
								and	coalesce(nr_seq_conservante::text, '') = ''
								and	cd_material	 	= cd_material_p
								and	ie_tipo_bolsa 		= ie_tipo_bolsa_p))));
	end if;
end if;

return	dt_producao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_calc_collect_conserv ( dt_vencimento_p timestamp, nr_seq_derivado_p bigint, nr_seq_conservante_p bigint, cd_material_p bigint, ie_tipo_bolsa_p text) FROM PUBLIC;

