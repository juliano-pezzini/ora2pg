-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_apagar_glosa_oc_analise ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, cd_motivo_tiss_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE


nr_seq_glosa_w			bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_analise_conta_item_w	bigint;
cd_motivo_tiss_w		varchar(10);



BEGIN
select	max(a.nr_sequencia)
into STRICT	nr_seq_glosa_w
from	pls_conta_glosa a,
	tiss_motivo_glosa b
where	a.nr_seq_motivo_glosa	= b.nr_sequencia
and	((a.nr_seq_conta_proc 	= nr_seq_conta_proc_p) or (a.nr_seq_conta_mat 	= nr_seq_conta_mat_p))
and	b.cd_motivo_tiss 	= cd_motivo_tiss_p
and	coalesce(a.nr_seq_ocorrencia_benef,0) = 0;

select	max(nr_sequencia)
into STRICT	nr_seq_ocorrencia_w
from	pls_ocorrencia_benef a
where	nr_seq_glosa = nr_seq_glosa_w;

select	max(nr_sequencia)
into STRICT	nr_seq_analise_conta_item_w
from	pls_analise_conta_item
where	nr_seq_glosa_oc = nr_seq_ocorrencia_w
and	ie_tipo		= 'O';

delete	FROM pls_analise_parecer_item
where	nr_seq_item	= nr_seq_analise_conta_item_w;

delete	FROM pls_analise_conta_item
where	nr_sequencia	= nr_seq_analise_conta_item_w;

delete	FROM pls_ocorrencia_benef
where	nr_sequencia = nr_seq_ocorrencia_w;

select	max(nr_sequencia)
into STRICT	nr_seq_ocorrencia_w
from	pls_ocorrencia_benef a
where	nr_seq_glosa = nr_seq_glosa_w;

select	max(nr_sequencia)
into STRICT	nr_seq_analise_conta_item_w
from	pls_analise_conta_item
where	nr_seq_glosa_oc = nr_seq_glosa_w
and	ie_tipo		= 'G';

delete	FROM pls_analise_parecer_item
where	nr_seq_item	= nr_seq_analise_conta_item_w;

delete	FROM pls_analise_conta_item
where	nr_sequencia	= nr_seq_analise_conta_item_w;

delete	FROM pls_conta_glosa
where	nr_sequencia = nr_seq_glosa_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_apagar_glosa_oc_analise ( nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, cd_motivo_tiss_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;
