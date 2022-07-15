-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_desfazer_concil ( nr_seq_concil_p bigint, nm_usuario_p text) AS $body$
BEGIN

update 	ctb_movimento a
set 	a.ie_status_concil 	 = NULL,
		a.nr_seq_reg_concil 	 = NULL,
		a.nr_seq_movto_partida  = NULL
where 	a.nr_seq_reg_concil	= nr_seq_concil_p;

update	ctb_registro_concil a
set		a.dt_abertura			 = NULL,
		a.nm_usuario_abertura	 = NULL,
		a.dt_fechamento 		 = NULL
where	a.nr_sequencia		= nr_seq_concil_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_desfazer_concil ( nr_seq_concil_p bigint, nm_usuario_p text) FROM PUBLIC;

