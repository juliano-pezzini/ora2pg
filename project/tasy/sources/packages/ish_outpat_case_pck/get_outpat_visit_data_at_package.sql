-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_outpat_case_pck.get_outpat_visit_data_at ( nr_seq_fila_p bigint) RETURNS SETOF T_OUTPAT_VISIT_DATA_AT AS $body$
DECLARE

		
r_outpat_visit_data_at_w	r_outpat_visit_data_at;

nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;

nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;

atendimento_paciente_w		atendimento_paciente%rowtype;


BEGIN

select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_conversao_w,	
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);
reg_integracao_w.nm_tabela 			:= 'ATENDIMENTO_PACIENTE';
reg_integracao_w.nm_elemento			:= 'OutpatVisitDataAt';


select	ish_get_encounter_case(coalesce(nr_episodio, nr_seq_documento_w), 'OUTPAT')
into STRICT	nr_atendimento_w
from	episodio_paciente
where	nr_sequencia = nr_seq_documento_w;

begin
select	*
into STRICT	atendimento_paciente_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_w;

intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_QUEIXA','reasonoftreatment', 'N', atendimento_paciente_w.nr_seq_queixa, 'S', r_outpat_visit_data_at_w.reasonoftreatment);
intpd_processar_atrib_envio(reg_integracao_w, 'QT_IG_SEMANA','weekofpregnancy', 'N', atendimento_paciente_w.qt_ig_semana, 'N', r_outpat_visit_data_at_w.weekofpregnancy);
intpd_processar_atrib_envio(reg_integracao_w, 'CD_PROCEDENCIA','admissiontype2', 'N', atendimento_paciente_w.cd_procedencia, 'S', r_outpat_visit_data_at_w.admissiontype2);

RETURN NEXT r_outpat_visit_data_at_w;
CALL intpd_gravar_log_fila(reg_integracao_w);

exception
when others then
	null;
end;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_outpat_case_pck.get_outpat_visit_data_at ( nr_seq_fila_p bigint) FROM PUBLIC;