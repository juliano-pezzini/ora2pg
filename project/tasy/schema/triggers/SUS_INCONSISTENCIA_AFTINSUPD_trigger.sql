-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sus_inconsistencia_aftinsupd ON sus_inconsistencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sus_inconsistencia_aftinsupd() RETURNS trigger AS $BODY$
declare

ie_executa              varchar(1) := 'S';
ie_consiste_w	        varchar(1);
ie_aih_w	        varchar(1);
ie_apac_w	        varchar(1);
ie_bpa_con_w	        varchar(1);
ie_bpa_ind_w	        varchar(1);
cd_estabelecimento_w    smallint;
BEGIN
  BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	ie_executa := 'N';
end if;

if (ie_executa = 'S') then
        cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
        BEGIN
        select	ie_consiste,
                ie_aih,
                ie_apac,
                ie_bpa_consolidado,
                ie_bpa_individualizado
        into STRICT	ie_consiste_w,
                ie_aih_w,
                ie_apac_w,
                ie_bpa_con_w,
                ie_bpa_ind_w
        from	sus_inconsistencia_estab
        where	nr_seq_inconsistencia	= NEW.nr_sequencia
        and	cd_estabelecimento	= cd_estabelecimento_w;
        exception
        when no_data_found then
                ie_consiste_w	:= NEW.ie_consiste;
                ie_aih_w	:= NEW.ie_aih;
                ie_apac_w	:= NEW.ie_apac;
                ie_bpa_con_w	:= NEW.ie_bpa_consolidado;
                ie_bpa_ind_w	:= NEW.ie_bpa_individualizado;
        when too_many_rows then
                ie_consiste_w	:= NEW.ie_consiste;
                ie_aih_w	:= NEW.ie_aih;
                ie_apac_w	:= NEW.ie_apac;
                ie_bpa_con_w	:= NEW.ie_bpa_consolidado;
                ie_bpa_ind_w	:= NEW.ie_bpa_individualizado;
        when others then
                ie_consiste_w	:= NEW.ie_consiste;
                ie_aih_w	:= NEW.ie_aih;
                ie_apac_w	:= NEW.ie_apac;
                ie_bpa_con_w	:= NEW.ie_bpa_consolidado;
                ie_bpa_ind_w	:= NEW.ie_bpa_individualizado;
        end;

        CALL sus_obter_inco_ativa_pck.set_cd_estabelecimento(cd_estabelecimento_w);
        CALL sus_obter_inco_ativa_pck.set_cd_inconsistencia(NEW.cd_inconsistencia);
        CALL sus_obter_inco_ativa_pck.set_ie_consiste(ie_consiste_w);
        CALL sus_obter_inco_ativa_pck.set_ie_aih(ie_aih_w);
        CALL sus_obter_inco_ativa_pck.set_ie_apac(ie_apac_w);
        CALL sus_obter_inco_ativa_pck.set_ie_bpa_con(ie_bpa_con_w);
        CALL sus_obter_inco_ativa_pck.set_ie_bpa_ind(ie_bpa_ind_w);
        CALL sus_obter_inco_ativa_pck.set_sus_obter_inco_ativa_trg();
end if;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sus_inconsistencia_aftinsupd() FROM PUBLIC;

CREATE TRIGGER sus_inconsistencia_aftinsupd
	AFTER INSERT OR UPDATE ON sus_inconsistencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sus_inconsistencia_aftinsupd();

