-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_informacoes_relat_web ( nr_prescricoes_p text) AS $body$
BEGIN
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264143);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_informacoes_relat_web ( nr_prescricoes_p text) FROM PUBLIC;
