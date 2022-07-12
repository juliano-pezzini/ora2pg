-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION man_complaint_pck.obter_se_os_complaint_eval (nr_seq_ordem_serv_p bigint) RETURNS varchar AS $body$
DECLARE

		ie_complaint_w	man_ordem_servico.ie_complaint%type;
	
BEGIN

		select 	coalesce(max('S'), 'N')
		into STRICT 	ie_complaint_w
		from 	man_ordem_servico
		where 	nr_sequencia = nr_seq_ordem_serv_p
		and		(ie_complaint IS NOT NULL AND ie_complaint::text <> '');

		return ie_complaint_w;
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION man_complaint_pck.obter_se_os_complaint_eval (nr_seq_ordem_serv_p bigint) FROM PUBLIC;