-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_agenda_tasy_convi_js ( nr_seq_agenda_p bigint, dt_agenda_p timestamp, ie_confirmado_p text, ds_motivo_ausencia_p text, nm_usuario_p text) AS $body$
BEGIN
/*
	procedure criada para realizar a chamada na procedure Atualizar_Agenda_Tasy_Convite
	e realizar o commit sem alterar o comportamento do sistema em Delphi.
	Criada pelo HEBERT.
*/
CALL Atualizar_Agenda_Tasy_Convite( nr_seq_agenda_p, dt_agenda_p, ie_confirmado_p, ds_motivo_ausencia_p, nm_usuario_p );

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_agenda_tasy_convi_js ( nr_seq_agenda_p bigint, dt_agenda_p timestamp, ie_confirmado_p text, ds_motivo_ausencia_p text, nm_usuario_p text) FROM PUBLIC;

