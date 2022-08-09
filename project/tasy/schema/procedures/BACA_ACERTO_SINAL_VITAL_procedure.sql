-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_sinal_vital () AS $body$
DECLARE


qt_existe_w	bigint;
ds_comando_w	varchar(2000);


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	user_tab_columns
where	table_name = 'ATENDIMENTO_SINAL_VITAL'
and	column_name = 'QT_CST';

if (qt_existe_w > 0) then

	ds_comando_w :=
	'insert into atendimento_monit_resp( '||
	'	nr_sequencia, '||
	'	nr_atendimento, '||
	'	dt_monitorizacao, '||
	'	dt_atualizacao, '||
	'	nm_usuario, '||
	'	cd_pessoa_fisica, '||
	'	ie_respiracao, '||
	'	cd_mod_vent, '||
	'	qt_freq_vent, '||
	'	qt_vci, '||
	'	qt_pip, '||
	'	qt_peep, '||
	'	qt_ps, '||
	'	qt_fio2, '||
	'	qt_co2, '||
	'	qt_vmin, '||
	'	qt_auto_peep, '||
	'	qt_pplato, '||
	'	qt_pva, '||
	'	qt_cst, '||
	'	qt_rsr, '||
	'	qt_fluxo_insp, '||
	'	qt_rel_pao2_fio2, '||
	'	qt_grad_aao2, '||
	'	qt_pressao_cuff, '||
	'	ds_observacao) '||
	'select	atendimento_monit_resp_seq.nextval, '||
	'	nr_atendimento, '||
	'	dt_sinal_vital, '||
	'	dt_atualizacao, '||
	'	nm_usuario, '||
	'	cd_pessoa_fisica, '||
	'	ie_respiracao, '||
	'	cd_mod_vent, '||
	'	qt_freq_vent, '||
	'	qt_vci, '||
	'	qt_pip, '||
	'	qt_peep, '||
	'	qt_ps, '||
	'	qt_fio2, '||
	'	qt_co2, '||
	'	qt_vmin, '||
	'	qt_auto_peep, '||
	'	qt_pplato, '||
	'	qt_pva, '||
	'	qt_cst, '||
	'	qt_rsr, '||
	'	qt_fluxo_insp, '||
	'	qt_rel_pao2_fio2, '||
	'	qt_grad_aao2, '||
	'	qt_pressao_cuff, '||
	'	ds_observacao '||
	'from	atendimento_sinal_vital '||
	'where	qt_pa_sistolica is null '||
	'and	qt_pa_diastolica is null '||
	'and	qt_pam is null '||
	'and	qt_freq_cardiaca is null '||
	'and	qt_freq_resp is null '||
	'and	qt_temp is null '||
	'and	qt_escala_dor is null '||
	'and	nr_seq_topografia_dor is null '||
	'and	qt_peso is null '||
	'and	qt_altura_cm is null '||
	'and	qt_imc is null '||
	'and	qt_superf_corporia is null '||
	'and	qt_glicemia_capilar is null '||
	'and	qt_saturacao_o2 is null '||
	'and	qt_pvc_h2o is null '||
	'and	qt_pvc is null '||
	'and	qt_pae is null '||
	'and	qt_pressao_intra_cranio is null '||
	'and	qt_pressao_intra_abd is null '||
	'and	qt_bcf is null '||
	'and	qt_temp_incubadora is null ';

	CALL Exec_sql_Dinamico('Edilson', ds_comando_w);

	ds_comando_w :=
	'delete	atendimento_sinal_vital '||
	'where	qt_pa_sistolica is null '||
	'and	qt_pa_diastolica is null '||
	'and	qt_pam is null '||
	'and	qt_freq_cardiaca is null '||
	'and	qt_freq_resp is null '||
	'and	qt_temp is null '||
	'and	qt_escala_dor is null '||
	'and	nr_seq_topografia_dor is null '||
	'and	qt_peso is null '||
	'and	qt_altura_cm is null '||
	'and	qt_imc is null '||
	'and	qt_superf_corporia is null '||
	'and	qt_glicemia_capilar is null '||
	'and	qt_saturacao_o2 is null '||
	'and	qt_pvc_h2o is null '||
	'and	qt_pvc is null '||
	'and	qt_pae is null '||
	'and	qt_pressao_intra_cranio is null '||
	'and	qt_pressao_intra_abd is null '||
	'and	qt_bcf is null '||
	'and	qt_temp_incubadora is null ';

	CALL Exec_sql_Dinamico('Edilson', ds_comando_w);

	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column CD_MOD_VENT');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column IE_RESPIRACAO');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_FIO2');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_FREQ_VENT');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_VCI');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_PEEP');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_CO2');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_VMIN');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_AUTO_PEEP');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_PPLATO');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_PVA');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_RSR');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_FLUXO_INSP');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_REL_PAO2_FIO2');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_GRAD_AAO2');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_PRESSAO_CUFF');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_PIP');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_PS');
	CALL Exec_sql_Dinamico('Edilson', 'alter table atendimento_sinal_vital drop column QT_CST');

end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_sinal_vital () FROM PUBLIC;
