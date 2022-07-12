-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_princ_ativo_plano (cd_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_princ_ativo_princ_w	varchar(1000);
ds_concetracao_princ_w	varchar(1000);
ds_princ_ativo_sec_w	varchar(1000);
ds_concetracao_sec_w	varchar(1000);
ds_princ_ativo_w		varchar(255);
ds_concentracao_w		varchar(255);

c01 CURSOR FOR
SELECT 	substr(obter_descricao_padrao('MEDIC_FICHA_TECNICA', 'DS_SUBSTANCIA',NR_SEQ_MEDIC_FICHA_TECNICA),1,80),
		QT_CONVERSAO_MG || CD_UNID_MED_CONCETRACAO
from 	material_princ_ativo
where 	cd_material = cd_material_p;


BEGIN

	open C01;
	loop
	fetch C01 into
		ds_princ_ativo_w,
		ds_concentracao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			if (ds_princ_ativo_w IS NOT NULL AND ds_princ_ativo_w::text <> '') then
				ds_princ_ativo_sec_w := ds_princ_ativo_sec_w || ' + ' || ds_princ_ativo_w;
			end if;
			if (ds_concentracao_w IS NOT NULL AND ds_concentracao_w::text <> '') then
				ds_concetracao_sec_w := ds_concetracao_sec_w || ' + ' || ds_concentracao_w;
			end if;
		end;
	end loop;
	close C01;

	select 	substr(obter_descricao_padrao('MEDIC_FICHA_TECNICA', 'DS_SUBSTANCIA',NR_SEQ_FICHA_TECNICA),1,80),
			QT_CONVERSAO_MG || CD_UNID_MED_CONCETRACAO
	INTO STRICT	ds_princ_ativo_princ_w,
			ds_concetracao_princ_w
	from 	material a
	where 	cd_material = cd_material_p;

	if (ie_opcao_p = 'P')then
		if (ds_princ_ativo_sec_w IS NOT NULL AND ds_princ_ativo_sec_w::text <> '') then
			return ds_princ_ativo_princ_w || ' + ' || substr(ds_princ_ativo_sec_w, 4, 1000);
		else
			return ds_princ_ativo_princ_w;
		end if;
	else
		if (ds_concetracao_sec_w IS NOT NULL AND ds_concetracao_sec_w::text <> '') then
			return ds_concetracao_princ_w || ' ' || substr(ds_concetracao_sec_w, 2, 1000);
		else
			return ds_concetracao_princ_w;
		end if;
	end if;

	return null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_princ_ativo_plano (cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;

