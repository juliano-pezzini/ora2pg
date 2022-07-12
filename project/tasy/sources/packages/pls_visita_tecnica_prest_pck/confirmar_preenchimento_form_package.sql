-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_visita_tecnica_prest_pck.confirmar_preenchimento_form ( nr_seq_visita_form_p pls_visita_tecnica_form.nr_sequencia%type, ie_origem_preenchimento_p pls_visita_tecnica_form.ie_origem_preenchimento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) AS $body$
DECLARE

qt_registro_w	integer;
nr_percentual_w	bigint;
nr_seq_class_w	pls_visita_tecnica_form.nr_seq_classificacao%type;

BEGIN

select	count(1)
into STRICT	qt_registro_w
from	pls_visita_tecnica_form_pr
where	nr_seq_visita_form	= nr_seq_visita_form_p
and	coalesce(nr_seq_resposta::text, '') = '';

if (qt_registro_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1208199);
end if;

-- Calculando o percentual
select	round((sum(resp.qt_peso)*100)/(count(*)*10),2) as percentual
into STRICT	nr_percentual_w
from	pls_visita_tecnica_form_pr pr,
	pls_formulario_visita_resp resp
where	resp.ie_desconsiderar_pergunta	= 'N'
and	resp.nr_sequencia		= pr.nr_seq_resposta
and	pr.nr_seq_visita_form		= nr_seq_visita_form_p;

-- Buscando a classificacao
begin
select	b.nr_seq_classificacao
into STRICT	nr_seq_class_w
from	pls_visita_tecnica_form a,
	pls_formulario_visita_clas b
where	b.nr_seq_formulario	= a.nr_seq_formulario
and	a.nr_sequencia	= nr_seq_visita_form_p
and	nr_percentual_w between b.pr_inicial and b.pr_final;
exception
when others then
	nr_seq_class_w := null;
end;

update	pls_visita_tecnica_form
set	ie_status		= 3,
	dt_preenchimento	= clock_timestamp(),
	nm_usuario_preenchimento = nm_usuario_p,
	ie_origem_preenchimento	= ie_origem_preenchimento_p,
	nr_seq_classificacao	= nr_seq_class_w,
	pr_aderencia		= nr_percentual_w,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_visita_form_p;

if (ie_commit_p = 'S') then
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_visita_tecnica_prest_pck.confirmar_preenchimento_form ( nr_seq_visita_form_p pls_visita_tecnica_form.nr_sequencia%type, ie_origem_preenchimento_p pls_visita_tecnica_form.ie_origem_preenchimento%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text) FROM PUBLIC;
