-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_mat_nao_consistidos (nr_prescricao_p bigint) AS $body$
BEGIN

delete 	FROM prescr_material
where 	ie_status_cirurgia 	= 'GI' 
and 	nr_prescricao 	= nr_prescricao_p;

commit;
										
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_mat_nao_consistidos (nr_prescricao_p bigint) FROM PUBLIC;

