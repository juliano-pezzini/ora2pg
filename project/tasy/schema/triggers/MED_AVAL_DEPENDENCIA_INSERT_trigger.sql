-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS med_aval_dependencia_insert ON med_aval_dependencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_med_aval_dependencia_insert() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ie_banho	 <> '3') and (NEW.ie_vestir	 = '1') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_continencia = '1') and (NEW.ie_comer <> '3') then
	NEW.ie_nivel_dependencia	:= '1';
elsif (NEW.ie_banho	= '3') and (NEW.ie_vestir <> '1') and (NEW.ie_toalete <> '1') and (NEW.ie_transferencia <> '1') and (NEW.ie_continencia <> '1') and (NEW.ie_comer	= '3') then
	NEW.ie_nivel_dependencia	:= '6';
elsif (NEW.ie_banho	= '3') and (NEW.ie_vestir <> '1') and (NEW.ie_continencia <> '1') and (NEW.ie_transferencia <> '1') and
	((NEW.ie_comer	= '3' AND NEW.ie_toalete = '1') or
	 (NEW.ie_comer <> '3' AND NEW.ie_toalete <> '1')) then
	NEW.ie_nivel_dependencia	:= '5';
elsif (NEW.ie_banho	= '3') and (NEW.ie_vestir <> '1') and (NEW.ie_continencia <> '1') and (NEW.ie_transferencia <> '1') and
	(((NEW.ie_comer	= '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1')) or
	 ((NEW.ie_comer <> '3') and (NEW.ie_toalete <> '1') and (NEW.ie_transferencia = '1')) or
	 ((NEW.ie_comer <> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia <> '1'))) then
	NEW.ie_nivel_dependencia	:= '4';
elsif (NEW.ie_banho	= '3') and
	(((NEW.ie_comer	= '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia = '1')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete <> '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia = '1')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia <> '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia = '1')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir <> '1') and (NEW.ie_continencia = '1')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia <> '1'))) then
	NEW.ie_nivel_dependencia	:= '3';
elsif	(((NEW.ie_comer	= '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia = '1') and (NEW.ie_banho <> '3')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete <> '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia = '1') and (NEW.ie_banho <> '3')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia <> '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia = '1') and (NEW.ie_banho <> '3')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir <> '1') and (NEW.ie_continencia = '1') and (NEW.ie_banho <> '3')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia <> '1') and (NEW.ie_banho <> '3')) or
	 ((NEW.ie_comer	<> '3') and (NEW.ie_toalete = '1') and (NEW.ie_transferencia = '1') and (NEW.ie_vestir = '1') and (NEW.ie_continencia = '1') and (NEW.ie_banho = '3'))) then
	NEW.ie_nivel_dependencia	:= '2';
else	NEW.ie_nivel_dependencia	:= '7';
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_med_aval_dependencia_insert() FROM PUBLIC;

CREATE TRIGGER med_aval_dependencia_insert
	BEFORE INSERT OR UPDATE ON med_aval_dependencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_med_aval_dependencia_insert();
