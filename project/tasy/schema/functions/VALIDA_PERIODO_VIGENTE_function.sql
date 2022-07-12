-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION valida_periodo_vigente ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w		varchar(1) := 'N';
nr_tipo_data_w		bigint;
ie_antes_apos_w		varchar(1);
qt_antes_apos_w		bigint;
qt_periodo_antes_w	bigint;
qt_periodo_apos_w	bigint;
ie_data_w		varchar(2);

dt_inicio_ind_w		timestamp;
dt_fim_ind_w		timestamp;


BEGIN

SELECT	nr_tipo_data,
	ie_antes_apos,
	qt_antes_apos,
	qt_periodo_antes,
	qt_periodo_apos
INTO STRICT	nr_tipo_data_w,
	ie_antes_apos_w,
	qt_antes_apos_w,
	qt_periodo_antes_w,
	qt_periodo_apos_w
FROM	regra_indicador_visual
WHERE	nr_sequencia = (SELECT	nr_seq_regra_indicador
			FROM	indic_gestao_salvo_meta
			WHERE	nr_sequencia = nr_sequencia_p);

SELECT	ie_data
INTO STRICT	ie_data_w
FROM	indicador_gestao_atrib
WHERE	nr_sequencia = nr_tipo_data_w;

IF (ie_antes_apos_w = 'P') THEN
	qt_antes_apos_w := - qt_antes_apos_w;
END IF;

CASE	ie_data_w
	WHEN 'D' THEN
		dt_inicio_ind_w := TRUNC(clock_timestamp() + qt_antes_apos_w);
		dt_fim_ind_w := fim_dia(clock_timestamp() + qt_antes_apos_w);
	WHEN 'M' THEN
		dt_inicio_ind_w := pkg_date_utils.start_of(pkg_date_utils.add_month(clock_timestamp(), qt_antes_apos_w,0), 'MONTH',0);
		dt_fim_ind_w := fim_mes(pkg_date_utils.add_month(clock_timestamp(), qt_antes_apos_w,0));
	WHEN 'A' THEN
		dt_inicio_ind_w := pkg_date_utils.start_of(pkg_date_utils.add_month(clock_timestamp(), qt_antes_apos_w * 12,0), 'YEAR',0);
		dt_fim_ind_w := fim_ano(TRUNC(pkg_date_utils.add_month(clock_timestamp(), qt_antes_apos_w * 12,0)));
	WHEN 'DP' THEN
		dt_inicio_ind_w := TRUNC(clock_timestamp() - qt_periodo_apos_w);
		dt_fim_ind_w := fim_dia(clock_timestamp() + qt_periodo_antes_w);
	WHEN 'MP' THEN
		dt_inicio_ind_w := pkg_date_utils.start_of(pkg_date_utils.add_month(clock_timestamp(), - qt_periodo_apos_w,0), 'MONTH',0);
		dt_fim_ind_w := fim_mes(pkg_date_utils.add_month(clock_timestamp(), + qt_periodo_antes_w,0));
	WHEN 'AP' THEN
		dt_inicio_ind_w := pkg_date_utils.start_of(pkg_date_utils.add_month(clock_timestamp(), - qt_periodo_apos_w * 12,0), 'YEAR',0);
		dt_fim_ind_w := fim_ano(TRUNC(pkg_date_utils.add_month(clock_timestamp(), + qt_periodo_antes_w * 12,0)));
END CASE;

SELECT	CASE WHEN COUNT(*)=0 THEN  'N'  ELSE 'S' END
INTO STRICT	retorno_w
FROM	indic_gestao_salvo_meta
WHERE	nr_sequencia = nr_sequencia_p
AND	dt_inicio_vigencia <= dt_inicio_ind_w
AND (coalesce(dt_fim_vigencia::text, '') = ''
OR	fim_dia(dt_fim_vigencia) >= dt_fim_ind_w);

RETURN	retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION valida_periodo_vigente ( nr_sequencia_p bigint) FROM PUBLIC;
