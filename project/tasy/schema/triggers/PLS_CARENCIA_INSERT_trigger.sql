-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_carencia_insert ON pls_carencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_carencia_insert() RETURNS trigger AS $BODY$
declare

ie_cpt_w	varchar(1);
ds_erro_w	varchar(255);
BEGIN
  BEGIN

BEGIN
if (NEW.nr_seq_tipo_carencia is null) then
	NEW.ie_cpt	:= 'N';
else
	select	max(ie_cpt)
	into STRICT	ie_cpt_w
	from	pls_tipo_carencia
	where	nr_sequencia	= NEW.nr_seq_tipo_carencia;

	NEW.ie_cpt	:= coalesce(ie_cpt_w,'N');
end if;
exception
when others then
	ds_erro_w	:= '';
end;

-- Performance do calculo da carência do SIP
NEW.dt_inicio_vig_plano_ref := trunc(pls_util_pck.obter_dt_vigencia_null( NEW.dt_inicio_vig_plano, 'I'),'dd');
NEW.dt_fim_vig_plano_ref := fim_dia(pls_util_pck.obter_dt_vigencia_null( NEW.dt_fim_vig_plano, 'F'));

-- OS 1371436 - Obs: O campo QT_DIAS_ORIGEM foi criado nesta OS e está sendo usado apenas nas carências do beneficiário por enquanto
if (TG_OP = 'INSERT') then
	NEW.qt_dias_origem := NEW.qt_dias;
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_carencia_insert() FROM PUBLIC;

CREATE TRIGGER pls_carencia_insert
	BEFORE INSERT OR UPDATE ON pls_carencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_carencia_insert();
