-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS hc_servico_proc_beforepost ON hc_servico_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_hc_servico_proc_beforepost() RETURNS trigger AS $BODY$
declare
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
 
BEGIN 
 
if (NEW.nr_seq_proc_interno is not null) and 
	((OLD.nr_seq_proc_interno is null) or 
	(OLD.nr_seq_proc_interno is not null AND OLD.nr_seq_proc_interno <> NEW.nr_seq_proc_interno)) then 
	 
	SELECT * FROM obter_proc_tab_interno_conv( 
					NEW.nr_seq_proc_interno, wheb_usuario_pck.get_cd_estabelecimento, null, null, null, null, cd_procedimento_w, ie_origem_proced_w, null, LOCALTIMESTAMP, null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
 
	NEW.cd_procedimento	:= cd_procedimento_w;
	NEW.ie_origem_proced	:= ie_origem_proced_w;
	 
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_hc_servico_proc_beforepost() FROM PUBLIC;

CREATE TRIGGER hc_servico_proc_beforepost
	BEFORE INSERT OR UPDATE ON hc_servico_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_hc_servico_proc_beforepost();
