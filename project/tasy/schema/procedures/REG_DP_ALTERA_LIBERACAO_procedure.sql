-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_dp_altera_liberacao ( nr_sequencia_p bigint, nm_user_p text, ie_tipo_p text) AS $body$
BEGIN
	if (ie_tipo_p = 'I') then
		update   reg_caso_teste
		set		dt_liberacao_vv			=	clock_timestamp(),
				nm_usuario				=   nm_user_p,
				nm_usuario_liberacao	=   nm_user_p,
				dt_atualizacao			=	clock_timestamp()
		where 	nr_sequencia	=	nr_sequencia_p;

	elsif (ie_tipo_p = 'E') then
		update   reg_caso_teste
		set		dt_liberacao_vv			 = NULL,
				nm_usuario_liberacao	 = NULL,
				nm_usuario				=   nm_user_p,
				dt_atualizacao			=	clock_timestamp()
		where 	nr_sequencia	=	nr_sequencia_p;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_dp_altera_liberacao ( nr_sequencia_p bigint, nm_user_p text, ie_tipo_p text) FROM PUBLIC;

