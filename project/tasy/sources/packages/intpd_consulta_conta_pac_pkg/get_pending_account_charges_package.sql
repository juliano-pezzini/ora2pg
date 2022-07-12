-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	
	
	/*FUNCTION GET_PENDING_ACCOUNT_CHARGES*/

CREATE OR REPLACE FUNCTION intpd_consulta_conta_pac_pkg.get_pending_account_charges (nr_seq_fila_p bigint) RETURNS SETOF T_PEND_ACCOUNT_CHARGES AS $body$
DECLARE

		r_pend_account_charges_w 	r_pend_account_charges_row;


	xml_w          xml;
	query_w        text;

	c01 CURSOR FOR
	SELECT	nr_atendimento,
		dt_inicio,
		dt_fim,
		ie_status
	from	xmltable('/STRUCTURE/FILTERS' passing xml_w columns
		nr_atendimento bigint path 'NR_ENCOUNTER',
		dt_inicio varchar(14) path 'DT_START',
		dt_fim varchar(14) path 'DT_END',
		ie_status varchar(1) path 'IE_STATUS');
	c01_w c01%rowtype;

	c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_atendimento,
		dt_atualizacao,
		ie_status,
		dt_conta,
		cd_setor_atendimento,
		cd_item,
		ie_tipo,
		qt_item,
		nr_seq_fila_transm,
		cd_unidade_medida,
		cd_sistema_ant
	from (
		SELECT	nr_sequencia,
			nr_atendimento,
			dt_atualizacao,
			ie_status,
			dt_conta,
			cd_setor_atendimento,
			cd_item,
			ie_tipo,
			qt_item,
			nr_seq_fila_transm,
			cd_unidade_medida,
			cd_sistema_ant
		from (
			select	b.nr_sequencia,
				b.dt_conta,
				obter_unidade_atendimento(b.nr_atendimento,'A','CS') cd_setor_atendimento,
				b.cd_procedimento cd_item,
				'P' ie_tipo,
				b.qt_procedimento qt_item,
				a.nr_seq_fila_transm,
				a.ie_status,
				b.nr_atendimento,
				a.dt_atualizacao,
				'' cd_unidade_medida,
				c.cd_sistema_ant,
				rank() over (
					partition by a.nr_seq_propaci
					order by a.dt_atualizacao desc, a.nr_sequencia desc) as rnk
			from	status_integr_conta_pac a,
				procedimento_paciente b,
				procedimento c
			where	(a.nr_seq_propaci IS NOT NULL AND a.nr_seq_propaci::text <> '')
			and   a.nr_seq_propaci = b.nr_sequencia
			and	  c.cd_procedimento = b.cd_procedimento
			and	  c.ie_origem_proced = b.ie_origem_proced) alias4
		where	rnk = 1
		
union all

		select	nr_sequencia,
			nr_atendimento,
			dt_atualizacao,
			ie_status,
			dt_conta,
			cd_setor_atendimento,
			cd_item,
			ie_tipo,
			qt_item,
			nr_seq_fila_transm,
			cd_unidade_medida,
			cd_sistema_ant
		from (
			select	
				b.nr_sequencia,
				b.dt_conta,
				obter_unidade_atendimento(b.nr_atendimento,'A','CS') cd_setor_atendimento,
				b.cd_material cd_item,
				'M' ie_tipo,
				b.qt_material qt_item,
				a.nr_seq_fila_transm,
				a.ie_status,
				b.nr_atendimento,
				a.dt_atualizacao,
				b.cd_unidade_medida,
				c.cd_sistema_ant,
				rank() over (
					partition by a.nr_seq_matpaci
					order by a.dt_atualizacao desc, a.nr_sequencia desc) as rnk
			from	status_integr_conta_pac a,
					material_atend_paciente b,
					material c
			where	(a.nr_seq_matpaci IS NOT NULL AND a.nr_seq_matpaci::text <> '')
			and   a.nr_seq_matpaci = b.nr_sequencia
			and	  c.cd_material = b.cd_material) alias9
		where	rnk = 1) alias10
	where	1 = 1
	and	nr_atendimento = c01_w.nr_atendimento
	and (ie_status = c01_w.ie_status or coalesce(c01_w.ie_status::text, '') = '')
	and (dt_atualizacao >= to_date(c01_w.dt_inicio, 'yyyymmddhh24miss') or coalesce(c01_w.dt_inicio::text, '') = '')
	and (dt_atualizacao <= to_date(c01_w.dt_fim, 'yyyymmddhh24miss') or coalesce(c01_w.dt_fim::text, '') = '');
	c02_w c02%rowtype;	
	
	
BEGIN
	select	xmlparse(DOCUMENT, convert_from(, 'utf-8'))
	into STRICT	xml_w
	from	intpd_fila_transmissao
	where	nr_sequencia = nr_seq_fila_p;

	open c01;
	fetch c01 into c01_w;
	close c01;

	for c02_w in c02 loop	
		r_pend_account_charges_w.nr_sequencia		:= c02_w.nr_sequencia;
		r_pend_account_charges_w.dt_conta		:= c02_w.dt_conta;
		r_pend_account_charges_w.cd_setor_atendimento	:= c02_w.cd_setor_atendimento;
		r_pend_account_charges_w.cd_item		:= c02_w.cd_item;
		r_pend_account_charges_w.ie_tipo		:= c02_w.ie_tipo;
		r_pend_account_charges_w.qt_item		:= c02_w.qt_item;
		r_pend_account_charges_w.nr_seq_fila_transm	:= c02_w.nr_seq_fila_transm;
		r_pend_account_charges_w.ie_status		:= c02_w.ie_status;
		r_pend_account_charges_w.cd_unidade_medida	:= c02_w.cd_unidade_medida;
		r_pend_account_charges_w.cd_sistema_ant := c02_w.cd_sistema_ant;
		
		if (r_pend_account_charges_w.ie_tipo = 'P') then			
			begin			
			select	max(nr_seq_original)
			into STRICT	r_pend_account_charges_w.nr_seq_original
			from	intpd_devol_mat_proc
			where	nr_seq_propaci = r_pend_account_charges_w.nr_sequencia;			
			end;
		elsif (r_pend_account_charges_w.ie_tipo = 'M') then
			begin			
			select	max(nr_seq_original)
			into STRICT	r_pend_account_charges_w.nr_seq_original
			from	intpd_devol_mat_proc
			where	nr_seq_matpaci = r_pend_account_charges_w.nr_sequencia;		
			end;
		end if;
		
	RETURN NEXT r_pend_account_charges_w;
	end loop;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION intpd_consulta_conta_pac_pkg.get_pending_account_charges (nr_seq_fila_p bigint) FROM PUBLIC;
