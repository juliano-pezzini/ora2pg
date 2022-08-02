-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_atualizar_quimio_js ( ds_lista_agenda_p text, nm_usuario_p text) AS $body$
DECLARE


ds_lista_w	varchar(2000);

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ds_lista_w := Qt_obter_seq_atend_dias_trat(ds_lista_agenda_p, ds_lista_w);
	CALL Qt_atualizar_data_chegada_trat(ds_lista_w, nm_usuario_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_atualizar_quimio_js ( ds_lista_agenda_p text, nm_usuario_p text) FROM PUBLIC;

