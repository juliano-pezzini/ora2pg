-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prev_implant_prop ( nr_seq_proposta_p bigint, nr_seq_prev_implant_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


ie_proposta_lib_w	varchar(1) := 'N';
nr_seq_cliente_w	bigint;
nr_horas_prev_impl_w	bigint;
nr_sequencia_w		bigint;

BEGIN
if (nr_seq_proposta_p IS NOT NULL AND nr_seq_proposta_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	coalesce(CASE WHEN coalesce(dt_liberacao::text, '') = '' THEN 'N'  ELSE 'S' END ,'N'),
		nr_seq_cliente
	into STRICT	ie_proposta_lib_w,
		nr_seq_cliente_w
	from	com_cliente_proposta
	where	nr_sequencia = nr_seq_proposta_p;

	if (ie_proposta_lib_w = 'S') then
		begin
		select	nextval('com_prev_implant_seq')
		into STRICT	nr_sequencia_w
		;

		nr_horas_prev_impl_w	:=	com_obter_horas_prev_implant(nr_sequencia_w,nr_seq_proposta_p,'P',nm_usuario_p);

		insert into
		com_prev_implant(
			nr_sequencia,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_atualizacao,
			nm_usuario,
			dt_previsao,
			nm_usuario_previsao,
			dt_prev_inic_impl,
			nr_horas_prev_impl,
			nr_meses_prev_impl,
			dt_liberacao,
			nm_usuario_liberacao,
			dt_cancelamento,
			nm_usuario_cancelamento,
			nr_seq_cliente,
			ie_origem_prev_implant,
			nr_seq_proposta)
		values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp() + interval '20 days',
			nr_horas_prev_impl_w,
			null,
			null,
			null,
			null,
			null,
			nr_seq_cliente_w,
			'P',
			nr_seq_proposta_p);
		end;
	end if;
	end;
end if;
nr_seq_prev_implant_p	:=	nr_sequencia_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prev_implant_prop ( nr_seq_proposta_p bigint, nr_seq_prev_implant_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
