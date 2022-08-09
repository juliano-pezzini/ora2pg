-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_cartao_ident_seg ( nr_seq_segurado_p pls_segurado_carteira.nr_seq_segurado%type, nr_via_p text, dt_validade_p text, nr_seq_plano_p text, ie_tipo_p text, nm_usuario_p text) AS $body$
DECLARE

/* ie_tipo_p
*     	V: Via
*	D: Data de validade
*	P: Produto
*	T: Todos
*/
nr_via_anterior_w	pls_segurado_carteira.nr_via_solicitacao%type;
dt_validade_ant_w	pls_segurado_carteira.dt_validade_carteira%type;


BEGIN

select	max(nr_via_solicitacao),
	max(dt_validade_carteira)
into STRICT	nr_via_anterior_w,
	dt_validade_ant_w
from	pls_segurado_carteira
where	nr_seq_segurado = nr_seq_segurado_p;

if (nr_via_p IS NOT NULL AND nr_via_p::text <> '') and
	((ie_tipo_p = 'V') or (ie_tipo_p = 'T')) and
	((coalesce(nr_via_anterior_w::text, '') = '') or ((nr_via_p)::numeric  <> nr_via_anterior_w)) then

	update	pls_segurado_carteira
	set	nr_via_solicitacao = (nr_via_p)::numeric
	where	nr_seq_segurado = nr_seq_segurado_p;

	CALL pls_gerar_segurado_historico(nr_seq_segurado_p, '76', clock_timestamp(),
				     wheb_mensagem_pck.get_texto(295006, 'NR_VIA_ANTERIOR=' || nr_via_anterior_w || ';NR_VIA_NOVA=' || nr_via_p),
				     null, null, null, null,
				     null, null, null, null,
				     null, null, null, null,
				     nm_usuario_p, 'N');
end if;

if (dt_validade_p IS NOT NULL AND dt_validade_p::text <> '') and
	((ie_tipo_p = 'D') or (ie_tipo_p = 'T')) and
	((coalesce(dt_validade_ant_w::text, '') = '') or (trunc(dt_validade_ant_w,'dd') <> trunc(last_day('01/'||dt_validade_p),'dd'))) then

	update	pls_segurado_carteira
	set	dt_validade_carteira = last_day('01/'||dt_validade_p)
	where	nr_seq_segurado = nr_seq_segurado_p;

	CALL pls_gerar_segurado_historico(nr_seq_segurado_p, '76', clock_timestamp(),
				     wheb_mensagem_pck.get_texto(295007, 'DT_VALIDADE_ANT=' || to_char(dt_validade_ant_w,'dd/mm/yyyy') || ';DT_VALIDADE_NOVA=' || to_char(last_day('01/'||dt_validade_p),'dd/mm/yyyy')),
				     null, null, null, null,
				     null, null, null, null,
				     null, null, null, null,
				     nm_usuario_p, 'N');
end if;

if (nr_seq_plano_p IS NOT NULL AND nr_seq_plano_p::text <> '') and ((ie_tipo_p = 'P') or (ie_tipo_p = 'T')) then
	update	pls_segurado
	set	nr_seq_plano = nr_seq_plano_p
	where	nr_sequencia = nr_seq_segurado_p;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_cartao_ident_seg ( nr_seq_segurado_p pls_segurado_carteira.nr_seq_segurado%type, nr_via_p text, dt_validade_p text, nr_seq_plano_p text, ie_tipo_p text, nm_usuario_p text) FROM PUBLIC;
