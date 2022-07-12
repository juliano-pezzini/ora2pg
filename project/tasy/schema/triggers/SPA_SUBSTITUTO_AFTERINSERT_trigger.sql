-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS spa_substituto_afterinsert ON spa_substituto CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_spa_substituto_afterinsert() RETURNS trigger AS $BODY$
declare
 
ds_log_w	varchar(4000);
 
BEGIN 
/*ds_log_w 	:= substr('Incluído substituto abaixo.' || chr(13) || chr(10) || chr(13) || chr(10) || 
			'PESSOA FÍSICA: ' || :new.cd_pessoa_fisica || ' - ' || obter_nome_pf(:new.cd_pessoa_fisica) || chr(13) || chr(10) || 
			'CARGO: ' || :new.cd_cargo || ' - ' || obter_desc_cargo(:new.cd_cargo) || chr(13) || chr(10) || 
			'SUBSTITUTO: ' || :new.cd_pessoa_substituta || ' - ' || obter_nome_pf(:new.cd_pessoa_substituta) || chr(13) || chr(10) || 
			'DT. LIMITE: ' || :new.dt_limite,1,4000);*/
 
ds_log_w 	:= substr(wheb_mensagem_pck.get_texto(313844) || chr(13) || chr(10) || chr(13) || chr(10) || 
			wheb_mensagem_pck.get_texto(313838, 'CD_PESSOA_FISICA=' || NEW.cd_pessoa_fisica || ';' || 
			  				   'NM_PESSOA_FISICA=' || obter_nome_pf(NEW.cd_pessoa_fisica)) || chr(13) || chr(10) || 
			 wheb_mensagem_pck.get_texto(313839, 'CD_CARGO=' || NEW.cd_cargo || ';' || 
							   'DS_CARGO=' || obter_desc_cargo(NEW.cd_cargo)) || chr(13) || chr(10) || 
			 wheb_mensagem_pck.get_texto(802631, 'NR_SEQ_TIPO=' || NEW.nr_seq_tipo || ';' || 
							   'DS_TIPO_SPA=' || spa_obter_desc_tipo(NEW.nr_seq_tipo)) || chr(13) || chr(10) || 
			 wheb_mensagem_pck.get_texto(802632, 'NR_SEQ_MOTIVO=' || NEW.nr_seq_motivo || ';' || 
							   'DS_MOTIVO_SPA=' || spa_obter_desc_motivo(NEW.nr_seq_motivo)) || chr(13) || chr(10) || 
			 wheb_mensagem_pck.get_texto(802630, 'CD_ESTABELECIMENTO=' || NEW.cd_estabelecimento || ';' || 
							   'DS_ESTABELECIMENTO=' || obter_nome_estabelecimento(NEW.cd_estabelecimento)) || chr(13) || chr(10) || 
			 wheb_mensagem_pck.get_texto(313840, 'CD_PESSOA_SUBSTITUTA=' || NEW.cd_pessoa_substituta || ';' || 
							   'NM_PESSOA_SUBSTITUTA=' || obter_nome_pf(NEW.cd_pessoa_substituta)) || chr(13) || chr(10) || 
			 wheb_mensagem_pck.get_texto(313841, 'DT_LIMITE=' || NEW.dt_limite),1,4000);			
 
insert into spa_substituto_log( 
	nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	ds_titulo, 
	ds_log) 
values (	nextval('spa_substituto_log_seq'), 
	LOCALTIMESTAMP, 
	NEW.nm_usuario, 
	LOCALTIMESTAMP, 
	NEW.nm_usuario, 
	--'Inclusão substituto', 
	wheb_mensagem_pck.get_texto(313843), 
	ds_log_w);
	 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_spa_substituto_afterinsert() FROM PUBLIC;

CREATE TRIGGER spa_substituto_afterinsert
	AFTER INSERT ON spa_substituto FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_spa_substituto_afterinsert();
