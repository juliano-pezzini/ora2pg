-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_livro_aux_mens ( cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
count_w				bigint	:= 0;

c_valores CURSOR FOR 
	SELECT	a.cd_guia, 
		c.cd_procedimento cd_item, 
		c.ds_procedimento ds_item, 
		a.dt_atendimento dt_realizacao, 
		coalesce(a.dt_emissao,a.dt_atendimento_referencia) dt_aviso, 
		substr(pls_obter_dados_segurado(d.nr_sequencia, 'C'),1,30) cd_carteira, 
		substr(e.nm_pessoa_fisica,1,80) nm_beneficiario, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'N'),1,255) nm_prestador, 
		(SELECT	substr(x.ds_evento,1,100) 
		from	pls_evento		x 
		where	x.nr_sequencia	= b.nr_seq_evento) ds_operacao, 
		(select	substr(x.ds_grupo,1,255) 
		from	ans_grupo_despesa	x 
		where	x.nr_sequencia	= b.nr_seq_grupo_ans) ds_tipo_proc, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'TR'),1,255) ds_tipo_relacao, 
		substr(obter_valor_dominio(3418, b.ie_ato_cooperado),1,255) ds_ato_cooperado, 
		substr(obter_valor_dominio(1669, g.ie_preco),1,18) ds_preco, 
		substr(obter_valor_dominio(2157, g.ie_regulamentacao),1,255) ds_regulamentacao, 
		substr(obter_valor_dominio(1666, g.ie_tipo_contratacao),1,255) ds_tipo_contratacao, 
		substr(obter_valor_dominio(1665, g.ie_segmentacao),1,255) ds_segmentacao, 
		(select	sum(r.vl_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'D') or (substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'C')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) vl_evento, 
		(select	max(s.dt_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'D') or (substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'C')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) dt_movimento, 
		(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '4.1.1.1.1' 
		and	s.ie_debito_credito		= 'D' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_deb, 
		(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_PROC' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '2.1.1.1.1' 
		and	s.ie_debito_credito		= 'C' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_cred 
	FROM pls_plano g, pessoa_fisica e, pls_segurado d, procedimento c, pls_conta_proc b, pls_conta a
LEFT OUTER JOIN pls_prestador f ON (a.nr_seq_prestador_exec = f.nr_sequencia)
WHERE a.nr_sequencia		= b.nr_seq_conta and c.cd_procedimento	= b.cd_procedimento and c.ie_origem_proced	= b.ie_origem_proced and d.nr_sequencia		= a.nr_seq_segurado and e.cd_pessoa_fisica	= d.cd_pessoa_fisica  and g.nr_sequencia		= a.nr_seq_plano and exists	(select	1 
			from	movimento_contabil_doc		r, 
				movimento_contabil		s, 
				lote_contabil			t 
			where	s.nr_sequencia			= r.nr_seq_movimento 
			and	s.nr_lote_contabil		= t.nr_lote_contabil 
			and	r.nr_lote_contabil		= t.nr_lote_contabil 
			and	b.nr_sequencia			= r.nr_documento 
			and	r.nm_tabela			= 'PLS_CONTA_PROC' 
			and	r.nm_atributo			!= 'VL_GLOSA' 
			and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'D') or (substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'C')) 
			and	t.dt_referencia between dt_inicial_p and dt_final_p) 
	 
union all
 
	select	a.cd_guia, 
		c.cd_material, 
		c.ds_material, 
		a.dt_atendimento dt_realizacao, 
		coalesce(a.dt_emissao,a.dt_atendimento_referencia) dt_aviso, 
		substr(pls_obter_dados_segurado(d.nr_sequencia, 'C'),1,30) cd_carteira, 
		substr(e.nm_pessoa_fisica,1,80) nm_beneficiario, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'N'),1,255) nm_prestador, 
		(select	substr(x.ds_evento,1,100) 
		from	pls_evento		x 
		where	x.nr_sequencia	= b.nr_seq_evento) ds_operacao, 
		(select	substr(x.ds_grupo,1,255) 
		from	ans_grupo_despesa	x 
		where	x.nr_sequencia	= b.nr_seq_grupo_ans) ds_tipo_proc, 
		substr(pls_obter_dados_prestador(f.nr_sequencia, 'TR'),1,255) ds_tipo_relacao, 
		substr(obter_valor_dominio(3418, b.ie_ato_cooperado),1,255) ds_ato_cooperado, 
		substr(obter_valor_dominio(1669, g.ie_preco),1,18) ds_preco, 
		substr(obter_valor_dominio(2157, g.ie_regulamentacao),1,255) ds_regulamentacao, 
		substr(obter_valor_dominio(1666, g.ie_tipo_contratacao),1,255) ds_tipo_contratacao, 
		substr(obter_valor_dominio(1665, g.ie_segmentacao),1,255) ds_segmentacao, 
		(select	sum(r.vl_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'D') or (substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'C')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) vl_evento, 
		(select	max(s.dt_movimento) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'D') or (substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'C')) 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) dt_movimento, 
		(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '4.1.1.1.1' 
		and	s.ie_debito_credito		= 'D' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_deb, 
		(select	max(s.cd_classificacao) 
		from	movimento_contabil_doc		r, 
			movimento_contabil		s, 
			lote_contabil			t 
		where	s.nr_sequencia			= r.nr_seq_movimento 
		and	s.nr_lote_contabil		= t.nr_lote_contabil 
		and	r.nr_lote_contabil		= t.nr_lote_contabil 
		and	b.nr_sequencia			= r.nr_documento 
		and	r.nm_tabela			= 'PLS_CONTA_MAT' 
		and	r.nm_atributo			!= 'VL_GLOSA' 
		and	substr(s.cd_classificacao,1,9)	= '2.1.1.1.1' 
		and	s.ie_debito_credito		= 'C' 
		and	t.dt_referencia between dt_inicial_p and dt_final_p) cd_conta_cred 
	FROM pls_plano g, pessoa_fisica e, pls_segurado d, pls_material c, pls_conta_mat b, pls_conta a
LEFT OUTER JOIN pls_prestador f ON (a.nr_seq_prestador_exec = f.nr_sequencia)
WHERE a.nr_sequencia		= b.nr_seq_conta and c.nr_sequencia		= b.nr_seq_material and d.nr_sequencia		= a.nr_seq_segurado and e.cd_pessoa_fisica	= d.cd_pessoa_fisica  and g.nr_sequencia		= a.nr_seq_plano and exists	(select	1 
			from	movimento_contabil_doc		r, 
				movimento_contabil		s, 
				lote_contabil			t 
			where	s.nr_sequencia			= r.nr_seq_movimento 
			and	s.nr_lote_contabil		= t.nr_lote_contabil 
			and	r.nr_lote_contabil		= t.nr_lote_contabil 
			and	b.nr_sequencia			= r.nr_documento 
			and	r.nm_tabela			= 'PLS_CONTA_MAT' 
			and	r.nm_atributo			!= 'VL_GLOSA' 
			and	((substr(s.cd_classificacao,1,9) = '4.1.1.1.1' and s.ie_debito_credito	= 'D') or (substr(s.cd_classificacao,1,9) = '2.1.1.1.1' and s.ie_debito_credito	= 'C')) 
			and	t.dt_referencia between dt_inicial_p and dt_final_p);

type 		fetch_array is table of c_valores%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_valores_w	vetor;

BEGIN 
delete	from w_ctb_livro_aux_mens 
where	nm_usuario	= nm_usuario_p;
 
open c_valores;
loop 
fetch c_valores bulk collect into s_array limit 1000;
	vetor_valores_w(i)	:= s_array;
	i			:= i + 1;
EXIT WHEN NOT FOUND; /* apply on c_valores */
end loop;
close c_valores;
 
for i in 1..vetor_valores_w.count loop 
	begin 
	s_array := vetor_valores_w(i);
	for z in 1..s_array.count loop 
		begin 
		insert into w_ctb_livro_aux_mens(nm_usuario, 
			cd_estabelecimento, 
			dt_atualizacao, 
			cd_guia, 
			cd_item, 
			ds_item, 
			dt_realizacao, 
			dt_aviso, 
			cd_carteira, 
			nm_beneficiario, 
			nm_prestador, 
			ds_operacao, 
			ds_tipo_proc, 
			ds_tipo_relacao, 
			ds_ato_cooperado, 
			ds_preco, 
			ds_regulamentacao, 
			ds_tipo_contratacao, 
			ds_segmentacao, 
			vl_evento, 
			dt_movimento, 
			cd_conta_deb, 
			cd_conta_cred) 
		values (nm_usuario_p, 
			cd_estabelecimento_p, 
			clock_timestamp(), 
			s_array[z].cd_guia, 
			s_array[z].cd_item, 
			s_array[z].ds_item, 
			s_array[z].dt_realizacao, 
			s_array[z].dt_aviso, 
			s_array[z].cd_carteira, 
			s_array[z].nm_beneficiario, 
			s_array[z].nm_prestador, 
			s_array[z].ds_operacao, 
			s_array[z].ds_tipo_proc, 
			s_array[z].ds_tipo_relacao, 
			s_array[z].ds_ato_cooperado, 
			s_array[z].ds_preco, 
			s_array[z].ds_regulamentacao, 
			s_array[z].ds_tipo_contratacao, 
			s_array[z].ds_segmentacao, 
			s_array[z].vl_evento, 
			s_array[z].dt_movimento, 
			s_array[z].cd_conta_deb, 
			s_array[z].cd_conta_cred);
		 
		count_w	:= count_w + 1;
		 
		if (count_w = 1000) then 
			count_w	:= 0;
			 
			commit;
		end if;
		end;
	end loop;
	end;
end loop;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_livro_aux_mens ( cd_empresa_p bigint, cd_estabelecimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;
