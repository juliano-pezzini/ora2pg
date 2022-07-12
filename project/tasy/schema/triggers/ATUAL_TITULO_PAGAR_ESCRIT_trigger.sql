-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atual_titulo_pagar_escrit ON titulo_pagar_escrit CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atual_titulo_pagar_escrit() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN

if (NEW.hr_pagamento is not null) and
   ((NEW.hr_pagamento <> OLD.hr_pagamento) or (OLD.dt_pagamento is null)) then
    /*Tem que validar se no hr_pagamento tem horas e minutos validos, igual ocorre na DEFINIR_HORA_PAGAMENTO*/

	BEGIN
	if (length(NEW.hr_pagamento) = 4) and  /*Tem que ter 4 digitos, 2 para hora e 2 para mintuos*/
	   (substr(NEW.hr_pagamento,1,2) >= 00 and substr(NEW.hr_pagamento,1,2) < 24) and /*Horas tem que ser entre 00 até 23*/
	   (substr(NEW.hr_pagamento,3,2) >= 00 and substr(NEW.hr_pagamento,3,2) < 60) then /*Mintuos tem que ser entre  01 e 59*/
		NEW.dt_pagamento := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_pagamento || '00', 'dd/mm/yyyy hh24:mi:ss');
	end if;
	exception when others then
		NEW.dt_pagamento := null;
	end;
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atual_titulo_pagar_escrit() FROM PUBLIC;

CREATE TRIGGER atual_titulo_pagar_escrit
	BEFORE INSERT OR UPDATE ON titulo_pagar_escrit FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atual_titulo_pagar_escrit();
