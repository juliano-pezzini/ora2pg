-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_data_protocolo ( dt_protocolo_p text) AS $body$
BEGIN

if (fim_dia(trunc(to_date(dt_protocolo_p,'dd/mm/yyyy hh24:mi:ss'),'dd')) > fim_dia(clock_timestamp())) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 266986, null);
	/*A data do protocolo não pode ser superior a data de hoje, verifique! */

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_data_protocolo ( dt_protocolo_p text) FROM PUBLIC;
