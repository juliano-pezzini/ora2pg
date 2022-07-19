-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_perf_copartic () AS $body$
DECLARE


ie_ato_cooperado_w		pls_conta_proc.ie_ato_cooperado%type;
nr_seq_prestador_atend_w	pls_prestador.nr_sequencia%type;
nr_seq_prestador_exec_w		pls_prestador.nr_sequencia%type;
ie_tipo_prestador_atend_w	varchar(2);
ie_tipo_prestador_exec_w	varchar(2);
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
dt_mes_competencia_w		pls_protocolo_conta.dt_mes_competencia%type;
ie_tipo_segurado_w		pls_segurado.ie_tipo_segurado%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_conta_copartic_w		pls_conta_coparticipacao.nr_sequencia%type;
ie_tipo_protocolo_w		pls_protocolo_conta.ie_tipo_protocolo%type;
vl_coparticipacao_w		pls_conta_coparticipacao.vl_coparticipacao%type;
vl_ato_cooperado_w		pls_conta_coparticipacao.vl_coparticipacao%type;
vl_ato_auxiliar_w		pls_conta_coparticipacao.vl_coparticipacao%type;
vl_ato_nao_cooperado_w		pls_conta_coparticipacao.vl_coparticipacao%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
ie_preco_w			pls_plano.ie_preco%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.ie_ato_cooperado,
		d.nr_seq_prestador,
		c.nr_seq_prestador_exec,
		c.ie_tipo_guia,
		d.dt_mes_competencia,
		c.nr_seq_segurado,
		d.ie_tipo_protocolo,
		a.vl_coparticipacao,
		d.nr_sequencia,
		c.nr_seq_plano
	from	pls_conta_coparticipacao a,
		pls_conta_proc b,
		pls_conta c,
		pls_protocolo_conta d
	where	a.nr_seq_conta_proc = b.nr_sequencia
	and	b.nr_seq_conta = c.nr_sequencia
	and	c.nr_seq_protocolo = d.nr_sequencia
	
union all

	SELECT	a.nr_sequencia,
		b.ie_ato_cooperado,
		d.nr_seq_prestador,
		c.nr_seq_prestador_exec,
		c.ie_tipo_guia,
		d.dt_mes_competencia,
		c.nr_seq_segurado,
		d.ie_tipo_protocolo,
		a.vl_coparticipacao,
		d.nr_sequencia,
		c.nr_seq_plano
	from	pls_conta_coparticipacao a,
		pls_conta_mat b,
		pls_conta c,
		pls_protocolo_conta d
	where	a.nr_seq_conta_mat = b.nr_sequencia
	and	b.nr_seq_conta = c.nr_sequencia
	and	c.nr_seq_protocolo = d.nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_conta_copartic_w,
	ie_ato_cooperado_w,
	nr_seq_prestador_atend_w,
	nr_seq_prestador_exec_w,
	ie_tipo_guia_w,
	dt_mes_competencia_w,
	nr_seq_segurado_w,
	ie_tipo_protocolo_w,
	vl_coparticipacao_w,
	nr_seq_protocolo_w,
	nr_seq_plano_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	vl_ato_cooperado_w	:= 0;
	vl_ato_auxiliar_w	:= 0;
	vl_ato_nao_cooperado_w	:= 0;

	if (ie_ato_cooperado_w = 1) then
		vl_ato_cooperado_w	:= vl_coparticipacao_w;
	elsif (ie_ato_cooperado_w = 2) then
		vl_ato_auxiliar_w	:= vl_coparticipacao_w;
	elsif (ie_ato_cooperado_w = 3) then
		vl_ato_nao_cooperado_w	:= vl_coparticipacao_w;
	end if;

	begin
	select	CASE WHEN coalesce(cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END
	into STRICT	ie_tipo_prestador_atend_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_atend_w;
	exception
	when others then
		ie_tipo_prestador_atend_w	:= null;
	end;

	begin
	select	CASE WHEN coalesce(cd_cgc::text, '') = '' THEN 'PF'  ELSE 'PJ' END
	into STRICT	ie_tipo_prestador_exec_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_exec_w;
	exception
	when others then
		ie_tipo_prestador_exec_w	:= null;
	end;

	select	max(ie_tipo_segurado),
		coalesce(nr_seq_plano_w,max(nr_seq_plano))
	into STRICT	ie_tipo_segurado_w,
		nr_seq_plano_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;

	select	max(ie_preco)
	into STRICT	ie_preco_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_plano_w;

	update	pls_conta_coparticipacao
	set	ie_ato_cooperado	= ie_ato_cooperado_w,
		nr_seq_prestador_atend	= nr_seq_prestador_atend_w,
		nr_seq_prestador_exec	= nr_seq_prestador_exec_w,
		ie_tipo_prestador_atend	= ie_tipo_prestador_atend_w,
		ie_tipo_prestador_exec	= ie_tipo_prestador_exec_w,
		ie_tipo_guia		= ie_tipo_guia_w,
		dt_mes_competencia	= dt_mes_competencia_w,
		ie_tipo_segurado	= ie_tipo_segurado_w,
		ie_tipo_protocolo	= ie_tipo_protocolo_w,
		nr_seq_segurado		= nr_seq_segurado_w,
		vl_ato_cooperado	= vl_ato_cooperado_w,
		vl_ato_auxiliar		= vl_ato_auxiliar_w,
		vl_ato_nao_cooperado	= vl_ato_nao_cooperado_w,
		nr_seq_protocolo	= nr_seq_protocolo_w,
		ie_preco		= ie_preco_w
	where	nr_sequencia		= nr_seq_conta_copartic_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_perf_copartic () FROM PUBLIC;

