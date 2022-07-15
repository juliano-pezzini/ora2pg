-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_config_painel ( nm_usuario_p text, ds_cor_fonte_p INOUT text, ds_fonte_p INOUT text, ds_estilo_fonte_p INOUT text, qt_tamanho_fonte_p INOUT bigint ) AS $body$
BEGIN

begin
select	ds_cor_fonte,
	ds_fonte,
	ds_estilo_fonte,
	qt_tamanho_fonte
into STRICT	ds_cor_fonte_p,
	ds_fonte_p,
	ds_estilo_fonte_p,
	qt_tamanho_fonte_p
from	agenda_config_painel
where	nm_usuario = nm_usuario_p;
exception
	when others then
	ds_cor_fonte_p		:= null;
	ds_fonte_p		:= null;
	ds_estilo_fonte_p	:= null;
	qt_tamanho_fonte_p	:= null;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_config_painel ( nm_usuario_p text, ds_cor_fonte_p INOUT text, ds_fonte_p INOUT text, ds_estilo_fonte_p INOUT text, qt_tamanho_fonte_p INOUT bigint ) FROM PUBLIC;

