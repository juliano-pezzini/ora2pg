-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_fase_cliente ( nr_seq_cliente_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_fase_anterior_w		varchar(100);
ds_fase_atual_w			varchar(100);
nr_seq_tipo_atividade_w		bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_tipo_atividade_w
from	pls_tipo_atividade
where	ie_fase_venda 		= 'S'
and	cd_estabelecimento	= cd_estabelecimento_p;

if (nr_seq_tipo_atividade_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 267006, null); /* Não existe cadastro do tipo de histórico para o item alteração da fase de venda. Verifique nos cadastros gerais do Tasy. */
end if;

select	substr(obter_valor_dominio(2517, ie_fase_venda),1,100),
	substr(obter_valor_dominio(2517, ie_acao_p),1,100)
into STRICT	ds_fase_anterior_w,
	ds_fase_atual_w
from	pls_comercial_cliente
where	nr_sequencia	= nr_seq_cliente_p;

update	pls_comercial_cliente
set	ie_fase_venda	= ie_acao_p
where	nr_sequencia	= nr_seq_cliente_p;

insert into pls_comercial_historico(	nr_sequencia,
					nr_seq_cliente,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_titulo,
					ds_historico,
					dt_liberacao,
					nm_usuario_historico,
					ie_tipo_atividade,
					dt_historico)
				values (	nextval('pls_comercial_historico_seq'),
					nr_seq_cliente_p,
					cd_estabelecimento_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'Alteração da fase da venda',
					'Alterada a fase da venda de "' || ds_fase_anterior_w || '" para "' || ds_fase_atual_w || '"',
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_tipo_atividade_w,
					clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_fase_cliente ( nr_seq_cliente_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
