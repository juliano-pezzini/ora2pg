-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_consulta_preco ( nm_usuario_p text, ie_tipo_item_p bigint ) AS $body$
BEGIN
if (ie_tipo_item_p <> -1) and (ie_tipo_item_p <> -5) and (ie_tipo_item_p <> -6) then

delete from w_consulta_preco
where dt_consulta < clock_timestamp()
and nm_usuario = nm_usuario_p;

delete from w_consulta_preco
where dt_consulta < clock_timestamp() - interval '8640 seconds';

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_consulta_preco ( nm_usuario_p text, ie_tipo_item_p bigint ) FROM PUBLIC;

