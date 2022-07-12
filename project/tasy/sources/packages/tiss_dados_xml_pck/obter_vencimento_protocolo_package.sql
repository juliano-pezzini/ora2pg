-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_dados_xml_pck.obter_vencimento_protocolo (nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type) RETURNS timestamp AS $body$
DECLARE

	dt_vencimento_w timestamp;

BEGIN

	begin
		select	dt_vencimento
		into STRICT	dt_vencimento_w
		from	protocolo_convenio
		where	nr_seq_protocolo = nr_seq_protocolo_p;
	exception
	when others then
		dt_vencimento_w := null;
	end;
	
	return dt_vencimento_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tiss_dados_xml_pck.obter_vencimento_protocolo (nr_seq_protocolo_p protocolo_convenio.nr_seq_protocolo%type) FROM PUBLIC;