-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_parecer_ocorrencias_pre ( nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE


/*
Diego 21/07/2011

Rotina que ira atualizar os pareceres  das ocorrências de pré- análise de um arquivo que faltam ser  liberadas.

*/
nr_seq_analise_w		bigint;
nr_seq_lote_w			bigint;
nr_seq_analise_item_w		bigint;
nr_seq_mot_liberacao_w		bigint;
nr_seq_analise_conta_item_w	bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_glosa_oc_w		bigint;
ie_tipo_w			varchar(10);
nr_seq_conta_w			bigint;

ie_status_w			varchar(1);

C01 CURSOR FOR
	SELECT	b.nr_seq_analise
	from	pls_protocolo_conta a,
		pls_conta b
	where	a.nr_seq_lote_conta	= nr_seq_lote_w
	and	b.nr_seq_protocolo	= a.nr_sequencia
	group by b.nr_seq_analise
	order by 1;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta_proc,
		a.nr_seq_conta_mat,
		a.nr_seq_conta,
		a.nr_seq_analise,
		a.nr_seq_glosa_oc,
		a.ie_tipo,
		a.ie_status
	from	pls_analise_conta_item a
	where	a.nr_seq_analise = nr_seq_analise_w
	and	a.ie_pre_analise = 'S'
	and	ie_status <> 'I'
	and not exists (SELECT	b.nr_sequencia
			from	pls_analise_parecer_item b
			where	b.nr_seq_item = a.nr_sequencia);


BEGIN

select	max(b.nr_seq_lote_conta)
into STRICT	nr_seq_lote_w
from	ptu_fatura a,
	pls_protocolo_conta b
where	a.nr_sequencia 	   = nr_seq_fatura_p
and	a.nr_seq_protocolo = b.nr_sequencia;

open C01;
loop
fetch C01 into
	nr_seq_analise_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	 --askono -- OS 396221 - item 1 -  SE EXISTIREM PENDÊNCIAS, ESTAS NÃO SERÃO  MAIS LIBERADAS NO MOMENTO DE ENVIO PARA A ANÁLISE. SERÃO ENVIADAS COM PENDÊNCIA.
	 -- Os itens de glosa/ocorrência serão transferidos para a análise da maneira comom estão.
	/*
	open C02;
	loop
	fetch C02 into
		nr_seq_analise_conta_item_w,
		nr_seq_conta_proc_w,
		nr_seq_conta_mat_w,
		nr_seq_conta_w,
		nr_seq_analise_w,
		nr_seq_glosa_oc_w,
		ie_tipo_w,
		ie_status_w;
	exit when C02%notfound;
		begin


		select	max(nr_sequencia)
		into	nr_seq_mot_liberacao_w
		from	pls_mot_lib_analise_conta
		where	ie_situacao		= 'A'
		and	nvl(ie_pre_analise,'N')	= 'S';

		if	(nr_seq_mot_liberacao_w is not null) then
			pls_conta_liberar_glosa_oc(nr_seq_analise_conta_item_w, nr_seq_conta_proc_w, nr_seq_conta_mat_w,
						   nr_seq_conta_w, nr_seq_analise_w, nr_seq_glosa_oc_w,
						   ie_tipo_w, nr_seq_mot_liberacao_w, '', nm_usuario_p,
						   cd_estabelecimento_p, null, null,
						   'N', 'N');
		else
			aise_application_error(-20011,'Não existe motivo liberação padrão de ocorrências de pré-análise.(Cadastros Gerais / Plano de Saúde / OPS - Contas médicas / Motivos de liberação da análise da conta / Intercâmbio (Pré-Análise)).'||'#@#@');
		end if;

		end;
	end loop;
	close C02;
	*/
	update	pls_auditoria_conta_grupo
	set	dt_liberacao	= clock_timestamp(),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_seq_analise	= nr_seq_analise_w
	and	ie_pre_analise	= 'S'
	and	coalesce(dt_liberacao::text, '') = '';

	CALL pls_atualizar_grupo_penden(nr_seq_analise_w, cd_estabelecimento_p, nm_usuario_p);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_parecer_ocorrencias_pre ( nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;
