-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_valida_anexo_ii ( nr_seq_lote_sip_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
dt_periodo_inicial_w		timestamp;
dt_periodo_final_w		timestamp;
cd_estrutura_w			varchar(10);
vl_diops_w			double precision	:= 0;
qt_caracteres_w			integer;
vl_sip_if_w			double precision;
vl_sip_csp_w			double precision;
vl_sip_ccp_w			double precision;
vl_total_sip_w			double precision	:= 0;
vl_sip_diops_w			double precision	:= 0;
vl_eventos_w			double precision;
vl_recuperacao_w		double precision;
vl_glosa_w			double precision;
vl_copartic_if_w		double precision;
vl_copartic_csp_w		double precision;
vl_copartic_ccp_w		double precision;
vl_coparticipacao_w		double precision;

C01 CURSOR FOR 
	SELECT	s.cd_estrutura, 
		coalesce(sum(c.vl_movimento),0) 
	from	ctb_mes_ref			d, 
		ctb_balancete_v			c, 
		sip_conta_contabil		b, 
		sip_tipo_item_despesa		a, 
		sip_tipo_despesa		s 
	where	s.nr_sequencia			= a.nr_seq_tipo_despesa 
	and	a.nr_sequencia			= b.nr_seq_tipo_item_desp 
	and	b.cd_conta_contabil		= c.cd_conta_contabil 
	and	c.nr_seq_mes_ref		= d.nr_sequencia 
	and	c.ie_normal_encerramento	= 'E' 
	/* and	c.ie_tipo_conta			= 'D' */
 
	and	d.dt_referencia between dt_periodo_inicial_w and dt_periodo_final_w 
	group by s.cd_estrutura 
	order by 
		s.cd_estrutura;


BEGIN 
 
delete from pls_despesa_sip_diops 
where	nr_seq_lote_sip	= nr_seq_lote_sip_p;
 
begin 
select	dt_periodo_inicial, 
	coalesce(dt_periodo_final, clock_timestamp()) 
into STRICT	dt_periodo_inicial_w, 
	dt_periodo_final_w 
from	pls_lote_sip 
where	nr_sequencia	= nr_seq_lote_sip_p;	
exception 
	when others then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 266994, 'NR_SEQ_LOTE_SIP='||nr_seq_lote_sip_p);
end;
 
open C01;
loop 
fetch C01 into	 
	cd_estrutura_w, 
	vl_diops_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	qt_caracteres_w	:= length(cd_estrutura_w);
	 
	select	coalesce(sum(vl_total_despesa),0), 
		coalesce(sum(vl_participacao),0) 
	into STRICT	vl_sip_if_w, 
		vl_copartic_if_w 
	from	w_sip_item_despesa 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p 
	and	substr(cd_estrutura,1,qt_caracteres_w)	= cd_estrutura_w 
	and	ie_tipo_item_despesa	= 'IF';
	 
	select	coalesce(sum(vl_total_despesa),0), 
		coalesce(sum(vl_participacao),0) 
	into STRICT	vl_sip_csp_w, 
		vl_copartic_csp_w 
	from	w_sip_item_despesa 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p 
	and	substr(cd_estrutura,1,qt_caracteres_w)	= cd_estrutura_w 
	and	ie_tipo_item_despesa	= 'CSP';
	 
	select	coalesce(sum(vl_total_despesa),0), 
		coalesce(sum(vl_participacao),0) 
	into STRICT	vl_sip_ccp_w, 
		vl_copartic_ccp_w 
	from	w_sip_item_despesa 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p 
	and	substr(cd_estrutura,1,qt_caracteres_w)	= cd_estrutura_w 
	and	ie_tipo_item_despesa	= 'CCP';
	 
	vl_total_sip_w		:= vl_sip_if_w + vl_sip_csp_w + vl_sip_ccp_w;
	vl_coparticipacao_w	:= vl_copartic_if_w + vl_copartic_csp_w + vl_copartic_ccp_w;
	 
	vl_sip_diops_w	:= vl_total_sip_w - vl_diops_w - vl_coparticipacao_w;
	 
	select	coalesce(sum(vl_eventos),0), 
		coalesce(sum(vl_recuperacao),0), 
		coalesce(sum(vl_glosa),0) 
	into STRICT	vl_eventos_w, 
		vl_recuperacao_w, 
		vl_glosa_w 
	from	w_sip_item_despesa 
	where	nr_seq_lote_sip	= nr_seq_lote_sip_p 
	and	substr(cd_estrutura,1,qt_caracteres_w)	= cd_estrutura_w;
	 
	insert into pls_despesa_sip_diops(nr_sequencia, cd_estrutura, dt_atualizacao, 
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
		vl_sip_if, vl_sip_csp, vl_sip_ccp, 
		vl_sip, vl_diops, vl_sip_diops, 
		nr_seq_lote_sip, vl_eventos, vl_recuperacao, 
		vl_glosa, vl_coparticipacao) 
	values (	nextval('pls_despesa_sip_diops_seq'), cd_estrutura_w, clock_timestamp(), 
		nm_usuario_p, clock_timestamp(), nm_usuario_p, 
		vl_sip_if_w, vl_sip_csp_w, vl_sip_ccp_w, 
		vl_total_sip_w, vl_diops_w, vl_sip_diops_w, 
		nr_seq_lote_sip_p, vl_eventos_w, vl_recuperacao_w, 
		vl_glosa_w, vl_coparticipacao_w);
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_valida_anexo_ii ( nr_seq_lote_sip_p bigint, nm_usuario_p text) FROM PUBLIC;

