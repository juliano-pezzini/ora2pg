-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conv_proc_fat_xml_atual ON pls_conv_proc_fat_xml CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conv_proc_fat_xml_atual() RETURNS trigger AS $BODY$
declare

BEGIN
-- esta trigger foi criada para alimentar os campos de data referencia, isto por questões de performance
-- para que não seja necessário utilizar um or is null nas rotinas que utilizam esta tabela
-- o campo inicial ref é alimentado com o valor informado no campo inicial ou se este for nulo é alimentado
-- com a data zero do oracle 31/12/1899 desta forma podemos utilizar um between ou fazer uma comparação com este campo
-- sem precisar se preocupar se o campo vai estar nulo
NEW.dt_inicio_vigencia_ref := pls_util_pck.obter_dt_vigencia_null( NEW.dt_inicio_vigencia, 'I');
NEW.dt_fim_vigencia_ref := pls_util_pck.obter_dt_vigencia_null(NEW.dt_fim_vigencia, 'F');

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conv_proc_fat_xml_atual() FROM PUBLIC;

CREATE TRIGGER pls_conv_proc_fat_xml_atual
	BEFORE INSERT OR UPDATE ON pls_conv_proc_fat_xml FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conv_proc_fat_xml_atual();

