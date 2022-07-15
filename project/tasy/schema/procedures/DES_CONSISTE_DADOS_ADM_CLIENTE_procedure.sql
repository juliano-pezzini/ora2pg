-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE des_consiste_dados_adm_cliente ( nr_sequencia_p bigint, nm_usuario_p text, ie_cliente_ok_p INOUT text) AS $body$
DECLARE


cd_cnpj_cli_w		varchar(14);
qt_existe_w		bigint;
nm_usuario_fin_w	varchar(15);
ie_cliente_ok_w		varchar(1);
nm_usuario_comunic_w	varchar(2000);
ie_erro_w		varchar(1) := 'N';
ds_titulo_w		varchar(255);
ds_comunic_w		varchar(255);

c01 CURSOR FOR
SELECT	nm_usuario
from	usuario
where	cd_setor_atendimento = 1
and	ie_situacao = 'A';


BEGIN

ie_cliente_ok_w	:= 'S';

select	b.cd_cnpj
into STRICT	cd_cnpj_cli_w
from	man_localizacao b,
	man_ordem_servico a
where	a.nr_seq_localizacao	= b.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_existe_w
from	titulo_receber
where	cd_cgc = cd_cnpj_cli_w
and	dt_pagamento_previsto <= trunc(clock_timestamp() - interval '30 days')
and	ie_situacao = '1';

if (qt_existe_w > 0) then
	begin

	nm_usuario_comunic_w	:= '';

	open c01;
	loop
	fetch c01 into
		nm_usuario_fin_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select	count(*)
		into STRICT	qt_existe_w
		from	man_ordem_servico_exec
		where	nr_seq_ordem = nr_sequencia_p
		and	nm_usuario_exec = nm_usuario_fin_w;

		if (qt_existe_w = 0) then
			begin

			insert into man_ordem_servico_exec(
					nr_sequencia,
					nr_seq_ordem,
					dt_atualizacao,
					nm_usuario,
					nm_usuario_exec,
					qt_min_prev,
					nr_seq_tipo_exec,
					dt_atualizacao_nrec,
					nm_usuario_nrec)
				values (	nextval('man_ordem_servico_exec_seq'),
					nr_sequencia_p,
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_fin_w,
					45,
					'3',
					clock_timestamp(),
					nm_usuario_p);

			nm_usuario_comunic_w	:= nm_usuario_comunic_w || nm_usuario_fin_w || ', ';

			end;
		else
			begin

			update	man_ordem_servico_exec
			set	dt_fim_execucao  = NULL
			where	nr_seq_ordem = nr_sequencia_p
			and	nm_usuario_exec = nm_usuario_fin_w;

			nm_usuario_comunic_w	:= nm_usuario_comunic_w || nm_usuario_fin_w || ', ';

			end;
		end if;

		end;
	end loop;
	close c01;

	ds_titulo_w	:= 'OS remetida ao setor Financeiro';
	ds_comunic_w	:= 'Informamos que a OS ' || to_char(nr_sequencia_p) || ' foi remetida ao setor de Financeiro';

	if (coalesce(nm_usuario_comunic_w,'X') <> 'X') then

		CALL Gerar_Comunic_Padrao(
			clock_timestamp(),
			ds_titulo_w,
			ds_comunic_w,
			nm_usuario_p,
			'N',
			nm_usuario_comunic_w,
			'N',
			5,
			null,
			null,
			null,
			clock_timestamp(),
			null,
			null);

		Insert into man_ordem_serv_envio(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			dt_envio,
			ie_tipo_envio,
			ds_destino,
			ds_observacao)
		values (	nextval('man_ordem_serv_envio_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'I',
			substr(nm_usuario_comunic_w,1,255),
			ds_titulo_w);

	end if;

	begin
	CALL Enviar_Email(ds_titulo_w, ds_comunic_w, null, 'financeiropci@philips.com', nm_usuario_p,'M');
	exception when others then
		ie_erro_w	:= 'S';
	end;

	if (ie_erro_w = 'N') then

		Insert into man_ordem_serv_envio(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			dt_envio,
			ie_tipo_envio,
			ds_destino,
			ds_observacao)
		values (	nextval('man_ordem_serv_envio_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			'E',
			'financeiropci@philips.com',
			ds_titulo_w);

	end if;

	update	man_ordem_servico_exec
	set	dt_fim_execucao 	= clock_timestamp()
	where	nr_seq_ordem 		= nr_sequencia_p
	and	nm_usuario_exec 	= nm_usuario_p
	and	coalesce(dt_fim_execucao::text, '') = '';

	ie_cliente_ok_w	:= 'N';

	end;
end if;

commit;

ie_cliente_ok_p	:= ie_cliente_ok_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE des_consiste_dados_adm_cliente ( nr_sequencia_p bigint, nm_usuario_p text, ie_cliente_ok_p INOUT text) FROM PUBLIC;

