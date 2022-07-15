-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_respostas_questionario ( atend_questao_lista_p text, questao_opcao_lista_p text, tasy_padrao_cor_lista_p text, ds_respostas_p text, nr_seq_questionario_gerado_p bigint, nm_usuario_p text) AS $body$
DECLARE

atend_questao_lista_w		dbms_sql.varchar2_table;
questao_opcao_lista_w		dbms_sql.varchar2_table;
tasy_padrao_cor_lista_w		dbms_sql.varchar2_table;
ds_respostas_w			dbms_sql.varchar2_table;
nr_seq_que_atend_questao_w	que_atendimento_questao_op.nr_seq_que_atend_questao%type;
nr_seq_que_questao_opcao_w	que_atendimento_questao_op.nr_seq_que_questao_opcao%type;
nr_seq_tasy_padrao_cor_w	que_atendimento_questao_op.nr_seq_tasy_padrao_cor%type;
ds_resposta_w			que_atendimento_questao_op.ds_resposta%type;
i				integer;


BEGIN
delete	from que_atendimento_questao_op a
where	a.nr_seq_que_atend_questao in (	SELECT	x.nr_sequencia
					from	que_atendimento_questao x,
						que_questao q
					where	x.nr_seq_que_atendimento = nr_seq_questionario_gerado_p
					and	q.nr_sequencia = x.nr_seq_questao
					and (q.ie_local_resposta = 'A' or q.ie_tipo_resposta <> 'D'));


atend_questao_lista_w	:= obter_lista_string(atend_questao_lista_p, ',');
questao_opcao_lista_w	:= obter_lista_string(questao_opcao_lista_p, ',');
tasy_padrao_cor_lista_w	:= obter_lista_string(tasy_padrao_cor_lista_p, ',');
ds_respostas_w		:= obter_lista_string(ds_respostas_p, ',');

for	i in atend_questao_lista_w.first..atend_questao_lista_w.last loop
	nr_seq_que_atend_questao_w	:= (atend_questao_lista_w(i))::numeric;
	nr_seq_que_questao_opcao_w	:= (questao_opcao_lista_w(i))::numeric;
	nr_seq_tasy_padrao_cor_w	:= (tasy_padrao_cor_lista_w(i))::numeric;
	ds_resposta_w			:= ds_respostas_w(i);

	if (ds_resposta_w <> ' ') or (nr_seq_que_questao_opcao_w <> 0) then
		insert	into que_atendimento_questao_op(      nr_sequencia,
							       dt_atualizacao,
							       nm_usuario,
							       dt_atualizacao_nrec,
							       nm_usuario_nrec,
							       ds_resposta,
							       nr_seq_que_atend_questao,
							       nr_seq_que_questao_opcao,
							       ds_observacao,
							       nr_seq_tasy_padrao_cor)
			values (	nextval('que_atendimento_questao_op_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					CASE WHEN ds_resposta_w=' ' THEN  null  ELSE ds_resposta_w END ,
					nr_seq_que_atend_questao_w,
					CASE WHEN nr_seq_que_questao_opcao_w=0 THEN  null  ELSE nr_seq_que_questao_opcao_w END ,
					null,
					CASE WHEN nr_seq_tasy_padrao_cor_w=0 THEN  null  ELSE nr_seq_tasy_padrao_cor_w END );
	end if;
end loop;

delete	from que_atendimento_questao
where	nr_sequencia in (	SELECT  a.nr_sequencia
				from    que_atendimento_questao a,
					que_questao b
				where   b.nr_sequencia = a.nr_seq_questao
				and     a.nr_seq_que_atendimento = nr_seq_questionario_gerado_p
				and     b.qt_nivel > 1
				and not exists (	select  1
							from    que_atendimento_questao x,
								que_questao y,
								que_atendimento_questao_op z
							where   y.nr_sequencia = x.nr_seq_questao
							and     z.nr_seq_que_atend_questao = x.nr_sequencia
							and     x.nr_seq_que_atendimento = nr_seq_questionario_gerado_p
							and	x.nr_seq_questao = b.nr_seq_questao_sup
							and	z.nr_seq_que_questao_opcao = b.nr_seq_questao_opcao ));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_respostas_questionario ( atend_questao_lista_p text, questao_opcao_lista_p text, tasy_padrao_cor_lista_p text, ds_respostas_p text, nr_seq_questionario_gerado_p bigint, nm_usuario_p text) FROM PUBLIC;

