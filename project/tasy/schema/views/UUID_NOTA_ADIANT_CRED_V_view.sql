-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW uuid_nota_adiant_cred_v (uuid, seq, seqorigem) AS select	b.nr_nfe_imp	uuid,
        a.nr_seq_nota	seq,
	b.nr_sequencia seqOrigem
FROM	nota_fiscal_adiant_receb a,
	nota_fiscal b
where	a.nr_seq_adiantamento = b.nr_seq_adiantamento
and     a.nr_seq_adiantamento is not null
and     b.nr_nfe_imp is not null

union

select	b.nr_nfe_imp	uuid,
        a.nr_sequencia 	seq,
	b.nr_sequencia seqOrigem
from	nota_fiscal a,
	nota_fiscal b
where	a.nr_sequencia_ref is not null
and	b.nr_sequencia = a.nr_sequencia_ref
and     b.nr_nfe_imp is not null

union

select	o.nr_nfe_imp	uuid,
        n.nr_sequencia	seq,
	o.nr_sequencia 	seqOrigem
from	nota_fiscal o,
	nota_fiscal n,
	conta_paciente_adiant b
where	n.nr_interno_conta	= b.nr_interno_conta
and	b.nr_adiantamento 	= o.nr_seq_adiantamento
and	o.ie_situacao = 1
and	o.nr_nfe_imp is not null

union

select	n.nr_nfe_imp	uuid,
	c.nr_seq_nf_gerada	seq,
	n.nr_sequencia seqOrigem
from	nf_credito c,
	nota_fiscal o,
	nota_fiscal n,
	conta_paciente_adiant b
where	c.nr_seq_nf_orig	= n.nr_sequencia
and	n.nr_interno_conta	= b.nr_interno_conta
and	b.nr_adiantamento	= o.nr_seq_adiantamento
and	o.ie_situacao = 1
and	o.nr_nfe_imp is not null;

