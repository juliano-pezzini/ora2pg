-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_gravar_prescr_etiq_long_f (nr_controle_p bigint, ds_etiqueta1_p text, ds_etiqueta2_p text, nm_usuario_p text) AS $body$
DECLARE


nr_prescricao_w		bigint;

BEGIN

select	max(nr_prescricao)
into STRICT	nr_prescricao_w
from	prescr_medica
where	nr_controle = nr_controle_p;

if (nr_prescricao_w > 0) then

	CALL lab_gravar_prescr_etiq_long(nr_prescricao_w, ds_etiqueta1_p, ds_etiqueta2_p, nm_usuario_p );

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_gravar_prescr_etiq_long_f (nr_controle_p bigint, ds_etiqueta1_p text, ds_etiqueta2_p text, nm_usuario_p text) FROM PUBLIC;

