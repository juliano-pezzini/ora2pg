-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_leito_retaguarda ( nr_seq_interno_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	unidade_atendimento
set	ie_retaguarda_atual	= 'N'
where	ie_retaguarda_atual	= 'S';

update	unidade_atendimento
set	ie_retaguarda_atual	= 'S',
	ie_status_unidade	= CASE WHEN ie_status_unidade='L' THEN 'R'  ELSE ie_status_unidade END
where	nr_seq_interno		= nr_seq_interno_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_leito_retaguarda ( nr_seq_interno_p bigint, nm_usuario_p text) FROM PUBLIC;

