-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ocor_glosa_aud_limi ( nr_seq_auditoria_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Insere a glosa ou ocorrência na tabela da análise, quando se utiliza nível de liberação para os auditores.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_requisicao_w		bigint;
nr_seq_proc_origem_w		bigint;
nr_seq_mat_origem_w		bigint;
nr_seq_proc_w 			bigint := 0;
nr_seq_mat_w			bigint := 0;
nr_seq_glosa_w			bigint;
nr_seq_aud_item_w		bigint;
nr_seq_ocorr_benef_w		bigint;
ie_tipo_w			varchar(10);
nr_nivel_liberacao_w		smallint;
nr_seq_ocorrencia_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_proc_origem,
		nr_seq_mat_origem
	from	pls_auditoria_item
	where	nr_seq_auditoria = nr_seq_auditoria_p
	order by nr_sequencia;

C02 CURSOR FOR
	SELECT	ie_tipo,
		nr_seq_glosa,
		nr_seq_ocorr_benef,
		nr_nivel_liberacao,
		nr_seq_ocorrencia
	from (SELECT	'O' ie_tipo,
			null nr_seq_glosa,
			nr_sequencia nr_seq_ocorr_benef,
			null nr_ocorrencia,
			nr_seq_requisicao,
			nr_seq_proc nr_seq_proc,
			nr_seq_mat nr_seq_mat,
			nr_nivel_liberacao,
			nr_seq_ocorrencia,
			nr_seq_regra
		from	pls_ocorrencia_benef
		where	coalesce(nr_seq_conta::text, '') = ''
		and	coalesce(nr_seq_guia_plano::text, '') = ''
		and	coalesce(nr_seq_execucao::text, '') = '') alias3
	where	nr_seq_regra		= nr_seq_regra_p
	and	nr_seq_requisicao	= nr_seq_requisicao_p
	and	coalesce(nr_ocorrencia::text, '') = ''
	
union

	select	ie_tipo,
		nr_seq_glosa,
		nr_seq_ocorr_benef,
		nr_nivel_liberacao,
		nr_seq_ocorrencia
	from (select	'O' ie_tipo,
			null nr_seq_glosa,
			nr_sequencia nr_seq_ocorr_benef,
			null nr_ocorrencia,
			nr_seq_guia_plano,
			nr_seq_proc nr_seq_proc,
			nr_seq_mat nr_seq_mat,
			nr_nivel_liberacao,
			nr_seq_ocorrencia,
			nr_seq_regra
		from	pls_ocorrencia_benef
		where	coalesce(nr_seq_conta::text, '') = ''
		and	coalesce(nr_seq_requisicao::text, '') = ''
		and	coalesce(nr_seq_execucao::text, '') = '') alias8
	where	nr_seq_regra		= nr_seq_regra_p
	and	nr_seq_guia_plano	= nr_seq_guia_p
	and	coalesce(nr_ocorrencia::text, '') = '';


BEGIN

select	nr_seq_requisicao
into STRICT	nr_seq_requisicao_w
from	pls_auditoria
where	nr_sequencia = nr_seq_auditoria_p;

open C02;
loop
fetch C02 into
	ie_tipo_w,
	nr_seq_glosa_w,
	nr_seq_ocorr_benef_w,
	nr_nivel_liberacao_w,
	nr_seq_ocorrencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	nr_nivel_liberacao_w := coalesce(nr_nivel_liberacao_w,0);

	insert into pls_analise_ocor_glosa_aut(nr_sequencia, ie_status, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_seq_auditoria, nr_seq_aud_item, nr_seq_glosa,
		nr_seq_ocorrencia_benef, ie_tipo, nr_nivel_liberacao,
		nr_seq_ocorrencia)
	values (nextval('pls_analise_ocor_glosa_aut_seq'), 'P', clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		nr_seq_auditoria_p, null, nr_seq_glosa_w,
		nr_seq_ocorr_benef_w, ie_tipo_w, nr_nivel_liberacao_w,
		nr_seq_ocorrencia_w);

	end;
end loop;
close C02;

open C01;
loop
fetch C01 into
	nr_seq_aud_item_w,
	nr_seq_proc_origem_w,
	nr_seq_mat_origem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(nr_seq_proc_origem_w,0) > 0) then
		nr_seq_proc_w := nr_seq_proc_origem_w;
		nr_seq_mat_w := 0;

	elsif (coalesce(nr_seq_mat_origem_w,0) > 0) then
		nr_seq_mat_w := nr_seq_mat_origem_w;
		nr_seq_proc_w := 0;

	end if;

	open C02;
	loop
	fetch C02 into
		ie_tipo_w,
		nr_seq_glosa_w,
		nr_seq_ocorr_benef_w,
		nr_nivel_liberacao_w,
		nr_seq_ocorrencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		nr_nivel_liberacao_w := coalesce(nr_nivel_liberacao_w,0);

		insert into pls_analise_ocor_glosa_aut(nr_sequencia, ie_status, dt_atualizacao,
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
			nr_seq_auditoria, nr_seq_aud_item, nr_seq_glosa,
			nr_seq_ocorrencia_benef, ie_tipo, nr_nivel_liberacao,
			nr_seq_ocorrencia)
		values (nextval('pls_analise_ocor_glosa_aut_seq'), 'P', clock_timestamp(),
			nm_usuario_p, clock_timestamp(), nm_usuario_p,
			nr_seq_auditoria_p, nr_seq_aud_item_w, nr_seq_glosa_w,
			nr_seq_ocorr_benef_w, ie_tipo_w, nr_nivel_liberacao_w,
			nr_seq_ocorrencia_w);

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
-- REVOKE ALL ON PROCEDURE pls_gerar_ocor_glosa_aud_limi ( nr_seq_auditoria_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) FROM PUBLIC;
