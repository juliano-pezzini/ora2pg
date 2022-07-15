-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alteracao_cli_vinculado ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



ie_classificacao_w	varchar(3);
ie_fase_venda_w		varchar(3);
ie_status_neg_w		varchar(3);
nr_seq_ativ_w		bigint;
nr_seq_cliente_w	bigint;
ie_atualiza_cli_w   	varchar(1) := 'N';

c01 CURSOR FOR
	SELECT	nr_seq_cliente_vinculo
	from	com_cliente_vinculo
	where	nr_seq_cliente = nr_sequencia_p;


BEGIN
ie_atualiza_cli_w := obter_valor_param_usuario(992,73,obter_perfil_ativo,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento);

select	ie_classificacao,
	ie_fase_venda,
	ie_status_neg,
	nr_seq_ativ
into STRICT	ie_classificacao_w,
	ie_fase_venda_w,
	ie_status_neg_w,
	nr_seq_ativ_w
from	com_cliente
where	nr_sequencia = nr_sequencia_p;

open c01;
loop
fetch	c01 into
	nr_seq_cliente_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (coalesce(ie_atualiza_cli_w,'N') = 'S') then
		begin
		update	com_cliente
		set	ie_classificacao = ie_classificacao_w,
			ie_fase_venda	 = ie_fase_venda_w,
			ie_status_neg	 = ie_status_neg_w,
			nr_seq_ativ	 = nr_seq_ativ_w,
			dt_atualizacao	 = clock_timestamp(),
			nm_usuario	 = nm_usuario_p
		where	nr_sequencia	 = nr_seq_cliente_w;
		end;
	elsif (coalesce(ie_atualiza_cli_w,'N') = 'N') then
		begin
		update	com_cliente
		set	ie_fase_venda	 = ie_fase_venda_w,
			ie_status_neg	 = ie_status_neg_w,
			nr_seq_ativ	 = nr_seq_ativ_w,
			dt_atualizacao	 = clock_timestamp(),
			nm_usuario	 = nm_usuario_p
		where	nr_sequencia	 = nr_seq_cliente_w;
		end;
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alteracao_cli_vinculado ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

