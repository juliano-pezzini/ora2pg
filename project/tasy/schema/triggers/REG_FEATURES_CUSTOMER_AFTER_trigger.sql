-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_features_customer_after ON reg_features_customer CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_features_customer_after() RETURNS trigger AS $BODY$
declare

ie_tipo_alteracao_w		reg_features_customer_hist.ie_tipo_alteracao%type;

BEGIN

if (TG_OP = 'INSERT') then
	ie_tipo_alteracao_w := 'I';
elsif (TG_OP = 'UPDATE') and (NEW.ie_situacao = 'I') then
	ie_tipo_alteracao_w := 'E';
else
	ie_tipo_alteracao_w := 'A';
end if;

insert into reg_features_customer_hist(
	nr_sequencia,
	nr_seq_area_customer,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_grupo,
	ds_feature,
	dt_aprovacao,
	nr_seq_apresentacao,
	nr_seq_estagio,
	ie_situacao,
	cd_versao,
	nr_seq_reg_version_rev,
	ds_overall_desc_rel,
	ds_overall_description,
	nr_seq_feature_cust,
	ie_tipo_alteracao)
values (
	nextval('reg_features_customer_hist_seq'),
	NEW.nr_seq_area_customer,
	NEW.dt_atualizacao,
	NEW.nm_usuario,
	NEW.dt_atualizacao_nrec,
	NEW.nm_usuario_nrec,
	NEW.nr_seq_grupo,
	NEW.ds_feature,
	NEW.dt_aprovacao,
	NEW.nr_seq_apresentacao,
	NEW.nr_seq_estagio,
	NEW.ie_situacao,
	NEW.cd_versao,
	null,
	NEW.ds_overall_desc_rel,
	NEW.ds_overall_description,
	NEW.nr_sequencia,
	ie_tipo_alteracao_w);

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_features_customer_after() FROM PUBLIC;

CREATE TRIGGER reg_features_customer_after
	AFTER INSERT OR UPDATE ON reg_features_customer FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_features_customer_after();
