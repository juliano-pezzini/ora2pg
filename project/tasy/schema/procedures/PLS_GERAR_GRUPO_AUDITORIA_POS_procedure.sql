-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_grupo_auditoria_pos ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


ie_tipo_conta_w			pls_conta.ie_tipo_conta%type;
ie_origem_conta_w		pls_conta.ie_origem_conta%type;
nr_seq_fluxo_w			pls_ocorrencia_grupo.nr_seq_fluxo%type;
ie_intercambio_w		varchar(1) := 'N';
ie_conta_medica_w		varchar(1) := 'N';
ie_existe_grupo_analise_w	integer := 0;
nr_seq_grupo_auditor_w		bigint;

C01 CURSOR(	nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		'P' ie_tipo_item
	from	pls_conta_pos_proc a
	where	a.nr_seq_conta		= nr_seq_conta_pc
	
union

	SELECT	a.nr_sequencia,
		'M' ie_tipo_item
	from	pls_conta_pos_mat a
	where	a.nr_seq_conta		= nr_seq_conta_pc
	order by 1;

C02 CURSOR(	nr_seq_conta_pos_estab_pc	pls_conta_pos_proc.nr_sequencia%type,
		ie_origem_conta_pc		pls_conta.ie_origem_conta%type) FOR
	SELECT	nr_seq_grupo			nr_seq_grupo,
		nr_seq_fluxo			nr_seq_fluxo,
		coalesce(ie_conta_medica,'N')	ie_conta_medica,
		ie_tipo_analise			ie_tipo_analise,
		coalesce(ie_intercambio,'N')		ie_intercambio
	from	pls_ocorrencia_grupo
	where	nr_seq_ocorrencia in (SELECT	nr_seq_ocorrencia
					from	pls_ocorrencia_benef
					where	nr_seq_conta_pos_proc	= nr_seq_conta_pos_estab_pc )
	and	ie_origem_conta			= ie_origem_conta_pc
	and	ie_situacao			= 'A'
	
union all

	select	nr_seq_grupo			nr_seq_grupo,
		nr_seq_fluxo			nr_seq_fluxo,
		coalesce(ie_conta_medica,'N')	ie_conta_medica,
		ie_tipo_analise			ie_tipo_analise,
		coalesce(ie_intercambio,'N')		ie_intercambio
	from	pls_ocorrencia_grupo
	where	nr_seq_ocorrencia in (select	nr_seq_ocorrencia
					from	pls_ocorrencia_benef
					where	nr_seq_conta_pos_proc	= nr_seq_conta_pos_estab_pc )
	and	coalesce(ie_origem_conta::text, '') = ''
	and	ie_situacao			= 'A';
	
C03 CURSOR(	nr_seq_conta_pos_estab_pc	pls_conta_pos_mat.nr_sequencia%type,
		ie_origem_conta_pc		pls_conta.ie_origem_conta%type) FOR
	SELECT	nr_seq_grupo			nr_seq_grupo,
		nr_seq_fluxo			nr_seq_fluxo,
		coalesce(ie_conta_medica,'N')	ie_conta_medica,
		ie_tipo_analise			ie_tipo_analise,
		coalesce(ie_intercambio,'N')		ie_intercambio
	from	pls_ocorrencia_grupo
	where	nr_seq_ocorrencia in (SELECT	nr_seq_ocorrencia
					from	pls_ocorrencia_benef
					where	nr_seq_conta_pos_mat	= nr_seq_conta_pos_estab_pc )
	and	ie_origem_conta			= ie_origem_conta_pc
	and	ie_situacao			= 'A'
	
union all

	select	nr_seq_grupo			nr_seq_grupo,
		nr_seq_fluxo			nr_seq_fluxo,
		coalesce(ie_conta_medica,'N')	ie_conta_medica,
		ie_tipo_analise			ie_tipo_analise,
		coalesce(ie_intercambio,'N')		ie_intercambio
	from	pls_ocorrencia_grupo
	where	nr_seq_ocorrencia in (select	nr_seq_ocorrencia
					from	pls_ocorrencia_benef
					where	nr_seq_conta_pos_mat	= nr_seq_conta_pos_estab_pc )
	and	coalesce(ie_origem_conta::text, '') = ''
	and	ie_situacao			= 'A';	

BEGIN

select	coalesce(max(ie_origem_conta),'O'),
	coalesce(max(ie_tipo_conta),'O')
into STRICT	ie_origem_conta_w,
	ie_tipo_conta_w
from	pls_conta
where	nr_sequencia	= nr_seq_conta_p;

if ( ie_tipo_conta_w = 'I') then
	ie_intercambio_w	:= 'S';
	ie_conta_medica_w	:= null;
else
	ie_intercambio_w	:= null;
	ie_conta_medica_w	:= 'S';
end if;

for r_c01_w in C01(nr_seq_conta_p) loop

	--Se for pos-estabelecido vinculado a procedimento
	if (r_c01_w.ie_tipo_item = 'P') then
		
		--Obtem os grupos das ocorrencias das contas
		for r_c02_w in C02(r_c01_w.nr_sequencia, ie_origem_conta_w) loop
		
			if ( r_c02_w.ie_conta_medica = 'S') then
			
				if	(( (ie_conta_medica_w IS NOT NULL AND ie_conta_medica_w::text <> '') and ie_conta_medica_w =  r_c02_w.ie_conta_medica) or ( (ie_intercambio_w IS NOT NULL AND ie_intercambio_w::text <> '') and ie_intercambio_w = r_c02_w.ie_intercambio) )then
				
					if ( coalesce(r_c02_w.ie_tipo_analise::text, '') = '' or r_c02_w.ie_tipo_analise = 'P' or r_c02_w.ie_tipo_analise = 'A') then
						
						if (coalesce(r_c02_w.nr_seq_fluxo::text, '') = '') then
							select	max(a.nr_seq_fluxo_padrao)
							into STRICT	nr_seq_fluxo_w
							from	pls_grupo_auditor	a
							where	a.nr_sequencia	= r_c02_w.nr_seq_grupo;
						else
							nr_seq_fluxo_w := r_c02_w.nr_seq_fluxo;
						end if;		
						
						/*Verifica se existe o grupo na analise*/

						select	count(a.nr_sequencia)
						into STRICT	ie_existe_grupo_analise_w
						from	pls_auditoria_conta_grupo a,
							pls_analise_conta	  b
						where	b.nr_sequencia		= a.nr_seq_analise	
						and	a.nr_seq_grupo		= r_c02_w.nr_seq_grupo
						and	a.nr_seq_analise	= nr_seq_analise_p;		
							
						if (ie_existe_grupo_analise_w = 0) then
							
							/*Se nao existir cria-se o grupo*/
		
							insert into pls_auditoria_conta_grupo(nr_sequencia,
								nr_seq_analise,
								nr_seq_grupo,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_ordem,
								ds_conta)
							values (nextval('pls_auditoria_conta_grupo_seq'),
								nr_seq_analise_p,
								r_c02_w.nr_seq_grupo,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_fluxo_w,
								to_char(nr_seq_conta_p));	
						end if;
					end if;
				end if;
			end if;
		
		end loop; --Cursor C02
	
	--Se for pos-estabelecido vinculado a procedimento
	else
		--Obtem os grupos das ocorrencias das contas
		for r_c03_w in C03(r_c01_w.nr_sequencia, ie_origem_conta_w) loop
		
			if ( r_c03_w.ie_conta_medica = 'S') then
			
				if	(( (ie_conta_medica_w IS NOT NULL AND ie_conta_medica_w::text <> '') and ie_conta_medica_w =  r_c03_w.ie_conta_medica) or ( (ie_intercambio_w IS NOT NULL AND ie_intercambio_w::text <> '') and ie_intercambio_w = r_c03_w.ie_intercambio))then
				
					if ( coalesce(r_c03_w.ie_tipo_analise::text, '') = '' or r_c03_w.ie_tipo_analise = 'P' or r_c03_w.ie_tipo_analise = 'A') then
				
						if (coalesce(r_c03_w.nr_seq_fluxo::text, '') = '') then
							select	max(a.nr_seq_fluxo_padrao)
							into STRICT	nr_seq_fluxo_w
							from	pls_grupo_auditor	a
							where	a.nr_sequencia	= r_c03_w.nr_seq_grupo;
						else
							nr_seq_fluxo_w := r_c03_w.nr_seq_fluxo;
						end if;		
						
						/*Verifica se existe o grupo na analise*/

						select	count(a.nr_sequencia)
						into STRICT	ie_existe_grupo_analise_w
						from	pls_auditoria_conta_grupo a,
							pls_analise_conta	  b
						where	b.nr_sequencia		= a.nr_seq_analise	
						and	a.nr_seq_grupo		= r_c03_w.nr_seq_grupo
						and	a.nr_seq_analise	= nr_seq_analise_p;		
							
						if (ie_existe_grupo_analise_w = 0) then

							/*Se nao existir cria-se o grupo*/
		
							insert into pls_auditoria_conta_grupo(nr_sequencia,
								nr_seq_analise,
								nr_seq_grupo,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_ordem,
								ds_conta)
							values (nextval('pls_auditoria_conta_grupo_seq'),
								nr_seq_analise_p,
								r_c03_w.nr_seq_grupo,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_fluxo_w,
								to_char(nr_seq_conta_p));	
						end if;
					end if;
				end if;
			end if;
			
		end loop; --Cursor C03
	end if;
	
end loop;--cursor C01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_grupo_auditoria_pos ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
