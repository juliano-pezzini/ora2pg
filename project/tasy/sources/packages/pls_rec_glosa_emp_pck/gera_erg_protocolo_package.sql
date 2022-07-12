-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.gera_erg_protocolo ( nr_seq_erg_lote_p pls_erg_recurso.nr_sequencia%type, nr_protocolo_p pls_grg_protocolo.nr_protocolo%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera os protocolo do lote de envio de recurso de glosa.
	
	
	So deve gera o protocolo quando o tipo de recurso de glosa for somente protocolo.
	E deve-se ser gerado apenas 1 protocolo por lote de dados, conforme schema TISS
	
	Devido a esta caracteristica do schema TISS, o sequencial do protocolo que servira
	como base para gerar os dados e informado via parametro nesta rotina, portanto em teoria
	deveria vir somente protocolos que tem valor a ser recursado. Mas por garantia e feito
	uma validacao antes de gerar o mesmo
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


nr_sequencia_w		pls_erg_protocolo.nr_sequencia%type;
nr_seq_erg_cabecalho_w	pls_erg_cabecalho.nr_sequencia%type;
cd_glosa_w		pls_erg_protocolo.cd_glosa%type;
ds_justificativa_w	pls_erg_protocolo.ds_justificativa%type;
vl_recursado_w		pls_grg_guia_proc.vl_recursado%type;


BEGIN

-- No modelo TISS atual, so pode-se recursar um protocolo por vez

-- Ainda faz uma verificacao de seguranca, para gerar apenas protocolos que realmente tenham valor a ser recursado

select	sum(vl_recursado)
into STRICT	vl_recursado_w
from (	SELECT	sum(a.vl_recursado) vl_recursado
	from	pls_grg_guia_proc	a,
		pls_grg_guia		b,
		pls_grg_protocolo	c,
		pls_grg_lote		d,
		pls_erg_recurso		e
	where	a.nr_seq_grg_guia	= b.nr_sequencia
	and	c.nr_sequencia		= b.nr_seq_grg_protocolo
	and	d.nr_sequencia		= c.nr_seq_grg_lote
	and	e.nr_seq_grg_lote	= d.nr_sequencia
	and	c.nr_protocolo		= nr_protocolo_p
	and	e.nr_sequencia		= nr_seq_erg_lote_p
	
union all

	SELECT	sum(a.vl_recursado) vl_recursado
	from	pls_grg_guia_mat	a,
		pls_grg_guia		b,
		pls_grg_protocolo	c,
		pls_grg_lote		d,
		pls_erg_recurso		e
	where	a.nr_seq_grg_guia	= b.nr_sequencia
	and	c.nr_sequencia		= b.nr_seq_grg_protocolo
	and	d.nr_sequencia		= c.nr_seq_grg_lote
	and	e.nr_seq_grg_lote	= d.nr_sequencia
	and	c.nr_protocolo		= nr_protocolo_p
	and	e.nr_sequencia		= nr_seq_erg_lote_p) alias3;

if (coalesce(vl_recursado_w, 0) > 0 ) then

	-- carrega os dados do protocolo em questao

	select	nextval('pls_erg_protocolo_seq') nr_sequencia,
		t.nr_seq_erg_cabecalho,
		t.cd_glosa,
		t.ds_justificativa
	into STRICT	nr_sequencia_w,
		nr_seq_erg_cabecalho_w,
		cd_glosa_w,
		ds_justificativa_w

	from (	SELECT	max(b.nr_sequencia) nr_seq_erg_cabecalho,
			max(substr(tiss_obter_dados_motivo_glosa(f.nr_seq_motivo_glosa,'C'),1,255)) cd_glosa,
			max(f.ds_justificativa) ds_justificativa
		from	pls_erg_recurso		a,
			pls_erg_cabecalho	b,
			pls_grg_lote		c,
			pls_grg_protocolo	d,
			pls_grg_protocolo_glosa	f
		where	b.nr_seq_erg_recurso	= a.nr_sequencia
		and	c.nr_sequencia		= a.nr_seq_grg_lote
		and	d.nr_seq_grg_lote	= c.nr_sequencia
		and	f.nr_seq_grg_protocolo	= d.nr_sequencia
		and	a.nr_sequencia		= nr_seq_erg_lote_p
		and	d.nr_protocolo		= nr_protocolo_p
		-- busca o protocolo mais recente para o nr_procotocolo do lote

		and	d.nr_sequencia		= (	select	max(x.nr_sequencia) nr_seq_protocolo
							from	pls_grg_protocolo	x
							where	x.nr_sequencia		= d.nr_sequencia)
		-- Busca a glosa mais recente para o protocolo em questao

		and	f.nr_sequencia		= (	select	max(x.nr_sequencia) nr_seq_grg_prot_glosa
							from	pls_grg_protocolo_glosa	x,
								pls_grg_protocolo	y
							where	y.nr_sequencia		= x.nr_seq_grg_protocolo
							and	(x.ds_justificativa IS NOT NULL AND x.ds_justificativa::text <> '')
							and	y.nr_sequencia		= d.nr_sequencia) ) t;


	CALL pls_rec_glosa_emp_pck.grava_erg_protocolo(	nr_sequencia_w,
				nr_seq_erg_cabecalho_w,
				cd_glosa_w,
				ds_justificativa_w,
				nm_usuario_p,
				'N');
				
end if;


if (coalesce(ie_commit_p, 'S') = 'S') then

	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.gera_erg_protocolo ( nr_seq_erg_lote_p pls_erg_recurso.nr_sequencia%type, nr_protocolo_p pls_grg_protocolo.nr_protocolo%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
