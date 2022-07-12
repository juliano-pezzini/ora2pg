-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.atualiza_soma_evento_item ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nr_seq_item_assist_p sip_item_assistencial.nr_sequencia%type, ie_primeira_vez_p text default 'S') AS $body$
DECLARE

					
qt_evento_w	integer;
					
c_itens CURSOR(	nr_seq_item_assist_pc	sip_item_assistencial.nr_sequencia%type,
		ie_primeira_vez_pc	text) FOR
	SELECT	a.nr_sequencia, a.nr_seq_apres,
		(SELECT count(1)
		 from  	sip_item_assistencial b
		 where 	b.nr_seq_superior = a.nr_sequencia) qt_item_filho
	from	sip_item_assistencial a
	where  	coalesce(a.nr_seq_superior::text, '') = ''
	and   	coalesce(nr_seq_item_assist_pc::text, '') = ''
	
union all

	select	a.nr_sequencia, a.nr_seq_apres,
		(select count(1)
		 from  	sip_item_assistencial b
		 where 	b.nr_seq_superior = a.nr_sequencia) qt_item_filho
	from  	sip_item_assistencial a
	where  	a.nr_seq_superior = nr_seq_item_assist_pc
	
union all

	-- somente chama o pai na primeira vez que executou

	select	a.nr_sequencia, a.nr_seq_apres,
		-- todos os filhos ja foram atualizados

		0 qt_item_filho
	from  	sip_item_assistencial a
	where  	a.nr_sequencia = nr_seq_item_assist_pc
	and	ie_primeira_vez_pc = 'S'
	order by nr_seq_apres desc;
	
c_dados_itens CURSOR(	nr_seq_lote_pc		pls_lote_sip.nr_sequencia%type,
			nr_seq_item_assist_pc	sip_item_assistencial.nr_sequencia%type) FOR
	SELECT	distinct a.ie_tipo_contratacao,
		a.ie_segmentacao_sip,
		a.dt_ocorrencia,
		a.sg_uf
	from 	sip_lote_item_assistencial a
	where	a.nr_seq_lote = nr_seq_lote_pc
	-- busca todos os filhos do item passado de parametro

	and 	a.nr_seq_item_sip = nr_seq_item_assist_pc;

BEGIN
-- varre todos os itens assistenciais respeitando pais e filhos

for r_c_itens_w in c_itens(nr_seq_item_assist_p, ie_primeira_vez_p) loop
	
	-- se tem filhos faz primeiro o somatario dos filhos

	if (r_c_itens_w.qt_item_filho > 0) then
		CALL pls_sip_pck.atualiza_soma_evento_item(nr_seq_lote_p, r_c_itens_w.nr_sequencia, 'N');
	else
		-- abre todos os dados do item em questao

		for r_c_dados_itens_w in c_dados_itens(nr_seq_lote_p, r_c_itens_w.nr_sequencia) loop
			
			-- soma a quantidade de eventos dos filhos do item assistencial

			select 	max(sum(qt_evento))
			into STRICT	qt_evento_w
			from	sip_lote_item_assistencial a
			where	a.nr_seq_lote = nr_seq_lote_p
				-- busca todos os filhos do item passado de parametro

			and 	a.nr_seq_item_sip in (WITH RECURSIVE cte AS (
SELECT 	b.nr_sequencia,1 as level
						      from 	sip_item_assistencial b WHERE b.nr_sequencia = r_c_itens_w.nr_sequencia
  UNION ALL
SELECT 	b.nr_sequencia,(c.level+1)
						      from 	sip_item_assistencial b JOIN cte c ON (c.prior nr_sequencia = b.nr_seq_superior)

) SELECT * FROM cte WHERE level = 2;
)
			and	a.sg_uf = r_c_dados_itens_w.sg_uf
			and	a.dt_ocorrencia = r_c_dados_itens_w.dt_ocorrencia
			and	a.ie_tipo_contratacao = r_c_dados_itens_w.ie_tipo_contratacao
			and	a.ie_segmentacao_sip = r_c_dados_itens_w.ie_segmentacao_sip
			group by a.ie_tipo_contratacao, a.ie_segmentacao_sip, a.dt_ocorrencia, a.sg_uf;
			
			-- atualiza o item pai

			if (qt_evento_w IS NOT NULL AND qt_evento_w::text <> '') and (qt_evento_w > 0) then
				update 	sip_lote_item_assistencial set
					qt_evento = qt_evento_w
				where	nr_seq_lote = nr_seq_lote_p
				and	nr_seq_item_sip = r_c_itens_w.nr_sequencia
				and	ie_tipo_contratacao = r_c_dados_itens_w.ie_tipo_contratacao
				and	ie_segmentacao_sip = r_c_dados_itens_w.ie_segmentacao_sip
				and 	dt_ocorrencia = r_c_dados_itens_w.dt_ocorrencia
				and	sg_uf = r_c_dados_itens_w.sg_uf;
				commit;
			end if;
			
		end loop;
	end if;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.atualiza_soma_evento_item ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nr_seq_item_assist_p sip_item_assistencial.nr_sequencia%type, ie_primeira_vez_p text default 'S') FROM PUBLIC;
