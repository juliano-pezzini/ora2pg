-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_total_dias_liberado as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_total_dias_liberado (nr_prescricao_p bigint, nr_atendimento_p bigint, dt_prescricao_p timestamp, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM obter_total_dias_liberado_atx ( ' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(dt_prescricao_p) || ',' || quote_nullable(cd_material_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_total_dias_liberado_atx (nr_prescricao_p bigint, nr_atendimento_p bigint, dt_prescricao_p timestamp, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE
qt_dias_util_medic_w	bigint;
qt_dias_liberado_w	bigint;
ie_controle_medico_w	bigint;
qt_dias_lib_atend_w	bigint;

ie_rastre_prescr_ua_w	varchar(1);


BEGIN
SELECT * FROM consiste_util_medic(	nr_prescricao_p, nr_atendimento_p, dt_prescricao_p, cd_material_p, qt_dias_util_medic_w, qt_dias_liberado_w, ie_controle_medico_w, qt_dias_lib_atend_w) INTO STRICT qt_dias_util_medic_w, qt_dias_liberado_w, ie_controle_medico_w, qt_dias_lib_atend_w;
			
ie_rastre_prescr_ua_w := obter_se_info_rastre_prescr('UA', wheb_usuario_pck.get_nm_usuario, obter_perfil_ativo, wheb_usuario_pck.get_cd_estabelecimento);

if (ie_rastre_prescr_ua_w = 'S') then
	-- Commit no insert do log, caso contrario tera excecao ORA-06519 devido a autonomous_transaction
	commit;
end if;
			
return	qt_dias_lib_atend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_dias_liberado (nr_prescricao_p bigint, nr_atendimento_p bigint, dt_prescricao_p timestamp, cd_material_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_total_dias_liberado_atx (nr_prescricao_p bigint, nr_atendimento_p bigint, dt_prescricao_p timestamp, cd_material_p bigint) FROM PUBLIC;
