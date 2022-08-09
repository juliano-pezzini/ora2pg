-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_grava_info_catraca ( cd_barras_p bigint, ie_tipo_pessoa_p text, dt_refeicao_p timestamp, nm_usuario_p text) AS $body$
DECLARE



nr_seq_integracao_w	bigint;


BEGIN

if (cd_barras_p IS NOT NULL AND cd_barras_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_integracao_w
	from	nut_integracao_catraca
	where	trunc(dt_refeicao) = trunc(dt_refeicao_p);

	if ( coalesce(nr_seq_integracao_w::text, '') = '') then

		select	nextval('nut_integracao_catraca_seq')
		into STRICT	nr_seq_integracao_w
		;

		insert into nut_integracao_catraca(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_refeicao,
			ds_observacao)
		values (nr_seq_integracao_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			dt_refeicao_p,
			'');
		end if;

	begin
		insert into nut_integ_catraca_item(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_refeicao,
			cd_barras,
			ie_tipo_pessoa,
			nr_seq_integracao)
		values (	nextval('nut_integ_catraca_item_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			dt_refeicao_p,
			cd_barras_p,
			ie_tipo_pessoa_p,
			nr_seq_integracao_w );
	exception
		when others then
		insert into log_nutricao(
				dt_atualizacao,
				nm_usuario,
				cd_log,
				ds_log)
		values ( 	clock_timestamp(),
				nm_usuario_p,
				10,
				wheb_mensagem_pck.get_texto(799713,
							'CD_BARRAS='||cd_barras_p||
							';NR_SEQ_INTEGRACAO='||nr_seq_integracao_w));
	end;
	CALL nut_gerar_refeicoes_catraca(dt_refeicao_p, nm_usuario_p);
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_grava_info_catraca ( cd_barras_p bigint, ie_tipo_pessoa_p text, dt_refeicao_p timestamp, nm_usuario_p text) FROM PUBLIC;
