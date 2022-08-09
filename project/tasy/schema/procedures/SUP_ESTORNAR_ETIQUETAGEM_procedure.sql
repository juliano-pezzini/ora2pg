-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_estornar_etiquetagem ( nr_sequencia_p bigint, ds_justif_estorno_p text, nm_usuario_p text) AS $body$
BEGIN

update	material_lote_fornec_etiq
set	ds_justif_estorno_aprov = substr(ds_justif_estorno_p,1,255),
	dt_estorno_aprov = clock_timestamp(),
	nm_usuario_estorno_aprov = nm_usuario_p
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_estornar_etiquetagem ( nr_sequencia_p bigint, ds_justif_estorno_p text, nm_usuario_p text) FROM PUBLIC;
