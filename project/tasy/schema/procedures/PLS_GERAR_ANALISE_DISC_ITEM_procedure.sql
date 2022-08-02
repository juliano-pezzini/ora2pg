-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_analise_disc_item ( nr_seq_discussao_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_observacao_w		varchar(4000);
cd_codigo_w		varchar(15);
ie_pre_analise_w	varchar(2);
ie_auditoria_w		varchar(2);
ie_tipo_w		varchar(1);
ie_status_w		varchar(1);
ie_tipo_motivo_w	varchar(1) := 'P';
ie_existe_grupo_glosa_w varchar(1);
vl_glosa_w		double precision;
nr_seq_conta_w		bigint;
nr_seq_conta_mat_w	bigint;
nr_seq_conta_proc_w	bigint;
nr_seq_glosa_oc_w	bigint;
nr_seq_motivo_padrao_w	bigint;
nr_seq_item_w		bigint;
nr_seq_conta_item_w	bigint;
nr_seq_glosa_ref_w	bigint;
qt_glosa_w		bigint;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		null,
		b.nr_seq_conta
	from	pls_discussao_proc	a,
		pls_conta_proc		b
	where	a.nr_seq_conta_proc	= b.nr_sequencia
	and	a.nr_seq_discussao	= nr_seq_discussao_p
	
union

	SELECT	null,
		b.nr_sequencia,
		b.nr_seq_conta
	from	pls_discussao_mat	a,
		pls_conta_mat		b
	where	a.nr_seq_conta_mat	= b.nr_sequencia
	and	a.nr_seq_discussao	= nr_seq_discussao_p;

C02 CURSOR FOR
	SELECT	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'C'),1,10) cd_codigo,
		substr(ds_observacao,1,255) ds_observacao,
		'G' ie_tipo,
		a.nr_seq_conta 		nr_seq_conta,
		a.nr_seq_conta_mat	nr_seq_mat,
		a.nr_seq_conta_proc	nr_seq_proc,
		a.nr_sequencia,
		a.qt_glosa,
		a.vl_glosa
	from	pls_conta_glosa	a
	where (nr_seq_conta_mat 	= nr_seq_conta_mat_w)
	or (nr_seq_conta_proc 	= nr_seq_conta_proc_w)
	and	coalesce(nr_seq_ocorrencia_benef,0) = 0 -- Diego 28/04/2011 - Só ira gerar glosas na análise se estas não foram GERADAS POR OCORRÊNCIAS ou geram ocorrências ou sejam Não possuem representante em ocorrências
	and	not exists (SELECT	x.nr_sequencia
				from	pls_ocorrencia_benef x
				where	x.nr_seq_glosa = a.nr_sequencia); -- Diego 28/04/2011 - Só ira gerar glosas na análise se estas não foram geradas por ocorrências ou GERARAM OCORRÊNCIAS ou sejam Não possuem representante em ocorrências
C03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_analise_conta_item
	where	nr_seq_discussao	= nr_seq_discussao_p;


BEGIN
open C03;
loop
fetch C03 into
	nr_seq_conta_item_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	delete	FROM pls_analise_parecer_item
	where	nr_seq_item	= nr_seq_conta_item_w;

	/* Diego OS 292007
	     Apagar os itens da analise para garatir que não fiquem glosas e ocorrencias de uma análise prévia desta conta.*/
	delete	FROM pls_analise_conta_item
	where	nr_sequencia = nr_seq_conta_item_w;
	end;
end loop;
close C03;

/*Inserir glosas e ocorrencias  dos procs e mats*/

open C01;
loop
fetch C01 into
	nr_seq_conta_proc_w,
	nr_seq_conta_mat_w,
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		cd_codigo_w,
		ds_observacao_w,
		ie_tipo_w,
		nr_seq_conta_w,
		nr_seq_conta_mat_w,
		nr_seq_conta_proc_w,
		nr_seq_glosa_oc_w,
		qt_glosa_w,
		vl_glosa_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(nr_seq_conta_w::text, '') = '') then
			if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '') then
				select	a.nr_seq_conta
				into STRICT	nr_seq_conta_w
				from	pls_conta_proc a
				where	a.nr_sequencia	= nr_seq_conta_proc_w;
			elsif (nr_seq_conta_mat_w IS NOT NULL AND nr_seq_conta_mat_w::text <> '') then
				select	a.nr_seq_conta
				into STRICT	nr_seq_conta_w
				from	pls_conta_mat a
				where	a.nr_sequencia	= nr_seq_conta_mat_w;
			end if;
		end if;

		select  nextval('pls_analise_conta_item_seq')
		into STRICT	nr_seq_item_w
		;

		insert into pls_analise_conta_item(cd_codigo, ds_obs_glosa_oc, dt_atualizacao,
			 dt_atualizacao_nrec, ie_situacao, ie_status,
			 ie_tipo, nm_usuario, nm_usuario_nrec,
			 nr_seq_analise, nr_seq_conta, nr_seq_conta_mat,
			 nr_seq_conta_proc, nr_seq_glosa_oc, nr_sequencia,
			 qt_glosa, vl_glosa, ie_fechar_conta, nr_seq_discussao)
		values (cd_codigo_w, ds_observacao_w, clock_timestamp(),
			 clock_timestamp(), 'A', ie_tipo_motivo_w,
			 ie_tipo_w, nm_usuario_p, nm_usuario_p,
			 nr_seq_analise_p, nr_seq_conta_w, nr_seq_conta_mat_w,
			 nr_seq_conta_proc_w, nr_seq_glosa_oc_w, nr_seq_item_w,
			 qt_glosa_w, vl_glosa_w, pls_obter_glos_oco_permite(cd_codigo_w, ie_tipo_w), nr_seq_discussao_p);
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_analise_disc_item ( nr_seq_discussao_p bigint, nr_seq_analise_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

