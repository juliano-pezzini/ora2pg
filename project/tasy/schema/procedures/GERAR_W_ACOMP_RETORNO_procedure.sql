-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_acomp_retorno (dt_mes_ref_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_convenio_w			bigint;
vl_total_protocolo_w		double precision;
nr_seq_protocolo_w		bigint;
nr_sequencia_w			bigint;
vl_amenor_total_w		double precision;
vl_recebido_1_w			double precision;
vl_recebido_2_w			double precision;
vl_recebido_3_w			double precision;
vl_recebido_4_w			double precision;

c01 CURSOR FOR 
SELECT	cd_convenio, 
	obter_total_protocolo(nr_seq_protocolo), 
	nr_seq_protocolo 
from	protocolo_convenio 
where	cd_estabelecimento			= cd_estabelecimento_p 
and	PKG_DATE_UTILS.start_of(dt_entrega_convenio, 'month', 0)	= PKG_DATE_UTILS.start_of(dt_mes_ref_p, 'month', 0) 
and	coalesce(obter_total_protocolo(nr_seq_protocolo),0) > 0 
group 	by cd_convenio, 
	nr_seq_protocolo;


BEGIN 
 
delete	from w_acomp_retorno 
where	nm_usuario	= nm_usuario_p 
or	dt_atualizacao	< clock_timestamp() - interval '7 days';
 
open c01;
loop 
fetch c01 into 
	cd_convenio_w, 
	vl_total_protocolo_w, 
	nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	-- Gerar valor total 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_sequencia_w 
	from	w_acomp_retorno 
	where	cd_convenio	= cd_convenio_w 
	and	nm_usuario	= nm_usuario_p;
 
	if (nr_sequencia_w = 0) then 
		select	nextval('w_acomp_retorno_seq') 
		into STRICT	nr_sequencia_w 
		;
 
		-- gerar vl faturado para o mês inicial 
		insert	into w_acomp_retorno(NR_SEQUENCIA, 
				CD_ESTABELECIMENTO, 
				DT_ATUALIZACAO, 
				NM_USUARIO, 
				CD_CONVENIO, 
				VL_FATURADO, 
				VL_AMENOR_TOTAL, 
				VL_AMENOR_1, 
				VL_AMENOR_2, 
				VL_AMENOR_3, 
				VL_AMENOR_4) 
		values (nr_sequencia_w, 
				cd_estabelecimento_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_convenio_w, 
				vl_total_protocolo_w, 
				0, 
				0, 
				0, 
				0, 
				0);
	else 
		update	w_acomp_retorno 
		set	vl_faturado	= vl_faturado + vl_total_protocolo_w 
		where	nr_sequencia	= nr_sequencia_w;
	end if;
 
 
	-- calculo do total a menor 
	select	coalesce(sum(b.vl_amenor),0) 
	into STRICT	vl_amenor_total_w 
	from	convenio_retorno_item b, 
		conta_paciente a 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	a.nr_seq_protocolo	= nr_seq_protocolo_w;
 
	update	w_acomp_retorno 
	set	vl_amenor_total	= vl_amenor_total + vl_amenor_total_w 
	where	nr_sequencia	= nr_sequencia_w;
 
	-- calculo do total a menor pendente no 1º mes subsequente 
	select	coalesce(sum(vl_historico),0) 
	into STRICT	vl_recebido_1_w 
	from	hist_audit_conta_paciente d, 
		conta_paciente_ret_hist c, 
		conta_paciente_retorno b, 
		conta_paciente a 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	b.nr_sequencia		= c.nr_seq_conpaci_ret 
	and	c.nr_seq_hist_audit	= d.nr_sequencia 
	and	d.ie_acao		= 1 
	and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
	and	PKG_DATE_UTILS.start_of(c.dt_historico, 'month', 0) = PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_mes_ref_p,1,0), 'month', 0);
 
	-- calculo do total a menor pendente no 2º mes subsequente 
	select	coalesce(sum(vl_historico),0) 
	into STRICT	vl_recebido_2_w 
	from	hist_audit_conta_paciente d, 
		conta_paciente_ret_hist c, 
		conta_paciente_retorno b, 
		conta_paciente a 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	b.nr_sequencia		= c.nr_seq_conpaci_ret 
	and	c.nr_seq_hist_audit	= d.nr_sequencia 
	and	d.ie_acao		= 1 
	and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
	and	PKG_DATE_UTILS.start_of(c.dt_historico, 'month', 0) = PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_mes_ref_p,2,0), 'month', 0);
 
--	if	(vl_recebido_2_w > 0) then 
--	end if; 
 
	-- calculo do total a menor pendente no 3º mes subsequente 
	select	coalesce(sum(vl_historico),0) 
	into STRICT	vl_recebido_3_w 
	from	hist_audit_conta_paciente d, 
		conta_paciente_ret_hist c, 
		conta_paciente_retorno b, 
		conta_paciente a 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	b.nr_sequencia		= c.nr_seq_conpaci_ret 
	and	c.nr_seq_hist_audit	= d.nr_sequencia 
	and	d.ie_acao		= 1 
	and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
	and	PKG_DATE_UTILS.start_of(c.dt_historico, 'month', 0) = PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_mes_ref_p,3,0), 'month', 0);
 
	-- calculo do total a menor pendente no 4º mes subsequente 
	select	coalesce(sum(vl_historico),0) 
	into STRICT	vl_recebido_4_w 
	from	hist_audit_conta_paciente d, 
		conta_paciente_ret_hist c, 
		conta_paciente_retorno b, 
		conta_paciente a 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	b.nr_sequencia		= c.nr_seq_conpaci_ret 
	and	c.nr_seq_hist_audit	= d.nr_sequencia 
	and	d.ie_acao		= 1 
	and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
	and	PKG_DATE_UTILS.start_of(c.dt_historico, 'month', 0) = PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_mes_ref_p,4,0), 'month', 0);
 
	-- setar os valores da tabela 
	update	w_acomp_retorno 
	set	vl_amenor_1	= vl_amenor_1 + vl_amenor_total_w - vl_recebido_1_w, 
		vl_amenor_2	= vl_amenor_2 + vl_amenor_total_w - vl_recebido_2_w - vl_recebido_1_w, 
		vl_amenor_3	= vl_amenor_3 + vl_amenor_total_w - vl_recebido_3_w - vl_recebido_2_w - vl_recebido_1_w, 
		vl_amenor_4	= vl_amenor_4 + vl_amenor_total_w - vl_recebido_4_w - vl_recebido_3_w - vl_recebido_2_w - vl_recebido_1_w 
	where	nr_sequencia	= nr_sequencia_w;
 
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_acomp_retorno (dt_mes_ref_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

