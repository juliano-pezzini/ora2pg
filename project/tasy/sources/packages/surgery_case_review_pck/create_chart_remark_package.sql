-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE surgery_case_review_pck.create_chart_remark (nr_cirurgia_p cirurgia.nr_cirurgia%type, nr_sequencia_p w_flowsheet_cirurgia_reg.nr_sequencia%type, nm_usuario_p revisao_cirurgia_obs.nm_usuario%type, ie_type_p text, ds_comment_p revisao_cirurgia_obs.ds_observao%type) AS $body$
DECLARE


w_nr_seq_origin revisao_cirurgia.nr_seq_origem%type;
w_nm_tabela 	w_flowsheet_cirurgia_info.nm_tabela%type;
w_nr_seq_sup 	w_flowsheet_cirurgia_info.nr_seq_superior%type;
w_nr_seq_review revisao_cirurgia.nr_sequencia%type;
w_dt_inicio		w_flowsheet_cirurgia_reg.dt_inicio%type;
w_dt_fim 		w_flowsheet_cirurgia_reg.dt_fim%type;
w_nr_seq_new 	revisao_cirurgia_obs.nr_sequencia%type;

sql_w varchar(4000);
count_w bigint;
							
							  

BEGIN


select CASE WHEN fcr.cd_grupo=1 THEN null  ELSE fcr.cd_grupo END , CASE WHEN fci.nm_tabela='CIRURGIA_AGENTE_ANESTESICO' THEN  'CIRURGIA_AGENTE_ANEST_OCOR'  ELSE fci.nm_tabela END , coalesce(fci.nr_seq_superior, coalesce(fci.nr_seq_resultado,fci.nr_seq_dispositivo)), fcr.dt_inicio, fcr.dt_fim 
into STRICT w_nr_seq_origin, w_nm_tabela, w_nr_seq_sup, w_dt_inicio, w_dt_fim
from w_flowsheet_cirurgia_reg fcr
inner join w_flowsheet_cirurgia_info fci on fcr.nr_seq_info = fci.nr_sequencia
where fcr.nr_sequencia = nr_sequencia_p;

select max(nr_sequencia) into STRICT w_nr_seq_review from revisao_cirurgia where nr_seq_origem = coalesce(w_nr_seq_origin, w_nr_seq_sup);

if (coalesce(w_nr_seq_review::text, '') = '') then

	if (w_nm_tabela <> 'DISPOSITIVO') then
	sql_w := 'select count(1) from '|| w_nm_tabela || ' where nr_sequencia = '|| w_nr_seq_sup ||' and dt_liberacao is not null';

		begin
		 EXECUTE sql_w into STRICT count_w;
		 exception when others then
		 count_w := 0;
		end;
		
		if (count_w = 0) then
			CALL liberar_informacao(w_nm_tabela,'NR_SEQUENCIA',w_nr_seq_sup,nm_usuario_p);
		end if;
	end if;
		CALL surgery_case_review_pck.external_disable(nr_cirurgia_p, nm_usuario_p);
		CALL surgery_case_review_pck.generate_case_review(nr_cirurgia_p, nm_usuario_p);			
		select max(nr_sequencia) into STRICT w_nr_seq_review from revisao_cirurgia where nr_seq_origem = coalesce(w_nr_seq_origin, w_nr_seq_sup);
end if;
	if (w_nr_seq_review IS NOT NULL AND w_nr_seq_review::text <> '') then
		insert into revisao_cirurgia_obs(nr_sequencia,
										  dt_atualizacao, 
										  nm_usuario, 
										  dt_atualizacao_nrec, 
										  nm_usuario_nrec, 
										  cd_profissional, 
										  ds_observao, 
										  nr_seq_revisao, 
										  dt_liberacao, 
										  dt_inativacao, 
										  nm_usuario_inativacao, 
										  ds_justificativa, 
										  ie_situacao, 
										  ie_etapa ) 
								values (nextval('revisao_cirurgia_obs_seq'),
										  clock_timestamp(),
										  nm_usuario_p,
										  clock_timestamp(),
										  nm_usuario_p,
										  obter_pf_usuario(nm_usuario_p, 'C'),
										  ds_comment_p,
										  w_nr_seq_review,
										  null,
										  null,
										  null,
										  null,
										  'A',
										  CASE WHEN ie_type_p='RI' THEN  'I'  ELSE 'F' END 
										  ) returning nr_sequencia into w_nr_seq_new;

		CALL liberar_informacao('REVISAO_CIRURGIA_OBS','NR_SEQUENCIA',w_nr_seq_new,nm_usuario_p);

		update w_flowsheet_cirurgia_reg
		   set ds_comentario = get_valor_comentario_graf(nr_cirurgia_p,coalesce(w_nr_seq_origin, w_nr_seq_sup),w_nm_tabela,null), 
				ds_comentario_end = get_valor_comentario_graf(nr_cirurgia_p,coalesce(w_nr_seq_origin, w_nr_seq_sup),w_nm_tabela,null, 'F')
		 where nr_sequencia = nr_sequencia_p;
	end if;	
commit;
END;						

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE surgery_case_review_pck.create_chart_remark (nr_cirurgia_p cirurgia.nr_cirurgia%type, nr_sequencia_p w_flowsheet_cirurgia_reg.nr_sequencia%type, nm_usuario_p revisao_cirurgia_obs.nm_usuario%type, ie_type_p text, ds_comment_p revisao_cirurgia_obs.ds_observao%type) FROM PUBLIC;