-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_gerar_retorno_item ( nr_requisicao_p bigint, nr_seq_conjunto_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_existe_w			bigint;
nr_seq_conj_cont_w		bigint;
dt_baixa_req_w			timestamp;
nr_sequencia_w			bigint;
cd_status_conj_atend_req_w		smallint;
ie_gera_novo_conj_w		varchar(1);
cd_local_estoque_w	bigint;

BEGIN

cd_local_estoque_w := obter_param_usuario(410, 62, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, cd_estabelecimento_p, cd_local_estoque_w);

select	dt_baixa
into STRICT	dt_baixa_req_w
from	cm_requisicao
where	nr_sequencia 	= nr_requisicao_p;

/*Verifica se a requisição já possui data de baixa*/

if (coalesce(dt_baixa_req_w::text, '') = '') then
	-- Esta requisição não possui data de baixa, não podem ser gerados retornos dos seus conjuntos.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264844);
end if;

nr_seq_conj_cont_w := coalesce(nr_seq_conjunto_p,0);

/*Verifica se o código passado é válido e maior que zero*/

if (nr_seq_conj_cont_w = 0) then
	-- Código de barras inválido!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(152728);
end if;

/*Verifica se existe algum item atendido sem retorno*/

select	count(*)
into STRICT	qt_existe_w
from	cm_requisicao_conj a,
	cm_requisicao_item b
where	a.nr_seq_item_req	= b.nr_sequencia
and	b.nr_seq_requisicao	= nr_requisicao_p
and	coalesce(a.dt_retorno::text, '') = '';

if (qt_existe_w = 0) then
	-- Não existem itens pendentes de retorno para esta requisição.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264845);
elsif (qt_existe_w > 0) then
	begin
	/*Verifica se existe algum conjunto igual ao passado pendente de retorno*/

	select	count(*),
		min(a.nr_sequencia)
	into STRICT	qt_existe_w,
		nr_sequencia_w
	from	cm_requisicao_conj a,
		cm_requisicao_item b
	where	a.nr_seq_item_req	= b.nr_sequencia
	and	b.nr_seq_requisicao	= nr_requisicao_p
	and	a.nr_seq_conj_real	= nr_seq_conjunto_p
	and	coalesce(a.dt_retorno::text, '') = '';

	if (qt_existe_w = 0) then
		-- Não existem itens deste conjunto pendentes de retorno para esta requisição.
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(264845);
	end if;
	end;
end if;

select	coalesce(max(obter_valor_param_usuario(406, 52, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)), 0)
into STRICT	cd_status_conj_atend_req_w
;

if (cd_status_conj_atend_req_w > 0) then
	begin
	update	cm_conjunto_cont
	set		ie_status_conjunto 	= cd_status_conj_atend_req_w,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_conjunto_p;
	end;
end if;


if (coalesce(nr_sequencia_w,0) > 0) then
	begin
	update	cm_requisicao_conj
	set		dt_retorno			= clock_timestamp(),
			nm_usuario_retorno	= nm_usuario_p
	where	nr_sequencia		= nr_sequencia_w;
	end;
end if;

select	coalesce(max(obter_valor_param_usuario(406, 63, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)),'N')
into STRICT	ie_gera_novo_conj_w
;

update	cm_conjunto_cont
set		cd_local_estoque 	= coalesce(cd_local_estoque_w, cd_local_estoque)
where	nr_sequencia		= nr_seq_conjunto_p;

if (ie_gera_novo_conj_w = 'S') then
	CALL cm_gerar_conj_retorno_atend(nr_seq_conjunto_p,nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_gerar_retorno_item ( nr_requisicao_p bigint, nr_seq_conjunto_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
