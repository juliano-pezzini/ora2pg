-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpto_valida_intervalo ( nr_prescricao_p prescr_material.nr_prescricao%type, ie_agrupador_p prescr_material.ie_agrupador%type, nr_sequencia_p prescr_material.nr_sequencia%type, nr_agrupamento_p prescr_material.nr_agrupamento%type, cd_intervalo_p prescr_material.cd_intervalo%type ) RETURNS varchar AS $body$
DECLARE


cd_intervalo_w		prescr_material.cd_intervalo%type;
ie_atualiza_w		varchar(1)     := 'S';


BEGIN

	SELECT	MAX(cd_intervalo)
	INTO STRICT	cd_intervalo_w
	FROM	prescr_material
	WHERE	nr_prescricao = nr_prescricao_p
	AND	ie_agrupador = ie_agrupador_p
	AND	nr_sequencia != nr_sequencia_p
	AND	nr_agrupamento = nr_agrupamento_p;

	IF ((cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') AND cd_intervalo_w != cd_intervalo_p) THEN
		ie_atualiza_w := 'N';
	END IF;

RETURN ie_atualiza_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpto_valida_intervalo ( nr_prescricao_p prescr_material.nr_prescricao%type, ie_agrupador_p prescr_material.ie_agrupador%type, nr_sequencia_p prescr_material.nr_sequencia%type, nr_agrupamento_p prescr_material.nr_agrupamento%type, cd_intervalo_p prescr_material.cd_intervalo%type ) FROM PUBLIC;
