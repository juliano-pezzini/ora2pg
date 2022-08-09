-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_material_estab2 () AS $body$
DECLARE


count_w			smallint;
cd_estabelecimento_w		smallint;
cd_material_w			integer;
ie_prescricao_w		varchar(1);
ie_padronizado_w		varchar(1);

C01 CURSOR FOR
	SELECT	cd_estabelecimento
	FROM	estabelecimento;

C02 CURSOR FOR
	SELECT	a.cd_material,
		a.ie_prescricao,
		a.ie_padronizado
	FROM	material a
	WHERE EXISTS (
		SELECT	1
		FROM	material_estab b
		WHERE	b.cd_material = a.cd_material
		AND	b.cd_estabelecimento = cd_estabelecimento_w
		and (coalesce(b.ie_prescricao::text, '') = '' or coalesce(b.ie_padronizado::text, '') = ''));

BEGIN

OPEN C01;
LOOP
FETCH c01 INTO
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN
	OPEN C02;
	LOOP
	FETCH c02 INTO
		cd_material_w,
		ie_prescricao_w,
		ie_padronizado_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		BEGIN

		update	material_estab
		set	ie_prescricao		= ie_prescricao_w
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	cd_material		= cd_material_w
		and	coalesce(ie_prescricao::text, '') = '';

		update	material_estab
		set	ie_padronizado	= ie_padronizado_w
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	cd_material		= cd_material_w
		and	coalesce(ie_padronizado::text, '') = '';

		END;
	END LOOP;
	CLOSE c02;
	END;
END LOOP;
CLOSE c01;

COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_material_estab2 () FROM PUBLIC;
