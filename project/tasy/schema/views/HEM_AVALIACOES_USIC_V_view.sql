-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hem_avaliacoes_usic_v (qt_ini, qt_fim, ds_parametro) AS select	qt_diametro_ref_prox_min qt_ini,
	qt_diam_ref_prox_min_fim qt_fim,
	'diâmetro referencial proximal mínimo (mm)' ds_parametro
FROM	hem_usic_aval_proced
where (qt_diametro_ref_prox_min is not null
	or qt_diam_ref_prox_min_fim is not null)

union

select	qt_diametro_ref_prox_med qt_ini,
	qt_diam_ref_prox_med_fim qt_fim,
	'Diâmetro referencial proximal médio (mm)' ds_parametro
from	hem_usic_aval_proced
where (qt_diametro_ref_prox_med is not null
	or qt_diam_ref_prox_med_fim is not null)

union

select	qt_diametro_ref_prox_max qt_ini,
	qt_diam_ref_prox_max_fim qt_fim,
	'Diâmetro referencial proximal máximo (mm)' ds_parametro
from	hem_usic_aval_proced
where (qt_diametro_ref_prox_max is not null
	or qt_diam_ref_prox_max_fim is not null)

union

select	qt_diametro_ref_dist_min qt_ini,
	qt_diam_ref_dist_min_fim qt_fim,
	'Diâmetro referencial distal mínimo (mm)' ds_parametro
from	hem_usic_aval_proced
where (qt_diametro_ref_dist_min is not null
	or qt_diam_ref_dist_min_fim is not null)

union

select	qt_diametro_ref_dist_med qt_ini,
	qt_diam_ref_dist_med_fim qt_fim,
	'Diâmetro referencial distal médio (mm)' ds_parametro
from	hem_usic_aval_proced
where (qt_diametro_ref_dist_med is not null
	or qt_diam_ref_dist_med_fim is not null)

union

select	qt_diametro_ref_dist_max qt_ini,
	qt_diam_ref_dist_max_fim qt_fim,
	'Diâmetro referencial distal máximo (mm)' ds_parametro
from	hem_usic_aval_proced
where (qt_diametro_ref_dist_max is not null
	or qt_diam_ref_dist_max_fim is not null)

union

select	qt_diametro_lesao_min qt_ini,
	qt_diam_lesao_min_fim qt_fim,
	'Diâmetro lesão mínimo (mm)' ds_parametro
from	hem_usic_aval_proced
where (qt_diametro_lesao_min is not null
	or qt_diam_lesao_min_fim is not null)

union

select	qt_diametro_lesao_max qt_ini,
	qt_diam_lesao_max_fim qt_fim,
	'Diâmetro lesão máximo (mm)' ds_parametro
from	hem_usic_aval_proced
where (qt_diametro_lesao_max is not null
	or qt_diam_lesao_max_fim is not null)

union

select	qt_area_total_ref_prox qt_ini,
	qt_area_total_ref_prox_fim qt_fim,
	'Área referencial proximal total (mm²)' ds_parametro
from	hem_usic_aval_proced
where (qt_area_total_ref_prox is not null
	or qt_area_total_ref_prox_fim is not null)

union

select	qt_area_lum_ref_prox qt_ini,
	qt_area_lum_ref_prox_fim qt_fim,
	'Área luminal de referência proximal (mm²)' ds_parametro
from	hem_usic_aval_proced
where (qt_area_lum_ref_prox is not null
	or qt_area_lum_ref_prox_fim is not null)

union

select	qt_area_total_ref_dist qt_ini,
	qt_area_total_ref_dist_fim qt_fim,
	'Área referencial distal total (mm²)' ds_parametro
from	hem_usic_aval_proced
where (qt_area_total_ref_dist is not null
	or qt_area_total_ref_dist_fim is not null)

union

select	qt_area_lum_ref_dist qt_ini,
	qt_area_lum_ref_dist_fim qt_fim,
	'Área luminal de referência distal (mm²)' ds_parametro
from	hem_usic_aval_proced
where (qt_area_lum_ref_dist is not null
	or qt_area_lum_ref_dist_fim is not null)

union

select	qt_area_lum_min_lesao qt_ini,
	qt_area_lum_min_lesao_fim qt_fim,
	'Área luminal mínima (mm²)' ds_parametro
from	hem_usic_aval_proced
where (qt_area_lum_min_lesao is not null
	or qt_area_lum_min_lesao_fim is not null)

union

select	qt_area_total_lesao qt_ini,
	qt_area_total_lesao_fim qt_fim,
	'Área lesão total (mm²)' ds_parametro
from	hem_usic_aval_proced
where (qt_area_total_lesao is not null
	or qt_area_total_lesao_fim is not null)

union

select	pr_estenose_diametro qt_ini,
	pr_estenose_diametro_fim qt_fim,
	'Diâmetro estenose (%)' ds_parametro
from	hem_usic_aval_proced
where (pr_estenose_diametro is not null
	or pr_estenose_diametro_fim is not null)

union

select	pr_estenose_area qt_ini,
	pr_estenose_area_fim qt_fim,
	'Área estenose (%)' ds_parametro
from	hem_usic_aval_proced
where (pr_estenose_area is not null
	or pr_estenose_area_fim is not null);

