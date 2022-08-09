-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_gerar_resumo_conta ( nr_seq_item_p bigint, ie_tipo_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* IE_TIPO_ITEM_P
	1 - Procedimento contas médicas
	2 - Material contas médicas
*/
nr_seq_segurado_w		bigint;
ie_tipo_beneficiario_w		varchar(3);
ie_tipo_plano_w			varchar(3);
ie_tipo_segurado_w		varchar(3);
ie_tipo_item_w			varchar(1);
cd_item_w			bigint;
ie_origem_proced_w		smallint;
qt_item_w			double precision;
vl_despesa_w			double precision;
vl_glosa_w			double precision;
cd_estabelecimento_w		smallint;
nr_sequencia_w			bigint;
dt_item_w			timestamp;
nr_seq_protocolo_w		bigint;
ie_tipo_conta_w			varchar(1);
nr_seq_conta_w			bigint;
cd_estrutura_sip_w		varchar(10);
ie_tipo_guia_w			varchar(2);
nr_seq_tipo_atendimento_w	bigint;
cd_medico_executor_w		varchar(10);
ie_regime_internacao_w		varchar(1);
nr_seq_conselho_w		bigint;
nr_seq_prestador_exec_w		bigint;
nr_seq_grupo_ans_w		bigint;
ie_tipo_desp_mat_w		varchar(2)	:= '';


BEGIN

if (ie_tipo_item_p	= 1) then
	ie_tipo_conta_w		:= 'C';

	select	a.cd_procedimento,
		a.ie_origem_proced,
		coalesce(a.qt_procedimento,0),
		coalesce(a.vl_liberado,0) vl_despesa,
		coalesce(a.vl_glosa,0) vl_glosa,
		b.nr_seq_segurado,
		b.ie_tipo_beneficiario,
		b.ie_tipo_plano,
		b.ie_tipo_segurado,
		b.cd_estabelecimento,
		b.nr_seq_protocolo,
		b.nr_sequencia,
		b.ie_tipo_guia,
		b.nr_seq_tipo_atendimento,
		b.cd_medico_executor,
		b.ie_regime_internacao,
		b.nr_seq_prestador_exec
	into STRICT	cd_item_w,
		ie_origem_proced_w,
		qt_item_w,
		vl_despesa_w,
		vl_glosa_w,
		nr_seq_segurado_w,
		ie_tipo_beneficiario_w,
		ie_tipo_plano_w,
		ie_tipo_segurado_w,
		cd_estabelecimento_w,
		nr_seq_protocolo_w,
		nr_seq_conta_w,
		ie_tipo_guia_w,
		nr_seq_tipo_atendimento_w,
		cd_medico_executor_w,
		ie_regime_internacao_w,
		nr_seq_prestador_exec_w
	from	pls_conta	b,
		pls_conta_proc	a
	where	a.nr_sequencia	= nr_seq_item_p
	and	a.nr_seq_conta	= b.nr_sequencia;

	select	dt_mes_competencia
	into STRICT	dt_item_w
	from	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_w;
elsif (ie_tipo_item_p	= 2) then
	ie_tipo_conta_w	:= 'C';

	select	a.nr_seq_material,
		null,
		coalesce(a.qt_material,0),
		coalesce(a.vl_liberado,0) vl_despesa,
		coalesce(a.vl_glosa,0) vl_glosa,
		b.nr_seq_segurado,
		b.ie_tipo_beneficiario,
		b.ie_tipo_plano,
		b.ie_tipo_segurado,
		b.cd_estabelecimento,
		b.nr_seq_protocolo,
		b.nr_sequencia,
		b.ie_tipo_guia,
		b.nr_seq_tipo_atendimento,
		b.cd_medico_executor,
		b.ie_regime_internacao,
		b.nr_seq_prestador_exec,
		a.ie_tipo_despesa
	into STRICT	cd_item_w,
		ie_origem_proced_w,
		qt_item_w,
		vl_despesa_w,
		vl_glosa_w,
		nr_seq_segurado_w,
		ie_tipo_beneficiario_w,
		ie_tipo_plano_w,
		ie_tipo_segurado_w,
		cd_estabelecimento_w,
		nr_seq_protocolo_w,
		nr_seq_conta_w,
		ie_tipo_guia_w,
		nr_seq_tipo_atendimento_w,
		cd_medico_executor_w,
		ie_regime_internacao_w,
		nr_seq_prestador_exec_w,
		ie_tipo_desp_mat_w
	from	pls_conta	b,
		pls_conta_mat	a
	where	a.nr_sequencia	= nr_seq_item_p
	and	a.nr_seq_conta	= b.nr_sequencia;

	select	dt_mes_competencia
	into STRICT	dt_item_w
	from	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_w;
end if;

select	max(nr_seq_conselho)
into STRICT	nr_seq_conselho_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_medico_executor_w;

select	pls_obter_grupo_ans(cd_item_w, ie_origem_proced_w, nr_seq_conselho_w,
			nr_seq_tipo_atendimento_w, ie_tipo_guia_w, ie_regime_internacao_w,
			ie_tipo_desp_mat_w, 'G', cd_estabelecimento_w,
			nr_seq_conta_w)
into STRICT	nr_seq_grupo_ans_w
;

if (nr_seq_grupo_ans_w	> 0) then
	select	coalesce(max(b.cd_estrutura),'')
	into STRICT	cd_estrutura_sip_w
	from	sip_estrutura_proc	b,
		sip_evento_regra	a
	where	a.nr_seq_sip_estrut_proc	= b.nr_sequencia
	and	a.nr_seq_grupo_ans		= nr_seq_grupo_ans_w;
end if;

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_sequencia_w
from	sip_resumo_conta
where	nr_seq_conta	= nr_seq_conta_w
and	ie_tipo_conta	= ie_tipo_conta_w;

insert into sip_resumo_conta(nr_seq_conta, nr_sequencia, ie_tipo_conta,
	cd_item, cd_estabelecimento, qt_item,
	vl_despesa, vl_glosa, dt_item,
	ie_tipo_segurado, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, ie_tipo_beneficiario,
	ie_tipo_plano, ie_origem_proced, cd_estrutura_sip,
	nr_seq_item, ie_tipo_item, nr_seq_grupo_ans)
values (	nr_seq_conta_w, nr_sequencia_w, ie_tipo_conta_w,
	cd_item_w, cd_estabelecimento_w, qt_item_w,
	vl_despesa_w, vl_glosa_w, dt_item_w,
	ie_tipo_segurado_w, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, ie_tipo_beneficiario_w,
	ie_tipo_plano_w, ie_origem_proced_w, cd_estrutura_sip_w,
	nr_seq_item_p, ie_tipo_item_p, nr_seq_grupo_ans_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_gerar_resumo_conta ( nr_seq_item_p bigint, ie_tipo_item_p bigint, nm_usuario_p text) FROM PUBLIC;
