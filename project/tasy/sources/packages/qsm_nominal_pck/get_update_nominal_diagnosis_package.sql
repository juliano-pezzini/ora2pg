-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


----------------     GET_UPDATE_NOMINAL_DIAGNOSIS
CREATE OR REPLACE FUNCTION qsm_nominal_pck.get_update_nominal_diagnosis ( nr_seq_fila_p bigint) RETURNS SETOF T_UPDATE_NOMINAL_DIAGNOSIS AS $body$
DECLARE


nr_seq_documento_w			intpd_fila_transmissao.nr_seq_documento%type;
ie_evento_w				intpd_fila_transmissao.ie_evento%type;
ie_conversao_w				intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w			intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w				intpd_eventos_sistema.nr_seq_regra_conv%type;
r_update_nominal_diagnosis_w		r_update_nominal_diagnosis;
diagnostico_doenca_chave_w		dbms_sql.varchar2_table;
nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
nr_seq_interno_w			diagnostico_doenca.nr_seq_interno%type;
cd_doenca_w				diagnostico_doenca.cd_doenca%type;

C01 CURSOR FOR
	SELECT	d.cd_doenca ds_code,
		intpd_conv('ATEND_PACIENTE_UNIDADE', 'CD_DEPARTAMENTO', ds.cd_departamento, nr_seq_regra_w, ie_conversao_w, 'E') ds_department,
		lpad(obter_conversao_301('C301_6_DEPARTAMENTO','DEPARTAMENTO_MEDICO',null,ds.cd_departamento,'I'),4,'0') ds_department_type,
		CASE WHEN ie_classificacao_doenca='P' THEN  'primary' WHEN ie_classificacao_doenca='S' THEN  'secondary'  ELSE 'none' END   ds_drg_relevance,
		replace(replace(d.cd_doenca, '*', ''), '!', '')  ds_key,
		CASE WHEN d.ie_lado='E' THEN  'left' WHEN d.ie_lado='D' THEN  'right' WHEN d.ie_lado='A' THEN  'both'  ELSE 'none' END  ds_localization,
		d.nr_atendimento ds_visit
	FROM departamento_setor ds, diagnostico_doenca d, obter_setor_atendimento(d
LEFT OUTER JOIN setor_atendimento s ON (obter_setor_atendimento(d.nr_atendimento) = s.cd_setor_atendimento)
WHERE s.cd_setor_atendimento	= ds.cd_setor_atendimento and d.nr_atendimento	= coalesce(nr_atendimento_w, 0) and d.ie_relevante_drg  = 'S' and (d.dt_liberacao IS NOT NULL AND d.dt_liberacao::text <> '') and coalesce(d.dt_inativacao::text, '') = '';

BEGIN
select	a.nr_seq_documento,
	a.ie_evento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_sistema,
	b.nr_seq_projeto_xml,
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_evento_w,
	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia		= nr_seq_fila_p;

if (ie_evento_w = '82') then
	diagnostico_doenca_chave_w	:= obter_lista_string(nr_seq_documento_w, obter_desc_expressao(960897));

	nr_atendimento_w		:= diagnostico_doenca_chave_w(1);
	nr_seq_interno_w		:= diagnostico_doenca_chave_w(2);
	cd_doenca_w			:= diagnostico_doenca_chave_w(3);
elsif (ie_evento_w = '120') then
	nr_atendimento_w := nr_seq_documento_w;
end if;

for r_C01_w in C01 loop
	begin
	r_update_nominal_diagnosis_w := qsm_nominal_pck.limpar_atributos_diagnosis(r_update_nominal_diagnosis_w);

	r_update_nominal_diagnosis_w.ds_code			:= r_C01_w.ds_code;
	r_update_nominal_diagnosis_w.ds_department		:= r_C01_w.ds_department;
	r_update_nominal_diagnosis_w.ds_department_type		:= r_C01_w.ds_department_type;
	r_update_nominal_diagnosis_w.ds_drg_relevance		:= r_C01_w.ds_drg_relevance;
	r_update_nominal_diagnosis_w.ds_key			:= r_C01_w.ds_key;
	r_update_nominal_diagnosis_w.ds_localization		:= r_C01_w.ds_localization;
	r_update_nominal_diagnosis_w.ds_visit			:= r_C01_w.ds_visit;

	RETURN NEXT r_update_nominal_diagnosis_w;
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION qsm_nominal_pck.get_update_nominal_diagnosis ( nr_seq_fila_p bigint) FROM PUBLIC;
