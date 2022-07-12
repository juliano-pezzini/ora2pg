-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS intpd_fila_transmissao_after ON intpd_fila_transmissao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_intpd_fila_transmissao_after() RETURNS trigger AS $BODY$
declare
 
jobno bigint;
qt_evento_superior_w bigint;
 
BEGIN 
 
select 	count(*) 
into STRICT	qt_evento_superior_w 
from 	intpd_evento_superior 
where	nr_seq_evento_sup = (	SELECT	max(nr_sequencia) 
				from	intpd_eventos 
				where	ie_evento = NEW.ie_evento);
 
if (NEW.ie_evento = '54' and qt_evento_superior_w = 0) then /*Enviar procedimento paciente*/
 
 
	if (NEW.nr_seq_agrupador is not null) and (NEW.nr_seq_dependencia is null) and (OLD.ie_status <> NEW.ie_status) then 
		 
		if (NEW.ie_status in ('E','S')) then 
		 
			dbms_job.submit(jobno, 'intpd_atualiza_reg_agrupador('|| to_char(NEW.nr_sequencia) || ', ' || chr(39)|| NEW.ie_status || chr(39)||');');
			 
		elsif (NEW.ie_status in ('R','P')) then 
		 
			dbms_job.submit(jobno, 'intpd_atualiza_reg_agrupador('|| to_char(NEW.nr_sequencia) || ', ' || chr(39)|| 'AP' || chr(39)||');');
			 
		end if;
	end if;
	 
end if;
 
if	((qt_evento_superior_w > 0) and (OLD.ie_status <> NEW.ie_status) and (NEW.ie_status = 'S')) then		 
	dbms_job.submit(jobno, 'intpd_atualiza_reg_dependente('|| to_char(NEW.nr_sequencia) || ', ' || chr(39)|| 'P' || chr(39)||');');	
end if;
	 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_intpd_fila_transmissao_after() FROM PUBLIC;

CREATE TRIGGER intpd_fila_transmissao_after
	AFTER UPDATE ON intpd_fila_transmissao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_intpd_fila_transmissao_after();

