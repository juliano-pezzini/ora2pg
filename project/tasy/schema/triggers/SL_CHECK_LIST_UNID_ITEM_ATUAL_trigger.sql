-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sl_check_list_unid_item_atual ON sl_check_list_unid_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sl_check_list_unid_item_atual() RETURNS trigger AS $BODY$
declare

cd_estabelecimento_w		smallint;

BEGIN
if (NEW.ie_result_item is not null) and (coalesce(OLD.ie_result_item,'X')) <> (coalesce(NEW.ie_result_item,'X')) then
	if (NEW.ie_result_item = 'F') then
		NEW.ie_resultado	:= 'S';
		NEW.ie_nao_aplica	:= 'N';
	elsif (NEW.ie_result_item = 'N') then
		NEW.ie_resultado	:= 'N';
		NEW.ie_nao_aplica	:= 'S';
	else
		NEW.ie_resultado	:= 'N';
		NEW.ie_nao_aplica	:= 'N';
		/*if	(:new.ie_result_item = 'C') then
			:new.ds_observacao	:= substr(:new.ds_observacao || '-' || WHEB_MENSAGEM_PCK.get_Texto(839028),1,500);
		end if;*/
	end if;
elsif (NEW.ie_resultado is not null) or (NEW.ie_nao_aplica is not null) and
		coalesce(OLD.ie_resultado,'X') <> coalesce(NEW.ie_resultado,'X') then
	if (coalesce(NEW.ie_resultado,'N')	= 'S') then
		NEW.ie_result_item := 'F';
	elsif (coalesce(NEW.ie_resultado,'N')	= 'N') then
		if (NEW.ie_nao_aplica	= 'S') then
			NEW.ie_result_item	:= 'N';
		else
			NEW.ie_result_item	:= 'P';
		end if;
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sl_check_list_unid_item_atual() FROM PUBLIC;

CREATE TRIGGER sl_check_list_unid_item_atual
	BEFORE INSERT OR UPDATE ON sl_check_list_unid_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sl_check_list_unid_item_atual();

