-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_exame_dialise_sorologia_v (ds_exame, dt_referencia, qt_positivo, qt_negativo, qt_conversao) AS select	'HBS - Ag' ds_exame,
		a.DT_REFERENCIA,
		coalesce(a.QT_HBS_AG_POS,0) qt_positivo,
		coalesce(a.QT_HBS_AG_NEG,0) qt_negativo,
		coalesce(a.QT_CONV_HBS_AG,0) qt_conversao
FROM	eis_hd_exame a

union all

select	'Anti HBS' ds_exame,
		a.DT_REFERENCIA,
		coalesce(a.QT_ANTI_HBS_POS,0) qt_positivo,
		0 qt_negativo,
		coalesce(a.QT_CONV_HBS_AG,0) qt_conversao
from	eis_hd_exame a

union all

select	'Anti - HCV' ds_exame,
		a.DT_REFERENCIA,
		coalesce(a.QT_ANTI_HCV_POS,0) qt_positivo,
		0 qt_negativo,
		coalesce(a.QT_CONV_HCV,0) qt_conversao
from	eis_hd_exame a

union all

select	'Anti - HIV' ds_exame,
		a.DT_REFERENCIA,
		coalesce(a.QT_ANTI_HIV_POS,0) qt_positivo,
		0 qt_negativo,
		coalesce(a.QT_CONV_HIV,0) qt_conversao
from	eis_hd_exame a;
