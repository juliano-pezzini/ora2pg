-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_prescr_farm ( nr_prescricao_p bigint, nr_seq_status_p bigint, nm_usuario_p text ) AS $body$
BEGIN

if (nr_prescricao_p > 0) and (nr_seq_status_p > 0) then
	update	prescr_medica
	set	nm_usuario		=	nm_usuario_p,
		dt_atualizacao		=	clock_timestamp(),
		nr_seq_status_farm	=	nr_seq_status_p
	where	nr_prescricao		=	nr_prescricao_p;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_prescr_farm ( nr_prescricao_p bigint, nr_seq_status_p bigint, nm_usuario_p text ) FROM PUBLIC;

