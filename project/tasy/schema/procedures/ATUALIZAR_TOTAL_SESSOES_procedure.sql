-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_total_sessoes (nr_controle_secao_p bigint, qt_total_sessoes_atual_p bigint, qt_total_sessoes_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (qt_total_sessoes_p < qt_total_sessoes_atual_p) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(262558);
else
	update	agenda_consulta
	set	qt_total_secao		= qt_total_sessoes_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_controle_secao	= nr_controle_secao_p;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_total_sessoes (nr_controle_secao_p bigint, qt_total_sessoes_atual_p bigint, qt_total_sessoes_p bigint, nm_usuario_p text) FROM PUBLIC;

