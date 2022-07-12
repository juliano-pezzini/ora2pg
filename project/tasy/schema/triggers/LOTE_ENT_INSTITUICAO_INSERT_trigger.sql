-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS lote_ent_instituicao_insert ON lote_ent_instituicao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_lote_ent_instituicao_insert() RETURNS trigger AS $BODY$
declare
 
nr_seq_evento_w		bigint;
 
c01 CURSOR FOR 
	SELECT	a.nr_seq_evento 
	from	regra_envio_sms a 
	where	a.ie_evento_disp = 'LECI' 
	and		coalesce(a.ie_situacao,'A') = 'A';
 
BEGIN 
 
open c01;
loop 
fetch c01 into	 
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN 
	 
	CALL lote_ent_gerar_evento_lab(nr_seq_evento_w,NEW.nm_usuario, NEW.nr_sequencia, NEW.ds_razao_social_inst, NEW.nr_telefone_inst, NEW.nr_ramal, NEW.ds_instituicao, NEW.cd_cnes_inst);
		 
		 
	end;
end loop;
close c01;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_lote_ent_instituicao_insert() FROM PUBLIC;

CREATE TRIGGER lote_ent_instituicao_insert
	AFTER INSERT ON lote_ent_instituicao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_lote_ent_instituicao_insert();
