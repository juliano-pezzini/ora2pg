-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_apropriacao_pck.pls_gerar_copart_aprop_rec ( nr_seq_proc_rec_p pls_rec_glosa_proc.nr_sequencia%type, nr_seq_mat_rec_p pls_rec_glosa_mat.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


regras_copartic CURSOR(	nr_seq_proc_rec_pc	pls_rec_glosa_proc.nr_sequencia%type,
				nr_seq_mat_rec_pc	pls_rec_glosa_mat.nr_sequencia%type) FOR
	SELECT	distinct nr_seq_regra_copartic
	from	pls_conta_proc_aprop
	where	nr_seq_proc_rec = nr_seq_proc_rec_pc
	
union all

	SELECT	distinct nr_seq_regra_copartic
	from	pls_conta_mat_aprop
	where	nr_seq_mat_rec = nr_seq_mat_rec_pc;
	
apropriacoes_procedimento CURSOR(	nr_seq_regra_copartic_pc	pls_regra_copartic.nr_sequencia%type,
					nr_seq_proc_rec_pc		pls_rec_glosa_proc.nr_sequencia%type) FOR
	SELECT	a.*,
		(CASE WHEN (b.nr_seq_contrato IS NOT NULL AND b.nr_seq_contrato::text <> '') THEN 'C' ELSE (CASE WHEN (b.nr_seq_intercambio IS NOT NULL AND b.nr_seq_intercambio::text <> '') THEN 'I' ELSE 'P' END) END)	ie_origem_regra,
		c.tx_apropriacao,
		c.ie_tipo_apropriacao c_ie_tipo_aprop,
		c.nr_seq_centro_apropriacao
	from	pls_conta_proc_aprop		a,
		pls_regra_copartic		b,
		pls_regra_copartic_aprop	c
	where	a.nr_seq_regra_copartic	= b.nr_sequencia
	and	c.nr_sequencia		= a.nr_seq_regra_copart_aprop
	and	b.nr_sequencia		= nr_seq_regra_copartic_pc
	and	a.nr_seq_proc_rec	= nr_seq_proc_rec_pc
	and	a.ie_coparticipacao	= 'S'
	and	a.vl_apropriado 	<> 0
	
union all

	SELECT	a.*,
		(CASE WHEN (b.nr_seq_contrato IS NOT NULL AND b.nr_seq_contrato::text <> '') THEN 'C' ELSE (CASE WHEN (b.nr_seq_intercambio IS NOT NULL AND b.nr_seq_intercambio::text <> '') THEN 'I' ELSE 'P' END) END)	ie_origem_regra,
		c.tx_apropriacao,
		c.ie_tipo_apropriacao	c_ie_tipo_aprop,
		c.nr_seq_centro_apropriacao
	from	pls_conta_proc_aprop		a,
		pls_regra_copartic		b,
		pls_regra_copartic_aprop	c
	where	a.nr_seq_regra_copartic	= b.nr_sequencia
	and	c.nr_sequencia		= a.nr_seq_regra_copart_aprop
	and	b.nr_sequencia		= nr_seq_regra_copartic_pc
	and	a.nr_seq_proc_rec	= nr_seq_proc_rec_pc
	and	a.ie_coparticipacao	= 'S'
	and	a.vl_apropriado 	= 0
	and	(a.nr_seq_regra_copar_exc IS NOT NULL AND a.nr_seq_regra_copar_exc::text <> '')
	order by c_ie_tipo_aprop;
	
apropriacoes_material CURSOR(	nr_seq_regra_copartic_pc	pls_regra_copartic.nr_sequencia%type,
				nr_seq_mat_rec_pc		pls_rec_glosa_mat.nr_sequencia%type) FOR
	SELECT	a.*,
		b.vl_maximo_copartic,
		(CASE WHEN (b.nr_seq_contrato IS NOT NULL AND b.nr_seq_contrato::text <> '') THEN 'C' ELSE (CASE WHEN (b.nr_seq_intercambio IS NOT NULL AND b.nr_seq_intercambio::text <> '') THEN 'I' ELSE 'P' END) END)	ie_origem_regra,
		c.tx_apropriacao,
		c.ie_tipo_apropriacao c_ie_tipo_aprop,
		c.nr_seq_centro_apropriacao
	from	pls_conta_mat_aprop		a,
		pls_regra_copartic		b,
		pls_regra_copartic_aprop	c
	where	a.nr_seq_regra_copartic = b.nr_sequencia
	and	c.nr_sequencia		= a.nr_seq_regra_copart_aprop
	and	b.nr_sequencia		= nr_seq_regra_copartic_pc
	and	a.nr_seq_mat_rec	= nr_seq_mat_rec_pc
	and	a.ie_coparticipacao	= 'S'
	and	a.vl_apropriado 	<> 0
	
union all

	SELECT	a.*,
		b.vl_maximo_copartic,
		(CASE WHEN (b.nr_seq_contrato IS NOT NULL AND b.nr_seq_contrato::text <> '') THEN 'C' ELSE (CASE WHEN (b.nr_seq_intercambio IS NOT NULL AND b.nr_seq_intercambio::text <> '') THEN 'I' ELSE 'P' END) END)	ie_origem_regra,
		c.tx_apropriacao,
		c.ie_tipo_apropriacao c_ie_tipo_aprop,
		c.nr_seq_centro_apropriacao
	from	pls_conta_mat_aprop		a,
		pls_regra_copartic		b,
		pls_regra_copartic_aprop	c
	where	a.nr_seq_regra_copartic = b.nr_sequencia
	and	c.nr_sequencia		= a.nr_seq_regra_copart_aprop
	and	b.nr_sequencia		= nr_seq_regra_copartic_pc
	and	a.nr_seq_mat_rec	= nr_seq_mat_rec_pc
	and	a.ie_coparticipacao	= 'S'
	and	a.vl_apropriado 	= 0
	and	(a.nr_seq_regra_copar_exc IS NOT NULL AND a.nr_seq_regra_copar_exc::text <> '')
	order by c_ie_tipo_aprop;

dt_mes_competencia_w		pls_rec_glosa_protocolo.dt_competencia_lote%type;
nr_seq_conta_copartic_aprop_w	pls_conta_copartic_aprop.nr_sequencia%type;
nr_seq_conta_coparticipacao_w	pls_conta_coparticipacao.nr_sequencia%type;
qt_itens_cobrados_w		pls_conta_proc_aprop.qt_apropriada%type;
nr_seq_conta_rec_w		pls_rec_glosa_conta.nr_sequencia%type;
vl_acatado_w			pls_rec_glosa_proc.vl_acatado%type;
pls_regra_copartic_w		pls_regra_copartic%rowtype;
vl_coparticipacao_w		double precision;
ie_status_mensalidade_w		varchar(1);
ie_cobrar_pos_estab_w		varchar(1);
ie_retorno_w			varchar(1);
qt_registros_w			integer;
ie_primeira_apropriacao_w	boolean;
ie_iterar_w			varchar(1) := 'S';
vl_copart_w			pls_conta_proc_aprop.vl_apropriado%type;

BEGIN
PERFORM set_config('pls_apropriacao_pck.vl_fixo_aprop_conta_w', 0, false);
PERFORM set_config('pls_apropriacao_pck.vl_pendente_aprop_w', 0, false);
PERFORM set_config('pls_apropriacao_pck.nr_centro_nao_aprop_w', 0, false);
PERFORM set_config('pls_apropriacao_pck.ie_primeira_vez_w', 'S', false);
PERFORM set_config('pls_apropriacao_pck.nr_seq_regra_aprop_ant_w', 0, false);
current_setting('pls_apropriacao_pck.vl_pendente_guia_table_w')::pls_util_cta_pck.t_number_table.delete;

PERFORM set_config('pls_apropriacao_pck.nr_seq_proc_rec_w', nr_seq_proc_rec_p, false);
PERFORM set_config('pls_apropriacao_pck.nr_seq_mat_rec_w', nr_seq_mat_rec_p, false);
PERFORM set_config('pls_apropriacao_pck.ie_recurso_glosa_w', 'S', false);

if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	PERFORM set_config('pls_apropriacao_pck.ie_gerando_conta_proc_mat_w', 'P', false);
	
	select	*
	into STRICT	current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype
	from	pls_conta_proc
	where	nr_sequencia = nr_seq_conta_proc_p;
	
	CALL CALL pls_apropriacao_pck.carregar_variaveis_pck(current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.nr_seq_conta, null, nm_usuario_p);
	
elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
	PERFORM set_config('pls_apropriacao_pck.ie_gerando_conta_proc_mat_w', 'M', false);
	
	select	*
	into STRICT	current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype
	from	pls_conta_mat
	where	nr_sequencia = nr_seq_conta_mat_p;
	
	CALL CALL pls_apropriacao_pck.carregar_variaveis_pck(current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype.nr_seq_conta, null, nm_usuario_p);
end if;

if (nr_seq_proc_rec_p IS NOT NULL AND nr_seq_proc_rec_p::text <> '') then
	select	*
	into STRICT	current_setting('pls_apropriacao_pck.pls_rec_glosa_proc_w')::pls_rec_glosa_proc%rowtype
	from	pls_rec_glosa_proc
	where	nr_sequencia = nr_seq_proc_rec_p;
	
	select	CASE WHEN count(1)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_iterar_w
	from	pls_conta_proc_aprop
	where	nr_seq_proc_rec = nr_seq_proc_rec_p;
	
	CALL CALL pls_apropriacao_pck.carregar_variaveis_pck(current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.nr_seq_conta, current_setting('pls_apropriacao_pck.pls_rec_glosa_proc_w')::pls_rec_glosa_proc%rowtype.nr_seq_conta_rec, nm_usuario_p);
elsif (nr_seq_mat_rec_p IS NOT NULL AND nr_seq_mat_rec_p::text <> '') then

	select	*
	into STRICT	current_setting('pls_apropriacao_pck.pls_rec_glosa_mat_w')::pls_rec_glosa_mat%rowtype
	from	pls_rec_glosa_mat
	where	nr_sequencia = nr_seq_mat_rec_p;
	
	select	CASE WHEN count(1)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_iterar_w
	from	pls_conta_mat_aprop
	where	nr_seq_mat_rec	= nr_seq_mat_rec_p;
	
	CALL CALL pls_apropriacao_pck.carregar_variaveis_pck(current_setting('pls_apropriacao_pck.pls_conta_mat_w')::pls_conta_mat%rowtype.nr_seq_conta, current_setting('pls_apropriacao_pck.pls_rec_glosa_mat_w')::pls_rec_glosa_mat%rowtype.nr_seq_conta_rec, nm_usuario_p);
end if;

if (ie_iterar_w = 'S') then
	CALL CALL pls_apropriacao_pck.iterar_regras_coparticipacao('C');
end if;

if (nr_seq_proc_rec_p IS NOT NULL AND nr_seq_proc_rec_p::text <> '') then
	
	if (coalesce(current_setting('pls_apropriacao_pck.pls_rec_glosa_proc_w')::pls_rec_glosa_proc%rowtype.ie_cobranca_prevista,'N') <> 'S') then
			
		ie_status_mensalidade_w := pls_apropriacao_pck.get_ie_status_mensalidade(current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_seq_guia);
		
		ie_cobrar_pos_estab_w	:= pls_obter_se_pos_estab(current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_seq_segurado, current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.cd_estabelecimento, get_dt_autorizacao);
		
		select	nr_seq_conta_rec,
			vl_acatado
		into STRICT	nr_seq_conta_rec_w,
			vl_acatado_w
		from	pls_rec_glosa_proc
		where	nr_sequencia = nr_seq_proc_rec_p;
		
		select	max(a.dt_competencia_lote)
		into STRICT	dt_mes_competencia_w
		from	pls_rec_glosa_protocolo a,
			pls_rec_glosa_conta b
		where	a.nr_sequencia = b.nr_seq_protocolo
		and	b.nr_sequencia = nr_seq_conta_rec_w;
		
		if (ie_cobrar_pos_estab_w = 'N') then
			for regras_copartic_w in regras_copartic(nr_seq_proc_rec_p, nr_seq_mat_rec_p) loop
				begin
				select	*
				into STRICT	pls_regra_copartic_w
				from	pls_regra_copartic
				where	nr_sequencia = regras_copartic_w.nr_seq_regra_copartic;
				exception
				when others then
					pls_regra_copartic_w := null;
				end;
				
				ie_primeira_apropriacao_w := true;
				
				for apropriacoes_procedimento_w in apropriacoes_procedimento(regras_copartic_w.nr_seq_regra_copartic, nr_seq_proc_rec_p) loop
					if (ie_primeira_apropriacao_w) then
					
						vl_coparticipacao_w := 0;
						qt_itens_cobrados_w := 1;
					
						select	count(1)
						into STRICT	qt_registros_w
						from	pls_conta_coparticipacao
						where	nr_seq_proc_rec	= nr_seq_proc_rec_p;
						
						if (qt_registros_w = 0) then						
							select	nextval('pls_conta_coparticipacao_seq')
							into STRICT	nr_seq_conta_coparticipacao_w
							;
							
							insert into pls_conta_coparticipacao(
									nr_sequencia,
									nr_seq_conta_proc,
									vl_coparticipacao,
									tx_coparticipacao,
									nr_seq_conta,
									ie_status_mensalidade,
									ie_origem_regra,
									vl_base_copartic,
									qt_liberada_copartic,
									ie_calculo_coparticipacao,
									nr_seq_regra_copartic,
									nm_usuario,
									nm_usuario_nrec,
									dt_atualizacao,
									dt_atualizacao_nrec,
									ie_ato_cooperado,
									ie_tipo_protocolo,
									ie_tipo_guia,
									dt_mes_competencia,
									ie_tipo_segurado,
									nr_seq_segurado,
									nr_seq_protocolo,
									ie_preco,
									nr_seq_prestador_atend,
									nr_seq_prestador_exec,
									ie_tipo_prestador_atend,
									ie_tipo_prestador_exec,
									nr_seq_conta_rec,
									nr_seq_proc_rec)
								values (	nr_seq_conta_coparticipacao_w,
									nr_seq_conta_proc_p,
									0,
									0,
									current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_sequencia,
									ie_status_mensalidade_w,
									apropriacoes_procedimento_w.ie_origem_regra,
									vl_acatado_w,
									qt_itens_cobrados_w,
									'P',
									apropriacoes_procedimento_w.nr_seq_regra_copartic,
									nm_usuario_p,
									nm_usuario_p,
									clock_timestamp(),
									clock_timestamp(),
									current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.ie_ato_cooperado,
									current_setting('pls_apropriacao_pck.pls_protocolo_conta_w')::pls_protocolo_conta%rowtype.ie_tipo_protocolo,
									null,
									dt_mes_competencia_w,
									current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.ie_tipo_segurado,
									current_setting('pls_apropriacao_pck.pls_segurado_w')::pls_segurado%rowtype.nr_sequencia,
									current_setting('pls_apropriacao_pck.pls_protocolo_conta_w')::pls_protocolo_conta%rowtype.nr_sequencia,
									current_setting('pls_apropriacao_pck.pls_plano_w')::pls_plano%rowtype.ie_preco,
									current_setting('pls_apropriacao_pck.pls_protocolo_conta_w')::pls_protocolo_conta%rowtype.nr_seq_prestador,
									current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_seq_prestador_exec,
									current_setting('pls_apropriacao_pck.ie_tipo_prestador_atend_w')::varchar(2),
									current_setting('pls_apropriacao_pck.ie_tipo_prestador_exec_w')::varchar(2),
									nr_seq_conta_rec_w,
									nr_seq_proc_rec_p);
									
							ie_primeira_apropriacao_w := false;
						end if;					
					end if;
					
					if (nr_seq_conta_coparticipacao_w IS NOT NULL AND nr_seq_conta_coparticipacao_w::text <> '') then
						vl_coparticipacao_w := vl_coparticipacao_w + apropriacoes_procedimento_w.vl_apropriado;
						
						SELECT * FROM pls_apropriacao_pck.valida_regra_copartic_rec(	nr_seq_conta_proc_p, nr_seq_conta_mat_p, regras_copartic_w.nr_seq_regra_copartic, vl_coparticipacao_w, ie_retorno_w, apropriacoes_procedimento_w.nr_seq_centro_apropriacao, apropriacoes_procedimento_w.c_ie_tipo_aprop) INTO STRICT vl_coparticipacao_w, ie_retorno_w;
						
						select	nextval('pls_conta_copartic_aprop_seq')
						into STRICT	nr_seq_conta_copartic_aprop_w
						;
						
						insert into pls_conta_copartic_aprop(	nr_sequencia,nr_seq_conta_coparticipacao,nr_seq_centro_apropriacao,vl_apropriacao,
							nm_usuario,nm_usuario_nrec,dt_atualizacao,dt_atualizacao_nrec)
						values (	nr_seq_conta_copartic_aprop_w,nr_seq_conta_coparticipacao_w,apropriacoes_procedimento_w.nr_seq_centro_aprop,vl_coparticipacao_w,
							nm_usuario_p,nm_usuario_p,clock_timestamp(),clock_timestamp());
					end if;
				end loop;
												
				if ( ie_retorno_w = 'S') then
									
					select 	sum(a.vl_apropriacao)
					into STRICT	vl_copart_w
					from 	pls_conta_copartic_aprop a,
						pls_centro_apropriacao b
					where 	a.nr_seq_conta_coparticipacao	= nr_seq_conta_coparticipacao_w
					and 	a.nr_seq_centro_apropriacao = b.nr_sequencia
					and	b.ie_coparticipacao	= 'S';									

					if (vl_copart_w <> 0) then
						if (coalesce(qt_itens_cobrados_w,0) = 0) then
							qt_itens_cobrados_w	:= 1;
						end if;
						
						update	pls_conta_coparticipacao
						set	vl_coparticipacao_unit	= coalesce((vl_copart_w / qt_itens_cobrados_w),0),
							vl_coparticipacao	= coalesce(vl_copart_w,0),
							tx_coparticipacao	= coalesce(((vl_copart_w / vl_acatado_w) * 100),0),
							vl_provisao		= coalesce(vl_copart_w,0)
						where	nr_sequencia		= nr_seq_conta_coparticipacao_w;
					end if;
				else
					delete	FROM pls_conta_copartic_aprop
					where	nr_seq_conta_coparticipacao = nr_seq_conta_coparticipacao_w;
					
					delete	FROM pls_conta_coparticipacao
					where	nr_sequencia = nr_seq_conta_coparticipacao_w;
					
					delete	FROM pls_conta_proc_aprop
					where	nr_seq_proc_rec = nr_seq_proc_rec_p;
				end if;
			end loop;			
		end if;
	end if;
elsif (nr_seq_mat_rec_p IS NOT NULL AND nr_seq_mat_rec_p::text <> '') then
	
	if (coalesce(current_setting('pls_apropriacao_pck.pls_rec_glosa_mat_w')::pls_rec_glosa_mat%rowtype.ie_cobranca_prevista,'N') <> 'S') then
		
		ie_status_mensalidade_w := pls_apropriacao_pck.get_ie_status_mensalidade(current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_seq_guia);
		
		ie_cobrar_pos_estab_w	:= pls_obter_se_pos_estab(current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_seq_segurado, current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.cd_estabelecimento, get_dt_autorizacao);
		
		select	nr_seq_conta_rec,
			vl_acatado
		into STRICT	nr_seq_conta_rec_w,
			vl_acatado_w
		from	pls_rec_glosa_mat
		where	nr_sequencia = nr_seq_mat_rec_p;
		
		select	max(a.dt_competencia_lote)
		into STRICT	dt_mes_competencia_w
		from	pls_rec_glosa_protocolo a,
			pls_rec_glosa_conta b
		where	a.nr_sequencia = b.nr_seq_protocolo
		and	b.nr_sequencia = nr_seq_conta_rec_w;
		
		if (ie_cobrar_pos_estab_w = 'N') then
		
			for regras_copartic_w in regras_copartic(nr_seq_proc_rec_p, nr_seq_mat_rec_p) loop
				select	*
				into STRICT	pls_regra_copartic_w
				from	pls_regra_copartic
				where	nr_sequencia = regras_copartic_w.nr_seq_regra_copartic;
				
				ie_primeira_apropriacao_w := true;
				
				for apropriacoes_material_w in apropriacoes_material(regras_copartic_w.nr_seq_regra_copartic, nr_seq_mat_rec_p) loop
					if (ie_primeira_apropriacao_w) then
					
						vl_coparticipacao_w := 0;
						qt_itens_cobrados_w := 1;
					
						select	count(1)
						into STRICT	qt_registros_w
						from	pls_conta_coparticipacao
						where	nr_seq_mat_rec = nr_seq_mat_rec_p;
						
						if (qt_registros_w = 0) then
						
							select	nextval('pls_conta_coparticipacao_seq')
							into STRICT	nr_seq_conta_coparticipacao_w
							;
							
							insert into pls_conta_coparticipacao(
									nr_sequencia,
									nr_seq_conta_mat,
									vl_coparticipacao,
									tx_coparticipacao,
									nr_seq_conta,
									ie_status_mensalidade,
									ie_origem_regra,
									vl_base_copartic,
									qt_liberada_copartic,
									ie_calculo_coparticipacao,
									nr_seq_regra_copartic,
									nm_usuario,
									nm_usuario_nrec,
									dt_atualizacao,
									dt_atualizacao_nrec,
									ie_ato_cooperado,
									ie_tipo_protocolo,
									ie_tipo_guia,
									dt_mes_competencia,
									ie_tipo_segurado,
									nr_seq_segurado,
									nr_seq_protocolo,
									ie_preco,
									nr_seq_prestador_atend,
									nr_seq_prestador_exec,
									ie_tipo_prestador_atend,
									ie_tipo_prestador_exec,
									nr_seq_conta_rec,
									nr_seq_mat_rec)
								values (	nr_seq_conta_coparticipacao_w,
									nr_seq_conta_mat_p,
									0,
									0,
									current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_sequencia,
									ie_status_mensalidade_w,
									apropriacoes_material_w.ie_origem_regra,
									vl_acatado_w,
									qt_itens_cobrados_w,
									'P',
									apropriacoes_material_w.nr_seq_regra_copartic,
									nm_usuario_p,
									nm_usuario_p,
									clock_timestamp(),
									clock_timestamp(),
									current_setting('pls_apropriacao_pck.pls_conta_proc_w')::pls_conta_proc%rowtype.ie_ato_cooperado,
									current_setting('pls_apropriacao_pck.pls_protocolo_conta_w')::pls_protocolo_conta%rowtype.ie_tipo_protocolo,
									null,
									dt_mes_competencia_w,
									current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.ie_tipo_segurado,
									current_setting('pls_apropriacao_pck.pls_segurado_w')::pls_segurado%rowtype.nr_sequencia,
									current_setting('pls_apropriacao_pck.pls_protocolo_conta_w')::pls_protocolo_conta%rowtype.nr_sequencia,
									current_setting('pls_apropriacao_pck.pls_plano_w')::pls_plano%rowtype.ie_preco,
									current_setting('pls_apropriacao_pck.pls_protocolo_conta_w')::pls_protocolo_conta%rowtype.nr_seq_prestador,
									current_setting('pls_apropriacao_pck.pls_conta_w')::pls_conta%rowtype.nr_seq_prestador_exec,
									current_setting('pls_apropriacao_pck.ie_tipo_prestador_atend_w')::varchar(2),
									current_setting('pls_apropriacao_pck.ie_tipo_prestador_exec_w')::varchar(2),
									nr_seq_conta_rec_w,
									nr_seq_mat_rec_p);
									
							ie_primeira_apropriacao_w := false;
						end if;
					end if;
					
					if (nr_seq_conta_coparticipacao_w IS NOT NULL AND nr_seq_conta_coparticipacao_w::text <> '') then
						vl_coparticipacao_w	  := vl_coparticipacao_w + apropriacoes_material_w.vl_apropriado;
						
						SELECT * FROM pls_apropriacao_pck.valida_regra_copartic_rec(	nr_seq_conta_proc_p, nr_seq_conta_mat_p, regras_copartic_w.nr_seq_regra_copartic, vl_coparticipacao_w, ie_retorno_w, apropriacoes_material_w.nr_seq_centro_apropriacao, apropriacoes_material_w.c_ie_tipo_aprop) INTO STRICT vl_coparticipacao_w, ie_retorno_w;
						
						select	nextval('pls_conta_copartic_aprop_seq')
						into STRICT	nr_seq_conta_copartic_aprop_w
						;
												
						insert into pls_conta_copartic_aprop(	nr_sequencia,nr_seq_conta_coparticipacao,nr_seq_centro_apropriacao,vl_apropriacao,
								nm_usuario,nm_usuario_nrec,dt_atualizacao,dt_atualizacao_nrec	)
						values (	nr_seq_conta_copartic_aprop_w,nr_seq_conta_coparticipacao_w,apropriacoes_material_w.nr_seq_centro_aprop,vl_coparticipacao_w,
								nm_usuario_p,nm_usuario_p,clock_timestamp(),clock_timestamp());
					end if;
				end loop;
							
				if (ie_retorno_w = 'S') then
				
					select 	sum(a.vl_apropriacao)
					into STRICT	vl_copart_w
					from 	pls_conta_copartic_aprop a,
						pls_centro_apropriacao b
					where 	a.nr_seq_conta_coparticipacao	= nr_seq_conta_coparticipacao_w
					and 	a.nr_seq_centro_apropriacao = b.nr_sequencia
					and	b.ie_coparticipacao	= 'S';
				
					if (vl_copart_w <> 0) then
						update	pls_conta_coparticipacao
						set	vl_coparticipacao_unit	= (vl_copart_w / qt_itens_cobrados_w),
							vl_coparticipacao	= vl_copart_w,
							tx_coparticipacao	= (vl_copart_w / vl_acatado_w) * 100,
							vl_provisao		= vl_copart_w
						where	nr_sequencia		= nr_seq_conta_coparticipacao_w;
					end if;
				else
					delete	FROM pls_conta_copartic_aprop
					where	nr_seq_conta_coparticipacao = nr_seq_conta_coparticipacao_w;
					
					delete	FROM pls_conta_coparticipacao
					where	nr_sequencia = nr_seq_conta_coparticipacao_w;
					
					delete	FROM pls_conta_mat_aprop
					where	nr_seq_mat_rec = nr_seq_mat_rec_p;
				end if;
			end loop;
		end if;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_apropriacao_pck.pls_gerar_copart_aprop_rec ( nr_seq_proc_rec_p pls_rec_glosa_proc.nr_sequencia%type, nr_seq_mat_rec_p pls_rec_glosa_mat.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
