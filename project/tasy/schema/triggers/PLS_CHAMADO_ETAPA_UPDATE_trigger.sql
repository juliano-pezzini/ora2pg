-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_chamado_etapa_update ON pls_chamado_etapa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_chamado_etapa_update() RETURNS trigger AS $BODY$
declare
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	if (coalesce(NEW.nr_seq_proxima_etapa,0) <> coalesce(OLD.nr_seq_proxima_etapa,0)) then
		insert	into	pls_chamado_etapa_hist(	nr_sequencia, nr_seq_chamado_etapa, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				dt_liberacao, ie_tipo_historico,
				ds_historico)
			values (nextval('pls_chamado_etapa_hist_seq'), NEW.nr_sequencia, LOCALTIMESTAMP,
				NEW.nm_usuario, LOCALTIMESTAMP, NEW.nm_usuario,
				LOCALTIMESTAMP, 'S',
				wheb_mensagem_pck.get_texto(1199936,'NM_USUARIO='||NEW.nm_usuario||';DS_ETAPA_ANTERIOR='||pls_chamado_pck.get_ds_etapa(OLD.nr_seq_proxima_etapa,'S')||';DS_PROXIMA_ETAPA='||pls_chamado_pck.get_ds_etapa(NEW.nr_seq_proxima_etapa,'S')));
	end if;
	
	if (coalesce(NEW.nm_usuario_responsavel, 'X') <> coalesce(OLD.nm_usuario_responsavel, 'X')) then
		insert	into	pls_chamado_etapa_hist(	nr_sequencia, nr_seq_chamado_etapa, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				dt_liberacao, ie_tipo_historico,
				ds_historico)
			values (nextval('pls_chamado_etapa_hist_seq'), NEW.nr_sequencia, LOCALTIMESTAMP,
				NEW.nm_usuario, LOCALTIMESTAMP, NEW.nm_usuario,
				LOCALTIMESTAMP, 'S',
				wheb_mensagem_pck.get_texto(1199935,'NM_USUARIO='||NEW.nm_usuario));
	end if;
	
	if (coalesce(NEW.dt_liberacao,LOCALTIMESTAMP + interval '1 days') <> coalesce(OLD.dt_liberacao,LOCALTIMESTAMP + interval '1 days')) then
		insert	into	pls_chamado_etapa_hist(	nr_sequencia, nr_seq_chamado_etapa, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				dt_liberacao, ie_tipo_historico,
				ds_historico)
			values (nextval('pls_chamado_etapa_hist_seq'), NEW.nr_sequencia, LOCALTIMESTAMP,
				NEW.nm_usuario, LOCALTIMESTAMP, NEW.nm_usuario,
				LOCALTIMESTAMP, 'S',
				wheb_mensagem_pck.get_texto(1199937,'NM_USUARIO='||NEW.nm_usuario));
	end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_chamado_etapa_update() FROM PUBLIC;

CREATE TRIGGER pls_chamado_etapa_update
	AFTER UPDATE ON pls_chamado_etapa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_chamado_etapa_update();

