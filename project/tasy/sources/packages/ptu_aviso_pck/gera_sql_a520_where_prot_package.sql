-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.gera_sql_a520_where_prot ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o SQL, parte do WHERE relacionada ao protocolo.
		
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ds_sql_w		varchar(32000);
qt_apresentacao_w	integer;
qt_origem_protocolo_w	integer;
qt_ie_status_w		integer;
qt_ie_tipo_guia_w	integer;
qt_nr_seq_prestador_w	integer;
in_apresentacao_w	varchar(4000);
in_origem_protocolo_w	varchar(4000);
in_ie_status_w		varchar(4000);
in_ie_tipo_guia_w	varchar(4000);


ds_and_w		varchar(10);
prot_w			alias_t%type;

BEGIN

ds_sql_w	:= '';
prot_w		:= alias_p.protocolo;

--carrega as inf das regras de protocolo, ja proprias para binding

	-- quantidade de regras com apresentacao

select	max((	select	count(1)
		from	ptu_regra_aviso_cob_prot	x
		where	x.nr_seq_regra			= a.nr_seq_regra
		and	(x.ie_apresentacao IS NOT NULL AND x.ie_apresentacao::text <> '')
		and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao)) qt_apresentacao,
	-- quantidade de regras com origem protocolo

	max((	select	count(1)
		from	ptu_regra_aviso_cob_prot	x
		where	x.nr_seq_regra			= a.nr_seq_regra
		and	(x.ie_origem_protocolo IS NOT NULL AND x.ie_origem_protocolo::text <> '')
		and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao)) qt_origem_protocolo,
	-- quantidade de regras para status

	max((	select	count(1)
		from	ptu_regra_aviso_cob_prot	x
		where	x.nr_seq_regra			= a.nr_seq_regra
		and	(x.ie_status IS NOT NULL AND x.ie_status::text <> '')
		and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao)) qt_ie_status,
	-- quantidade de regras para tipo de guia

	max((	select	count(1)
		from	ptu_regra_aviso_cob_prot	x
		where	x.nr_seq_regra			= a.nr_seq_regra
		and	(x.ie_tipo_guia IS NOT NULL AND x.ie_tipo_guia::text <> '')
		and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao)) qt_ie_tipo_guia,
	-- quantidade de regras para prestador

	max((	select	count(1)
		from	ptu_regra_aviso_cob_prot	x
		where	x.nr_seq_regra			= a.nr_seq_regra
		and	(x.nr_seq_prestador IS NOT NULL AND x.nr_seq_prestador::text <> '')
		and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao)) qt_nr_seq_prestador,
	-- Levante das regras por apresentacao

	max((WITH RECURSIVE cte AS (
select	substr(''''||t.ie_apresentacao,3)||''''
		from (	select	x.ie_apresentacao,
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_apresentacao) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_apresentacao IS NOT NULL AND x.ie_apresentacao::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_apresentacao, x.nr_seq_regra) t WHERE t.seq = 1
  UNION ALL
select	c. || ''',' || substr(''''||t.ie_apresentacao,3)||''''
		from (	select	x.ie_apresentacao, 
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_apresentacao) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_apresentacao IS NOT NULL AND x.ie_apresentacao::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_apresentacao, x.nr_seq_regra) JOIN cte c ON (c.prior seq + 1 = t.seq)

) SELECT * FROM cte WHERE seq	= cnt;
)) in_apresentacao,
	-- Levante das regras por origem protocolo

	max((WITH RECURSIVE cte AS (
(select	substr(''''||t.ie_origem_protocolo,3)||''''
		from (	select	x.ie_origem_protocolo, 
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_origem_protocolo) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_origem_protocolo IS NOT NULL AND x.ie_origem_protocolo::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_origem_protocolo, x.nr_seq_regra) t WHERE t.seq = 1
  UNION ALL
(select	c. || ''',' || substr(''''||t.ie_origem_protocolo,3)||''''
		from (	select	x.ie_origem_protocolo, 
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_origem_protocolo) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_origem_protocolo IS NOT NULL AND x.ie_origem_protocolo::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_origem_protocolo, x.nr_seq_regra) JOIN cte c ON (c.prior seq + 1 = t.seq))

) SELECT * FROM cte WHERE seq	= cnt;
)) in_origem_protocolo,
	-- Levante das regras por status

	max((WITH RECURSIVE cte AS (
(select	substr(''''||t.ie_status,3)||''''
		from (	select	x.ie_status, 
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_status) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_status IS NOT NULL AND x.ie_status::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_status, x.nr_seq_regra) t WHERE t.seq = 1
  UNION ALL
(select	c. || ''',' || substr(''''||t.ie_status,3)||''''
		from (	select	x.ie_status, 
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_status) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_status IS NOT NULL AND x.ie_status::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_status, x.nr_seq_regra) JOIN cte c ON (c.prior seq + 1 = t.seq))

) SELECT * FROM cte WHERE seq	= cnt;
)) in_ie_status,
	-- Levante das regras por tipo de guia

	max((WITH RECURSIVE cte AS (
(select	substr(''''||t.ie_tipo_guia,3)||''''
		from (	select	x.ie_tipo_guia, 
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_tipo_guia) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_tipo_guia IS NOT NULL AND x.ie_tipo_guia::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_tipo_guia, x.nr_seq_regra) t WHERE t.seq = 1
  UNION ALL
(select	c. || ''',' || substr(''''||t.ie_tipo_guia,3)||''''
		from (	select	x.ie_tipo_guia, 
				count(1) over (partition by x.nr_seq_regra) cnt,
				row_number() over (partition by x.nr_seq_regra order by x.ie_tipo_guia) seq
			from	ptu_regra_aviso_cob_prot	x
			where	x.nr_seq_regra			= dados_a520_p.nr_seq_regra
			and	(x.ie_tipo_guia IS NOT NULL AND x.ie_tipo_guia::text <> '')
			and	x.ie_excecao			= dados_gerais_a520_p.ie_excecao
			group by x.ie_tipo_guia, x.nr_seq_regra) JOIN cte c ON (c.prior seq + 1 = t.seq))

) SELECT * FROM cte WHERE seq	= cnt;
)) in_ie_tipo_guia
into STRICT	qt_apresentacao_w,
	qt_origem_protocolo_w,
	qt_ie_status_w,
	qt_ie_tipo_guia_w,
	qt_nr_seq_prestador_w,
	in_apresentacao_w,
	in_origem_protocolo_w,
	in_ie_status_w,
	in_ie_tipo_guia_w	
from	ptu_lote_aviso	a
where	a.nr_sequencia	= dados_a520_p.nr_seq_lote;


ds_and_w := '';

-- monta o sql conforme inf das regras

if (qt_apresentacao_w > 0) then

	ds_sql_w := ds_sql_w||ds_and_w||prot_w||'.ie_apresentacao in ('||in_apresentacao_w||') '||pls_util_pck.enter_w;
	ds_and_w := 'and	';
end if;

if (qt_origem_protocolo_w > 0) then

	ds_sql_w := ds_sql_w||ds_and_w||prot_w||'.ie_origem_protocolo in ('||in_origem_protocolo_w||') '||pls_util_pck.enter_w;
	ds_and_w := 'and	';
end if;

if (qt_ie_status_w > 0) then

	ds_sql_w := ds_sql_w||ds_and_w||prot_w||'.ie_status in ('||in_ie_status_w||') '||pls_util_pck.enter_w;
	ds_and_w := 'and	';
end if;


if (qt_ie_tipo_guia_w > 0) then

	ds_sql_w := ds_sql_w||ds_and_w||prot_w||'.ie_tipo_guia in ('||in_ie_tipo_guia_w||') '||pls_util_pck.enter_w;
	ds_and_w := 'and	';
end if;


if (qt_nr_seq_prestador_w > 0) then

	ds_sql_w := ds_sql_w||ds_and_w||'exists (	select	1 ' || pls_util_pck.enter_w ||
					'		from	ptu_regra_aviso_cob_prot	x ' || pls_util_pck.enter_w ||
					'		where	x.nr_seq_prestador		= '||prot_w||'.nr_seq_prestador ' || pls_util_pck.enter_w ||
					'		and	x.nr_seq_regra			= :nr_seq_regra )'|| pls_util_pck.enter_w;
					
	dados_bind_p := sql_pck.bind_variable(':nr_seq_regra', dados_a520_p.nr_seq_regra, dados_bind_p);
	ds_and_w := 'and	';
end if;


-- Verifica os filtros adicionais

if (dados_a520_p.qt_prot_adic > 0) then

	ds_sql_w := ds_sql_w||ds_and_w||'exists(	select 	1 ' 							|| pls_util_pck.enter_w ||
					'		from	ptu_lote_aviso_adic y ' 				|| pls_util_pck.enter_w ||
					'		where	y.nr_seq_protocolo	= '||prot_w||'.nr_sequencia' 	|| pls_util_pck.enter_w ||
					'		and	y.nr_seq_lote		= :nr_seq_lote ' 		|| pls_util_pck.enter_w ||
					'		and	y.nr_seq_protocolo is not null) ' 			|| pls_util_pck.enter_w;
					
	dados_bind_p := sql_pck.bind_variable(':nr_seq_lote', dados_a520_p.nr_seq_lote, dados_bind_p);
	ds_and_w := 'and	';
end if;

-- Verifica os filtros de excecao

if (dados_a520_p.qt_prot_exce > 0) then

	ds_sql_w := ds_sql_w||ds_and_w||'not exists(	select 	1 ' 							|| pls_util_pck.enter_w ||
					'		from	ptu_lote_aviso_excecao y ' 				|| pls_util_pck.enter_w ||
					'		where	y.nr_seq_protocolo	= '||prot_w||'.nr_sequencia' 	|| pls_util_pck.enter_w ||
					'		and	y.nr_seq_lote		= :nr_seq_lote ' 		|| pls_util_pck.enter_w ||
					'		and	y.nr_seq_protocolo is not null) ' 			|| pls_util_pck.enter_w;
					
	dados_bind_p := sql_pck.bind_variable(':nr_seq_lote', dados_a520_p.nr_seq_lote, dados_bind_p);
	ds_and_w := 'and	';
end if;


return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.gera_sql_a520_where_prot ( dados_a520_p dados_lote_a520_t, alias_p alias_a520_t, dados_gerais_a520_p dados_gerais_a520_t, dados_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
