-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_peso_altura_js ( nr_prescricao_p bigint, nr_sequencias_p text, qt_peso_p INOUT bigint, qt_altura_p INOUT bigint, ds_obs_coleta_peso_p INOUT text) AS $body$
DECLARE


qt_peso_w	real;
qt_altura_cm_w	real;
ds_obs_coleta_peso_w varchar(1);


BEGIN

select	max(qt_peso),
	max(qt_altura_cm)
into STRICT	qt_peso_w,
	qt_altura_cm_w
from 	prescr_medica
where 	nr_prescricao = nr_prescricao_p;


qt_peso_p	:= qt_peso_w;
qt_altura_p	:= qt_altura_cm_w;
ds_obs_coleta_peso_p := lab_obter_exige_observ_col(nr_prescricao_p,nr_sequencias_p);


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_peso_altura_js ( nr_prescricao_p bigint, nr_sequencias_p text, qt_peso_p INOUT bigint, qt_altura_p INOUT bigint, ds_obs_coleta_peso_p INOUT text) FROM PUBLIC;

