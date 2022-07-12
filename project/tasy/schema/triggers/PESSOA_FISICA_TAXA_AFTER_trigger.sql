-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_taxa_after ON pessoa_fisica_taxa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_taxa_after() RETURNS trigger AS $BODY$
declare
is_changing_obriga_pag_w boolean    := false;
is_changing_seq_justif_w boolean    := false;
ds_log_w    varchar(2000);
BEGIN
is_changing_obriga_pag_w := (TG_OP = 'UPDATE' and coalesce(NEW.ie_obriga_pag_adicional, 'NULL') <> coalesce(OLD.ie_obriga_pag_adicional, 'NULL'));
is_changing_seq_justif_w := (TG_OP = 'UPDATE' and coalesce(NEW.nr_seq_justificativa, -1) <> coalesce(OLD.nr_seq_justificativa, -1));
if (TG_OP = 'INSERT' or is_changing_obriga_pag_w or is_changing_seq_justif_w) then
    if (coalesce(NEW.ie_obriga_pag_adicional, 'N') = 'S' and NEW.nr_seq_justificativa is not null) then
        if (TG_OP = 'INSERT') then
            ds_log_w    :=  'Insert' || 
                        '|New IOPA=#' || NEW.ie_obriga_pag_adicional || '#' || 
                        '|New NSJ=#' || NEW.nr_seq_justificativa || '#' ||
                        '|New nr_seq_atecaco=#' || NEW.nr_seq_atecaco;
        elsif (TG_OP = 'UPDATE') then
            ds_log_w    :=  'Update' ||
                        '|New IOPA=#' || NEW.ie_obriga_pag_adicional || '#' ||
                        '|Old IOPA=#' || OLD.ie_obriga_pag_adicional || '#' || 
                        '|New NSJ=#' || NEW.nr_seq_justificativa || '#' || 
                        '|Old NSJ=#' || OLD.nr_seq_justificativa || '#' ||
                        '|New nr_seq_atecaco=#' || NEW.nr_seq_atecaco || '#' ||
                        '|Old nr_seq_atecaco=#' || OLD.nr_seq_atecaco;
        end if;

        ds_log_w    :=  substr(ds_log_w || chr(13) || chr(10) || dbms_utility.format_call_stack,1, 2000);

        CALL gravar_log_tasy(1515, ds_log_w, NEW.nm_usuario);
    end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_taxa_after() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_taxa_after
	AFTER INSERT OR UPDATE ON pessoa_fisica_taxa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_taxa_after();
