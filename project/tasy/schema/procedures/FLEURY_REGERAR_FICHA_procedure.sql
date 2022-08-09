-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fleury_regerar_ficha ( nr_prescricao_p bigint, nr_controle_p text, ds_method_p text) AS $body$
BEGIN


update	prescr_medica
set		nr_controle  = NULL
where	nr_prescricao = nr_prescricao_p;

update	prescr_procedimento
set		nr_controle_ext  = NULL,
		nr_grupo_integracao  = NULL,
		dt_integracao  = NULL
where	nr_prescricao = nr_prescricao_p;

delete	FROM prescr_etiqueta
where	nr_prescricao = nr_prescricao_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fleury_regerar_ficha ( nr_prescricao_p bigint, nr_controle_p text, ds_method_p text) FROM PUBLIC;
