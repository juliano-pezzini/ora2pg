-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tx_gerar_resultado_crossmatch (nr_seq_receptor_p bigint, nr_Seq_doador_orgao_p bigint, nr_seq_laboratorio_p bigint, nr_seq_metodo_p bigint, dt_exame_p timestamp, result_t_p text, result_tdtt_p text, result_tagh_p text, result_taghdtt_p text, result_b_p text, result_bdtt_p text, nm_usuario_p text, ie_tipo_exame_p text, ds_erro_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);
nr_Seq_doador_w		bigint;
nr_seq_metodo_w		bigint;
/*
A - Exame Autologo
D - Doador/Receptor
*/
BEGIN

nr_Seq_doador_w	:= null;
nr_seq_metodo_w	:= nr_seq_metodo_p;
if (nr_seq_metodo_p = 0) then
	nr_seq_metodo_w	:= null;
end if;

if (coalesce(dt_exame_p::text, '') = '') then
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(278955,null);
else
	if (ie_tipo_exame_p = 'D') then

		select 	max(b.nr_sequencia),
			max(b.cd_pessoa_fisica)
		into STRICT	nr_Seq_doador_w,
			cd_pessoa_fisica_w
		from	tx_doador_orgao a,
		      	tx_doador b
		where 	a.nr_sequencia 	= nr_Seq_doador_orgao_p
		and   	a.nr_seq_doador = b.nr_sequencia;

	elsif (ie_tipo_exame_p = 'A') then

		select 	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_w
		from	tx_receptor
		where 	nr_sequencia = nr_seq_receptor_p;

	end if;

	insert into tx_crossmatch(nr_sequencia,
				dt_exame,
				nr_seq_laboratorio,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_t,
				ie_t_dtt,
				ie_t_agh,
				ie_t_agh_dtt,
				ie_b,
				ie_b_dtt,
				cd_pessoa_fisica,
				nr_seq_doador,
				nr_seq_receptor,
				nr_seq_metodo)
			values (nextval('tx_crossmatch_seq'),
				dt_exame_p,
				nr_seq_laboratorio_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				result_t_p,
				result_tdtt_p,
				result_tagh_p,
				result_taghdtt_p,
				result_b_p,
				result_bdtt_p,
				cd_pessoa_fisica_w,
				nr_seq_doador_w,
				nr_seq_receptor_p,
				nr_seq_metodo_w);
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tx_gerar_resultado_crossmatch (nr_seq_receptor_p bigint, nr_Seq_doador_orgao_p bigint, nr_seq_laboratorio_p bigint, nr_seq_metodo_p bigint, dt_exame_p timestamp, result_t_p text, result_tdtt_p text, result_tagh_p text, result_taghdtt_p text, result_b_p text, result_bdtt_p text, nm_usuario_p text, ie_tipo_exame_p text, ds_erro_p INOUT text) FROM PUBLIC;

