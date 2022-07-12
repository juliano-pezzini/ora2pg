-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_consiste_hemocomp_isbt ( cd_identificacao_isbt_p text, cd_produto_isbt_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_grupo_p text, dt_vencimento_p text, dt_vencimento_hora_p text, dt_coleta_p text, dt_coleta_hora_p text, cd_ger_isbt_p text, cd_isbt_atigeno_p text) RETURNS bigint AS $body$
DECLARE

ie_rest_estab_w   varchar(2);
nr_retorno_w      san_producao.nr_sequencia%TYPE;
ie_possui_regra_w varchar(1);
ds_sql_w          varchar(2500);
cursor_w          sql_pck.t_cursor;
bind_sql_w        sql_pck.t_dado_bind;


BEGIN 

ie_rest_estab_w := Obter_param_usuario(450, 74, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_rest_estab_w);

SELECT Coalesce(Max('S'), 'N') 
INTO STRICT   ie_possui_regra_w 
FROM   san_regra_visual_estab 
WHERE  cd_estabelecimento = cd_estabelecimento_p 
AND ie_situacao = 'A';

        ds_sql_w	:=	'	select 	max(nr_sequencia) '||chr(10)||
				'	from   	san_producao_v a  '||chr(10)||
				'	where  	nr_seq_inutil is null 	'||chr(10)||
				'	and    	nr_seq_propaci is null	'||chr(10)||
				'	and		ie_bloqueado = ''N'' '||chr(10)||
				'	and    	san_obter_se_analise_bloqueio(a.nr_sequencia,''P'') = ''N'' '||chr(10)||
				'	and		nr_seq_transfusao is null '||chr(10)||
				'	and		nr_seq_emp_saida is null '||chr(10)||
				'	and 	not exists  (	select	1  '||chr(10)||
				'							from	san_reserva_prod b  '||chr(10)||
				'							where	b.nr_seq_producao = a.nr_sequencia 	'||chr(10)||
				'							and		b.nr_seq_propaci is not null 	'||chr(10)||
				'							and 	b.ie_status <> ''N'')	'||chr(10)||
				'	and 	nvl(a.ie_encaminhado,''N'') = ''N''       '||chr(10)||
				'	and		a.cd_identificacao_isbt = substr(:cd_identificacao_isbt_pc,1,13) '||chr(10)||
				'	and		a.cd_produto_isbt || (select max(SUBSTR(NVL(c.cd_isbt,''0''),1,1)) from san_tipo_doacao c where a.nr_seq_tipo	= c.nr_sequencia) || ' || chr(10) ||
       				'               (select max(NVL(b.cd_divisao_isbt,''00'')) from san_producao b where a.nr_seq_doacao = b.nr_seq_doacao) = :cd_produto_isbt_pc' || chr(10) ||
				'	and 	san_obter_dt_venc_producao(a.nr_sequencia) >= sysdate 		'||chr(10)||
				'	and		dt_liberacao is null '||chr(10);

if (cd_grupo_p IS NOT NULL AND cd_grupo_p::text <> '') then
  ds_sql_w	:= ds_sql_w ||chr(10)||' and SUBSTR(san_obter_cd_sangue_isbt( a.ie_tipo_sangue, a.ie_fator_rh, a.nr_seq_tipo_isbt),1,2)|| ''00'' = :cd_grupo_p ';
end if;

if (dt_vencimento_p IS NOT NULL AND dt_vencimento_p::text <> '') then
  ds_sql_w	:= ds_sql_w ||chr(10)||' and to_char( a.dt_vencimento,''yyy'')|| to_char( a.dt_vencimento,''ddd'') = :dt_vencimento_p ';
end if;

if (dt_vencimento_hora_p IS NOT NULL AND dt_vencimento_hora_p::text <> '') then
  ds_sql_w	:= ds_sql_w ||chr(10)||' and to_char( a.dt_vencimento,''yyy'')||to_char( a.dt_vencimento,''ddd'')||to_char( a.dt_vencimento,''hh24mi'') =  :dt_vencimento_hora_p ';
end if;

if (dt_coleta_p IS NOT NULL AND dt_coleta_p::text <> '') then
  ds_sql_w	:= ds_sql_w ||chr(10)||' and to_char( a.dt_coleta_isbt,''yyy'')||to_char( a.dt_coleta_isbt,''ddd'') =  :dt_coleta_p ';
end if;

if (dt_coleta_hora_p IS NOT NULL AND dt_coleta_hora_p::text <> '') then
  ds_sql_w	:= ds_sql_w ||chr(10)||' and to_char( a.dt_coleta_isbt,''yyy'')||to_char( a.dt_coleta_isbt,''ddd'')||to_char( a.dt_coleta_isbt,''hh24mi'') = :dt_coleta_hora_p ';
end if;

if (cd_ger_isbt_p IS NOT NULL AND cd_ger_isbt_p::text <> '') then
  ds_sql_w	:= ds_sql_w ||chr(10)||' and  exists(select 1 from san_doacao x where x.nr_sequencia = a.nr_seq_doacao and x.cd_test_esp_ger_isbt = :cd_test_esp_ger_isbt_p)';
end if;

if (cd_isbt_atigeno_p IS NOT NULL AND cd_isbt_atigeno_p::text <> '') then
  ds_sql_w	:= ds_sql_w ||chr(10)||' and  exists(select 1 from san_doacao x where x.nr_sequencia = a.nr_seq_doacao and x.cd_isbt_antigeno = :cd_isbt_antigeno_p)';
end if;


if (ie_rest_estab_w = 'S') then

	ds_sql_w	:= ds_sql_w ||chr(10)||' and (nvl(a.cd_estab_atual, nvl(a.cd_estab_producao,a.cd_estabelecimento)) = :cd_estabelecimento_pc	) ';

elsif (ie_rest_estab_w = 'R') then

	if (ie_possui_regra_w = 'S') then

	ds_sql_w	:= ds_sql_w ||chr(10)||' and (nvl(a.cd_estab_atual, nvl(a.cd_estab_producao,a.cd_estabelecimento)) in ( select  x.cd_estab_regra '||chr(10)||
															'	from    san_regra_visual_estab x 		'||chr(10)||
															'	where   x.cd_estabelecimento = :cd_estabelecimento_pc 	'||chr(10)||
															'	and     x.ie_situacao = ''A''				'||chr(10)||
															'	union 	                                                '||chr(10)||
															'	select  to_number(:cd_estabelecimento_pc)		'||chr(10)||
															'	from    dual))';
	else

		ds_sql_w	:= ds_sql_w ||chr(10)||' and (nvl(a.cd_estab_atual, nvl(a.cd_estab_producao,a.cd_estabelecimento)) = :cd_estabelecimento_pc )';

	end if;

end if;

bind_sql_w := sql_pck.bind_variable(':cd_identificacao_isbt_pc', cd_identificacao_isbt_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':cd_produto_isbt_pc', cd_produto_isbt_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':cd_estabelecimento_pc', cd_estabelecimento_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':cd_grupo_p', cd_grupo_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':dt_vencimento_p', dt_vencimento_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':dt_vencimento_hora_p', dt_vencimento_hora_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':dt_coleta_p', dt_coleta_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':dt_coleta_hora_p', dt_coleta_hora_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':cd_test_esp_ger_isbt_p', cd_ger_isbt_p, bind_sql_w);

bind_sql_w := sql_pck.bind_variable(':cd_isbt_antigeno_p', cd_isbt_atigeno_p, bind_sql_w);

bind_sql_w := sql_pck.executa_sql_cursor(ds_sql_w, bind_sql_w);


LOOP
    FETCH cursor_w INTO nr_retorno_w;

    EXIT WHEN NOT FOUND; /* apply on cursor_w */

    NULL;
END LOOP;

close cursor_w;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_consiste_hemocomp_isbt ( cd_identificacao_isbt_p text, cd_produto_isbt_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_grupo_p text, dt_vencimento_p text, dt_vencimento_hora_p text, dt_coleta_p text, dt_coleta_hora_p text, cd_ger_isbt_p text, cd_isbt_atigeno_p text) FROM PUBLIC;

