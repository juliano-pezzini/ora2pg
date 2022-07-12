-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_cont_proc_mat ( nr_seq_contest_proc_p bigint, nr_seq_contest_mat_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);

/*
CDT - Código motivo TISS
DST - Descrição motivo TISS
CDP - Código motivo PTU
DSP - Descrição motivo PTU
OBS - Observação item glosa
*/
BEGIN
if (ie_opcao_p = 'CDT') then
	if (nr_seq_contest_proc_p IS NOT NULL AND nr_seq_contest_proc_p::text <> '') then
		select	substr(tiss_obter_motivo_glosa(max(a.nr_seq_motivo_glosa),'C'),1,255) cd_motivo_tiss
		into STRICT	ds_retorno_w
		from	pls_contest_item_glosa a
		where	nr_seq_contest_proc = nr_seq_contest_proc_p;
	elsif (nr_seq_contest_mat_p IS NOT NULL AND nr_seq_contest_mat_p::text <> '') then
		select	substr(tiss_obter_motivo_glosa(max(a.nr_seq_motivo_glosa),'C'),1,255) cd_motivo_tiss
		into STRICT	ds_retorno_w
		from	pls_contest_item_glosa a
		where	nr_seq_contest_mat = nr_seq_contest_mat_p;
	end if;
elsif (ie_opcao_p = 'DST') then
	if (nr_seq_contest_proc_p IS NOT NULL AND nr_seq_contest_proc_p::text <> '') then
		select	substr(tiss_obter_motivo_glosa(max(a.nr_seq_motivo_glosa),'D'),1,255) ds_motivo_tiss
		into STRICT	ds_retorno_w
		from	pls_contest_item_glosa a
		where	nr_seq_contest_proc = nr_seq_contest_proc_p;
	elsif (nr_seq_contest_mat_p IS NOT NULL AND nr_seq_contest_mat_p::text <> '') then
		select	substr(tiss_obter_motivo_glosa(max(a.nr_seq_motivo_glosa),'D'),1,255) ds_motivo_tiss
		into STRICT	ds_retorno_w
		from	pls_contest_item_glosa a
		where	nr_seq_contest_mat = nr_seq_contest_mat_p;
	end if;
elsif (ie_opcao_p = 'CDP') then
	if (nr_seq_contest_proc_p IS NOT NULL AND nr_seq_contest_proc_p::text <> '') then
		select	max(a.cd_motivo) cd_ptu
		into STRICT	ds_retorno_w
		from	ptu_motivo_questionamento a,
			pls_contest_item_glosa  b
		where	a.nr_sequencia = b.nr_seq_mot_quest
		and	b.nr_seq_contest_proc = nr_seq_contest_proc_p;
	elsif (nr_seq_contest_mat_p IS NOT NULL AND nr_seq_contest_mat_p::text <> '') then
		select	max(a.cd_motivo) cd_ptu
		into STRICT	ds_retorno_w
		from	ptu_motivo_questionamento a,
			pls_contest_item_glosa  b
		where	a.nr_sequencia = b.nr_seq_mot_quest
		and	b.nr_seq_contest_mat = nr_seq_contest_mat_p;
	end if;
elsif (ie_opcao_p = 'DSP') then
	if (nr_seq_contest_proc_p IS NOT NULL AND nr_seq_contest_proc_p::text <> '') then
		select	max(a.ds_motivo) ds_ptu
		into STRICT	ds_retorno_w
		from	ptu_motivo_questionamento a,
			pls_contest_item_glosa  b
		where	a.nr_sequencia = b.nr_seq_mot_quest
		and	b.nr_seq_contest_proc = nr_seq_contest_proc_p;
	elsif (nr_seq_contest_mat_p IS NOT NULL AND nr_seq_contest_mat_p::text <> '') then
		select	max(a.ds_motivo) ds_ptu
		into STRICT	ds_retorno_w
		from	ptu_motivo_questionamento a,
			pls_contest_item_glosa  b
		where	a.nr_sequencia = b.nr_seq_mot_quest
		and	b.nr_seq_contest_mat = nr_seq_contest_mat_p;
	end if;
elsif (ie_opcao_p = 'OBS') then
	if (nr_seq_contest_proc_p IS NOT NULL AND nr_seq_contest_proc_p::text <> '') then
		select	max(a.ds_observacao)
		into STRICT	ds_retorno_w
		from	pls_contest_item_glosa a
		where	nr_seq_contest_proc = nr_seq_contest_proc_p;
	elsif (nr_seq_contest_mat_p IS NOT NULL AND nr_seq_contest_mat_p::text <> '') then
		select	max(a.ds_observacao)
		into STRICT	ds_retorno_w
		from	pls_contest_item_glosa a
		where	nr_seq_contest_mat = nr_seq_contest_mat_p;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_cont_proc_mat ( nr_seq_contest_proc_p bigint, nr_seq_contest_mat_p bigint, ie_opcao_p text) FROM PUBLIC;
