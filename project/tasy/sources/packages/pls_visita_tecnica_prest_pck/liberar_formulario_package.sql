-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.liberar_formulario ( nr_seq_formulario_p pls_formulario_visita.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

nr_contador_w		integer;
ds_grupo_w		pls_formulario_visita_grup.ds_grupo%type;
ie_resultado_w		integer;
nr_faixa_inicial_w	pls_formulario_visita_clas.pr_inicial%type;
nr_faixa_final_w	pls_formulario_visita_clas.pr_final%type;

C01 CURSOR FOR
	SELECT	a.ds_grupo,
		b.ds_pergunta
	from	pls_formulario_visita_grup a,
		pls_formulario_visita_perg b
	where	a.nr_sequencia		= b.nr_seq_grupo
	and	a.nr_seq_formulario	= nr_seq_formulario_p
	and	not exists (	SELECT	1
				from	pls_formulario_visita_resp x
				where	x.nr_seq_pergunta = b.nr_sequencia);

C02 CURSOR FOR
	SELECT	pr_inicial,
		pr_final
	from	pls_formulario_visita_clas
	where	nr_seq_formulario = nr_seq_formulario_p
	order by pr_inicial;
BEGIN

-- Verifica Classificacao
ie_resultado_w	:= 0;
nr_contador_w	:= 0;
for c02_w in C02 loop
	nr_contador_w := nr_contador_w+1;
	if (nr_contador_w) = 1 then
		nr_faixa_final_w := c02_w.pr_final;
	else
		if (c02_w.pr_inicial <= coalesce(nr_faixa_final_w,0)) then
			ie_resultado_w := ie_resultado_w+1;
		end if;
		nr_faixa_final_w := c02_w.pr_final;
	end if;
end loop;
if (ie_resultado_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1209642);
end if;

-- Verifica se existe classificacao cadastrada
if (nr_contador_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1209644);
end if;

-- Verifica se faixa esta entre 0 e 100
select	min(pr_inicial),
	max(pr_final)
into STRICT	nr_faixa_inicial_w,
	nr_faixa_final_w
from	pls_formulario_visita_clas
where	nr_seq_formulario = nr_seq_formulario_p;

if (nr_faixa_inicial_w > 0 or nr_faixa_final_w <> 100) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1209645);
end if;

-- Grupo
select	count(1)
into STRICT	nr_contador_w
from	pls_formulario_visita_grup
where	nr_seq_formulario = nr_seq_formulario_p;

if (nr_contador_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1206823);
end if;

-- Perguntas
select	max(a.ds_grupo)
into STRICT	ds_grupo_w
from	pls_formulario_visita_grup a
where	a.nr_seq_formulario = nr_seq_formulario_p
and	not exists (	SELECT	1
			from	pls_formulario_visita_perg x
			where	x.nr_seq_grupo = a.nr_sequencia);

if (ds_grupo_w IS NOT NULL AND ds_grupo_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1206822,'DS_GRUPO='||ds_grupo_w);
end if;

--Respostas
for c01_w in C01 loop
	begin
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1206821,'DS_PERGUNTA='||c01_w.ds_pergunta||';DS_GRUPO='||c01_w.ds_grupo);
	end;
end loop;

update	pls_formulario_visita
set	dt_liberacao	= clock_timestamp(),
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_formulario_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.liberar_formulario ( nr_seq_formulario_p pls_formulario_visita.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;