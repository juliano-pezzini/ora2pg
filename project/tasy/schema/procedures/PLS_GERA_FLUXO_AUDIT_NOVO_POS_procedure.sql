-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gera_fluxo_audit_novo_pos ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_pos_p bigint, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o fluxo de auditoria para os itens da conta
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Esta rotina é chamada na PLS_$GERAR_$AUDITORIA_POS para que seja verificado se análise
de pós estabelecido possui fluxo, caso não possua são então fechadas as contas da análise de pós
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_status_w			varchar(255);
ie_auditoria_ww			varchar(1)	:= 'N';
ie_auditoria_w			varchar(1);
qt_registro_w			bigint;
qt_analise_item_w		bigint;
qt_grupo_analise_w		bigint;
cd_estabelecimento_w		smallint;
ie_intercambio_w		varchar(1);
qt_oco_despesa_w		integer;
ie_despesa_w			varchar(1);
ie_origem_analise_w		pls_analise_conta.ie_origem_analise%type;
qt_analise_w			integer;

C01 CURSOR(	nr_seq_analise_pc	pls_analise_conta.nr_sequencia%type,
		nr_seq_conta_pos_pc	pls_conta_pos_proc.nr_sequencia%type) FOR
	SELECT	b.nr_sequencia,
		b.nr_seq_ocorrencia,
		a.ie_origem_conta
	from	pls_ocorrencia_benef	b,
		pls_conta_pos_proc	a
	where	a.nr_sequencia		= b.nr_seq_conta_pos_proc
	and	a.nr_seq_analise	= nr_seq_analise_pc
	and (a.nr_sequencia	 	= nr_seq_conta_pos_pc or coalesce(nr_seq_conta_pos_pc::text, '') = '')
	and (coalesce(b.ie_lib_manual::text, '') = '' or b.ie_lib_manual = 'N')
	
union all

	SELECT	b.nr_sequencia,
		b.nr_seq_ocorrencia,
		a.ie_origem_conta
	from	pls_ocorrencia_benef	b,
		pls_conta_pos_mat	a
	where	a.nr_sequencia		= b.nr_seq_conta_pos_mat
	and	a.nr_seq_analise	= nr_seq_analise_pc
	and (a.nr_sequencia	 	= nr_seq_conta_pos_pc or coalesce(nr_seq_conta_pos_pc::text, '') = '')
	and (coalesce(b.ie_lib_manual::text, '') = '' or b.ie_lib_manual = 'N');

C02 CURSOR(	nr_seq_ocorrencia_pc	pls_ocorrencia_benef.nr_seq_ocorrencia%type,
		nr_seq_analise_pc	pls_analise_conta.nr_sequencia%type) FOR
	SELECT	b.nr_seq_grupo
	from	pls_analise_grupo_item b,
		pls_analise_conta_item a
	where	a.nr_sequencia		= b.nr_seq_item_analise
	and	a.nr_seq_analise	= nr_seq_analise_pc
	and	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_pc
	group by
		a.nr_seq_ocorrencia,
		b.nr_seq_grupo;

C03 CURSOR(	nr_seq_ocorrencia_pc	pls_ocorrencia_benef.nr_seq_ocorrencia%type,
		ie_origem_conta_pc	pls_conta.ie_origem_conta%type) FOR
	SELECT	a.nr_seq_grupo,
		a.nr_sequencia
	from	pls_ocorrencia_grupo	a
	where	a.nr_seq_ocorrencia	= nr_seq_ocorrencia_pc
	and	a.ie_conta_medica	= 'S'
	and	a.ie_situacao		= 'A'
	and	((a.ie_intercambio = 'S') or (a.ie_intercambio = ie_intercambio_w))
	and (a.ie_origem_conta = ie_origem_conta_pc or coalesce(a.ie_origem_conta::text, '') = '')
	and	(	(coalesce(a.ie_tipo_analise::text, '') = '') or (a.ie_tipo_analise = 'A') or (a.ie_tipo_analise 	= 'C' and ie_origem_analise_w in ('1','3','4','5','6')) or (a.ie_tipo_analise	= 'P' and ie_origem_analise_w in ('2','7')));
BEGIN

select 	count(1)
into STRICT	qt_analise_w
from	pls_analise_conta
where	nr_sequencia	= nr_seq_analise_p;

if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') and (qt_analise_w > 0) then

	/* Verificar primeiro se tem os registros na tabela antiga */

	select	count(1)
	into STRICT	qt_analise_item_w
	from	pls_analise_conta_item a
	where	a.nr_seq_analise	= nr_seq_analise_p;

	select	CASE WHEN a.ie_origem_analise=3 THEN 'I'  ELSE 'N' END ,
		ie_origem_analise
	into STRICT	ie_intercambio_w,
		ie_origem_analise_w
	from	pls_analise_conta	a
	where	a.nr_sequencia	= nr_seq_analise_p;

	for r_c01_w in C01( nr_seq_analise_p, nr_seq_conta_pos_p) loop

		select	coalesce(max(ie_auditoria_conta),'N')
		into STRICT	ie_auditoria_w
		from	pls_ocorrencia
		where	nr_sequencia	= r_c01_w.nr_seq_ocorrencia;

		if (ie_auditoria_w = 'S') then
			ie_auditoria_ww	:= ie_auditoria_w;
		end if;

		/* Se tiver, copiar para nova */

		if (qt_analise_item_w > 0) then
			for r_C02_w in C02( r_c01_w.nr_seq_ocorrencia, nr_seq_analise_p) loop
				ie_auditoria_ww	:= 'S';

				select	count(1)
				into STRICT	qt_registro_w
				from	pls_analise_glo_ocor_grupo a
				where	a.nr_seq_ocor_benef	= r_c01_w.nr_sequencia
				and	a.nr_seq_grupo		= r_c02_w.nr_seq_grupo;

				if (qt_registro_w = 0) then
					insert into pls_analise_glo_ocor_grupo(nr_sequencia,
						nm_usuario,
						dt_atualizacao,
						nm_usuario_nrec,
						dt_atualizacao_nrec,
						nr_seq_analise,
						nr_seq_ocor_benef,
						nr_seq_grupo,
						ie_status)
					values (nextval('pls_analise_glo_ocor_grupo_seq'),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nr_seq_analise_p,
						r_c01_w.nr_sequencia,
						r_c02_w.nr_seq_grupo,
						'P');
				end if;

			end loop;--Cursor C02
		end if;

		for r_c03_w in C03(r_c01_w.nr_seq_ocorrencia, r_c01_w.ie_origem_conta) loop
			ie_despesa_w	:= 'N';

			select	count(1)
			into STRICT	qt_oco_despesa_w
			from	pls_oc_grupo_tipo_desp
			where	nr_seq_ocorrencia_grupo = r_c03_w.nr_seq_grupo;

			if (qt_oco_despesa_w = 0) then
				ie_despesa_w	:= 'S';
			end if;


			if (coalesce(ie_despesa_w,'S') = 'S') then
				ie_auditoria_ww	:= 'S';

				select	count(1)
				into STRICT	qt_registro_w
				from	pls_analise_glo_ocor_grupo a
				where	a.nr_seq_ocor_benef	= r_c01_w.nr_sequencia
				and	a.nr_seq_grupo		= r_C03_w.nr_seq_grupo  LIMIT 1;

				if (qt_registro_w = 0) then
					select	count(1)
					into STRICT	qt_grupo_analise_w
					from	pls_auditoria_conta_grupo
					where	nr_seq_analise	= nr_seq_analise_p
					and	nr_seq_grupo	= r_C03_w.nr_seq_grupo;

					insert into pls_analise_glo_ocor_grupo(nr_sequencia,
						nm_usuario,
						dt_atualizacao,
						nm_usuario_nrec,
						dt_atualizacao_nrec,
						nr_seq_analise,
						nr_seq_ocor_benef,
						nr_seq_grupo,
						ie_status)
					values (nextval('pls_analise_glo_ocor_grupo_seq'),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nr_seq_analise_p,
						r_c01_w.nr_sequencia,
						r_c03_w.nr_seq_grupo,
						'P');
				end if;
			end if;

		end loop;--Cursor C03
	end loop; --Cursor C01
	select	CASE WHEN a.ie_status='S' THEN  CASE WHEN ie_auditoria_ww='S' THEN  'G' WHEN ie_auditoria_ww='N' THEN  'S' END   ELSE a.ie_status END
	into STRICT	ie_status_w
	from	pls_analise_conta	a
	where	a.nr_sequencia	= nr_seq_analise_p;

	CALL pls_alterar_status_analise_cta(nr_seq_analise_p, ie_status_w, 'PLS_GERA_FLUXO_AUDIT_NOVO_POS', nm_usuario_p, cd_estabelecimento_w);

	update	pls_analise_conta
	set	ie_auditoria	= CASE WHEN ie_auditoria='S' THEN  'S' WHEN ie_auditoria='N' THEN  ie_auditoria_ww END
	where	nr_sequencia	= nr_seq_analise_p;
end if;

/* commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gera_fluxo_audit_novo_pos ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_pos_p bigint, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

