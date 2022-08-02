-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplica_glosa_aut ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_lote_cta_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

--rotina irá aplicar a glosa automática sobre os itens que já não estejam glosados e possuam vinculadas ao mesmo alguma ocorrência que esteja assinalada com o glosa automática
nr_seq_mot_liberacao_glosa_w	pls_param_analise_conta.nr_seq_mot_liberacao_glosa%type;

C01 CURSOR(	nr_seq_analise_pc		pls_analise_conta.nr_sequencia%type,
		nr_seq_lote_cta_pc		pls_lote_protocolo_conta.nr_sequencia%type)FOR
	SELECT	c.nr_sequencia		nr_seq_conta,
		ob.nr_seq_conta_proc 	nr_seq_conta_proc,
		ob.nr_seq_conta_mat	nr_seq_conta_mat,
		c.nr_seq_analise nr_seq_analise,
		ob.nr_seq_proc_partic,
		b.nr_seq_grupo
	from	pls_ocorrencia_benef		ob,
		pls_ocorrencia			o,
		pls_conta_v			c,
		pls_analise_glo_ocor_grupo	b
	where	c.nr_sequencia		= ob.nr_seq_conta
	and	ob.nr_seq_ocorrencia	= o.nr_sequencia
	and	c.nr_seq_analise	= nr_seq_analise_pc
	and	o.ie_glosa_automatica	= 'S'
	and	ob.ie_situacao		= 'A'
	and	(o.nr_seq_motivo_glosa IS NOT NULL AND o.nr_seq_motivo_glosa::text <> '')
	and	b.nr_seq_ocor_benef	= ob.nr_sequencia
	and	((coalesce(b.ie_status::text, '') = '') or (b.ie_status != 'G'))
	
union all

	SELECT	c.nr_sequencia		nr_seq_conta,
		ob.nr_seq_conta_proc 	nr_seq_conta_proc,
		ob.nr_seq_conta_mat	nr_seq_conta_mat,
		c.nr_seq_analise nr_seq_analise,
		ob.nr_seq_proc_partic,
		b.nr_seq_grupo
	from	pls_ocorrencia_benef		ob,
		pls_ocorrencia			o,
		pls_conta_v			c,
		pls_analise_glo_ocor_grupo	b
	where	c.nr_sequencia		= ob.nr_seq_conta
	and	ob.nr_seq_ocorrencia	= o.nr_sequencia
	and	c.nr_seq_lote_conta	= nr_seq_lote_cta_pc
	and	o.ie_glosa_automatica	= 'S'
	and	ob.ie_situacao		= 'A'
	and	(o.nr_seq_motivo_glosa IS NOT NULL AND o.nr_seq_motivo_glosa::text <> '')
	and	b.nr_seq_ocor_benef	= ob.nr_sequencia
	and	((coalesce(b.ie_status::text, '') = '') or (b.ie_status != 'G'));
BEGIN

select	max(nr_seq_mot_liberacao_glosa)
into STRICT	nr_seq_mot_liberacao_glosa_w
from	pls_param_analise_conta a
where	a.cd_estabelecimento	= cd_estabelecimento_p;

for r_c01_w in C01(nr_seq_analise_p, nr_seq_lote_cta_p) loop
	begin
	CALL pls_analise_glosar_item(	r_c01_w.nr_seq_analise, r_c01_w.nr_seq_conta, r_c01_w.nr_seq_conta_proc,
					r_c01_w.nr_seq_conta_mat, r_c01_w.nr_seq_proc_partic, null,
					nr_seq_mot_liberacao_glosa_w, null, cd_estabelecimento_p,
					r_c01_w.nr_seq_grupo, 'N', 'N',
					'S', 'N', nm_usuario_p,
					null,'S','S');
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplica_glosa_aut ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_lote_cta_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

