-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_pat_case_pck.get_add_absence_data ( nr_seq_fila_p bigint) RETURNS SETOF T_ADD_ABSENCE_DATA AS $body$
DECLARE


r_add_absence_data_w	r_add_absence_data;

nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
dt_geral_w				varchar(255);

c03 CURSOR FOR
SELECT	a.dt_saida_temporaria,
	a.dt_retorno_saida_temporaria	 	
from	atend_paciente_unidade	a,
	atendimento_paciente	b
where	a.nr_atendimento		= b.nr_atendimento
and	a.nr_seq_interno		= nr_seq_documento_w;

c03_w	c03%rowtype;


BEGIN	
select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_conversao_w,	
	nr_seq_regra_w
from	intpd_fila_transmissao	a,
	intpd_eventos_sistema	b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia		= nr_seq_fila_p;

intpd_reg_integracao_inicio(nr_seq_fila_p,'E', reg_integracao_w);

open c03;
loop
fetch c03 into	
	c03_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin
	
	r_add_absence_data_w.MovemntTypeBeg	:= 'AB';
	reg_integracao_w.nm_elemento		:= 'InpatAbsenceData';
	reg_integracao_w.nm_tabela 		:= 'ATEND_PACIENTE_UNIDADE';
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_SAIDA_TEMPORARIA', 'MovemntDateBeg', 'N', c03_w.dt_saida_temporaria, 'N', dt_geral_w);
	r_add_absence_data_w.MovemntDateBeg	:= to_char(to_date(dt_geral_w),'YYYY-MM-DD');
	dt_geral_w							:= null;
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_SAIDA_TEMPORARIA', 'MovemntTimeBeg', 'N', c03_w.dt_saida_temporaria, 'N', dt_geral_w);
	r_add_absence_data_w.MovemntTimeBeg	:=	to_char(to_date(dt_geral_w),'HH24:MI:SS');
	
	r_add_absence_data_w.MovemntTypeEnd	:= 'AE';
	reg_integracao_w.nm_tabela 		:= 'ATEND_PACIENTE_UNIDADE';
	dt_geral_w							:= null;
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_RETORNO_SAIDA_TEMPORARIA', 'MovemntDateEnd', 'N', c03_w.dt_retorno_saida_temporaria, 'N', dt_geral_w);
	r_add_absence_data_w.MovemntDateEnd	:= coalesce(to_char(to_date(dt_geral_w),'YYYY-MM-DD'),'9999-12-31');
	dt_geral_w							:= null;
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_RETORNO_SAIDA_TEMPORARIA', 'MovemntDateEnd', 'N', c03_w.dt_retorno_saida_temporaria, 'N', dt_geral_w);
	r_add_absence_data_w.MovemntTimeEnd	:= coalesce(to_char(to_date(dt_geral_w),'HH24:MI:SS'),'24:00:00');
	
	r_add_absence_data_w.StatusIndEnd	:= 'P';	
	
	end;
end loop;
close c03;

RETURN NEXT r_add_absence_data_w;
CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_pat_case_pck.get_add_absence_data ( nr_seq_fila_p bigint) FROM PUBLIC;