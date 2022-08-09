-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eis_fechamento_part_alert_wait ( ds_evento_p text, qt_limite_seg_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, ie_status_p INOUT bigint) AS $body$
DECLARE


ds_mensagem_w	varchar(255) 	:= '';
ie_status_w	bigint	:= 0;


BEGIN
--dbms_alert.REGISTER(ds_evento_p);
--dbms_alert.WAITONE(ds_evento_p, ds_mensagem_w, ie_status_w, qt_limite_seg_p);
ds_mensagem_p	:= ds_mensagem_w;
ie_status_p	:= ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eis_fechamento_part_alert_wait ( ds_evento_p text, qt_limite_seg_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, ie_status_p INOUT bigint) FROM PUBLIC;
