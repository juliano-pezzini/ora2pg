-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estab_mat_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_estab_w		bigint;
qt_estab_w		double precision;
cd_diluente_w		bigint;
cd_diluente_prescr_w	bigint;
ie_estagio_w		varchar(10);
nr_seq_diluicao_w	bigint;
nr_seq_reconstituicao_w	bigint;
cd_material_w		bigint;
cd_reconstituinte_w	bigint;
cd_estabelecimento_w	bigint;
ie_via_aplicacao_w	varchar(5);
qt_idade_w		bigint;
qt_peso_w		double precision;
ie_tempo_estab_w	varchar(5);
qt_estabilidade_w	double precision := null;
ds_forma_armaz_w	varchar(255);
ds_retorno_w		varchar(2000);

c01 CURSOR FOR
SELECT	a.qt_estabilidade,
	SUBSTR(obter_descricao_padrao('MAT_FORMA_ARMAZ','DS_FORMA_ARMAZ',a.nr_seq_forma),1,80),
	SUBSTR(obter_valor_dominio(1246, a.ie_tempo_estab),1,254)
FROM mat_estagio_armaz x, material_armazenamento a
LEFT OUTER JOIN material_diluicao c ON (a.NR_SEQ_RECONSTITUICAO = c.nr_seq_interno)
LEFT OUTER JOIN material_diluicao b ON (a.NR_SEQ_DILUICAO = b.nr_seq_interno)
WHERE x.nr_sequencia		= a.nr_seq_estagio and x.ie_estagio		= ie_estagio_w and a.cd_material		= cd_material_w and ((coalesce(a.ie_via_aplicacao::text, '') = '') or (a.ie_via_aplicacao	= ie_via_aplicacao_w)) and ((coalesce(NR_SEQ_RECONSTITUICAO::text, '') = '') or
	 (cd_reconstituinte_w IS NOT NULL AND cd_reconstituinte_w::text <> '' AND c.cd_diluente	= cd_reconstituinte_w)) and ((coalesce(NR_SEQ_DILUICAO::text, '') = '') or
	 (cd_diluente_prescr_w IS NOT NULL AND cd_diluente_prescr_w::text <> '' AND b.cd_diluente	= cd_diluente_prescr_w)) order by a.nr_seq_apres,
	 1;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	a.ie_via_aplicacao,
		a.cd_material
	into STRICT	ie_via_aplicacao_w,
		cd_material_w
	from	prescr_material a
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia	= nr_sequencia_p;

	select	max(a.cd_material)
	into STRICT	cd_diluente_prescr_w
	from	prescr_material a
	where	a.nr_sequencia_diluicao	= nr_sequencia_p
	and	a.nr_prescricao		= nr_prescricao_p
	and	a.ie_agrupador		= 3;

	select	max(a.cd_material)
	into STRICT	cd_reconstituinte_w
	from	prescr_material a
	where	a.nr_sequencia_diluicao	= nr_sequencia_p
	and	a.nr_prescricao		= nr_prescricao_p
	and	a.ie_agrupador		= 9;

	if (cd_diluente_prescr_w IS NOT NULL AND cd_diluente_prescr_w::text <> '') then
		ie_estagio_w	:= 1;
	elsif (cd_reconstituinte_w IS NOT NULL AND cd_reconstituinte_w::text <> '') then
		ie_estagio_w	:= 2;
	else
		ie_estagio_w	:= 3;
	end if;

	qt_estabilidade_w := null;
	qt_estab_w	:= null;
	ie_tempo_estab_w := null;
	ds_forma_armaz_w := null;

	open c01;
	loop
	fetch c01 into
		qt_estabilidade_w,
		ds_forma_armaz_w,
		ie_tempo_estab_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
		ds_retorno_w	:= ds_retorno_w || obter_desc_expressao(347075);
		END;
	END LOOP;
	CLOSE C01;

end if;

RETURN	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estab_mat_prescr (nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
