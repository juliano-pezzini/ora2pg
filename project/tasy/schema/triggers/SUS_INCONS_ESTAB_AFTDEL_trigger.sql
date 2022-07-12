-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sus_incons_estab_aftdel ON sus_inconsistencia_estab CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sus_incons_estab_aftdel() RETURNS trigger AS $BODY$
declare

ie_executa		varchar(1) := 'S';
ie_consiste_w	        varchar(1);
ie_aih_w	        varchar(1);
ie_apac_w	        varchar(1);
ie_bpa_con_w	        varchar(1);
ie_bpa_ind_w	        varchar(1);
cd_inconsistencia_w     sus_inconsistencia.cd_inconsistencia%type;
BEGIN
  BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	ie_executa := 'N';
end if;

if (ie_executa = 'S') then
        BEGIN
        select	cd_inconsistencia
        into STRICT	cd_inconsistencia_w
        from	sus_inconsistencia
        where	nr_sequencia	= OLD.nr_seq_inconsistencia;
        exception
        when no_data_found then
                cd_inconsistencia_w := 0;
        when too_many_rows then
                cd_inconsistencia_w := 0;
        when others then
                cd_inconsistencia_w := 0;
        end;

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
        from	sus_inconsistencia
        where	cd_inconsistencia	= cd_inconsistencia_w;
        exception
        when no_data_found then
                ie_consiste_w	:= 'N';
                ie_aih_w	:= 'N';
                ie_apac_w	:= 'N';
                ie_bpa_con_w	:= 'N';
                ie_bpa_ind_w	:= 'N';
        when too_many_rows then
                ie_consiste_w	:= 'N';
                ie_aih_w	:= 'N';
                ie_apac_w	:= 'N';
                ie_bpa_con_w	:= 'N';
                ie_bpa_ind_w	:= 'N';
        when others then
                ie_consiste_w	:= 'N';
                ie_aih_w	:= 'N';
                ie_apac_w	:= 'N';
                ie_bpa_con_w	:= 'N';
                ie_bpa_ind_w	:= 'N';
        end;

        CALL sus_obter_inco_ativa_pck.set_cd_estabelecimento(wheb_usuario_pck.get_cd_estabelecimento);
        CALL sus_obter_inco_ativa_pck.set_cd_inconsistencia(cd_inconsistencia_w);
        CALL sus_obter_inco_ativa_pck.set_ie_consiste(ie_consiste_w);
        CALL sus_obter_inco_ativa_pck.set_ie_aih(ie_aih_w);
        CALL sus_obter_inco_ativa_pck.set_ie_apac(ie_apac_w);
        CALL sus_obter_inco_ativa_pck.set_ie_bpa_con(ie_bpa_con_w);
        CALL sus_obter_inco_ativa_pck.set_ie_bpa_ind(ie_bpa_ind_w);
        CALL sus_obter_inco_ativa_pck.set_sus_obter_inco_ativa_trg();
end if;
  END;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sus_incons_estab_aftdel() FROM PUBLIC;

CREATE TRIGGER sus_incons_estab_aftdel
	AFTER DELETE ON sus_inconsistencia_estab FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sus_incons_estab_aftdel();
