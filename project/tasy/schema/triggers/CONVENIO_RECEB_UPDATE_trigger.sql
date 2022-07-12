-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS convenio_receb_update ON convenio_receb CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_convenio_receb_update() RETURNS trigger AS $BODY$
BEGIN
/* Bruna OS48856 22/01/2007
select	 decode(	obter_baixa_conrece(:new.nr_sequencia), 0, 'N',
			decode(:new.vl_recebimento - obter_baixa_conrece(:new.nr_sequencia), 0, 'T', 'P'))
into	:new.ie_status
from dual;
*/
null;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_convenio_receb_update() FROM PUBLIC;

CREATE TRIGGER convenio_receb_update
	BEFORE UPDATE ON convenio_receb FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_convenio_receb_update();
