-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_ame_regra_atrib_befinsup ON pls_ame_regra_atrib CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_ame_regra_atrib_befinsup() RETURNS trigger AS $BODY$
declare

	ie_tipo_banda_w 	pls_ame_regra_banda.ie_tipo_banda%type;
	vl_atributo_w		varchar(255);
	nm_atributo_w		varchar(255);
BEGIN
  BEGIN

select 	a.ie_tipo_banda
into STRICT 	ie_tipo_banda_w
from 	pls_ame_regra_banda a
where 	a.nr_sequencia = NEW.nr_seq_banda;

if (ie_tipo_banda_w in (1, 4)) then

	nm_atributo_w := obter_valor_dominio(9036, NEW.cd_atributo);

	if (NEW.cd_atributo in (3,4,5,6) and NEW.ds_mascara is not null) then
		--datas
		BEGIN
			vl_atributo_w := to_char(LOCALTIMESTAMP, NEW.ds_mascara);
		exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1057732, 'DS_MASCARA='|| NEW.ds_mascara ||';'||'NM_ATRIBUTO_W='||nm_atributo_w);
		end;

	end if;
else

	nm_atributo_w := obter_valor_dominio(9037, NEW.cd_atributo);

	if (NEW.cd_atributo in (5,6,10)) then
		--datas
		BEGIN
			vl_atributo_w := to_char(LOCALTIMESTAMP, NEW.ds_mascara);
		exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1057732, 'DS_MASCARA='|| NEW.ds_mascara ||';'||'NM_ATRIBUTO_W='||nm_atributo_w);
		end;
	end if;
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_ame_regra_atrib_befinsup() FROM PUBLIC;

CREATE TRIGGER pls_ame_regra_atrib_befinsup
	BEFORE INSERT OR UPDATE ON pls_ame_regra_atrib FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_ame_regra_atrib_befinsup();

