-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cih_ficha_ocorrencia_aft_ins ON cih_ficha_ocorrencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cih_ficha_ocorrencia_aft_ins() RETURNS trigger AS $BODY$
declare

qt_hist_w	bigint := 0;

BEGIN

select	count(*)
into STRICT	qt_hist_w
from	cih_ficha_ocorrencia_hist
where	nr_atendimento		= NEW.nr_atendimento
and	nr_ficha_ocorrencia 	is null;

if (qt_hist_w > 0)  then

	update	cih_ficha_ocorrencia_hist
	set	nr_ficha_ocorrencia 	= NEW.nr_ficha_ocorrencia
	where	nr_atendimento		= NEW.nr_atendimento
	and	nr_ficha_ocorrencia 	is null;

end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cih_ficha_ocorrencia_aft_ins() FROM PUBLIC;

CREATE TRIGGER cih_ficha_ocorrencia_aft_ins
	AFTER INSERT ON cih_ficha_ocorrencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cih_ficha_ocorrencia_aft_ins();

