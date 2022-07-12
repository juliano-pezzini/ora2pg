-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

		
				
-- procedure responsavel por fazer a abertura das contas gerando novas de honorario individual



CREATE OR REPLACE PROCEDURE pls_cta_gera_hono_indiv_pck.gera_conta_hono_indiv ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


C01 CURSOR(	nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type,
		cd_estabelecimento_p	estabelecimento.cd_estabelecimento%type) FOR
	SELECT * from (
		SELECT	b.nr_seq_conta,
			b.nr_seq_prestador_exec,
			b.nr_seq_protocolo,
			b.cd_guia_referencia,
			b.nr_seq_segurado,
			b.nr_sequencia nr_seq_conta_proc,
			b.dt_procedimento,
			b.dt_inicio_proc,
			b.dt_fim_proc,
			c.nr_sequencia nr_seq_proc_partic,
			c.nr_seq_prestador nr_seq_prestador_partic,
			-- se nao tem prestador informado, busca da funcao pls_obter_seq_prestador_partic

			CASE WHEN coalesce(c.nr_cpf_imp::text, '') = '' THEN  c.nr_seq_prestador  ELSE pls_obter_seq_prestador_partic( c.cd_medico, b.nr_seq_prestador_exec,
			c.nr_seq_grau_partic,
			c.cd_medico,
			c.cd_guia cd_guia_partic,
			c.nr_seq_cbo_saude,
			c.vl_digitado_complemento,
			(select	count(1)
			 from	pls_conta_proc x
			 where	x.nr_seq_participante_hi	= c.nr_sequencia
			 and    x.ie_status != 'D') qtde_partic_hi
		from	pls_conta_proc_v	b,
			pls_proc_participante	c
		where	b.nr_sequencia			= nr_seq_conta_proc_pc
		and	c.nr_seq_conta_proc		= b.nr_sequencia
		and	((c.nr_seq_prestador IS NOT NULL AND c.nr_seq_prestador::text <> '') or (b.ie_tipo_guia = '5'))
		and (c.ie_status 			!= 'C' or coalesce(c.ie_status::text, '') = '')
		and	((c.ie_gerada_cta_honorario 	!= 'S') or (coalesce(c.ie_gerada_cta_honorario::text, '') = '')))
	
	where qtde_partic_hi = 0;
	
ds_sql_conta_w 			varchar(2000);
ds_filtro_conta_w		varchar(500);
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
ie_tipo_guia_convertido_w 	pls_conta.ie_tipo_guia%type;
ie_origem_conta_w		pls_conta.ie_origem_conta%type;
var_cur_w			integer;
var_exec_w			integer;
var_retorno_w			integer;

dados_regra_w		dados_regra_abertura_conta;
nr_seq_conta_anterior_w pls_conta.nr_sequencia%type;
ie_credenciado_w	varchar(1);
ie_cooperado_ativo_w	varchar(1);

nr_seq_novo_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
nr_seq_nova_conta_w		pls_conta.nr_sequencia%type;
ie_gerou_novo_registro_w	varchar(1);
nr_seq_protocolo_anterior_w	pls_protocolo_conta.nr_sequencia%type;
ie_tipo_guia_anterior_w		pls_conta.ie_tipo_guia%type;
cd_procedimento_w		procedimento.cd_procedimento%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
qt_regra_grupo_servico_w	integer;
BEGIN

select	count(1)
into STRICT	qt_regra_grupo_servico_w
from	pls_regra_conta_autom
where	(nr_seq_grupo_servico IS NOT NULL AND nr_seq_grupo_servico::text <> '');

-- filtro por lote

ds_filtro_conta_w := '';
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	ds_filtro_conta_w := ds_filtro_conta_w || 'and a.nr_seq_lote_conta = :nr_seq_lote_conta ';
end if;
-- filtro por protocolo

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	ds_filtro_conta_w := ds_filtro_conta_w || 'and a.nr_seq_protocolo = :nr_seq_protocolo_conta ';
end if;
-- filtro por lote de processo

if (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') then
	ds_filtro_conta_w := ds_filtro_conta_w || 'and	exists (select	1 ' ||
					          '		from	pls_cta_lote_proc_conta p ' ||
						  '		where	p.nr_seq_lote_processo = :nr_seq_lote_processo ' ||
						  '		and	p.nr_seq_conta = a.nr_seq_conta)';
end if;
-- filtro por conta

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	ds_filtro_conta_w := ds_filtro_conta_w || 'and a.nr_seq_conta = :nr_seq_conta ';
-- filtro por procedimento

elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	ds_filtro_conta_w := ds_filtro_conta_w || 'and a.nr_sequencia = :nr_seq_conta_proc ';
end if;
-- obtem todas as contas e procedimentos 

ds_sql_conta_w := 'select	a.nr_seq_conta, ' ||
		  '		a.nr_sequencia nr_seq_conta_proc, ' ||
		  '		a.ie_tipo_guia, ' ||
		  '		a.ie_origem_conta, ' ||
		  '		a.cd_procedimento, ' ||		
		  '		a.ie_origem_proced ' ||
		  'from		pls_conta_proc_v	a ' ||
		  'where	a.ie_tipo_guia			in (''4'',''5'') ' ||
		  'and 		a.ie_status_protocolo 		in (''1'', ''2'', ''5'') ' ||
		  'and 		a.ie_status_conta 		in (''A'', ''L'', ''P'', ''U'') ' ||
		  'and		a.nr_seq_conta_referencia 	is null ' ||
		  'and		a.ie_situacao_protocolo		in (''D'',''T'') '||
		  'and		a.ie_status 			!= ''D'' ' ||
		  ds_filtro_conta_w ||
		  ' order by 	a.nr_seq_conta';

var_cur_w := dbms_sql.open_cursor;
dbms_sql.parse(var_cur_w, ds_sql_conta_w, 1);

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_seq_lote_conta', nr_seq_lote_p);
end if;
if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_seq_protocolo_conta', nr_seq_protocolo_p);
end if;
if (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_seq_lote_processo', nr_seq_lote_processo_p);
end if;
if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_seq_conta', nr_seq_conta_p);
elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	dbms_sql.bind_variable(var_cur_w, ':nr_seq_conta_proc', nr_seq_conta_proc_p);
end if;

dbms_sql.define_column(var_cur_w, 1, nr_seq_conta_w);
dbms_sql.define_column(var_cur_w, 2, nr_seq_conta_proc_w);
dbms_sql.define_column(var_cur_w, 3, ie_tipo_guia_w, 2);
dbms_sql.define_column(var_cur_w, 4, ie_origem_conta_w, 1);
dbms_sql.define_column(var_cur_w, 5, cd_procedimento_w);
dbms_sql.define_column(var_cur_w, 6, ie_origem_proced_w);

var_exec_w := dbms_sql.execute(var_cur_w);

nr_seq_conta_anterior_w := null;

-- todas as contas e procedimentos	

loop
var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
exit when var_retorno_w = 0;

	dbms_sql.column_value(var_cur_w, 1, nr_seq_conta_w);
	dbms_sql.column_value(var_cur_w, 2, nr_seq_conta_proc_w);
	dbms_sql.column_value(var_cur_w, 3, ie_tipo_guia_w);
	dbms_sql.column_value(var_cur_w, 4, ie_origem_conta_w);
	dbms_sql.column_value(var_cur_w, 5, cd_procedimento_w);
	dbms_sql.column_value(var_cur_w, 6, ie_origem_proced_w);
	
	-- converte o tipo de guia para usar em tratamentos

	if (ie_tipo_guia_w = '5') then
		-- honorario individual

		ie_tipo_guia_convertido_w	:= '6';
	else
		ie_tipo_guia_convertido_w 	:= ie_tipo_guia_w;
	end if;
			
	nr_seq_protocolo_anterior_w := null;
	ie_tipo_guia_anterior_w := null;
	
	-- faz todas as verificacaes para abrir ou nao a conta

	for r_C01_w in C01(nr_seq_conta_proc_w, cd_estabelecimento_p) loop
		
		
		
		-- obtem os dados da regra de abertura de conta

		dados_regra_w := pls_cta_gera_hono_indiv_pck.obter_regra_abertura_conta(	ie_tipo_guia_w,
								ie_origem_conta_w,
								'P',
								cd_estabelecimento_p,
								cd_procedimento_w,
								ie_origem_proced_w,
								r_c01_w.nr_seq_prestador_partic_func);
								
		
								
	
		if (dados_regra_w.nr_sequencia IS NOT NULL AND dados_regra_w.nr_sequencia::text <> '') then
		
			-- verifica se o medico e um prestador credenciado ou se e credenciado a um prestador

			ie_credenciado_w	:= pls_obter_se_credenciado_prest( r_C01_w.cd_medico,
										   r_C01_w.nr_seq_prestador_exec);
			-- verifica se e cooperado e esta ativo no momento do atendimento

			ie_cooperado_ativo_w	:= pls_obter_se_cooperado_ativo( r_C01_w.cd_medico,
										 r_C01_w.dt_procedimento, 
										 null);
			
			-- verificacaes para decidir se abre ou nao a conta/procedimento

			if	(
				-- se for cooperado ou credenciado e for uma guia de resumo de internacao ou tiver o prestador do participante informado

				((((ie_cooperado_ativo_w = 'S') or (ie_credenciado_w = 'S')) and (ie_tipo_guia_w = '5')) or (r_C01_w.nr_seq_prestador_partic IS NOT NULL AND r_C01_w.nr_seq_prestador_partic::text <> '')) and
				 -- e tiver guia informada (referencia ou guia normal da conta) 

				(r_C01_w.cd_guia_referencia IS NOT NULL AND r_C01_w.cd_guia_referencia::text <> '') and	
				-- se e informada a regra que exige prestador ou se tiver prestador informado

				((dados_regra_w.ie_prestador_partic = 'N') or ((r_C01_w.nr_seq_prestador_partic IS NOT NULL AND r_C01_w.nr_seq_prestador_partic::text <> '') and (r_C01_w.nr_seq_prestador_partic != coalesce(r_c01_w.nr_seq_prestador_exec,0)))) and
				-- e se e informado na regra que a guia precisa ser informada no participante

				((dados_regra_w.ie_guia_informada = 'N') or (r_C01_w.cd_guia_partic IS NOT NULL AND r_C01_w.cd_guia_partic::text <> ''))) then
				
				ie_gerou_novo_registro_w := 'N';
				-- se mudou o protocolo ou a guia executa de novo, caso contrario nao precisa fazer nada

				if (coalesce(nr_seq_protocolo_anterior_w::text, '') = '' or
					 nr_seq_protocolo_anterior_w != r_C01_w.nr_seq_protocolo or
					 coalesce(ie_tipo_guia_anterior_w::text, '') = '' or
					 ie_tipo_guia_anterior_w != ie_tipo_guia_convertido_w) then
					 
					-- verificar para gerar ou buscar o protocolo

					SELECT * FROM pls_cta_gera_hono_indiv_pck.gera_protocolo_abert_conta(	r_C01_w.nr_seq_protocolo, ie_tipo_guia_convertido_w, nm_usuario_p, cd_estabelecimento_p, nr_seq_novo_protocolo_w, ie_gerou_novo_registro_w) INTO STRICT nr_seq_novo_protocolo_w, ie_gerou_novo_registro_w;
				end if;
				
				-- verificar para gerar ou buscar a conta

				SELECT * FROM pls_cta_gera_hono_indiv_pck.gera_conta_abert_conta(	r_C01_w.nr_seq_conta, nr_seq_novo_protocolo_w, r_C01_w.nr_seq_segurado, r_C01_w.cd_guia_partic, r_C01_w.nr_seq_prestador_partic_func, r_C01_w.nr_seq_grau_partic, r_C01_w.cd_medico, ie_tipo_guia_convertido_w, r_C01_w.nr_seq_cbo_saude, nm_usuario_p, cd_estabelecimento_p, dados_regra_w, nr_seq_nova_conta_w, ie_gerou_novo_registro_w) INTO STRICT nr_seq_nova_conta_w, ie_gerou_novo_registro_w;
				
				-- verificar para gerar o procedimento

				ie_gerou_novo_registro_w := pls_cta_gera_hono_indiv_pck.gera_proc_abert_conta(	nr_seq_nova_conta_w, r_C01_w.nr_seq_conta_proc, r_C01_w.nr_seq_proc_partic, r_C01_w.dt_procedimento, r_C01_w.dt_inicio_proc, r_C01_w.dt_fim_proc, r_C01_w.vl_digitado_complemento, nm_usuario_p, dados_regra_w, ie_gerou_novo_registro_w);
				
				-- cancela o participante que foi aberto

				CALL pls_cta_gera_hono_indiv_pck.cancela_partic_abert_conta(	r_C01_w.nr_seq_conta,
								r_C01_w.nr_seq_conta_proc,
								r_C01_w.nr_seq_proc_partic,
								nm_usuario_p);
								
				-- so cancela o procedimento se foi gerado um novo procedimento

				if (ie_gerou_novo_registro_w = 'S') then
					-- cancela o procedimento que foi aberto se a regra permitir

					CALL pls_cta_gera_hono_indiv_pck.cancela_proc_abert_conta( r_C01_w.nr_seq_conta,
								  r_C01_w.nr_seq_conta_proc,
								  r_C01_w.dt_procedimento,
								  nm_usuario_p);
				end if;
				
				nr_seq_protocolo_anterior_w := r_C01_w.nr_seq_protocolo;
				ie_tipo_guia_anterior_w := ie_tipo_guia_convertido_w;
				
				commit;
			end if;
		end if;
	end loop;

	-- armazena a conta para utilizar na comparacao acima.

	nr_seq_conta_anterior_w := nr_seq_conta_w;
end loop;
dbms_sql.close_cursor(var_cur_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_gera_hono_indiv_pck.gera_conta_hono_indiv ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;