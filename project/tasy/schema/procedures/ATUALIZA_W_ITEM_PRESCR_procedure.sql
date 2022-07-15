-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_w_item_prescr (nr_sequencia_p text, qt_dose_p text, ie_excluido_p text, cd_unidade_medida_p text) AS $body$
BEGIN

update w_item_prescr
set qt_dose 			= coalesce(qt_dose_p,0),
	ie_excluido 		= coalesce(ie_excluido_p,'N'),
	cd_unidade_medida 	= cd_unidade_medida_p
where nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_w_item_prescr (nr_sequencia_p text, qt_dose_p text, ie_excluido_p text, cd_unidade_medida_p text) FROM PUBLIC;

