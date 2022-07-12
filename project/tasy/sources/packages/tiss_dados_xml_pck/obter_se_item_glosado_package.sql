-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_dados_xml_pck.obter_se_item_glosado (nr_seq_item_p tiss_dem_conta_proc.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


	ie_retorno_w 	varchar(1);
	qt_glosa_w	numeric(20);


BEGIN
	
	ie_retorno_w := 'N';

	begin
		select	count(*) qt
		into STRICT	qt_glosa_w
		from	tiss_dem_glosa
		where	nr_seq_conta_proc = nr_seq_item_p;
	exception
	when others then
		ie_retorno_w := 'N';
	end;
	
	if coalesce(qt_glosa_w, 0) > 0 then
		ie_retorno_w := 'S';
	end if;
	
	return ie_retorno_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tiss_dados_xml_pck.obter_se_item_glosado (nr_seq_item_p tiss_dem_conta_proc.nr_sequencia%type) FROM PUBLIC;
