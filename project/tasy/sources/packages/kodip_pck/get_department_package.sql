-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
'Department'
*/
CREATE OR REPLACE FUNCTION kodip_pck.get_department ( nr_seq_documento_p text, nr_atendimento_p bigint) RETURNS SETOF T_DEPARTMENT AS $body$
DECLARE

		
_ora2pg_r RECORD;
nr_seq_episodio_w		episodio_paciente.nr_sequencia%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;

r_department_w		r_department;

deptcode301_w		c301_conversao_dados.ds_valor_301%type;

c01 CURSOR FOR
SELECT	rownum-1 id,
	x.*
from (
select	
	b.nr_seq_interno,
	b.cd_departamento,
	c.ds_departamento,
	b.dt_entrada_unidade,
	b.dt_saida_unidade,
	a.cd_motivo_alta,
	a.nr_atendimento,
	trunc(coalesce(b.dt_retorno_saida_temporaria, clock_timestamp()) - b.dt_saida_temporaria) qt_dia_saida
from 	atendimento_paciente a,
	atend_paciente_unidade b,
	departamento_medico c
where	a.nr_atendimento = b.nr_atendimento
and	b.cd_departamento = c.cd_departamento
and	a.nr_seq_episodio = nr_seq_episodio_w
and 	coalesce(a.dt_cancelamento::text, '') = ''
order by b.dt_entrada_unidade, b.nr_seq_interno) x;

c01_w	c01%rowtype;


BEGIN
nr_seq_episodio_w	:=	somente_numero(nr_seq_documento_p);
nr_atendimento_w	:=	nr_atendimento_p;
SELECT * FROM kodip_pck.inicializacao(nr_seq_episodio_w, nr_atendimento_w, reg_integracao_w) INTO STRICT _ora2pg_r;
 nr_seq_episodio_w := _ora2pg_r.nr_seq_episodio_p; nr_atendimento_w := _ora2pg_r.nr_atendimento_p; reg_integracao_w := _ora2pg_r.reg_integracao_p;

reg_integracao_w.nm_elemento	:= 'Department';

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	r_department_w	:=	null;
	reg_integracao_w.nm_tabela	:= 'ATEND_PACIENTE_UNIDADE';
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_ENTRADA_UNIDADE', 'AdmDate', 'N', to_char(c01_w.dt_entrada_unidade, 'YYYYMMDDHHMM'), 'N', r_department_w.admdate);
	intpd_processar_atrib_envio(reg_integracao_w, 'DT_ENTRADA_UNIDADE', 'SepDate', 'N', to_char(c01_w.dt_saida_unidade, 'YYYYMMDDHHMM'), 'N', r_department_w.sepdate);
	intpd_processar_atrib_envio(reg_integracao_w, 'QT_DIA_SAIDA', 'LeaveDays', 'N', c01_w.qt_dia_saida, 'N', r_department_w.leavedays);
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_DEPARTAMENTO', 'DeptCode', 'N', c01_w.cd_departamento, 'N', r_department_w.deptcode);
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_DEPARTAMENTO', 'DeptName', 'N', c01_w.ds_departamento, 'N', r_department_w.deptname);
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_DEPARTAMENTO', 'DeptId', 'N', c01_w.nr_seq_interno, 'N', r_department_w.deptid);
	
	begin
	select	ds_valor_301
	into STRICT	deptcode301_w
	from	c301_conversao_dados
	where	nm_tabela_301 = 'C301_6_DEPARTAMENTO' 
	and	ds_valor_tasy = to_char(c01_w.cd_departamento)  LIMIT 1;	
	exception
	when others then
		deptcode301_w	:=	null;
	end;
	
	reg_integracao_w.nm_tabela	:= 'C301_CONVERSAO_DADOS';
	intpd_processar_atrib_envio(reg_integracao_w, 'DS_VALOR_301', 'DeptCode301', 'N', deptcode301_w, 'N', r_department_w.deptcode301);
	
	reg_integracao_w.nm_tabela	:= 'ATENDIMENTO_PACIENTE';
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_MOTIVO_ALTA', 'SepMode', 'N', c01_w.cd_motivo_alta, 'S', r_department_w.sepmode);
	
	intpd_processar_atrib_envio(reg_integracao_w, 'ID', 'ID', 'N', c01_w.id, 'N', r_department_w.id);
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'NR_SEQ_INTERNO', 'N', c01_w.nr_seq_interno, 'N', r_department_w.nr_seq_interno);
	
	/*'
	Pending of Definition
	-- DeptType
	-- DeptTypeFlags
	--AllowedDiagTypeFlags
	--AllowedProcTypeFlags
	--DefDiagTypeFlag
	--DefProcTypeFlag
	'*/
	
	RETURN NEXT r_department_w;
	end;
end loop;
close c01;

reg_integracao_w := kodip_pck.record_log(nr_seq_episodio_w, reg_integracao_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION kodip_pck.get_department ( nr_seq_documento_p text, nr_atendimento_p bigint) FROM PUBLIC;
